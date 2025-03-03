import {
  validateEmail,
  validateUsername,
  validatePassword,
} from "../Validation/validation.js";
import { connectToDB } from "../utils/db/db.js";
import {
  hashPassword,
  verifyPassword,
  generateToken,
} from "../Security/security.js";
import { successResponse, failureResponse } from "../Helper/helper.js";
import { OAuth2Client } from "google-auth-library";
import { configDotenv } from "dotenv";
import jwt from "jsonwebtoken";
import axios from "axios";
import { oauth2Client } from "../utils/googleConfig.js";

configDotenv();
const pool = connectToDB();
const SECRET_KEY = process.env.KEY;

const client = new OAuth2Client(process.env.GOOGLE_CLIENT_ID);

export const Signup = async (req, res) => {
  const { username, email, password } = req.body;
  const authType = "standard";

  if (!validateEmail(email)) {
    return res
      .status(422)
      .json(
        failureResponse({ email: "Invalid email format" }, "Validation Failed")
      );
  }
  if (!validateUsername(username)) {
    return res.status(422).json(
      failureResponse(
        {
          username:
            "Username must be 3-30 characters long and can only contain letters, numbers, and underscores",
        },
        "Validation Failed"
      )
    );
  }
  if (!validatePassword(password)) {
    return res.status(422).json(
      failureResponse(
        {
          password:
            "Password must be at least 8 characters long, contain at least one letter and one number",
        },
        "Validation Failed"
      )
    );
  }

  try {
    pool.query(
      "SELECT * FROM users WHERE username = ? OR email = ?",
      [username, email],
      (err, results) => {
        if (err) {
          console.error("Error querying database for existing user:", err);
          return res
            .status(500)
            .json(
              failureResponse(
                { database: "Server error while querying database" },
                "Signup Failed"
              )
            );
        }
        if (results.length > 0) {
          return res
            .status(422)
            .json(
              failureResponse(
                { username: "Username or email already exists" },
                "Signup Failed"
              )
            );
        }

        const hashedPassword = hashPassword(password);

        // Check if this is the first user to be added
        pool.query(
          "SELECT COUNT(*) AS userCount FROM users",
          (err, countResult) => {
            if (err) {
              console.error("Error querying user count:", err);
              return res
                .status(500)
                .json(
                  failureResponse(
                    { database: "Server error while checking user count" },
                    "Signup Failed"
                  )
                );
            }

            const isFirstUser = countResult[0].userCount === 0;

            pool.query(
              "INSERT INTO users (username, email, password) VALUES (?, ?, ?)",
              [username, email, hashedPassword],
              (err, result) => {
                if (err) {
                  console.error("Error inserting new user into database:", err);
                  return res.status(500).json(
                    failureResponse(
                      {
                        database: "Server error while inserting into database",
                      },
                      "Signup Failed"
                    )
                  );
                }

                const userId = result.insertId;
                const roleId = isFirstUser ? 1 : 3;

                pool.query(
                  "INSERT INTO role_to_users (role_id, user_id) VALUES (?, ?)",
                  [roleId, userId],
                  (err) => {
                    if (err) {
                      console.error(
                        "Error inserting role mapping into database:",
                        err
                      );
                      return res
                        .status(500)
                        .json(
                          failureResponse(
                            { database: "Server error while assigning role" },
                            "Signup Failed"
                          )
                        );
                    }

                    const token = generateToken(userId, email, authType);
                    res
                      .status(201)
                      .json(
                        successResponse({ token }, "User created successfully")
                      );
                  }
                );
              }
            );
          }
        );
      }
    );
  } catch (error) {
    console.error("Error during signup process:", error);
    return res
      .status(500)
      .json(
        failureResponse({ server: "Internal server error" }, "Signup Failed")
      );
  }
};
export const Login = async (req, res) => {
  let message;
  try {
    const { email, password } = req.body;
    const authType = "standard";

    pool.query(
      "SELECT * FROM users WHERE email = ?",
      [email],
      (err, result) => {
        if (err) {
          message = "Email and Password are not correct";
          return res
            .status(502)
            .json(failureResponse({ email: message }, "Login Failed"));
        }

        if (result.length > 0) {
          const user = result[0];

          if (verifyPassword(user.password, password)) {
            console.log(user.id);

            const fetch_user_role =
              "SELECT role_id FROM role_to_users WHERE user_id = ?";
            pool.query(fetch_user_role, [user.id], (roleErr, roleResults) => {
              if (roleErr) {
                message = "Error fetching role ID";
                return res
                  .status(502)
                  .json(failureResponse({ error: message }, "Login Failed"));
              }

              if (roleResults.length === 0) {
                message = "No role assigned to this user";
                return res
                  .status(404)
                  .json(failureResponse({ error: message }, "Login Failed"));
              }

              let roleID = roleResults[0].role_id;

              const fetch_role_name = "SELECT name FROM roles WHERE id = ?";
              pool.query(fetch_role_name, [roleID], (err, results) => {
                if (err || results.length === 0) {
                  message = "Role name not found for this user";
                  return res
                    .status(502)
                    .json(failureResponse({ error: message }, "Login Failed"));
                }

                const roleName = results[0].name;

                const permissionsQUERY =
                  "SELECT p.slug FROM permissions p LEFT JOIN permission_to_role pr ON pr.permission_id = p.id WHERE pr.role_id = ?";
                pool.query(
                  permissionsQUERY,
                  [roleID],
                  (err, permissionResults) => {
                    if (err) {
                      message = "Error fetching permissions";
                      return res
                        .status(502)
                        .json(failureResponse({ error: message }, "Failure"));
                    }

                    // If no permissions are found, return an empty array
                    const permissionSlugs =
                      permissionResults.length > 0
                        ? [...new Set(permissionResults.map((row) => row.slug))]
                        : [];

                    const AuthToken = generateToken(user.id, email, authType);

                    return res
                      .status(200)
                      .json(
                        successResponse(
                          { AuthToken, roleName, permissionSlugs },
                          "Login successful"
                        )
                      );
                  }
                );
              });
            });
          } else {
            message = "Password does not match";
            return res
              .status(422)
              .json(failureResponse({ password: message }, "Login Failed"));
          }
        } else {
          message = "Email and Password are not correct";
          return res
            .status(404)
            .json(failureResponse({ email: message }, "Login Failed"));
        }
      }
    );
  } catch (error) {
    console.error("Error logging in user:", error);
    const api_message = "Email and Password are not correct";
    return res
      .status(500)
      .json(failureResponse({ api_message }, "Internal Server Error"));
  }
};

export const checkEmail = async (req, res) => {
  try {
    const { email } = req.body;

    if (!validateEmail(email)) {
      return res
        .status(422)
        .json(
          failureResponse(
            { email: "Invalid email format" },
            "Validation Failed"
          )
        );
    }

    await pool.query(
      "SELECT id FROM users WHERE email = ?",
      [email],
      (err, result) => {
        if (err) {
          console.error("Database Query Error:", err);
          return res
            .status(500)
            .json(
              failureResponse(
                { database: "Server error while querying database" },
                "Server error"
              )
            );
        }
        if (result.length > 0) {
          const user = result[0];
          return res
            .status(200)
            .json(successResponse({ userId: user.id }, "User found"));
        } else {
          return res
            .status(404)
            .json(
              failureResponse(
                { database: "User not Found in Record" },
                "Unauthorized"
              )
            );
        }
      }
    );
  } catch (error) {
    console.error("Error checking email:", error);
    return res
      .status(500)
      .json(
        failureResponse(
          { server: "Internal server error" },
          "Email Verification Failed"
        )
      );
  }
};
export const changePassword = async (req, res) => {
  try {
    const { newPassword, confirmPassword } = req.body;

    if (!validatePassword(newPassword)) {
      return res.status(422).json(
        failureResponse(
          {
            password:
              "Password must be at least 8 characters long, contain at least one letter and one number",
          },
          "Validation Failed"
        )
      );
    }

    if (!newPassword || !confirmPassword) {
      return res
        .status(422)
        .json(
          failureResponse(
            { fields: "newPassword, confirmPassword" },
            "All fields are required"
          )
        );
    }

    if (newPassword !== confirmPassword) {
      return res
        .status(422)
        .json(
          failureResponse(
            { passwords: "Passwords do not match" },
            "Passwords do not match"
          )
        );
    }

    const hashedPassword = hashPassword(newPassword);
    const userId = req.user.userId;

    pool.query(
      "UPDATE users SET password = ? WHERE id = ?",
      [hashedPassword, userId],
      (err, results) => {
        if (err) {
          console.error("Database error:", err);
          return res
            .status(500)
            .json(
              failureResponse(
                { database: "Error updating password" },
                "Database error"
              )
            );
        }

        return res
          .status(200)
          .json(
            successResponse(
              { Password: "Password Updated Successfully" },
              "Password updated successfully"
            )
          );
      }
    );
  } catch (error) {
    console.error("An error occurred:", error);
    return res
      .status(500)
      .json(
        failureResponse(
          { server: "An unexpected error occurred" },
          "An error occurred"
        )
      );
  }
};
export const googleLogin = async (req, res) => {
  try {
    const { authorizationCode } = req.body;
    const authType = 'google'

    if (!authorizationCode) {
      return res
        .status(400)
        .json(failureResponse(null, "Authorization code is required."));
    }
    
    // Exchange authorization code for tokens
    const googleResponse = await oauth2Client.getToken(authorizationCode);
    oauth2Client.setCredentials(googleResponse.tokens);

    // Fetch user info from Google
    const userResponse = await axios.get(
      `https://www.googleapis.com/oauth2/v1/userinfo?alt=json&access_token=${googleResponse.tokens.access_token}`
    );

    const { id: google_id, email, name, picture } = userResponse.data;

    pool.query(
      "SELECT * FROM users WHERE email = ? OR google_id = ?",
      [email, google_id],
      (err, results) => {
        if (err) {
          console.error("Database query error:", err);
          return res
            .status(500)
            .json(failureResponse(err.message, "Database error."));
        }

        let userData = {
          google_id,
          email,
          username: name,
          profile_picture: picture,
        };

        if (results.length > 0) {
          // User exists
          const userId = results[0].id;
          userData.id = userId;

          // Fetch user role
          pool.query(
            "SELECT role_id FROM role_to_users WHERE user_id = ?",
            [userId],
            (roleErr, roleResults) => {
              if (roleErr) {
                console.error("Error fetching role ID:", roleErr);
                return res
                  .status(500)
                  .json(failureResponse(roleErr.message, "Database error."));
              }

              let roleID = roleResults.length > 0 ? roleResults[0].role_id : null;
              let roleName = "User"; // Default role

              if (roleID) {
                // Fetch role name
                pool.query(
                  "SELECT name FROM roles WHERE id = ?",
                  [roleID],
                  (err, roleNameResults) => {
                    if (err || roleNameResults.length === 0) {
                      console.error("Error fetching role name:", err);
                      roleName = "User"; // Fallback to default role
                    } else {
                      roleName = roleNameResults[0].name;
                    }

                    // Fetch permissions
                    pool.query(
                      "SELECT p.slug FROM permissions p LEFT JOIN permission_to_role pr ON pr.permission_id = p.id WHERE pr.role_id = ?",
                      [roleID],
                      (err, permissionResults) => {
                        if (err) {
                          console.error("Error fetching permissions:", err);
                          return res
                            .status(500)
                            .json(
                              failureResponse(err.message, "Database error.")
                            );
                        }

                        // If no permissions are found, return an empty array
                        const permissionSlugs =
                          permissionResults.length > 0
                            ? [
                                ...new Set(
                                  permissionResults.map((row) => row.slug)
                                ),
                              ]
                            : [];

                        // FIXED: Store googleId in the token if it's a Google auth
                        const token = generateToken(userId, email, authType);

                        // Return response with token, role, and permissions
                        return res.json(
                          successResponse(
                            {
                              user: userData,
                              token,
                              roleName,
                              permissionSlugs,
                            },
                            "User logged in successfully."
                          )
                        );
                      }
                    );
                  }
                );
              } else {
                // No role assigned, use default role and empty permissions
                const token = generateToken(userId, email, authType);

                return res.json(
                  successResponse(
                    { user: userData, token, roleName, permissionSlugs: [] },
                    "User logged in successfully."
                  )
                );
              }
            }
          );
        } else {
          // User does not exist, create new user
          pool.query(
            "INSERT INTO users (google_id, email, username, profile_picture, created_at) VALUES (?, ?, ?, ?, NOW())",
            [google_id, email, name, picture],
            (insertErr, insertResults) => {
              if (insertErr) {
                console.error("Database insert error:", insertErr);
                return res
                  .status(500)
                  .json(failureResponse(insertErr.message, "Database error."));
              }

              const userId = insertResults.insertId;
              userData.id = userId;

              // Assign default role to the new user
              const defaultRoleName = "User";
              pool.query(
                "SELECT id FROM roles WHERE name = ?",
                [defaultRoleName],
                (roleErr, roleResults) => {
                  if (roleErr || roleResults.length === 0) {
                    console.error("Error fetching default role:", roleErr);
                    return res
                      .status(500)
                      .json(
                        failureResponse(roleErr.message, "Database error.")
                      );
                  }

                  const defaultRoleId = roleResults[0].id;

                  // Assign default role to the user
                  pool.query(
                    "INSERT INTO role_to_users (user_id, role_id) VALUES (?, ?)",
                    [userId, defaultRoleId],
                    (assignErr) => {
                      if (assignErr) {
                        console.error(
                          "Error assigning default role:",
                          assignErr
                        );
                        return res
                          .status(500)
                          .json(
                            failureResponse(
                              assignErr.message,
                              "Database error."
                            )
                          );
                      }

                      const token = generateToken(userId, email, authType);

                      return res.json(
                        successResponse(
                          {
                            user: userData,
                            token,
                            roleName: defaultRoleName,
                            permissionSlugs: [],
                          },
                          "User created and logged in successfully."
                        )
                      );
                    }
                  );
                }
              );
            }
          );
        }
      }
    );
  } catch (error) {
    console.error("Error during Google authentication:", error);
    res.status(500).json({
      success: false,
      message: "Internal Server Error",
    });
  }
};


const getAccessToken = async (code) => {
  const body = new URLSearchParams({
    grant_type: "authorization_code",
    code: code,
    client_id: process.env.LINKEDIN_CLIENT_ID,
    client_secret: process.env.LINKEDIN_SECRECT_ID,
    redirect_uri: process.env.LINKEDIN_REDIRECTING_URL,
  });

  const response = await fetch(
    "https://www.linkedin.com/oauth/v2/accessToken",
    {
      method: "POST",
      headers: {
        "Content-type": "application/x-www-form-urlencoded",
      },
      body: body.toString(),
    }
  );

  if (!response.ok) {
    throw new Error(response.statusText);
  }

  const accessToken = await response.json();
  console.log(accessToken);
  
  return accessToken;
};
export const verifyAuth = (req, res) => {
  try {
    // Check if the cookie exists
    const token = req.cookies["user-visited-dashboard"];

    if (!token) {
      return res.json({ authenticated: false });
    }

    const decoded = jwt.verify(token, process.env.JWT_SECRET);

    if (!decoded) {
      return res.json({ authenticated: false });
    }

    return res.json({
      authenticated: true,
      token: token, // This allows frontend to store it in localStorage
    });
  } catch (error) {
    console.error("Error verifying authentication:", error);
    return res.json({ authenticated: false });
  }
};

export const linkedinLogin = async (req, res) => {
  try {
    const { code } = req.query;
    const authType = 'linkedin';

    if (!code) {
      return res.status(400).send("Authorization code is missing.");
    }

    const accessToken = await getAccessToken(code);
    const finalToken = accessToken.access_token;
    console.log(finalToken, "finalToken");

    // Fetch LinkedIn profile
    const response = await fetch(`https://api.linkedin.com/v2/userinfo`, {
      method: "GET",
      headers: {
        Authorization: `Bearer ${finalToken}`,
      },
    });

    const profile = await response.json();
    console.log("LinkedIn Profile Response:", profile);

    if (profile.error) {
      console.error("Error verifying LinkedIn token:", profile.error);
      return res
        .status(401)
        .json(failureResponse(profile.error, "Invalid token"));
    }

    const {
      sub: linkedinId,
      name,
      email,
      picture: profilePictureUrl,
    } = profile;

    pool.query(
      "SELECT * FROM users WHERE email = ? OR linkedin_id = ?",
      [email, linkedinId],
      (error, results) => {
        if (error) {
          console.error("Database query error:", error);
          return res
            .status(500)
            .json(failureResponse(error, "Internal server error"));
        }

        let userId, userName, userEmail;
        let isNewUser = false;

        if (results.length > 0) {
          userId = results[0].id;
          userName = results[0].username;
          userEmail = results[0].email;
        } else {
          isNewUser = true;
          const newUser = {
            username: name,
            email,
            profile_picture: profilePictureUrl,
            linkedin_id: linkedinId,
            created_at: new Date(),
          };

          pool.query("INSERT INTO users SET ?", newUser, (error, result) => {
            if (error) {
              console.error("Error creating new user:", error);
              return res
                .status(500)
                .json(failureResponse(error, "Internal server error"));
            }

            userId = result.insertId;
            userName = name;
            userEmail = email;

            // Use the custom token generation function with authType
            const jwtToken = generateToken(userId, userEmail, authType);

            return res.redirect(
              `https://app.mycareermap.ai?token=${encodeURIComponent(jwtToken)}`
            );
          });
          return;
        }

        // Use the custom token generation function with authType
        const jwtToken = generateToken(userId, userEmail, authType);

        return res.redirect(
          `http://localhost:5173?token=${encodeURIComponent(jwtToken)}`
        );
      }
    );
  } catch (error) {
    console.error("Error verifying LinkedIn token:", error);
    res.status(500).json(failureResponse(error, "Internal server error"));
  }
};

export const repo = async (id, permission) => {
  permission = Array.isArray(permission)
    ? `id IN ( ${permission.map((i) => i)} ) `
    : `id="${permission}" `;
  const query =
    `SELECT users.*, roles.*, CONCAT('[', GROUP_CONCAT('"', permissions.permission, '"' SEPARATOR ','), ']') as permissions
FROM users
INNER JOIN role_to_users
ON role_to_users.user_id = users.id
INNER JOIN roles
ON roles.id = role_to_users.role_id
INNER JOIN permission_to_role
ON permission_to_role.role_id = role_to_users.role_id
INNER JOIN permissions
ON permissions.id = permission_to_role.permission_id
WHERE users.id = ${id} AND permissions.` +
    permission +
    `GROUP BY permission_to_role.role_id`;
  const [rows, _fields] = await sqlConnection().execute(query);
};
