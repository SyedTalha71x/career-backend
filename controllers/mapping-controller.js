import { connection } from "../utils/db/db.js";
import { successResponse, failureResponse } from "../Helper/helper.js";
import { generateRandomColor } from '../Security/security.js';

export const createPath = (req, res) => {
  try {
    const { prompt } = req.body;
    const file = req.file;
    const userId = req.user?.userId;
    const color = generateRandomColor();

    // Check if either prompt or file is provided, but not both
    if ((!prompt && !file) || (prompt && file)) {
      return res.status(400).json(
        failureResponse({ error: 'You must provide either a prompt or file' }, 'Failed to create the path')
      );
    }

    // Extract the filename from the file path if a file is provided
    const fileName = file ? file.filename : null;

    // SQL query to insert data into the path table
    const sqlQuery = 'INSERT INTO path (prompt, file, color, status, user_id) VALUES (?, ?, ?, ?, ?)';
    connection.query(sqlQuery, [prompt || null, fileName || null, color, 'pending', userId], (err, result) => {
      if (err) {
        return res.status(500).json(
          failureResponse({ error: 'Internal Server Error' }, 'Failed to create the path')
        );
      }
      res.status(200).json(successResponse({ color }, 'Path is created successfully'));
    });
  } catch (error) {
    console.error("Unexpected error:", error);
    return res.status(500).json(
      failureResponse({ error: "Internal Server Error" }, "Failed to create the path")
    );
  }
};
export const getPathsWithDetails = (req, res) => {
  try {
    const userId = req.user?.userId;

    if (!userId) {
      return res.status(400).json(failureResponse({ error: 'User ID is required' }, 'Failed to retrieve paths'));
    }

     // get all paths for the user
    const pathsQuery = 'SELECT * FROM path WHERE user_id = ?';
    connection.query(pathsQuery, [userId], (err, pathsResult) => {
      if (err) {
        return res.status(500).json(failureResponse({ error: 'Internal Server Error' }, 'Failed to retrieve paths'));
      }

      const paths = {};
      pathsResult.forEach(path => {
        paths[path.id] = {
          id: path.id,
          prompt: path.prompt,
          file: path.file,
          color: path.color,
          status: path.status,
          steps: []
        };
      });

      // For each path, get its associated steps
      const pathIds = pathsResult.map(path => path.id);
      const stepsQuery = `
        SELECT * FROM steps 
        WHERE path_id IN (${pathIds.map(() => '?').join(',')})
      `;
      connection.query(stepsQuery, pathIds, (err, stepsResult) => {
        if (err) {
          return res.status(500).json(failureResponse({ error: 'Internal Server Error' }, 'Failed to retrieve steps'));
        }

        stepsResult.forEach(step => {
          if (paths[step.path_id]) {
            paths[step.path_id].steps.push({
              id: step.id,
              title: step.title,
              description: step.description,
              sort: step.sort,
              status: step.status,
              skills: []
            });
          }
        });

        // Step 3: For each step, get its associated skills
        const stepIds = stepsResult.map(step => step.id);
        const skillsQuery = `
          SELECT * FROM skills 
          WHERE step_id IN (${stepIds.map(() => '?').join(',')})
        `;
        connection.query(skillsQuery, stepIds, (err, skillsResult) => {
          if (err) {
            return res.status(500).json(failureResponse({ error: 'Internal Server Error' }, 'Failed to retrieve skills'));
          }

          skillsResult.forEach(skill => {
            for (const pathId in paths) {
              const path = paths[pathId];
              const step = path.steps.find(s => s.id === skill.step_id);
              if (step) {
                step.skills.push({
                  id: skill.id,
                  title: skill.title,
                  sort: skill.sort,
                  status: skill.status
                });
              }
            }
          });

          // Format the final response
          res.status(200).json(successResponse(Object.values(paths), 'Paths retrieved successfully'));
        });
      });
    });
  } catch (error) {
    console.error("Unexpected error:", error);
    return res.status(500).json(failureResponse({ error: "Internal Server Error" }, "Failed to retrieve paths"));
  }
};
export const getPathsForUser = (req, res) => {
  try {
    const userId = req.user?.userId; 

    if (!userId) {
      return res.status(400).json(failureResponse({ error: 'User ID is required' }, 'Failed to retrieve paths'));
    }

    const pathsQuery = 'SELECT * FROM path WHERE user_id = ?';
    connection.query(pathsQuery, [userId], (err, pathsResult) => {
      if (err) {
        return res.status(500).json(failureResponse({ error: 'Internal Server Error' }, 'Failed to retrieve paths'));
      }

      if (pathsResult.length === 0) {
        return res.status(200).json(successResponse([], 'No paths found for the user'));
      }

      const pathIds = pathsResult.map(path => path.id); // corrected from path._id to path.id

      const skillsCountQuery = `
        SELECT steps.path_id, COUNT(skills.id) AS skill_count 
        FROM skills 
        INNER JOIN steps ON skills.step_id = steps.id 
        WHERE steps.path_id IN (${pathIds.map(() => '?').join(',')})
        GROUP BY steps.path_id
      `;

      connection.query(skillsCountQuery, pathIds, (err, skillsCountResult) => {
        if (err) {
          return res.status(500).json(failureResponse({ error: 'Internal Server Error' }, 'Failed to retrieve skills count'));
        }

        const skillsCount = {};
        skillsCountResult.forEach(row => {
          skillsCount[row.path_id] = row.skill_count;
        });

        const pathresultWithSkillsCount = pathsResult.map(path => ({
          id: path.id,
          prompt: path.prompt,
          file: path.file,
          color: path.color,
          status: path.status,
          skill_count: skillsCount[path.id] || 0 // Default to 0 if no skills are found
        }));

        return res.status(200).json(successResponse(pathresultWithSkillsCount, 'Paths retrieved successfully'));
      });
    });
  } catch (error) {
    console.error("Unexpected error:", error);
    return res.status(500).json(failureResponse({ error: 'Internal Server Error' }, 'Failed to retrieve paths'));
  }
};

export const getSkillsForUser = (req, res) => {
  try {
    const userId = req.user?.userId;  

    if (!userId) {
      return res.status(400).json(failureResponse({ error: 'User ID is required' }, 'Failed to retrieve skills'));
    }

    const query = `
      SELECT skills.* FROM skills 
      INNER JOIN steps ON skills.step_id = steps.id 
      INNER JOIN path ON steps.path_id = path.id
      WHERE path.user_id = ?
    `;

    connection.query(query, [userId], (err, skillsResult) => {
      if (err) {
        return res.status(500).json(failureResponse({ error: 'Internal Server Error' }, 'Failed to retrieve skills'));
      }

      return res.status(200).json(successResponse(skillsResult, 'Skills retrieved successfully'));
    });
  } catch (error) {
    console.error("Unexpected error:", error);
    return res.status(500).json(failureResponse({ error: 'Internal Server Error' }, 'Failed to retrieve skills'));
  }
};




