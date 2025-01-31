import { connectToDB } from "../utils/db/db.js";
import { successResponse, failureResponse } from "../Helper/helper.js";
import axios from "axios";
import { PdfReader } from "pdfreader";
import path from "path";

import {
  GET_ALL_PATH_DETAILS_WITH_SKILL_AND_STEPS,
  GET_PATHS_WITH_TOTAL_SKILLS_COUNT,
  GET_ALL_SKILLS,
  GET_EACH_SKILLS_WITH_ITS_STEP,
  GET_SINGLE_PATH_DETAILS,
} from "../Models/mapping-controller-queries.js";

const OPENAI_KEY = process.env.OPENAI_SECRET_KEY;
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

const extractTextFromPDF = async (filePath) => {
  return new Promise((resolve, reject) => {
    const pdfReader = new PdfReader();
    const extractedTexts = [];

    pdfReader.parseFileItems(filePath, (err, item) => {
      if (err) {
        reject(err);
      } else if (!item) {
        resolve(extractedTexts.join(" "));
        console.log(extractedTexts, "---------");
      } else if (item.text) {
        extractedTexts.push(item.text);
        console.log(extractedTexts, "ssssssssss");
      }
    });
  });
};

export const createPath = async (req, res) => {
  try {
    const { title, prompt } = req.body;
    const userId = req.user?.userId;
    const file = req.file;

    if (!userId) {
      return res
        .status(404)
        .json(failureResponse({ error: "Failed to create the path" }));
    }
    if (!title) {
      return res
        .status(400)
        .json(failureResponse({ error: "Title is required" }));
    }

    if (!prompt && !file) {
      return res
        .status(400)
        .json(failureResponse({ error: "Either prompt or file is required" }));
    }

    const fileName = file ? file.filename : null;

    const sqlQuery =
      "INSERT INTO path (title, prompt, status, user_id, file) VALUES (?, ?, ?, ?, ?)";

    pool.query(
      sqlQuery,
      [title || null, prompt || null, "pending", userId, fileName],
      (pathInsertErr, pathResult) => {
        if (pathInsertErr) {
          console.error("Path insertion error:", pathInsertErr);
          return res
            .status(500)
            .json(failureResponse({ error: "Path insertion failed" }));
        }

        const activityLogQuery =
          "INSERT INTO activity_logs (name, user_id) VALUES (?,?)";
        pool.query(
          activityLogQuery,
          [`Created Path: ${title}`, userId],
          (activityLogErr) => {
            if (activityLogErr) {
              console.error("Activity log error:", activityLogErr);
              return res
                .status(500)
                .json(failureResponse({ error: "Activity log failed" }));
            }

            const updateSubscriptionQuery = `
              UPDATE user_subscription 
SET current_path = COALESCE(current_path, 0) + 1 
WHERE id = (
  SELECT id 
  FROM (
    SELECT id 
    FROM user_subscription 
    WHERE user_id = ? 
      AND expiry_date > NOW() 
    ORDER BY expiry_date DESC, created_at DESC 
    LIMIT 1
  ) AS latest_subscription
);

            `;
            pool.query(
              updateSubscriptionQuery,
              [userId, userId],
              (subscriptionUpdateErr) => {
                if (subscriptionUpdateErr) {
                  console.error(
                    "Subscription update error:",
                    subscriptionUpdateErr
                  );
                  return res
                    .status(500)
                    .json(
                      failureResponse({ error: "Subscription update failed" })
                    );
                }

                axios
                  .post(
                    `https://app.mycareermap.ai/ai/generate_roadmap?id=${pathResult.insertId}`,
                    {},
                    {
                      headers: {
                        Authorization: req.header("Authorization"),
                      },
                    }
                  )
                  .then((roadmapResponse) => {
                    console.log("Roadmap response:", roadmapResponse.data);
                    return res
                      .status(200)
                      .json(
                        successResponse({}, "Path is created successfully")
                      );
                  })
                  .catch((roadmapError) => {
                    console.error("Roadmap generation error:", roadmapError);
                    return res.status(500).json(
                      failureResponse({
                        error: "Roadmap generation failed",
                      })
                    );
                  });
              }
            );
          }
        );
      }
    );
  } catch (error) {
    console.error("Unexpected top-level error:", error);
    return res
      .status(500)
      .json(
        failureResponse(
          { error: "Unexpected error occurred" },
          "Failed to create the path"
        )
      );
  }
};
export const updatePath = (req, res) => {
  try {
    const { title, prompt } = req.body;
    const userId = req.user?.userId;
    const pathId = req.params.id;
    const file = req.file;

    if (!userId) {
      return res.status(404).json(failureResponse({ error: "User not found" }));
    }

    if (!pathId) {
      return res
        .status(400)
        .json(failureResponse({ error: "Path ID is required" }));
    }

    const fileName = file ? file.filename : null;

    if (prompt) {
      const sqlQuery = `UPDATE path SET prompt = ?, title = ? WHERE id = ? AND user_id = ?`;
      pool.query(sqlQuery, [prompt, title, pathId, userId], (err, result) => {
        if (err) {
          console.log("---", err);

          return res
            .status(500)
            .json(failureResponse({ error: "Internal Server Error" }));
        }

        if (result.affectedRows === 0) {
          return res
            .status(404)
            .json(
              failureResponse({ error: "Path not found or not owned by user" })
            );
        }

        return res
          .status(200)
          .json(successResponse({}, "Prompt updated successfully"));
      });
    } else if (fileName) {
      const sqlQuery = `UPDATE path SET file = ?, title = ? WHERE id = ? AND user_id = ?`;
      pool.query(sqlQuery, [fileName, title, pathId, userId], (err, result) => {
        if (err) {
          console.log("ooo", err);

          return res
            .status(500)
            .json(failureResponse({ error: "Internal Server Error" }));
        }

        if (result.affectedRows === 0) {
          return res
            .status(404)
            .json(
              failureResponse({ error: "Path not found or not owned by user" })
            );
        }

        return res
          .status(200)
          .json(successResponse({}, "File updated successfully"));
      });
    } else {
      return res
        .status(400)
        .json(
          failureResponse({ error: "Either prompt or file must be provided" })
        );
    }
  } catch (error) {
    console.error("Unexpected error:", error);
    return res
      .status(500)
      .json(failureResponse({ error: "Internal Server Error" }));
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

    const pathsQuery = `
      SELECT id, status, title 
      FROM path 
      WHERE user_id = ? AND status = 'analysed'
      ORDER BY id DESC
    `;
    const pathsResult = await query(pathsQuery, [userId]);

    if (pathsResult.length === 0) {
      return res
        .status(404)
        .json(
          failureResponse({ status: 404 }, "No paths found for this user.")
        );
    }

    const pathIds = pathsResult.map((path) => path.id);

    // Fetch branches and steps for all paths
    const branchesQuery = `
      SELECT id, color, step_id, path_id 
      FROM branch 
      WHERE path_id IN (?)
    `;
    const branchesResult = await query(branchesQuery, [pathIds]);

    const stepsQuery = `
      SELECT id, title, description, branch_id, path_id, status
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
            Title: path.title,
            branch,
          };
        } else {
          return {
            id: path.id,
            Status: path.status,
            Title: path.title,
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
export const getSingleBranch = async (req, res) => {
  try {
    const userId = req.user?.userId;
    const branchId = req.params.id;

    console.log("Branch id ", branchId);
    console.log("User id ", userId);

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
    if (!branchId) {
      return res
        .status(400)
        .json(
          failureResponse(
            { error: "Branch ID is required" },
            "Failed to get details"
          )
        );
    }

    // Fetch the branch to verify its existence and get associated step_id
    const branchQuery =
      "SELECT id, path_id, step_id, color FROM branch WHERE id = ?";
    const branchResult = await query(branchQuery, [branchId]);

    if (branchResult.length === 0) {
      return res
        .status(404)
        .json(failureResponse({ status: 404 }, "Branch not found."));
    }

    const branch = branchResult[0];

    // Verify that the branch belongs to the user's path
    const pathQuery =
      "SELECT id, status, title FROM path WHERE id = ? AND user_id = ?";
    const pathResult = await query(pathQuery, [branch.path_id, userId]);

    if (pathResult.length === 0) {
      return res
        .status(404)
        .json(
          failureResponse({ status: 404 }, "No paths found for this user.")
        );
    }

    // Fetch the main step associated with this branch
    const mainStepResult = [];
    if (branch.step_id) {
      const stepQuery =
        "SELECT id, title, description, status FROM steps WHERE id = ?";
      const stepResult = await query(stepQuery, [branch.step_id]);

      if (stepResult.length > 0) {
        mainStepResult.push(stepResult[0]);
      }
    }

    // Fetch all steps associated with this branch
    const allStepsQuery =
      "SELECT id, title, description, status FROM steps WHERE branch_id = ?";
    const allStepsResult = await query(allStepsQuery, [branchId]);

    // Combine main step and all associated steps
    const combinedStepsResult = [...mainStepResult, ...allStepsResult];

    const stepIds = combinedStepsResult.map((step) => step.id);

    // Fetch skills associated with the combined steps
    let skillsResult = [];
    if (stepIds.length > 0) {
      const skillsQuery =
        "SELECT title, step_id FROM skills WHERE step_id IN (?)";
      skillsResult = await query(skillsQuery, [stepIds]);
    }

    // Prepare response data array
    const data = [];

    // Add branch details with its associated steps and skills
    const branchData = {
      pathTitle: pathResult[0].title,
      id: branch.id,
      color: branch.color,
      steps: [],
    };

    for (const step of combinedStepsResult) {
      const stepSkills = skillsResult.filter(
        (skill) => skill.step_id === step.id
      );
      branchData.steps.push({
        id: step.id,
        title: step.title,
        description: step.description,
        status: step.status,
        skills: stepSkills.map((skill) => ({ title: skill.title })),
      });
    }

    data.push(branchData);

    return res.json({
      data,
    });
  } catch (error) {
    console.error("Error fetching branch details:", error);
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
export const getSpecificSkillsWithStepId = (req, res) => {
  try {
    const stepId = req.params.id;
    const userId = req.user?.userId;

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

    const sqlQuery = "select * from skills where step_id = ?";
    pool.query(sqlQuery, [stepId], (err, result) => {
      if (err) {
        console.log(err);
        return res
          .status(500)
          .json(
            failureResponse(
              { error: "Internal Server Error" },
              "Failed to fetch the skills"
            )
          );
      }
      const formattedResult = result.map((item) => ({
        id: item.id,
        title: item.title,
        status: item.status,
      }));

      return res
        .status(200)
        .json(
          successResponse(
            { skills: formattedResult },
            "Successfully fetched the skills"
          )
        );
    });
  } catch (error) {
    return res
      .status(500)
      .json(
        failureResponse(
          { error: "Internal Server Error" },
          "Failed to fetch the skills"
        )
      );
  }
};
export const sendMessage = async (req, res) => {
  try {
    console.log("Request Received:");

    const { message, step_id } = req.body;
    console.log(message);
    console.log(step_id);

    if (!step_id) {
      return res.status(400).json({
        status: false,
        error: "Step ID is required",
      });
    }

    const uploadedFile = req.file ? req.file.filename : null;
    console.log("File:", uploadedFile);

    const systemMessage =
      "You are an experienced career advisor with a deep understanding of career development paths.";

    // Fetch conversation history
    const getConversationHistory = async (stepId) => {
      const historyQuery = `
        SELECT prompt, result 
        FROM gpt_data 
        WHERE step_id = ? 
        ORDER BY created ASC
      `;
      try {
        const historyRecords = await query(historyQuery, [stepId]);
        console.log("History records for step_id:", historyRecords);
        return historyRecords;
      } catch (error) {
        console.error("Error fetching conversation history:", error);
        return [];
      }
    };

    const conversationHistory = await getConversationHistory(step_id);
    console.log("Conversation History for step_id:", conversationHistory);

    // Initial messages array
    const messages = [{ role: "system", content: systemMessage }];

    // Process conversation history and check for empty prompt or result
    let isLastRecordEmpty = false;
    conversationHistory.forEach((record) => {
      if (!record.prompt || !record.result) {
        isLastRecordEmpty = true;
      } else {
        messages.push({ role: "user", content: record.prompt });
        messages.push({ role: "assistant", content: record.result });
      }
    });

    // If the last record had empty prompt or result and a file is uploaded
    if (isLastRecordEmpty && uploadedFile) {
      console.log("Last record is empty, adding hardcoded file explanation...");

      const filePath = `./uploads/${uploadedFile}`;
      const fileExtension = path.extname(uploadedFile).toLowerCase();

      if (fileExtension !== ".pdf") {
        return res.status(400).json({
          status: false,
          error: "Only PDF files are allowed.",
        });
      }

      const extractedText = await extractTextFromPDF(filePath);
      messages.push({
        role: "user",
        content:
          "The user uploaded a file with important details. Here is the extracted content from the file: \n" +
          extractedText,
      });
    }

    // If there is a message, add it to the messages array
    if (message) {
      messages.push({ role: "user", content: message });
    }

    console.log("Final messages array:", JSON.stringify(messages, null, 2));

    const userResponse = await axios.post(
      "https://api.openai.com/v1/chat/completions",
      {
        model: "gpt-4o-mini",
        messages: messages,
        max_tokens: 2000,
      },
      {
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${process.env.OPENAI_SECRET_KEY}`,
        },
      }
    );

    console.log(userResponse.data);

    const assistantResponse = userResponse.data.choices[0].message.content;

    const insertQuery = `
      INSERT INTO gpt_data (result, step_id, parent_gpt_id, prompt, file) 
      VALUES (?, ?, ?, ?, ?)
    `;

    const previousRecordQuery = `
      SELECT id FROM gpt_data 
      WHERE step_id = ? 
      ORDER BY created DESC 
      LIMIT 1
    `;
    const previousRecord = await query(previousRecordQuery, [step_id]);
    console.log("Previous record:", previousRecord);

    const parentId = previousRecord.length > 0 ? previousRecord[0].id : null;

    const queryParams = [
      assistantResponse,
      step_id,
      parentId,
      message || null,
      uploadedFile || null,
    ];
    await query(insertQuery, queryParams);

    const fullConversation = [
      { role: "system", content: systemMessage },
      ...messages.slice(1),
      { role: "assistant", content: assistantResponse },
    ];

    console.log("Full Conversation:", fullConversation);

    return res.status(200).json({
      status: true,
      message: assistantResponse,
    });
  } catch (error) {
    console.error("Error in sendMessage API:", error);
    return res.status(500).json({
      status: false,
      error: error.message || "Internal Server Error",
    });
  }
};
export const getMessage = async (req, res) => {
  try {
    const step_id = req.params.id;
    const getQry = `
      SELECT id, result, prompt
      FROM gpt_data 
      WHERE step_id = ? 
      LIMIT 10
    `;

    const records = await query(getQry, [step_id]);

    if (records.length === 0) {
      return res
        .status(404)
        .json({ message: "No records found for the provided step ID" });
    }
    return res.status(200).json({ data: records });
  } catch (error) {
    console.error("Error in getMessage API:", error);
    return res.status(500).json({ message: "Internal Server Error" });
  }
};
export const addSkill = async (req, res) => {
  try {
    const { title, step_id, status } = req.body;
    const userId = req.user?.userId;

    if (!userId) {
      return res.status(400).json({ error: "User is not authorized" });
    }

    if (!step_id) {
      return res.status(400).json({ error: "StepId should be provided" });
    }

    const getMaxSortQuery = `
      SELECT COALESCE(MAX(sort), 0) + 1 AS nextSort FROM skills WHERE step_id = ?
    `;
    const [maxSortResult] = await query(getMaxSortQuery, [step_id]);
    const nextSort = maxSortResult.nextSort;

    const insertQuery = `
      INSERT INTO skills (title, step_id, status, sort)
      VALUES (?, ?, ?, ?)
    `;
    const results = await query(insertQuery, [
      title,
      step_id,
      status || "pending",
      nextSort,
    ]);

    const insert_activity_logs =
      "INSERT INTO activity_logs (name, user_id) VALUES (?,?)";

    pool.query(
      insert_activity_logs,
      [`Skill Created: ${title}`, userId],
      (err) => {
        if (err) {
          console.log(err);
          return res.status(500).json({ error: "Internal Server Error" });
        }
      }
    );

    console.log(results);
    return res.status(200).json({ message: "Skill created successfully" });
  } catch (error) {
    console.error("Database error:", error);
    return res.status(500).json({ error: "Internal Server Error" });
  }
};
export const updateSkill = async (req, res) => {
  try {
    const skillId = req.params.id;
    const userId = req.user?.userId;

    if (!userId) {
      return res.status(400).json({ error: "User is not authorized" });
    }

    if (!skillId) {
      return res.status(400).json({ error: "SkillIs should be provided" });
    }
    const { title, sort, step_id, status } = req.body;

    const fieldsToUpdate = [];
    const values = [];

    if (title !== undefined) {
      fieldsToUpdate.push("title = ?");
      values.push(title);
    }
    if (sort !== undefined) {
      fieldsToUpdate.push("sort = ?");
      values.push(sort);
    }
    if (step_id !== undefined) {
      fieldsToUpdate.push("step_id = ?");
      values.push(step_id);
    }
    if (status !== undefined) {
      fieldsToUpdate.push("status = ?");
      values.push(status);
    }

    if (fieldsToUpdate.length === 0) {
      return res.status(400).json({ error: "No field are provided to update" });
    }

    const updateQuery = `
      UPDATE skills
      SET ${fieldsToUpdate.join(", ")}
      WHERE id = ?
    `;

    values.push(skillId);
    const result = await query(updateQuery, values);

    if (result.affectedRows === 0) {
      return res.status(400).json({ error: "skill not found" });
    }

    const insert_activity_logs =
      "INSERT INTO activity_logs (name, user_id) VALUES (?,?)";

    pool.query(
      insert_activity_logs,
      [`Skill Updated: ${title}`, userId],
      (err) => {
        if (err) {
          console.log(err);
          return res.status(500).json({ error: "Internal Server Error" });
        }
      }
    );

    return res.status(200).json({ message: "skill has been updated" });
  } catch (error) {
    console.error("Error in updateSkill API:", error);
    return res.status(500).json({ error: "Internal Server Error" });
  }
};
export const deleteSkill = async (req, res) => {
  try {
    const skillId = req.params.id;
    const userId = req.user?.userId;

    if (!userId) {
      return res.status(400).json({ error: "User is not authorized" });
    }

    if (!skillId) {
      return res.status(400).json({ error: "SkillIs should be provided" });
    }

    const deleteQuery = `
      DELETE FROM skills
      WHERE id = ?
    `;

    const result = await query(deleteQuery, [skillId]);

    if (result.affectedRows === 0) {
      return res.status(400).json({ error: "Skill not found" });
    }

    const insert_activity_logs =
      "INSERT INTO activity_logs (name, user_id) VALUES (?,?)";

    pool.query(
      insert_activity_logs,
      [`Skill Deleted: ${title}`, userId],
      (err) => {
        if (err) {
          console.log(err);
          return res.status(500).json({ error: "Internal Server Error" });
        }
      }
    );

    return res.status(200).json({ message: "Skill has been deleted" });
  } catch (error) {
    console.error("Error in deleteSkill API:", error);
    return res.status(500).json({ error: "Internal Server Error" });
  }
};
export const getSinglePathDetailWithMap = async (req, res) => {
  try {
    const userId = req.user?.userId;
    const { pathId } = req.params;

    if (!pathId) {
      return res.status(400).json({ error: "PathID is required" });
    }

    const pathsQuery = `
    SELECT p.id, p.status, p.title, p.prompt, u.username 
    FROM path p
    JOIN users u ON p.user_id = u.id
    WHERE p.id = ? 
    ORDER BY p.id DESC
  `;

    const pathsResult = await query(pathsQuery, [pathId]);

    if (pathsResult.length === 0) {
      return res
        .status(404)
        .json(
          failureResponse({ status: 404 }, "No paths found for this user.")
        );
    }

    const pathIds = pathsResult.map((path) => path.id);

    // Fetch branches and steps for all paths
    const branchesQuery = `
      SELECT id, color, step_id, path_id 
      FROM branch 
      WHERE path_id IN (?)
    `;
    const branchesResult = await query(branchesQuery, [pathIds]);

    const stepsQuery = `
      SELECT id, title, description, branch_id, path_id, status
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
            Title: path.title,
            Prompt: path.prompt,
            Username: path.username,
            branch,
          };
        } else {
          return {
            id: path.id,
            Status: path.status,
            Title: path.title,
            Prompt: path.prompt,
            Username: path.username,
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
export const checkRemainingPlans = async (req, res) => {
  try {
    const userId = req.user.userId;
    if (!userId) {
      return res.status(400).json({ error: "User is not authorized" });
    }

    const checkUserSubscription = `
      SELECT * FROM user_subscription 
      WHERE user_id = ? AND expiry_date > NOW()
      ORDER BY created_at DESC 
      LIMIT 1
    `;

    pool.query(checkUserSubscription, [userId], (err, results) => {
      if (err) {
        console.error(err);
        return res.status(500).json({ error: "Internal Server Error" });
      }
      if (results.length === 0) {
        return res.status(400).json({ message: "No active subscription found for this user" });
      }

      const userSubscription = results[0];

      const getAllSubscriptions = "SELECT * FROM subscriptions WHERE id = ?";

      pool.query(getAllSubscriptions, [userSubscription.subscription_id], (err, subscriptionResult) => {
        if (err) {
          console.error(err);
          return res.status(500).json({ error: "Internal Server Error" });
        }

        if (subscriptionResult.length === 0) {
          return res.status(400).json({ message: "No Subscription details found" });
        }

        const subscription = subscriptionResult[0];

        const remainingPaths = subscription.total_path - (userSubscription.current_path || 0);
        const remainingTrainingPlans = subscription.total_training_plan - (userSubscription.current_training_plan || 0);

        const data = {
          subscriptionPlan: subscription.name,
          RemainingPrompts: remainingPaths,
          RemainingTrainingPlan: remainingTrainingPlans,
        };

        return res.status(200).json(data);
      });
    });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: "Internal Server Error" });
  }
};

export const uploadFilesForCHATGPT = async (req, res) => {
  try {
    const userId = req.user.userId;
    if (!userId) {
      return res.status(400).json({ error: "user is not authenticated" });
    }
    if (!req.file) {
      return res
        .status(400)
        .json(
          failureResponse({ error: "No file uploaded" }, "File Upload Failed")
        );
    }

    const filename = req.file?.filename;
  } catch (error) {}
};
export const editStepTitle = async (req, res) => {
  try {
    const stepId = req.params.stepId;
    const { title } = req.body;

    if (!title) {
      return res.status(400).json({ message: "Title is required" });
    }

    if (!stepId) {
      return res.status(400).json({ message: "StepId is required" });
    }

    const updateStepTitle = "UPDATE steps SET title = ? WHERE id = ?";
    pool.query(updateStepTitle, [title, stepId], (err, results) => {
      if (err) {
        console.error("Database query error:", err);
        return res.status(500).json({ error: "Internal Server Error" });
      }

      if (results.affectedRows === 0) {
        return res
          .status(404)
          .json({ message: "No step found with the provided StepId" });
      }

      return res
        .status(200)
        .json({ message: "Title has been updated successfully" });
    });
  } catch (error) {
    console.error("Server error:", error);
    return res.status(500).json({ error: "Internal Server Error" });
  }
};
