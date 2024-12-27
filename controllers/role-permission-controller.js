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

            // Check if permission already exists in the database with the same name and moduleId
            const checkExistingPermissionQuery = `
              SELECT p.id 
              FROM permissions p
              JOIN permission_modules pm ON p.id = pm.permission_id
              WHERE p.name = ? AND pm.module_id = ?`;
            
            pool.query(
              checkExistingPermissionQuery,
              [permission.name, moduleId],
              (err, existingPermission) => {
                if (err) {
                  console.error("Error checking if permission exists:", err);
                  results.failed.push({
                    name: permission.name,
                    error: "Failed to check if permission exists",
                  });
                  return;
                }

                // If permission does not exist in the module, insert it
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
                    `Permission '${permission.name}' already exists in module, skipping add.`
                  );
                }
              }
            );
          });

          // Wait a bit to allow async operations to finish
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

      // Check which permissions are already assigned to this role
      const permissionCheckQuery = `
        SELECT permission_id FROM permission_to_role WHERE role_id = ? 
      `;
      pool.query(permissionCheckQuery, [roleId], (err, assignedPermissions) => {
        if (err) {
          console.log("Error checking assigned permissions", err);
          return res
            .status(500)
            .json(
              failureResponse(
                { error: "Error checking assigned permissions" },
                "Internal Server Error"
              )
            );
        }

        // Get list of assigned permission ids
        const assignedPermissionIds = assignedPermissions.map(
          (permission) => permission.permission_id
        );

        // Permissions to add (those that are not yet assigned)
        const permissionsToAdd = permissionIds.filter(
          (id) => !assignedPermissionIds.includes(id)
        );

        // Permissions to remove (those that are currently assigned but not in the request)
        const permissionsToRemove = assignedPermissionIds.filter(
          (id) => !permissionIds.includes(id)
        );

        // Handle adding new permissions
        if (permissionsToAdd.length > 0) {
          const valuesToAdd = permissionsToAdd.map((permissionId) => [
            roleId,
            permissionId,
          ]);

          const addQuery =
            "INSERT INTO permission_to_role (role_id, permission_id) VALUES ?";
          pool.query(addQuery, [valuesToAdd], (err, results) => {
            if (err) {
              console.log("Error adding permissions to role", err);
              return res
                .status(500)
                .json(
                  failureResponse(
                    { error: "Failed to assign permissions to role" },
                    "Internal Server Error"
                  )
                );
            }
          });
        }

        // Handle removing permissions
        if (permissionsToRemove.length > 0) {
          const removeQuery =
            "DELETE FROM permission_to_role WHERE role_id = ? AND permission_id IN (?)";
          pool.query(
            removeQuery,
            [roleId, permissionsToRemove],
            (err, results) => {
              if (err) {
                console.log("Error removing permissions from role", err);
                return res
                  .status(500)
                  .json(
                    failureResponse(
                      { error: "Failed to unassign permissions from role" },
                      "Internal Server Error"
                    )
                  );
              }
            }
          );
        }

        return res
          .status(200)
          .json(successResponse(null, "Permissions updated for role successfully"));
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
    const userId = req.user.id;

    const checkSubAdminQuery =
      "SELECT rtu.role_id FROM role_to_users rtu JOIN roles r ON rtu.role_id = r.id WHERE rtu.user_id = ? AND r.name = 'Sub Admin'";

    pool.query(checkSubAdminQuery, [userId], (err, results) => {
      if (err) {
        console.error("Database query error (subadmin role check):", err);
        return res.status(500).json({ error: "Internal Server Error" });
      }

      let userQuery;
      let userParams = [];

      if (results.length > 0) {
        // User is a Sub Admin - Fetch users assigned to them in `user_to_subadmin` table
        userQuery = `
          SELECT u.id, u.username, u.email, u.created_at 
          FROM users u 
          JOIN user_to_subadmin uts ON u.id = uts.user_id 
          WHERE uts.subadmin_id = ?
          ORDER BY u.created_at DESC
        `;
        userParams = [userId];
      } else {
        // User is not a Sub Admin - Fetch all users
        userQuery = `
          SELECT id, username, email, created_at 
          FROM users 
          ORDER BY created_at DESC
        `;
      }

      pool.query(userQuery, userParams, (userErr, userResults) => {
        if (userErr) {
          console.error("Database query error (fetch users):", userErr);
          return res.status(500).json({ error: "Internal Server Error" });
        }

        if (!userResults.length) {
          return res.status(404).json({ error: "No users found" });
        }

        const usersWithRolesPromises = userResults.map((user) => {
          return new Promise((resolve, reject) => {
            const fetchRoleQuery =
              "SELECT r.name FROM role_to_users rtu JOIN roles r ON rtu.role_id = r.id WHERE rtu.user_id = ?";
            pool.query(fetchRoleQuery, [user.id], (roleErr, roleResults) => {
              if (roleErr) {
                console.error("Database query error (fetch roles):", roleErr);
                return reject("Internal Server Error");
              }

              const roleName = roleResults.length > 0 ? roleResults[0].name : "User";
              resolve({
                id: user.id,
                username: user.username,
                email: user.email,
                created_at: user.created_at,
                role: roleName,
              });
            });
          });
        });

        Promise.all(usersWithRolesPromises)
          .then((usersWithRoles) => res.status(200).json({ users: usersWithRoles }))
          .catch((error) => {
            console.error("Error processing user roles:", error);
            res.status(500).json({ error: "Internal Server Error" });
          });
      });
    });
  } catch (error) {
    console.error("Error in getUsers API:", error);
    res.status(500).json({ error: "Internal Server Error" });
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

    // Modified query to avoid duplicate rows by using DISTINCT
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
      GROUP BY
        m.module_name, p.id
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
export const getActivityLogs = async (req, res) => {
  try {
    const { page = 1 } = req.query;
    const itemsPerPage = 10;
    const offset = (page - 1) * itemsPerPage;
    const userId = req.user.id; // Assuming user ID is available after authentication

    // Fetch user role from the role_to_users table
    const getUserRoleQuery = `
      SELECT roles.name as role_name
      FROM role_to_users
      JOIN roles ON role_to_users.role_id = roles.id
      WHERE role_to_users.user_id = ?
    `;

    const userRoleResult = await new Promise((resolve, reject) => {
      pool.query(getUserRoleQuery, [userId], (err, results) => {
        if (err) {
          console.log(err);
          return reject(err);
        }
        resolve(results);
      });
    });

    // If the user does not have a role, return an error
    if (userRoleResult.length === 0) {
      return res.status(403).json({ error: "User role not found" });
    }

    const roleName = userRoleResult[0].role_name;

    let fetch_all_logs = `
      SELECT 
        activity_logs.id,
        activity_logs.name,
        activity_logs.user_id,
        users.username
      FROM 
        activity_logs
      JOIN
        users ON activity_logs.user_id = users.id
    `;

    let countQuery = "SELECT COUNT(*) AS total FROM activity_logs";

    // For Sub Admins, only show logs for assigned users and adjust count query
    if (roleName === "Sub Admin") {
      fetch_all_logs += `
        JOIN user_to_subadmin utsa ON activity_logs.user_id = utsa.user_id
        WHERE utsa.subadmin_id = ?
      `;
      countQuery = `
        SELECT COUNT(*) AS total
        FROM activity_logs
        JOIN user_to_subadmin utsa ON activity_logs.user_id = utsa.user_id
        WHERE utsa.subadmin_id = ?
      `;
    } else {
      // For Super Admin and Admin, fetch all logs (no filtering by user)
      fetch_all_logs += " ORDER BY activity_logs.created_at DESC LIMIT ? OFFSET ?";
    }

    const [activity_logs, totalCount] = await Promise.all([
      new Promise((resolve, reject) => {
        pool.query(fetch_all_logs, roleName === "Sub Admin" ? [userId, itemsPerPage, offset] : [itemsPerPage, offset], (err, results) => {
          if (err) {
            console.log(err);
            return reject(err);
          }
          resolve(results);
        });
      }),
      new Promise((resolve, reject) => {
        pool.query(countQuery, roleName === "Sub Admin" ? [userId] : [], (err, results) => {
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
    const offset = (page - 1) * itemsPerPage; // Calculate starting point

    const userId = req.user.id; // Assuming `req.user.id` is populated by middleware

    // Step 1: Check if the user is a Sub Admin
    const checkSubAdminQuery = `
      SELECT rtu.role_id 
      FROM role_to_users rtu 
      JOIN roles r ON rtu.role_id = r.id 
      WHERE rtu.user_id = ? AND r.name = 'Sub Admin'
    `;

    const isSubAdmin = await new Promise((resolve, reject) =>
      pool.query(checkSubAdminQuery, [userId], (err, results) => {
        if (err) return reject(err);
        resolve(results.length > 0); // Returns true if the user is a Sub Admin
      })
    );

    // Step 2: Construct paths query based on role
    let fetchPathsQuery;
    let countQuery;
    let queryParams;

    if (isSubAdmin) {
      // If Sub Admin, only fetch paths for assigned users
      fetchPathsQuery = `
        SELECT p.id, p.prompt, p.status, p.user_id, p.title 
        FROM path p
        JOIN user_to_subadmin uts ON p.user_id = uts.user_id
        WHERE uts.subadmin_id = ?
        ORDER BY p.id DESC
        LIMIT ? OFFSET ?
      `;
      countQuery = `
        SELECT COUNT(*) AS total
        FROM path p
        JOIN user_to_subadmin uts ON p.user_id = uts.user_id
        WHERE uts.subadmin_id = ?
      `;
      queryParams = [userId, itemsPerPage, offset];
    } else {
      // If not Sub Admin, fetch all paths
      fetchPathsQuery = `
        SELECT id, prompt, status, user_id, title 
        FROM path 
        ORDER BY id DESC 
        LIMIT ? OFFSET ?
      `;
      countQuery = "SELECT COUNT(*) AS total FROM path";
      queryParams = [itemsPerPage, offset];
    }

    // Step 3: Fetch paths and total count in parallel
    const [paths, totalCount] = await Promise.all([
      new Promise((resolve, reject) =>
        pool.query(fetchPathsQuery, queryParams, (err, results) => {
          if (err) return reject(err);
          resolve(results);
        })
      ),
      new Promise((resolve, reject) =>
        pool.query(countQuery, isSubAdmin ? [userId] : [], (err, results) => {
          if (err) return reject(err);
          resolve(results[0].total);
        })
      ),
    ]);

    if (paths.length === 0) {
      return res.status(404).json({ message: "No paths found" });
    }

    // Step 4: Fetch users based on user_ids in paths
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
    const fetch_purchase_subscription = "SELECT COUNT(*) AS total_subscription_purchase FROM user_subscription"

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

          pool.query(fetch_purchase_subscription, (err, purchaseSubscriptionResult) => {
            if (err) {
              console.log(err);
              return res.status(500).json({ error: "Internal Server Error" });
            }
  
            const purchaseSubscription = purchaseSubscriptionResult[0].total_subscription_purchase;
  
            const data = {
              totalUsers: totalUsers,
              totalPaths: totalPaths,
              pendingPaths: pendingPaths,
              purchaseSubscription: purchaseSubscription
            }
  
            return res.status(200).json({result: data})
          });
        });
      });
    });
  } catch (error) {
    console.log(error);
    return res.status(500).json({ error: "Internal Server Error" });
  }
};
export const getAllSkillsWithUserId = async (req, res) => {
  try {
    const userId = req.params.userId;
    const { page = 1 } = req.query;
    const itemsPerPage = 10;
    const offset = (page - 1) * itemsPerPage;

    if (!userId) {
      return res.status(400).json({ message: 'UserId not found' });
    }
    const fetchSkillsQuery = `
      SELECT 
        skills.id AS skill_id, 
        skills.title, 
        skills.step_id, 
        skills.status 
      FROM skills
      INNER JOIN steps ON skills.step_id = steps.id
      INNER JOIN path ON steps.path_id = path.id
      WHERE path.user_id = ?
      ORDER BY skills.id DESC
      LIMIT ? OFFSET ?;
    `;

    const skills = await new Promise((resolve, reject) => {
      pool.query(fetchSkillsQuery, [userId, itemsPerPage, offset], (err, results) => {
        if (err) return reject(err);
        resolve(results);
      });
    });

    if (skills.length === 0) {
      return res.status(404).json({ message: 'No skills found for this user' });
    }

    const stepIds = skills.map((skill) => skill.step_id).filter(Boolean);
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

    const userMap = {
      [userId]: "This User", 
    };

    const enrichedSkills = skills.map((skill) => {
      return {
        ...skill,
        username: userMap[userId] || 'Unknown',
      };
    });

    const totalCount = await new Promise((resolve, reject) => {
      pool.query(
        `SELECT COUNT(*) AS total 
         FROM skills
         INNER JOIN steps ON skills.step_id = steps.id
         INNER JOIN path ON steps.path_id = path.id
         WHERE path.user_id = ?;`,
        [userId],
        (err, results) => {
          if (err) return reject(err);
          resolve(results[0].total);
        }
      );
    });

    const totalPages = Math.ceil(totalCount / itemsPerPage);

    return res.status(200).json({
      currentPage: Number(page),
      totalPages,
      totalSkills: totalCount,
      skills: skills,
    });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: 'Internal Server Error' });
  }
};
export const deletePathData = async (req, res) =>{
  const pathId = req.params.pathId;

  try {
    // 1. Check if path exists 
    const checkPathQuery = `SELECT id FROM path WHERE id = ?`;
    const pathExists = await new Promise((resolve, reject) => {
      pool.query(checkPathQuery, [pathId], (err, results) => {
        if (err) return reject(err);
        resolve(results);
      });
    });

    if (pathExists.length === 0) {
      return res.status(404).json({ 
        success: false,
        message: 'Path not found' 
      });
    }

    const getTrainingPlansQuery = `
      SELECT tp.id 
      FROM trainning_plan tp
      INNER JOIN branch b ON tp.branch_id = b.id
      WHERE b.path_id = ?
    `;

    const trainingPlans = await new Promise((resolve, reject) => {
      pool.query(getTrainingPlansQuery, [pathId], (err, results) => {
        if (err) return reject(err);
        resolve(results);
      });
    });
    for (const plan of trainingPlans) {
      await new Promise((resolve, reject) => {
        pool.query('DELETE FROM action_plan_summary WHERE plan_id = ?', [plan.id], (err) => {
          if (err) return reject(err);
          resolve();
        });
      });
      await new Promise((resolve, reject) => {
        pool.query('DELETE FROM career_goals_overview WHERE plan_id = ?', [plan.id], (err) => {
          if (err) return reject(err);
          resolve();
        });
      });
      await new Promise((resolve, reject) => {
        pool.query('DELETE FROM career_path_progression_map WHERE plan_id = ?', [plan.id], (err) => {
          if (err) return reject(err);
          resolve();
        });
      });
      await new Promise((resolve, reject) => {
        pool.query('DELETE FROM next_steps_recommendations WHERE plan_id = ?', [plan.id], (err) => {
          if (err) return reject(err);
          resolve();
        });
      });
      await new Promise((resolve, reject) => {
        pool.query('DELETE FROM skill_gap_analysis WHERE plan_id = ?', [plan.id], (err) => {
          if (err) return reject(err);
          resolve();
        });
      });
      await new Promise((resolve, reject) => {
        pool.query('DELETE FROM training_activities WHERE plan_id = ?', [plan.id], (err) => {
          if (err) return reject(err);
          resolve();
        });
      });
      await new Promise((resolve, reject) => {
        pool.query('DELETE FROM trainning_plan WHERE id = ?', [plan.id], (err) => {
          if (err) return reject(err);
          resolve();
        });
      });
    }

    await new Promise((resolve, reject) => {
      pool.query(`
        DELETE s FROM skills s
        INNER JOIN steps st ON s.step_id = st.id
        WHERE st.path_id = ?
      `, [pathId], (err) => {
        if (err) return reject(err);
        resolve();
      });
    });

    await new Promise((resolve, reject) => {
      pool.query(`
        DELETE FROM steps WHERE path_id = ?
      `, [pathId], (err) => {
        if (err) return reject(err);
        resolve();
      });
    });

    await new Promise((resolve, reject) => {
      pool.query(`
        DELETE FROM branch WHERE path_id = ?
      `, [pathId], (err) => {
        if (err) return reject(err);
        resolve();
      });
    });

    await new Promise((resolve, reject) => {
      pool.query(`
        DELETE FROM path WHERE id = ?
      `, [pathId], (err) => {
        if (err) return reject(err);
        resolve();
      });
    });

    return res.status(200).json({
      success: true,
      message: 'Path and all related data deleted successfully'
    });

  } catch (error) {
    console.error('Error deleting path:', error);
    return res.status(500).json({ 
      success: false,
      message: 'Internal server error',
      error: error.message 
    });
  }
}
export const assignUserToSubAdmin = async (req, res) => {
  try {
    const { userIds, subAdminId } = req.body;

    if (!userIds || !Array.isArray(userIds) || userIds.length === 0 || !subAdminId) {
      return res.status(400).json(failureResponse({ error: "User IDs and Sub-admin ID are required" }, "Bad Request"));
    }

    const results = [];
    for (let userId of userIds) {
      const query = "INSERT INTO user_to_subadmin (user_id, subadmin_id) VALUES (?, ?)";
      pool.query(query, [userId, subAdminId], (err, result) => {
        if (err) {
          console.error("Error assigning sub-admin:", err);
          results.push({ userId, success: false, error: err.message });
        } else {
          results.push({ userId, success: true, message: "Assigned sub-admin successfully" });
        }
      });
    }

    setTimeout(() => {
      return res.status(200).json({
        message: "Sub-admin assignment process completed",
        results: results,
      });
    }, 500);

  } catch (error) {
    console.error("Error occurred:", error);
    return res.status(500).json(failureResponse({ error: "Internal Server Error" }, "Failure"));
  }
};
export const FilteringUsers = async (req, res) => {
  try {
    const { name } = req.query;

    let query = "SELECT id, CONCAT(username, ' (', email, ')') AS user FROM users";

    if (name) {
      query += ` WHERE CONCAT(username, ' (', email, ')') LIKE ?`;
    }

    pool.query(query, [ `%${name}%` ], (err, result) => {
      if (err) {
        console.error("Error fetching filtered users:", err);
        return res.status(502).json({ error: "Error fetching data" });
      }

      if (result.length === 0) {
        return res.status(404).json({ message: "No matching users found" });
      }

      return res.status(200).json({ users: result });
    });
  } catch (error) {
    console.log(error);
    return res.status(500).json({ error: 'Internal Server Error' });
  }
};



