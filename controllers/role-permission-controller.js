import { connectToDB } from "../utils/db/db.js";
import { successResponse, failureResponse } from "../Helper/helper.js";
import { hashPassword } from "../Security/security.js";

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
export const getRole = async (req, res) => {
  try {
    const get_roles = "SELECT id, name FROM roles";
    
    pool.query(get_roles, (err, results) => {
      if (err) {
        console.log(err);
        return res.status(500).json({ error: 'Internal Server Error' });
      }

      if (results && results.length > 0) {
        return res.status(200).json({ results });
      } else {
        return res.status(404).json({ message: 'No roles found' });
      }
    });
  } catch (error) {
    console.log(error);
    return res.status(500).json({ error: 'Internal Server Error' });
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
    const { roleId, permissionIds } = req.body;

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
    const { moduleName, permissions } = req.body;

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
          `${moduleName.toLowerCase()}-${permission.toLowerCase()}`,
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
export const createUser = async (req, res) => {
  try {
    const { username, email, password } = req.body;

    if (!username || !email || !password) {
      console.log("Missing required fields");
      return res.status(400).json({ error: "All fields are required" });
    }

    const insert_user_query =
      "INSERT INTO users (username, email, password) VALUES (?, ?, ?)";
    const hashedPassword = hashPassword(password);

    pool.query(
      insert_user_query,
      [username, email, hashedPassword],
      (err, results) => {
        if (err) {
          console.log("Database error:", err);
          return res.status(500).json({ error: "Internal Server Error" });
        }

        const userId = results.insertId;

        // Step to assign the Admin role (role ID 2)
        const assign_role_query =
          "INSERT INTO role_to_users (user_id, role_id) VALUES (?, 2)";
        pool.query(assign_role_query, [userId], (roleErr, roleResults) => {
          if (roleErr) {
            console.log("Role assignment error:", roleErr);
            return res
              .status(500)
              .json({ error: "Internal Server Error while assigning role" });
          }

          const data = {
            userId: userId,
            message:
              "User has been created and Admin role has been assigned to him",
          };
          return res.status(200).json(data);
        });
      }
    );
  } catch (error) {
    console.log("Unexpected error:", error);
    return res.status(500).json({ error: "Internal Server Error" });
  }
};
export const updateUser = async (req, res) => {
  try {
    const { password } = req.body;
    const userId = req.params.id;

    if (!userId) {
      return res.status(400).json({ error: "UserID not found" });
    }

    const fieldsToUpdate = [];
    const values = [];

    if (password !== undefined) {
      const hashedPassword = await hashPassword(password);
      fieldsToUpdate.push("password = ?");
      values.push(hashedPassword);
    }

    if (fieldsToUpdate.length === 0) {
      return res
        .status(400)
        .json({ error: "No fields are provided to update" });
    }

    const updateQuery = `
      UPDATE users
      SET ${fieldsToUpdate.join(", ")}
      WHERE id = ?
    `;

    values.push(userId);

    pool.query(updateQuery, values, (err, result) => {
      if (err) {
        console.log(err);
        return res.status(500).json({ error: "Internal Server Error" });
      }

      if (result.affectedRows === 0) {
        return res.status(400).json({ error: "Nothing is updated" });
      }

      return res.status(200).json({ message: "User has been updated" });
    });
  } catch (error) {
    console.log(error);
    return res.status(500).json({ error: "Internal Server Error" });
  }
};
export const deleteUser = async (req, res) => {
  try {
    const userId = req.params.id;
    if (!userId) {
      return res.status(400).json({ error: "UserID not found" });
    }

    const deleteQuery = "DELETE FROM users WHERE id = ?";

    pool.query(deleteQuery, [userId], (err, results) => {
      if (err) {
        console.log("Database error:", err);
        return res.status(500).json({ error: "Internal Server Error" });
      }
      return res.status(200).json({ message: "User has been deleted" });
    });
  } catch (error) {
    console.log(error);
    return res.status(500).json({ error: "Internal Server Error" });
  }
};
export const getUsers = async (req, res) => {
  try {
    const fetchAllUsersQuery =
      "SELECT id, username, email, created_at FROM users";

    pool.query(fetchAllUsersQuery, (userErr, userResults) => {
      if (userErr) {
        console.error("Database query error (users):", userErr);
        return res.status(500).json({ error: "Internal Server Error" });
      }

      if (!userResults.length) {
        return res.status(404).json({ error: "No users found" });
      }

      const users = userResults;
      const usersWithRolesPromises = users.map((user) => {
        return new Promise((resolve, reject) => {
          const fetchRoleQuery =
            "SELECT role_id FROM role_to_users WHERE user_id = ?";
          pool.query(fetchRoleQuery, [user.id], (roleErr, roleResults) => {
            if (roleErr) {
              console.error("Database query error (role_to_users):", roleErr);
              return reject("Internal Server Error");
            }

            let roleId;
            if (!roleResults.length) {
              // Assign the default role ID (e.g., 3 for "user") if no role is found
              roleId = 3;
            } else {
              roleId = roleResults[0].role_id;
            }

            const fetchRoleNameQuery = "SELECT name FROM roles WHERE id = ?";
            pool.query(
              fetchRoleNameQuery,
              [roleId],
              (roleNameErr, roleNameResults) => {
                if (roleNameErr) {
                  console.error("Database query error (roles):", roleNameErr);
                  return reject("Internal Server Error");
                }

                let roleName;

                roleName = roleNameResults[0].name;

                resolve({
                  id: user.id,
                  username: user.username,
                  email: user.email,
                  created_at: user.created_at,
                  role: roleName,
                });
              }
            );
          });
        });
      });

      Promise.all(usersWithRolesPromises)
        .then((usersWithRoles) => {
          return res.status(200).json({ users: usersWithRoles });
        })
        .catch((error) => {
          console.error("Error processing user roles:", error);
          return res.status(500).json({ error: "Internal Server Error" });
        });
    });
  } catch (error) {
    console.error("Error in getUsers API:", error);
    return res.status(500).json({ error: "Internal Server Error" });
  }
};
export const listPermissions = async (req, res) => {
  try {
    const fetchAllModules = "SELECT id, module_name FROM modules";
    const fetchAllPermissions = "SELECT id, name FROM permissions";
    const fetchAllPermissionModules = "SELECT module_id, permission_id FROM permission_modules";

    const [moduleResults, permissionResults, permissionModuleResults] = await Promise.all([
      new Promise((resolve, reject) =>
        pool.query(fetchAllModules, (err, results) => {
          if (err) return reject(err);
          resolve(results);
        })
      ),
      new Promise((resolve, reject) =>
        pool.query(fetchAllPermissions, (err, results) => {
          if (err) return reject(err);
          resolve(results);
        })
      ),
      new Promise((resolve, reject) =>
        pool.query(fetchAllPermissionModules, (err, results) => {
          if (err) return reject(err);
          resolve(results);
        })
      ),
    ]);

    const permissionsByModule = moduleResults.map((module) => {
      const modulePermissions = permissionModuleResults
        .filter((pm) => pm.module_id === module.id)
        .map((pm) => {
          const permission = permissionResults.find((perm) => perm.id === pm.permission_id);
          return {
            permissionName: permission.name,
          };
        });

      return {
        moduleName: module.module_name,
        permissions: modulePermissions,
      };
    });

    return res.status(200).json({ permissionsByModule });
  } catch (error) {
    console.log(error);
    return res.status(500).json({ error: "Internal Server Error" });
  }
};

