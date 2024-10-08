import { connectToDB } from "../utils/db/db.js";
import { successResponse, failureResponse } from "../Helper/helper.js";

const pool = connectToDB();

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

    pool.query(sqlQry, [name], (err, results) => {
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

    pool.query(sqlQry, [name, id], (err, results) => {
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

    pool.query(sqlQry, [permission, id], (err, results) => {
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

    if (
      !roleId ||
      !Array.isArray(permissionIds) ||
      permissionIds.length === 0
    ) {
      return res
        .status(400)
        .json(
          failureResponse(
            { error: "Role ID and permission IDs are required" },
            "Bad Request"
          )
        );
    }

    // Query to check if the role exists
    const roleCheckQuery = "SELECT id FROM roles WHERE id = ?";
    pool.query(roleCheckQuery, [roleId], (err, roleResults) => {
      if (err || !roleResults.length) {
        return res
          .status(404)
          .json(
            failureResponse(
              { error: "Role not found" },
              "The specified role does not exist"
            )
          );
      }

      // Prepare data for inserting into role_to_permission table
      const values = permissionIds.map((permissionId) => [
        roleId,
        permissionId,
      ]);

      // Insert multiple records into role_to_permission table
      const assignQuery =
        "INSERT INTO permission_to_role (role_id, permission_id) VALUES ?";

      pool.query(assignQuery, [values], (err, results) => {
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
          .json(
            successResponse(null, "Permissions assigned to role successfully")
          );
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
export const assignRolesToUser = async (req, res) => {
  try {
    const { userId, roleIds } = req.body;

    if (!userId || !Array.isArray(roleIds) || roleIds.length === 0) {
      return res
        .status(400)
        .json(
          failureResponse(
            { error: "User ID and an array of Role IDs are required" },
            "Bad Request"
          )
        );
    }

    const userCheckQuery = "SELECT id FROM users WHERE id = ?";
    pool.query(userCheckQuery, [userId], (err, userResults) => {
      if (err || !userResults.length) {
        return res
          .status(404)
          .json(
            failureResponse(
              { error: "User not found" },
              "The specified user does not exist"
            )
          );
      }

      const roleCheckQuery = "SELECT id FROM roles WHERE id IN (?)";
      pool.query(roleCheckQuery, [roleIds], (err, roleResults) => {
        if (err || roleResults.length !== roleIds.length) {
          return res
            .status(404)
            .json(
              failureResponse(
                { error: "One or more roles not found" },
                "One or more specified roles do not exist"
              )
            );
        }

        const insertQuery = `INSERT INTO role_to_users (user_id, role_id) VALUES ?`;
        const values = roleIds.map((roleId) => [userId, roleId]);

        pool.query(insertQuery, [values], (err, results) => {
          if (err) {
            console.log("Error assigning user roles", err);
            return res
              .status(500)
              .json(
                failureResponse(
                  { error: "Failed to assign roles to user" },
                  "Internal Server Error"
                )
              );
          }

          return res
            .status(200)
            .json(successResponse(null, "User roles assigned successfully"));
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
export const createPermissionWithModule = async (req, res) => {
  try {
    const { moduleName, permissions, slugs } = req.body;

    if (!moduleName) {
      return res
        .status(400)
        .json(
          failureResponse(
            { error: "Module Name is required" },
            "Failed to create the module"
          )
        );
    }

    if (
      !permissions ||
      !Array.isArray(permissions) ||
      permissions.length === 0
    ) {
      return res
        .status(400)
        .json(
          failureResponse(
            { error: "Permissions array is required and cannot be empty" },
            "Bad Request"
          )
        );
    }

    if (
      !slugs ||
      !Array.isArray(slugs) ||
      slugs.length === 0 ||
      slugs.length !== permissions.length
    ) {
      return res
        .status(400)
        .json(
          failureResponse(
            { error: "Slugs array must match the length of permissions array" },
            "Bad Request"
          )
        );
    }

    // Check if the module already exists
    const checkModuleQuery = "SELECT id FROM modules WHERE module_name = ?";
    pool.query(checkModuleQuery, [moduleName], (err, results) => {
      if (err) {
        console.log(err);
        return res
          .status(500)
          .json(
            failureResponse(
              { error: "Internal Server Error" },
              "Failed to check the module"
            )
          );
      }

      let moduleId;

      if (results.length > 0) {
        // If the module already exists, use its id
        moduleId = results[0].id;
      } else {
        // Insert the module if it doesn't exist
        const modelQuery = "INSERT INTO modules (module_name) VALUES (?)";
        pool.query(modelQuery, [moduleName], (err, insertResults) => {
          if (err) {
            console.log(err);
            return res
              .status(500)
              .json(
                failureResponse(
                  { error: "Internal Server Error" },
                  "Failed to create the permission module"
                )
              );
          }

          moduleId = insertResults.insertId;
          createPermissions(moduleId); // Call the permission creation logic after module creation
        });
      }

      if (moduleId) {
        createPermissions(moduleId); // If the module exists, proceed with permission creation
      }

      // Function to create permissions
      function createPermissions(moduleId) {
        const permissionQuery = `
            INSERT INTO permissions (name, slug)
            VALUES ?
          `;

        const permissionValues = permissions.map((permission, index) => [
          permission,
          slugs[index],
        ]);

        pool.query(
          permissionQuery,
          [permissionValues],
          (err, permissionResults) => {
            if (err) {
              console.log(err);
              return res
                .status(500)
                .json(
                  failureResponse(
                    { error: "Internal Server Error" },
                    "Failed to create the permissions"
                  )
                );
            }

            // Permission IDs start from permissionResults.insertId and increment by 1 for each permission
            const permissionId = permissionResults.insertId;

            // Correctly map moduleId and permissionId for each permission
            const permissionModuleId = permissions.map((_, index) => [
              moduleId,
              permissionId + index,
            ]);

            const permissionModuleQuery = `
            INSERT INTO permission_modules (module_id, permission_id)
            VALUES ?
          `;

            pool.query(
              permissionModuleQuery,
              [permissionModuleId],
              (err, results) => {
                if (err) {
                  console.log(err);
                  return res
                    .status(500)
                    .json(
                      failureResponse(
                        { error: "Internal Server Error" },
                        "Failed to create the permission module relationship"
                      )
                    );
                }
                return res
                  .status(200)
                  .json(
                    successResponse(
                      { moduleId, permissionId },
                      "Permission with Module created Successfully"
                    )
                  );
              }
            );
          }
        );
      }
    });
  } catch (error) {
    console.log(error);
    return res
      .status(500)
      .json(
        failureResponse(
          { error: "Internal Server Error" },
          "Failed to create the permission module"
        )
      );
  }
};



