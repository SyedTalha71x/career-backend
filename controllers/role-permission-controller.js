import { connection } from "../utils/db/db.js";
import { successResponse, failureResponse } from "../Helper/helper.js";

export const createRole = async (req, res) => {
  try {
    const { name } = req.body;

    if (!name) {
      return res
        .status(400)
        .json(
          failureResponse({ error: "Role name is required" }, "Bad Request")
        );
    }

    const sqlQry = "INSERT INTO roles (name) VALUES (?)";

    connection.query(sqlQry, [name], (err, results) => {
      if (err) {
        console.log("Database Error--------------", err);
        return res
          .status(500)
          .json(
            failureResponse(
              { error: "Failed to create role" },
              "Internal Server Error"
            )
          );
      }
      return res
        .status(201)
        .json(
          successResponse({ id: results.insertId }, "Role created successfully")
        );
    });
  } catch (error) {
    console.log(error);
    return res
      .status(500)
      .json(
        failureResponse(
          { error: "Internal Server Error" },
          "Internal Server Error"
        )
      );
  }
};
export const updateRole = async (req, res) => {
  try {
    const { id } = req.params;
    const { name } = req.body;

    if (!name) {
      return res
        .status(400)
        .json(
          failureResponse({ error: "Role name is required" }, "Bad Request")
        );
    }

    const sqlQry = "UPDATE roles SET name = ? WHERE id = ?";

    connection.query(sqlQry, [name, id], (err, results) => {
      if (err) {
        console.log("Database Error--------------", err);
        return res
          .status(500)
          .json(
            failureResponse(
              { error: "Failed to update role" },
              "Internal Server Error"
            )
          );
      }
      if (results.affectedRows === 0) {
        return res
          .status(404)
          .json(
            failureResponse(
              { error: "Role not found" },
              "Role with the specified ID does not exist"
            )
          );
      }
      return res
        .status(200)
        .json(successResponse({ id: results.id }, "Role updated successfully"));
    });
  } catch (error) {
    console.log(error);
    return res
      .status(500)
      .json(
        failureResponse(
          { error: "Internal Server Error" },
          "Internal Server Error"
        )
      );
  }
};
export const createPermission = async (req, res) => {
  try {
    const { permission } = req.body;

    if (!permission) {
      return res
        .status(400)
        .json(
          failureResponse(
            { error: "Permission name is required" },
            "Bad Request"
          )
        );
    }

    const sqlQry = "INSERT INTO permissions (name) VALUES (?)";

    connection.query(sqlQry, [permission], (err, results) => {
      if (err) {
        console.log("Database Error--------------", err);
        return res
          .status(500)
          .json(
            failureResponse(
              { error: "Failed to create permission" },
              "Internal Server Error"
            )
          );
      }
      return res
        .status(201)
        .json(
          successResponse(
            { id: results.insertId },
            "Permission created successfully"
          )
        );
    });
  } catch (error) {
    console.log(error);
    return res
      .status(500)
      .json(
        failureResponse(
          { error: "Internal Server Error" },
          "Internal Server Error"
        )
      );
  }
};
export const updatePermission = async (req, res) => {
  try {
    const { id } = req.params;
    const { permission } = req.body;

    if (!permission) {
      return res
        .status(400)
        .json(
          failureResponse(
            { error: "Permission name is required" },
            "Bad Request"
          )
        );
    }

    const sqlQry = "UPDATE permissions SET name = ? WHERE id = ?";

    connection.query(sqlQry, [permission, id], (err, results) => {
      if (err) {
        console.log("Database Error--------------", err);
        return res
          .status(500)
          .json(
            failureResponse(
              { error: "Failed to update permission" },
              "Internal Server Error"
            )
          );
      }
      if (results.affectedRows === 0) {
        return res
          .status(404)
          .json(
            failureResponse(
              { error: "Permission not found" },
              "Permission with the specified ID does not exist"
            )
          );
      }
      return res
        .status(200)
        .json(
          successResponse({ id: results.id }, "Permission updated successfully")
        );
    });
  } catch (error) {
    console.log(error);
    return res
      .status(500)
      .json(
        failureResponse(
          { error: "Internal Server Error" },
          "Internal Server Error"
        )
      );
  }
};
export const assignPermissionsToRole = async (req, res) => {
  try {
    const { roleId, permissionIds } = req.body; // roleId is the ID of the role, permissionIds is an array of permission IDs

    if (!roleId || !Array.isArray(permissionIds) || permissionIds.length === 0) {
      return res.status(400).json(
        failureResponse(
          { error: "Role ID and permission IDs are required" },
          "Bad Request"
        )
      );
    }

    // Query to check if the role exists
    const roleCheckQuery = "SELECT id FROM roles WHERE id = ?";
    connection.query(roleCheckQuery, [roleId], (err, roleResults) => {
      if (err || !roleResults.length) {
        return res.status(404).json(
          failureResponse(
            { error: "Role not found" },
            "The specified role does not exist"
          )
        );
      }

      // Prepare data for inserting into role_to_permission table
      const values = permissionIds.map((permissionId) => [roleId, permissionId]);

      // Insert multiple records into role_to_permission table
      const assignQuery = "INSERT INTO role_to_permission (role_id, permission_id) VALUES ?";

      connection.query(assignQuery, [values], (err, results) => {
        if (err) {
          console.log("Error assigning permissions to role", err);
          return res
            .status(500)
            .json(
              failureResponse(
                { error: "Failed to assign permissions to role" },
                "Internal Server Error"
              )
            );
        }

        return res
          .status(200)
          .json(successResponse(null, "Permissions assigned to role successfully"));
      });
    });
  } catch (error) {
    console.log(error);
    return res
      .status(500)
      .json(
        failureResponse(
          { error: "Internal Server Error" },
          "Internal Server Error"
        )
      );
  }
};
export const assignRoleToUser = async (req, res) => {
  try {
    const { userId, roleId } = req.body; // userId is the ID of the user, roleId is the ID of the role

    if (!userId || !roleId) {
      return res.status(400).json(
        failureResponse(
          { error: "User ID and Role ID are required" },
          "Bad Request"
        )
      );
    }

    // Query to check if the user exists
    const userCheckQuery = "SELECT id FROM users WHERE id = ?";
    connection.query(userCheckQuery, [userId], (err, userResults) => {
      if (err || !userResults.length) {
        return res.status(404).json(
          failureResponse(
            { error: "User not found" },
            "The specified user does not exist"
          )
        );
      }

      // Query to check if the role exists
      const roleCheckQuery = "SELECT id FROM roles WHERE id = ?";
      connection.query(roleCheckQuery, [roleId], (err, roleResults) => {
        if (err || !roleResults.length) {
          return res.status(404).json(
            failureResponse(
              { error: "Role not found" },
              "The specified role does not exist"
            )
          );
        }

        // Update the user's role
        const updateQuery = "UPDATE users SET role_id = ? WHERE id = ?";
        connection.query(updateQuery, [roleId, userId], (err, results) => {
          if (err) {
            console.log("Error updating user role", err);
            return res
              .status(500)
              .json(
                failureResponse(
                  { error: "Failed to update user role" },
                  "Internal Server Error"
                )
              );
          }

          return res
            .status(200)
            .json(successResponse(null, "User role updated successfully"));
        });
      });
    });
  } catch (error) {
    console.log(error);
    return res
      .status(500)
      .json(
        failureResponse(
          { error: "Internal Server Error" },
          "Internal Server Error"
        )
      );
  }
};


// Below are Testing api to check desired permissions 
export const createTab = (req, res) => {
  return res.status(200).json({ message: "Hello" });
};
export const createtabbars = (req, res) => {
  return res.status(200).json({ message: "Hello" });
};
