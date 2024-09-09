import { connectToDB } from "../utils/db/db.js";
import { successResponse, failureResponse } from "../Helper/helper.js";
import { generateRandomColor } from "../Security/security.js";
import {
  GET_ALL_PATH_DETAILS_WITH_SKILL_AND_STEPS,
  GET_PATHS_WITH_TOTAL_SKILLS_COUNT,
  GET_ALL_SKILLS,
  GET_EACH_SKILLS_WITH_ITS_STEP,
  GET_SINGLE_PATH_DETAILS
} from "../Models/mapping-controller-queries.js";

const pool = connectToDB();
export const createPath = (req, res) => {
  try {
    const { prompt } = req.body;
    const file = req.file;
    const userId = req.user?.userId;
    const color = generateRandomColor();

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
      "INSERT INTO path (prompt, file, color, status, user_id) VALUES (?, ?, ?, ?, ?)";
    pool.query(
      sqlQuery,
      [prompt || null, fileName || null, color, "pending", userId],
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
          .json(successResponse({ color }, "Path is created successfully"));
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
export const getPathsWithDetails = (req, res) => {
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

    pool.query(
      GET_ALL_PATH_DETAILS_WITH_SKILL_AND_STEPS,
      [userId],
      (err, results) => {
        if (err) {
          return res
            .status(500)
            .json(
              failureResponse(
                { error: "Internal Server Error" },
                "Failed to retrieve paths"
              )
            );
        }

        // Format and send the response
        const parsedResults = results.map((result) => {
          return {
            ...result,
            steps: JSON.parse(result.steps),
          };
        });
        res
          .status(200)
          .json(successResponse(parsedResults, "Paths retrieved successfully"));
      }
    );
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

    pool.query(
      GET_PATHS_WITH_TOTAL_SKILLS_COUNT,
      [userId],
      (err, result) => {
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
      }
    );
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
export const getSinglePath = (req,res) =>{
  try{
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

      pool.query(GET_SINGLE_PATH_DETAILS, [userId, pathId], (err, result)=>{
        if(err){
          return res
          .status(500)
          .json(
            failureResponse(
              { error: "Internal Server Error" },
              "Failed to get the data"
            )
          );
        }
        const formatResult = result.map(item =>{
          return{
            ...item,
            steps : JSON.parse(item.steps)
          }
        })
        return res.status(200).json(successResponse({formatResult}, 'Path retrived Successfully'))
      })


  }
  catch (error) {
    console.log(error);
    return res
      .status(500)
      .json(
        failureResponse(
          { error: "Internal Server Error" },
          "Failed to get the data"
        )
      );
  }
}
