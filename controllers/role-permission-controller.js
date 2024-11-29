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
    const get_roles =
      "SELECT id, name, created_at FROM roles WHERE name NOT IN ('Super Admin','User') ORDER BY created_at DESC";

    pool.query(get_roles, (err, results) => {
      if (err) {
        console.log(err);
        return res.status(500).json({ error: "Internal Server Error" });
      }

      if (results && results.length > 0) {
        return res.status(200).json({ results });
      } else {
        return res.status(404).json({ message: "No roles found" });
      }
    });
  } catch (error) {
    console.log(error);
    return res.status(500).json({ error: "Internal Server Error" });
  }
};
export const updateModuleAndPermissions = async (req, res) => {
  try {
    const { moduleId, moduleName, permissions } = req.body;

    if (!moduleId) {
      return res
        .status(400)
        .json(
          failureResponse(
            { error: "Module ID is required and cannot be empty" },
            "Bad Request"
          )
        );
    }

    if (moduleName) {
      const updateModuleQuery =
        "UPDATE modules SET module_name = ? WHERE id = ?";
      pool.query(
        updateModuleQuery,
        [moduleName, moduleId],
        (err, moduleUpdateResult) => {
          if (err) {
            console.error("Error updating module:", err);
            return res.status(500).json({ error: "Internal Server Error" });
          }

          if (moduleUpdateResult.affectedRows === 0) {
            return res
              .status(404)
              .json(
                failureResponse({ error: "Module not found" }, "Not Found")
              );
          }

          console.log("Module updated successfully");
        }
      );
    }

    // Step 2: Handle Permissions
    if (permissions && Array.isArray(permissions)) {
      const fetchPermissionsQuery = `
        SELECT p.id, p.name 
        FROM permissions p
        JOIN permission_modules pm ON p.id = pm.permission_id
        WHERE pm.module_id = ?`;

      pool.query(
        fetchPermissionsQuery,
        [moduleId],
        (err, existingPermissions) => {
          if (err) {
            console.error("Error fetching existing permissions:", err);
            return res.status(500).json({ error: "Internal Server Error" });
          }

          // Create a map for quick lookup of existing permissions
          const existingPermissionsMap = new Map();
          existingPermissions.forEach((permission) => {
            existingPermissionsMap.set(permission.name, permission.id);
          });

          // Identify permissions to delete
          const frontendPermissionNames = permissions.map((p) => p.name);
          const permissionsToDelete = existingPermissions
            .filter((p) => !frontendPermissionNames.includes(p.name))
            .map((p) => p.id);

          const permissionsToAdd = permissions.filter(
            (p) => !existingPermissionsMap.has(p.name)
          );

          const results = {
            added: [],
            deleted: [],
            failed: [],
          };

          // Step 3: Delete Permissions that are no longer needed
          if (permissionsToDelete.length > 0) {
            permissionsToDelete.forEach((permissionId) => {
              const checkRoleAssignmentsQuery =
                "SELECT * FROM permission_to_role WHERE permission_id = ?";
              pool.query(
                checkRoleAssignmentsQuery,
                [permissionId],
                (err, roleAssignments) => {
                  if (err) {
                    console.error("Error checking role assignments:", err);
                    results.failed.push({
                      id: permissionId,
                      error: "Failed to check role assignments",
                    });
                    return;
                  }

                  if (roleAssignments.length > 0) {
                    const deleteFromRoleAssignmentsQuery =
                      "DELETE FROM permission_to_role WHERE permission_id = ?";
                    pool.query(
                      deleteFromRoleAssignmentsQuery,
                      [permissionId],
                      (err) => {
                        if (err) {
                          console.error(
                            "Error deleting role assignments:",
                            err
                          );
                          results.failed.push({
                            id: permissionId,
                            error: "Failed to delete role assignments",
                          });
                          return;
                        }

                        console.log(
                          `Deleted role assignments for permission ID: ${permissionId}`
                        );
                      }
                    );
                  }

                  const deleteFromPermissionModulesQuery =
                    "DELETE FROM permission_modules WHERE permission_id = ?";
                  pool.query(
                    deleteFromPermissionModulesQuery,
                    [permissionId],
                    (err) => {
                      if (err) {
                        console.error(
                          "Error deleting from permission_modules:",
                          err
                        );
                        results.failed.push({
                          id: permissionId,
                          error: "Failed to delete from permission_modules",
                        });
                        return;
                      }

                      const deletePermissionQuery =
                        "DELETE FROM permissions WHERE id = ?";
                      pool.query(
                        deletePermissionQuery,
                        [permissionId],
                        (err, deleteResult) => {
                          if (err) {
                            console.error("Error deleting permission:", err);
                            results.failed.push({
                              id: permissionId,
                              error: "Failed to delete permission",
                            });
                            return;
                          }

                          if (deleteResult.affectedRows > 0) {
                            results.deleted.push({
                              id: permissionId,
                              name: existingPermissionsMap.get(permissionId),
                              message: "Permission deleted successfully",
                            });
                            console.log(
                              `Permission with ID ${permissionId} deleted successfully`
                            );
                          } else {
                            results.failed.push({
                              id: permissionId,
                              error: "Failed to delete permission",
                            });
                          }
                        }
                      );
                    }
                  );
                }
              );
            });
          }

          // Step 4: Add New Permissions
          permissionsToAdd.forEach((permission) => {
            const slug = `${moduleName}-${permission.name}`
              .toLowerCase()
              .replace(/ /g, "-");

            // Check if permission already exists in the database before adding
            const checkExistingPermissionQuery =
              "SELECT id FROM permissions WHERE name = ?";
            pool.query(
              checkExistingPermissionQuery,
              [permission.name],
              (err, existingPermission) => {
                if (err) {
                  console.error("Error checking if permission exists:", err);
                  results.failed.push({
                    name: permission.name,
                    error: "Failed to check if permission exists",
                  });
                  return;
                }

                // If permission does not exist, insert it
                if (existingPermission.length === 0) {
                  const addPermissionQuery =
                    "INSERT INTO permissions (name, slug) VALUES (?, ?)";
                  pool.query(
                    addPermissionQuery,
                    [permission.name, slug],
                    (err, addResult) => {
                      if (err) {
                        console.error("Error adding permission:", err);
                        results.failed.push({
                          name: permission.name,
                          error: "Failed to add permission",
                        });
                        return;
                      }

                      if (addResult.affectedRows > 0) {
                        const permissionId = addResult.insertId;
                        console.log(
                          `Permission '${permission.name}' added with ID: ${permissionId}`
                        );

                        const addToPermissionModulesQuery =
                          "INSERT INTO permission_modules (module_id, permission_id) VALUES (?, ?)";
                        pool.query(
                          addToPermissionModulesQuery,
                          [moduleId, permissionId],
                          (err) => {
                            if (err) {
                              console.error(
                                "Error linking permission to module:",
                                err
                              );
                              results.failed.push({
                                name: permission.name,
                                error: "Failed to link permission to module",
                              });
                              return;
                            }

                            results.added.push({
                              id: permissionId,
                              moduleId: moduleId,
                              name: permission.name,
                              message: `Permission '${permission.name}' added successfully to module '${moduleName}'`,
                            });
                          }
                        );
                      }
                    }
                  );
                } else {
                  console.log(
                    `Permission '${permission.name}' already exists in the database, skipping add.`
                  );
                }
              }
            );
          });

          // Wait for a moment to ensure queries finish before sending response
          setTimeout(() => {
            return res.status(200).json({
              results: results,
            });
          }, 500);
        }
      );
    } else {
      return res
        .status(400)
        .json(
          failureResponse(
            { error: "Permissions array is required" },
            "Bad Request"
          )
        );
    }
  } catch (error) {
    console.error("Error occurred during processing:", error);
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
    const { username, email, password, roleId } = req.body;

    if (!username || !email || !password || !roleId) {
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

        pool.query(
          "INSERT INTO role_to_users (role_id, user_id) VALUES (?,?)",
          [roleId, userId],
          (err, roleResults) => {
            if (err) {
              console.log("Database error:", err);
              return res.status(500).json({ error: "Internal Server Error" });
            }

            const data = {
              userId: userId,
              message:
                "User has been created successfully and role has been assigned",
            };
            return res.status(200).json(data);
          }
        );
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

    // Query to check if the user has an Admin role (role ID 2)
    const checkRoleQuery = `
      SELECT r.id AS role_id
      FROM roles r
      JOIN role_to_users rt ON r.id = rt.role_id
      WHERE rt.user_id = ? AND r.id = 2
    `;

    pool.query(checkRoleQuery, [userId], (checkErr, checkResults) => {
      if (checkErr) {
        console.log("Role check error:", checkErr);
        return res.status(500).json({ error: "Internal Server Error" });
      }

      console.log("Check role results:", checkResults);

      if (checkResults.length === 0) {
        return res.status(403).json({
          error:
            "Sorry you cannot delete this user because he is not assigned to the Admin role",
        });
      }

      const deleteRoleQuery = "DELETE FROM role_to_users WHERE user_id = ?";
      pool.query(deleteRoleQuery, [userId], (roleErr, roleResults) => {
        if (roleErr) {
          console.log("Role deletion error:", roleErr);
          return res.status(500).json({ error: "Internal Server Error" });
        }

        console.log("Role relation deleted successfully:", roleResults);

        const deleteUserQuery = "DELETE FROM users WHERE id = ?";
        pool.query(deleteUserQuery, [userId], (userErr, userResults) => {
          if (userErr) {
            console.log("User deletion error:", userErr);
            return res.status(500).json({ error: "Internal Server Error" });
          }

          console.log("User deleted successfully:", userResults);
          return res.status(200).json({ message: "User has been deleted" });
        });
      });
    });
  } catch (error) {
    console.log(error);
    return res.status(500).json({ error: "Internal Server Error" });
  }
};
export const getUsers = async (req, res) => {
  try {
    const fetchAllUsersQuery =
      "SELECT id, username, email, created_at FROM users ORDER BY created_at DESC";

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
    const fetchAllModules =
      "SELECT id, module_name FROM modules ORDER BY id DESC  ";
    const fetchAllPermissions =
      "SELECT id, name, created_at FROM permissions ORDER BY id DESC ";
    const fetchAllPermissionModules =
      "SELECT module_id, permission_id FROM permission_modules";

    const [moduleResults, permissionResults, permissionModuleResults] =
      await Promise.all([
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
          const permission = permissionResults.find(
            (perm) => perm.id === pm.permission_id
          );
          return {
            permissionId: permission.id,
            permissionName: permission.name,
            createdAt: permission.created_at,
          };
        })
        .sort((a, b) => b.permissionId - a.permissionId);

      return {
        id: module.id,
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
export const getRolePermissions = async (req, res) => {
  try {
    const roleId = req.params.roleId;

    const query = `
      SELECT
        m.module_name AS moduleName,
        p.id AS permissionId,
        p.name AS permissionName,
        CASE 
          WHEN pr.role_id IS NOT NULL THEN 1  -- Permission assigned to the role, return true
          ELSE 0  -- No permission assigned, return false
        END AS status
      FROM
        permissions p
      LEFT JOIN
        permission_modules pm ON p.id = pm.permission_id
      LEFT JOIN
        modules m ON m.id = pm.module_id
      LEFT JOIN
        permission_to_role pr ON p.id = pr.permission_id AND pr.role_id = ?
      ORDER BY
        m.module_name, p.name;
    `;

    pool.query(query, [roleId], (error, results) => {
      if (error) {
        return res.status(500).json({
          status: false,
          message: "Error fetching role permissions",
          error,
        });
      }

      // Customizing the result to ensure `status` is `true` or `false`
      const formattedResults = results.reduce((acc, row) => {
        let module = acc.find((m) => m.moduleName === row.moduleName);
        if (!module) {
          module = {
            moduleName: row.moduleName,
            permissions: [],
          };
          acc.push(module);
        }

        module.permissions.push({
          permissionId: row.permissionId,
          permissionName: row.permissionName,
          status: row.status === 1, // Convert `1` to `true` and `0` to `false`
        });

        return acc;
      }, []);

      res.json({
        status: true,
        data: formattedResults,
        message: "Permissions retrieved successfully",
      });
    });
  } catch (err) {
    res
      .status(500)
      .json({ status: false, message: "Server error", error: err.message });
  }
};
export const getMostPaths = async (req, res) => {
  try {
    const sqlQuery = `
      SELECT title, COUNT(*) as count, 
      ROUND((COUNT(*) / (SELECT COUNT(*) FROM path) * 100), 2) as percentage
      FROM path
      GROUP BY title
      ORDER BY count DESC
    `;

    pool.query(sqlQuery, (err, results) => {
      if (err) {
        console.error("Error fetching most created paths:", err);
        return res
          .status(500)
          .json(
            failureResponse(
              { error: "Internal Server Error" },
              "Failed to fetch data"
            )
          );
      }

      if (results.length === 0) {
        return res
          .status(404)
          .json(
            failureResponse({ error: "No paths found" }, "No data available")
          );
      }

      const data = results.map((row) => ({
        title: row.title,
        percentage: row.percentage,
      }));

      res
        .status(200)
        .json(
          successResponse(
            data,
            "Most created paths with percentages fetched successfully"
          )
        );
    });
  } catch (error) {
    console.error("Unexpected error:", error);
    return res
      .status(500)
      .json(
        failureResponse(
          { error: "Internal Server Error" },
          "Failed to fetch data"
        )
      );
  }
};
export const getActivitylogs = async (req, res) => {
  try {
    const { page = 1 } = req.query;
    const itemsPerPage = 10;
    const offset = (page - 1) * itemsPerPage;

    const fetch_all_logs = `SELECT 
      activity_logs .id,
      activity_logs .name,
      activity_logs.user_id,
      users.username
      FROM 
      activity_logs 
      JOIN
      users
      ON  
      activity_logs .user_id = users.id
      ORDER BY 
      activity_logs.created_at DESC 
      LIMIT ? OFFSET ?
`;

    const countQuery = "SELECT COUNT(*) AS total FROM activity_logs";

    const [activity_logs, totalCount] = await Promise.all([
      new Promise((resolve, reject) => {
        pool.query(fetch_all_logs, [itemsPerPage, offset], (err, results) => {
          if (err) {
            console.log(err);
            return reject(err);
          }
          resolve(results);
        });
      }),
      new Promise((resolve, reject) => {
        pool.query(countQuery, (err, results) => {
          if (err) {
            console.log(err);
            return reject(err);
          }
          resolve(results[0].total);
        });
      }),
    ]);

    if (activity_logs.length === 0) {
      return res.status(400).json({ message: "Sorry no activity logs found" });
    }

    const totalPages = Math.ceil(totalCount / itemsPerPage);

    return res.status(200).json({
      currentPage: page,
      totalPages: totalPages,
      totalActivityLogs: totalCount,
      activity_logs,
    });
  } catch (error) {
    console.log(error);
    return res.status(500).json({ error: "Internal Server Error" });
  }
};
export const adminUpdateSkill = async (req, res) => {
  console.log("adminUpdateSkill API called");
  try {
    const { skillId } = req.params;

    if (!skillId) {
      return res.status(400).json({ error: "SkillId must be provided" });
    }

    const { title, step_id, status } = req.body;

    const fieldsToUpdate = [];
    const values = [];

    if (title !== undefined) {
      fieldsToUpdate.push("title = ?");
      values.push(title);
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
      return res.status(400).json({ error: "No fields provided to update" });
    }

    const updateQuery = `
      UPDATE skills
      SET ${fieldsToUpdate.join(", ")}
      WHERE id = ?
    `;

    values.push(skillId);
    pool.query(updateQuery, values, (err, result) => {
      if (err) {
        console.log(err);
        return res.status(500).json({ error: "Internal Server Error" });
      }
      if (result.affectedRows === 0) {
        return res.status(404).json({ error: "Skill not found" });
      }

      return res
        .status(200)
        .json({ message: "Skill has been updated successfully" });
    });
  } catch (error) {
    console.error("Error in adminUpdateSkill API:", error);
    return res.status(500).json({ error: "Internal Server Error" });
  }
};
export const adminDeleteSkill = async (req, res) => {
  console.log("adminDeleteSkill API called");
  try {
    const { skillId } = req.params;

    if (!skillId) {
      return res.status(400).json({ error: "SkillId must be provided" });
    }

    const deleteQuery = `
      DELETE FROM skills
      WHERE id = ?
    `;

    pool.query(deleteQuery, [skillId], (err, result) => {
      if (err) {
        console.log(err);
        return res.status(500).json({ error: "Internal Server Error" });
      }
      if (result.affectedRows === 0) {
        return res.status(404).json({ error: "Skill not found" });
      }
      return res
        .status(200)
        .json({ message: "Skill has been deleted successfully" });
    });
  } catch (error) {
    console.error("Error in adminDeleteSkill API:", error);
    return res.status(500).json({ error: "Internal Server Error" });
  }
};
export const getAllSkills = async (req, res) => {
  try {
    const { page = 1 } = req.query;
    const itemsPerPage = 10;
    const offset = (page - 1) * itemsPerPage;

    // Step 1: Fetch skills with pagination
    const fetchSkillsQuery = `
      SELECT id, title, step_id, status 
      FROM skills 
      ORDER BY id DESC 
      LIMIT ? OFFSET ?;
    `;

    const skills = await new Promise((resolve, reject) => {
      pool.query(fetchSkillsQuery, [itemsPerPage, offset], (err, results) => {
        if (err) return reject(err);
        resolve(results);
      });
    });

    if (skills.length === 0) {
      return res.status(404).json({ message: "No skills found" });
    }

    // Step 2: Fetch steps for the fetched skills
    const stepIds = skills.map((skill) => skill.step_id).filter(Boolean); // Remove null/undefined step_ids
    const steps = await new Promise((resolve, reject) => {
      if (stepIds.length === 0) return resolve([]);
      pool.query(
        `SELECT id, path_id FROM steps WHERE id IN (?);`,
        [stepIds],
        (err, results) => {
          if (err) return reject(err);
          resolve(results);
        }
      );
    });

    // Step 3: Fetch paths for the fetched steps
    const pathIds = steps.map((step) => step.path_id).filter(Boolean);
    const paths = await new Promise((resolve, reject) => {
      if (pathIds.length === 0) return resolve([]);
      pool.query(
        `SELECT id, user_id FROM path WHERE id IN (?);`,
        [pathIds],
        (err, results) => {
          if (err) return reject(err);
          resolve(results);
        }
      );
    });

    // Step 4: Fetch users for the fetched paths
    const userIds = paths.map((path) => path.user_id).filter(Boolean);
    const users = await new Promise((resolve, reject) => {
      if (userIds.length === 0) return resolve([]);
      pool.query(
        `SELECT id, username FROM users WHERE id IN (?);`,
        [userIds],
        (err, results) => {
          if (err) return reject(err);
          resolve(results);
        }
      );
    });

    // Step 5: Map everything together
    const userMap = Object.fromEntries(
      users.map((user) => [user.id, user.username])
    );
    const pathMap = Object.fromEntries(
      paths.map((path) => [path.id, path.user_id])
    );
    const stepMap = Object.fromEntries(
      steps.map((step) => [step.id, step.path_id])
    );

    const enrichedSkills = skills.map((skill) => {
      const stepId = skill.step_id;
      const pathId = stepMap[stepId];
      const userId = pathMap[pathId];
      const username = userMap[userId];

      return {
        ...skill,
        username: username || "Unknown", // Include username if found
      };
    });

    // Step 6: Count total skills for pagination
    const totalCount = await new Promise((resolve, reject) => {
      pool.query("SELECT COUNT(*) AS total FROM skills", (err, results) => {
        if (err) return reject(err);
        resolve(results[0].total);
      });
    });

    const totalPages = Math.ceil(totalCount / itemsPerPage);

    return res.status(200).json({
      currentPage: Number(page),
      totalPages,
      totalSkills: totalCount,
      skills: enrichedSkills,
    });
  } catch (error) {
    console.error("Error fetching skills:", error);
    return res.status(500).json({ error: "Internal Server Error" });
  }
};
export const getAllPaths = async (req, res) => {
  try {
    const { page = 1 } = req.query;
    const itemsPerPage = 10;
    const offset = (page - 1) * itemsPerPage; // calculating the starting point

    // Fetch paths with pagination
    const fetchPathsQuery = `
      SELECT id, prompt, status, user_id, title 
      FROM path 
      ORDER BY id DESC 
      LIMIT ? OFFSET ?
    `;

    const countQuery = "SELECT COUNT(*) AS total FROM path";

    // Fetch paths and total count in parallel
    const [paths, totalCount] = await Promise.all([
      new Promise((resolve, reject) =>
        pool.query(fetchPathsQuery, [itemsPerPage, offset], (err, results) => {
          if (err) return reject(err);
          resolve(results);
        })
      ),
      new Promise((resolve, reject) =>
        pool.query(countQuery, (err, results) => {
          if (err) return reject(err);
          resolve(results[0].total);
        })
      ),
    ]);

    if (paths.length === 0) {
      return res.status(404).json({ message: "No paths found" });
    }

    // Fetch users based on user_ids in paths
    const userIds = paths.map((path) => path.user_id).filter(Boolean); // Filter out null or undefined
    const users = userIds.length
      ? await new Promise((resolve, reject) =>
          pool.query(
            `SELECT id, username FROM users WHERE id IN (?)`,
            [userIds],
            (err, results) => {
              if (err) return reject(err);
              resolve(results);
            }
          )
        )
      : [];

    // Create a user map for easy lookup
    const userMap = Object.fromEntries(
      users.map((user) => [user.id, user.username])
    );

    // Enrich paths with username
    const enrichedPaths = paths.map((path) => ({
      ...path,
      username: userMap[path.user_id] || "Unknown", // Add username or null if not found
    }));

    const totalPages = Math.ceil(totalCount / itemsPerPage);

    return res.status(200).json({
      currentPage: Number(page),
      totalPages,
      totalPaths: totalCount,
      paths: enrichedPaths,
    });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: "Internal Server Error" });
  }
};
export const updatePathPrompt = async (req, res) => {
  const { pathId } = req.params;

  const { newPrompt } = req.body;

  if (!pathId) {
    return res.status(400).json({ error: "Path ID is required" });
  }

  if (!newPrompt) {
    return res.status(400).json({ error: "New prompt are required." });
  }

  try {
    const updatePathquery = `
      UPDATE path 
      SET prompt = ? 
      WHERE id = ?;
    `;
    pool.query(updatePathquery, [newPrompt, pathId], (err, result) => {
      if (err) {
        console.log(err);
        return res.status(500).json({ err: "Internal Server Error" });
      }

      if (result.affectedRows === 0) {
        return res
          .status(404)
          .json({ error: "Path not found or no changes made." });
      }

      return res.status(200).json({ message: "Prompt updateds successfully." });
    });
  } catch (error) {
    console.log(error);
    return res.status(500).json({ error: "Internal Server Error" });
  }
};
export const getAnalytics = async (req, res) => {
  try {
    const fetch_user_count = "SELECT COUNT(*) AS total_users FROM users";
    const fetch_total_paths = "SELECT COUNT(*) AS total_paths FROM path";
    const fetch_pending_paths =
      `SELECT COUNT(*) AS total_pending_paths FROM path WHERE status = 'pending'`;

    pool.query(fetch_user_count, (err, totalusersresults) => {
      if (err) {
        console.log(err);
        return res.status(500).json({ error: "Internal Server Error" });
      }

      const totalUsers = totalusersresults[0].total_users;

      pool.query(fetch_total_paths, (err, totalPathResults) => {
        if (err) {
          console.log(err);
          return res.status(500).json({ error: "Internal Server Error" });
        }

        const totalPaths = totalPathResults[0].total_paths;

        pool.query(fetch_pending_paths, (err, pendingPathResults) => {
          if (err) {
            console.log(err);
            return res.status(500).json({ error: "Internal Server Error" });
          }

          const pendingPaths = pendingPathResults[0].total_pending_paths;

          const data = {
            totalUsers: totalUsers,
            totalPaths: totalPaths,
            pendingPaths: pendingPaths
          }

          return res.status(200).json({result: data})
        });
      });
    });
  } catch (error) {
    console.log(error);
    return res.status(500).json({ error: "Internal Server Error" });
  }
};
