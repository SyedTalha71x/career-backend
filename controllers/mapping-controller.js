import { connectToDB } from "../utils/db/db.js";
import { successResponse, failureResponse } from "../Helper/helper.js";
import { generateRandomColor } from "../Security/security.js";
import {
  GET_ALL_PATH_DETAILS_WITH_SKILL_AND_STEPS,
  GET_PATHS_WITH_TOTAL_SKILLS_COUNT,
  GET_ALL_SKILLS,
  GET_EACH_SKILLS_WITH_ITS_STEP,
  GET_SINGLE_PATH_DETAILS,
} from "../Models/mapping-controller-queries.js";

const pool = connectToDB();

const query = (sql, params) =>
  new Promise((resolve, reject) => {
    pool.query(sql, params, (error, results) => {
      if (error) {
        return reject(error);
      }
      resolve(results);
    });
  });
export const createPath = (req, res) => {
  try {
    const { prompt } = req.body;
    const file = req.file;
    const userId = req.user?.userId;

    // Check if either prompt or file is provided, but not both
    if ((!prompt && !file) || (prompt && file)) {
      return res
        .status(400)
        .json(
          failureResponse(
            { error: "You must provide either a prompt or file" },
            "Failed to create the path"
          )
        );
    }

    // Extract the filename from the file path if a file is provided
    const fileName = file ? file.filename : null;

    // SQL query to insert data into the path table
    const sqlQuery =
      "INSERT INTO path (prompt, file, status, user_id) VALUES (?, ?, ?, ?, ?)";
    pool.query(
      sqlQuery,
      [prompt || null, fileName || null, "pending", userId],
      (err, result) => {
        if (err) {
          return res
            .status(500)
            .json(
              failureResponse(
                { error: "Internal Server Error" },
                "Failed to create the path"
              )
            );
        }
        res
          .status(200)
          .json(successResponse({}, "Path is created successfully"));
      }
    );
  } catch (error) {
    console.error("Unexpected error:", error);
    return res
      .status(500)
      .json(
        failureResponse(
          { error: "Internal Server Error" },
          "Failed to create the path"
        )
      );
  }
};
export const getPathsWithDetails = async (req, res) => {
  try {
    const userId = req.user?.userId;

    if (!userId) {
      return res.status(400).json({
        status: false,
        message: "User ID is missing from the request.",
      });
    }

    // Fetch all paths for the user
    const pathsQuery = `
      SELECT id, color, status 
      FROM path 
      WHERE user_id = ? AND status = 'analyzed'
    `;
    const pathsResult = await query(pathsQuery, [userId]);

    if (pathsResult.length === 0) {
      return res
        .status(404)
        .json({ status: false, message: "No paths found for this user." });
    }

    // Collect all path IDs
    const pathIds = pathsResult.map((path) => path.id);

    // Fetch branches and steps for all paths
    const branchesQuery = `
      SELECT id, color, step_id, path_id 
      FROM branch 
      WHERE path_id IN (?)
    `;
    const branchesResult = await query(branchesQuery, [pathIds]);

    const stepsQuery = `
      SELECT id, title, description, branch_id, path_id 
      FROM steps 
      WHERE path_id IN (?)
    `;
    const stepsResult = await query(stepsQuery, [pathIds]);

    // Fetch skills for each step
    // const skillsQuery = `
    //   SELECT title, step_id 
    //   FROM skills 
    //   WHERE step_id IN (?)
    // `;
    // const skillsResult = await query(skillsQuery, [
    //   stepsResult.map((step) => step.id),
    // ]);

    // Function to find branches by step_id
    const findBranchByStepId = (branches, step_id = null) => {
      const branchArr = [];
      for (const value of branches) {
        if (value.step_id === step_id) {
          if (step_id === null) {
            return value;
          } else {
            branchArr.push(value);
          }
        }
      }
      return branchArr;
    };

    // Recursive function to process steps
    const processSteps = (branch, branches, steps) => {
      const processedSteps = [];

      for (const value of steps) {
        if (value.branch_id === branch.id) {
          const searchedBranch = findBranchByStepId(branches, value.id);
          if (Array.isArray(searchedBranch) && searchedBranch.length > 0) {
            const processedBranch = [];
            for (const sb of searchedBranch) {
              const subProcessedBranch = processSteps(sb, branches, steps);
              processedBranch.push(subProcessedBranch);
            }
            if (processedBranch.length > 0) {
              value.branches = processedBranch;
            }
          }
          processedSteps.push(value);
        }
      }

      branch.steps = processedSteps;
      return branch;
    };

    // Process branches with steps and skills for each path
    const pathsWithDetails = await Promise.all(
      pathsResult.map(async (path) => {
        const branchesForPath = branchesResult.filter(
          (branch) => branch.path_id === path.id
        );
        const stepsForPath = stepsResult.filter(
          (step) => step.path_id === path.id
        );
        const startingBranch = findBranchByStepId(branchesForPath);
        if (!Array.isArray(startingBranch)) {
          const branch = processSteps(
            startingBranch,
            branchesForPath,
            stepsForPath
          );
          return {
            id: path.id,
            Status: path.status,
            branch,
          };
        } else {
          return {
            id: path.id,
            Status: path.status,
            branch: {},
          };
        }
      })
    );

    return res.json(
      successResponse(
        pathsWithDetails,
        "Paths with branches, steps, and skills retrieved successfully"
      )
    );
  } catch (error) {
    console.error("Error fetching path details:", error);
    return res
      .status(500)
      .json({ status: false, message: "Internal server error" });
  }
};
export const getPathsForUser = (req, res) => {
  try {
    const userId = req.user?.userId;

    if (!userId) {
      return res
        .status(400)
        .json(
          failureResponse(
            { error: "User ID is required" },
            "Failed to retrieve paths"
          )
        );
    }

    pool.query(GET_PATHS_WITH_TOTAL_SKILLS_COUNT, [userId], (err, result) => {
      if (err) {
        console.error("Unexpected error:", err);
        return res
          .status(500)
          .json(
            failureResponse(
              { error: "Internal Server Error" },
              "Failed to retrieve paths"
            )
          );
      }
      return res
        .status(200)
        .json(successResponse({ result }, "path retrive successfully"));
    });
  } catch (error) {
    console.error("Unexpected error:", error);
    return res
      .status(500)
      .json(
        failureResponse(
          { error: "Internal Server Error" },
          "Failed to retrieve paths"
        )
      );
  }
};
export const getSkillsForUser = (req, res) => {
  try {
    const userId = req.user?.userId;

    if (!userId) {
      return res
        .status(400)
        .json(
          failureResponse(
            { error: "User ID is required" },
            "Failed to retrieve skills"
          )
        );
    }

    pool.query(GET_ALL_SKILLS, [userId], (err, skillsResult) => {
      if (err) {
        return res
          .status(500)
          .json(
            failureResponse(
              { error: "Internal Server Error" },
              "Failed to retrieve skills"
            )
          );
      }

      return res
        .status(200)
        .json(successResponse(skillsResult, "Skills retrieved successfully"));
    });
  } catch (error) {
    console.error("Unexpected error:", error);
    return res
      .status(500)
      .json(
        failureResponse(
          { error: "Internal Server Error" },
          "Failed to retrieve skills"
        )
      );
  }
};
export const geteachskillsforpath = (req, res) => {
  try {
    const { stepId } = req.body;
    const userId = req.user?.userId;

    if (!userId) {
      return res
        .status(400)
        .json(
          failureResponse(
            { error: "User ID is required" },
            "Failed to retrieve skills"
          )
        );
    }

    if (!stepId) {
      return res
        .status(400)
        .json(
          failureResponse(
            { error: "Step ID is required" },
            "Failed to retrieve skills"
          )
        );
    }

    // Step 1: Query to get path_id based on stepId
    const getPathIdQuery = `SELECT path_id FROM steps WHERE id = ?`;

    pool.query(getPathIdQuery, [stepId], (err, pathResult) => {
      if (err) {
        return res
          .status(500)
          .json(
            failureResponse(
              { error: "Internal Server Error" },
              "Failed to retrieve path ID"
            )
          );
      }

      if (!pathResult || pathResult.length === 0) {
        return res
          .status(404)
          .json(
            failureResponse(
              { error: "No path found for the given step ID" },
              "Failed to retrieve path ID"
            )
          );
      }

      const pathId = pathResult[0].path_id;

      pool.query(
        GET_EACH_SKILLS_WITH_ITS_STEP,
        [stepId, userId, pathId],
        (err, result) => {
          if (err) {
            return res
              .status(500)
              .json(
                failureResponse(
                  { error: "Internal Server Error" },
                  "Failed to retrieve step and skills"
                )
              );
          }

          console.log("SQL Query Result:", result);

          if (!result || result.length === 0) {
            return res
              .status(404)
              .json(
                failureResponse(
                  { error: "No data found for the given step ID" },
                  "Failed to retrieve step and skills"
                )
              );
          }

          const stepData = {
            id: result[0].id,
            title: result[0].title,
            description: result[0].description,
          };

          const skills = result
            .filter((row) => row.skill_id) // Only include rows with valid skills
            .map((row) => ({
              id: row.skill_id,
              title: row.skill_title,
              sort: row.skill_sort,
              status: row.skill_status,
            }));

          console.log("Mapped Skills:", skills);
          res
            .status(200)
            .json(
              successResponse(
                { step: stepData, skills: skills },
                "Skills and step details retrieved successfully"
              )
            );
        }
      );
    });
  } catch (error) {
    console.log(error);
    return res
      .status(500)
      .json(
        failureResponse(
          { error: "Internal Server Error" },
          "Failed to retrieve skills"
        )
      );
  }
};
export const changeSkillStatus = (req, res) => {
  try {
    const skillId = req.params.id;
    const userId = req.user?.userId;

    if (!userId) {
      return res
        .status(400)
        .json(
          failureResponse(
            { error: "User ID is required" },
            "Failed to change the status"
          )
        );
    }
    if (!skillId) {
      return res
        .status(400)
        .json(
          failureResponse(
            { error: "Skill Id is required" },
            "Failed to change the status"
          )
        );
    }

    const getSkillStatusQuery = `
    SELECT s.status, p.user_id 
    FROM skills s
    JOIN steps st ON s.step_id = st.id
    JOIN path p ON st.path_id = p.id
    WHERE s.id = ? AND p.user_id = ?
  `;

    pool.query(getSkillStatusQuery, [skillId, userId], (err, result) => {
      if (err) {
        console.log(err);
        return res
          .status(500)
          .json(
            failureResponse(
              { error: "Internal Server Error" },
              "Skill Status changing Failed"
            )
          );
      }
      if (result.length === 0) {
        return res
          .status(404)
          .json(
            failureResponse(
              { error: "No skill found for the provided ID and user" },
              "Failed to change skill status"
            )
          );
      }

      const currentStatus = result[0].status;
      const ToggleStatus =
        currentStatus === "pending" ? "completed" : "pending";

      const updateStatusQuery = `
        UPDATE skills s
        JOIN steps st ON s.step_id = st.id
        JOIN path p ON st.path_id = p.id
        SET s.status = ?
        WHERE s.id = ? AND p.user_id = ?
      `;

      pool.query(
        updateStatusQuery,
        [ToggleStatus, skillId, userId],
        (err, result) => {
          if (err) {
            console.log(err);
            return res
              .status(500)
              .json(
                failureResponse(
                  { error: "Internal Server Error" },
                  "Skill Status changing Failed"
                )
              );
          }
          if (result.affectedRows === 0) {
            return res
              .status(400)
              .json(
                failureResponse(
                  { error: "No rows affected" },
                  "Failed to change the status"
                )
              );
          }

          return res
            .status(200)
            .json(
              successResponse(
                { newStatus: ToggleStatus },
                "Status has been updated "
              )
            );
        }
      );
    });
  } catch (error) {
    console.log(error);
    return res
      .status(500)
      .json(
        failureResponse(
          { error: "Internal Server Error" },
          "Skill Status changing Failed"
        )
      );
  }
};
export const getSinglePath = async (req, res) => {
  try {
    const userId = req.user?.userId;
    const pathId = req.params.id;

    if (!userId) {
      return res
        .status(400)
        .json(
          failureResponse(
            { error: "User ID is required" },
            "Failed to get details"
          )
        );
    }
    if (!pathId) {
      return res
        .status(400)
        .json(
          failureResponse(
            { error: "Path ID is required" },
            "Failed to get details"
          )
        );
    }

    // Fetch the main path
    const pathQuery =
      "SELECT id, color, status FROM path WHERE user_id = ? AND id = ? AND status = 'analyzed'";
    const pathResult = await query(pathQuery, [userId, pathId]);

    if (pathResult.length === 0) {
      return res.status(404).json({ status: false, message: "Path not found" });
    }

    const path = pathResult[0];

    // Fetch branches and steps for the path
    const branchesQuery =
      "SELECT id, color, step_id FROM branch WHERE path_id = ?";
    const branchesResult = await query(branchesQuery, [pathId]);

    const stepsQuery =
      "SELECT id, title, description, branch_id FROM steps WHERE path_id = ?";
    const stepsResult = await query(stepsQuery, [pathId]);

    const stepIds = stepsResult.map((step) => step.id);

    // Fetch skills only if there are steps
    let skillsResult = [];
    if (stepIds.length > 0) {
      const skillsQuery =
        "SELECT title, step_id FROM skills WHERE step_id IN (?)";
      skillsResult = await query(skillsQuery, [stepIds]);
    }

    // Function to find branches by step_id
    const findBranchByStepId = (branches, step_id) => {
      return branches.find((branch) => branch.step_id === step_id);
    };

    // Recursive function to process steps
    const processSteps = async (branch, branches, steps) => {
      const processedSteps = [];

      for (const step of steps) {
        if (step.branch_id === branch.id) {
          // Fetch skills for the step
          const stepSkills = skillsResult.filter(
            (skill) => skill.step_id === step.id
          );
          const stepWithSkills = {
            title: step.title,
            description: step.description,
            skills: stepSkills.map((skill) => ({ title: skill.title })),
          };

          const subBranch = findBranchByStepId(branches, step.id);
          if (subBranch) {
            // Process the sub-branch
            const processedSubBranch = await processSteps(
              subBranch,
              branches,
              steps
            );
            processedSteps.push({
              ...stepWithSkills,
              ...processedSubBranch,
            });
          } else {
            processedSteps.push(stepWithSkills);
          }
        }
      }

      // Include only color in the branch object, remove id
      const { color } = branch;
      return { color, steps: processedSteps };
    };

    // Convert branches to an object with branch details but no IDs
    const branchesObject = {};
    for (const branch of branchesResult) {
      const processedBranch = await processSteps(
        branch,
        branchesResult,
        stepsResult
      );
      branchesObject[branch.id] = processedBranch;
    }

    const result = {
      id: path.id,
      status: path.status,
      branch: Object.keys(branchesObject).length > 0 ? Object.values(branchesObject) : {},
    };

    return res
      .status(200)
      .json(successResponse(result, "Path retrieved successfully"));
  } catch (error) {
    console.error("Error fetching path details:", error);
    return res
      .status(500)
      .json(
        failureResponse(
          { error: "Internal Server Error" },
          "Failed to get the data"
        )
      );
  }
};
