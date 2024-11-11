import { validateEmail, validateUsername, validatePassword } from '../Validation/validation.js';
import { connectToDB } from '../utils/db/db.js';
import { hashPassword, verifyPassword, generateToken } from '../Security/security.js'
import { successResponse, failureResponse } from '../Helper/helper.js';
import { OAuth2Client } from 'google-auth-library';
import { configDotenv } from 'dotenv';
import jwt from 'jsonwebtoken'
import axios from 'axios';

configDotenv();
const pool = connectToDB();

const client = new OAuth2Client(process.env.GOOGLE_CLIENT_ID);

export const Signup = async (req, res) => {
    const { username, email, password } = req.body;
    const authType = 'standard';

    if (!validateEmail(email)) {
        return res.status(422).json(failureResponse({ email: 'Invalid email format' }, 'Validation Failed'));
    }
    if (!validateUsername(username)) {
        return res.status(422).json(failureResponse({ username: 'Username must be 3-30 characters long and can only contain letters, numbers, and underscores' }, 'Validation Failed'));
    }
    if (!validatePassword(password)) {
        return res.status(422).json(failureResponse({ password: 'Password must be at least 8 characters long, contain at least one letter and one number' }, 'Validation Failed'));
    }

    try {
        pool.query('SELECT * FROM users WHERE username = ? OR email = ?', [username, email], (err, results) => {
            if (err) {
                console.error('Error querying database:', err);
                return res.status(500).json(failureResponse({ database: 'Server error while querying database' }, 'Signup Failed'));
            }
            if (results.length > 0) {
                return res.status(422).json(failureResponse({ username: 'Username or email already exists' }, 'Signup Failed'));
            }

            const hashedPassword = hashPassword(password);
            pool.query('INSERT INTO users (username, email, password) VALUES (?, ?, ?)', [username, email, hashedPassword], (err, result) => {
                if (err) {
                    console.error('Error inserting into database:', err);
                    return res.status(500).json(failureResponse({ database: 'Server error while inserting into database' }, 'Signup Failed'));
                }

                const token = generateToken(result.insertId, email, authType);
                res.status(201).json(successResponse({ token }, 'User created successfully'));
            });
        });
    } catch (error) {
        console.error('Error during signup process:', error);
        return res.status(500).json(failureResponse({ server: 'Internal server error' }, 'Signup Failed'));
    }
};
export const Login = async (req, res) => {
    let message;
    try {
        const { email, password } = req.body;
        const authType = 'standard';

        pool.query('SELECT * FROM users WHERE email = ?', [email], (err, result) => {
            if (err) {
                message = 'Email and Password are not correct';
                return res.status(502).json(failureResponse({ email: message }, 'Login Failed'));
            }

            if (result.length > 0) {
                const user = result[0];

                if (verifyPassword(user.password, password)) {
                    console.log(user.id);

                    const fetch_user_role = "SELECT role_id FROM role_to_users WHERE user_id = ?";
                    pool.query(fetch_user_role, [user.id], (roleErr, roleResults) => {
                        if (roleErr) {
                            message = 'Error fetching role ID';
                            return res.status(502).json(failureResponse({ error: message }, 'Login Failed'));
                        }

                        let roleID;
                        if (roleResults.length === 0) {
                            roleID = 3;
                        } else {
                            roleID = roleResults[0].role_id;
                        }

                        const fetch_role_name = 'SELECT name FROM roles WHERE id = ?';
                        pool.query(fetch_role_name, [roleID], (err, results) => {
                            if (err || results.length === 0) {
                                message = 'Role name not found for this user';
                                return res.status(502).json(failureResponse({ error: message }, 'Login Failed'));
                            }

                            const roleName = results[0].name;
                            const AuthToken = generateToken(user.id, email, authType);
                            return res.status(200).json(successResponse({ AuthToken, roleName }, 'Login successful'));
                        });
                    });
                } else {
                    message = 'Password does not match';
                    return res.status(422).json(failureResponse({ password: message }, 'Login Failed'));
                }
            } else {
                message = 'Email and Password are not correct';
                return res.status(404).json(failureResponse({ email: message }, 'Login Failed'));
            }
        });
    } catch (error) {
        console.error('Error logging in user:', error);
        const api_message = 'Email and Password are not correct';
        return res.status(500).json(failureResponse({ api_message }, 'Internal Server Error'));
    }
};

export const checkEmail = async (req, res) => {
    try {
        const { email } = req.body;

        if (!validateEmail(email)) {
            return res.status(422).json(failureResponse({ email: 'Invalid email format' }, 'Validation Failed'));
        }

        await pool.query('SELECT id FROM users WHERE email = ?', [email], (err, result) => {
            if (err) {
                console.error('Database Query Error:', err);
                return res.status(500).json(failureResponse({ database: 'Server error while querying database' }, 'Server error'));
            }
            if (result.length > 0) {
                const user = result[0];
                return res.status(200).json(successResponse({ userId: user.id }, 'User found'));
            } else {
                return res.status(404).json(failureResponse({ database: 'User not Found in Record' }, 'Unauthorized'));
            }
        });
    } catch (error) {
        console.error('Error checking email:', error);
        return res.status(500).json(failureResponse({ server: 'Internal server error' }, 'Email Verification Failed'));
    }
};
export const changePassword = async (req, res) => {
    try {
        const { newPassword, confirmPassword } = req.body;

        if (!validatePassword(newPassword)) {
            return res.status(422).json(failureResponse({ password: 'Password must be at least 8 characters long, contain at least one letter and one number' }, 'Validation Failed'));
        }

        if (!newPassword || !confirmPassword) {
            return res.status(422).json(failureResponse({ fields: 'newPassword, confirmPassword' }, 'All fields are required'));
        }

        if (newPassword !== confirmPassword) {
            return res.status(422).json(failureResponse({ passwords: 'Passwords do not match' }, 'Passwords do not match'));
        }

        const hashedPassword = hashPassword(newPassword);
        const userId = req.user.userId;

        pool.query(
            'UPDATE users SET password = ? WHERE id = ?',
            [hashedPassword, userId],
            (err, results) => {
                if (err) {
                    console.error('Database error:', err);
                    return res.status(500).json(failureResponse({ database: 'Error updating password' }, 'Database error'));
                }

                return res.status(200).json(successResponse({ Password: 'Password Updated Successfully' }, 'Password updated successfully'));
            }
        );
    } catch (error) {
        console.error('An error occurred:', error);
        return res.status(500).json(failureResponse({ server: 'An unexpected error occurred' }, 'An error occurred'));
    }
};
export const googleLogin = async (req, res) => {
    const { authorizationCode } = req.body;

    if (!authorizationCode) {
        return res.status(400).json(failureResponse(null, 'Authorization code is required.'));
    }

    try {
        // Exchange authorization code for access token
        const tokenResponse = await axios.post('https://oauth2.googleapis.com/token', null, {
            params: {
                code: authorizationCode,
                client_id: process.env.GOOGLE_CLIENT_ID,
                client_secret: process.env.GOOGLE_CLIENT_SECRET,
                redirect_uri: process.env.GOOGLE_REDIRECT_URI,
                grant_type: 'authorization_code'
            }
        });

        const { access_token } = tokenResponse.data;

        // Get user info from Google
        const userInfoResponse = await axios.get('https://www.googleapis.com/oauth2/v2/userinfo', {
            headers: {
                Authorization: `Bearer ${access_token}`
            }
        });

        const { id, email, name, picture } = userInfoResponse.data;

        // Check if user already exists
        pool.query('SELECT * FROM google_login WHERE google_id = ?', [id], (err, results) => {
            if (err) return res.status(500).json(failureResponse(null, 'Database error.'));

            const userData = { google_id: id, email, name, profile_picture: picture };

            if (results.length > 0) {
                // User exists, update user info if necessary
                pool.query(
                    'UPDATE google_login SET email = ?, name = ?, profile_picture = ?, updated_at = NOW() WHERE google_id = ?',
                    [email, name, picture, id],
                    (updateErr) => {
                        if (updateErr) return res.status(500).json(failureResponse(null, 'Database error.'));
                        const token = generateToken(id, email, 'google');
                        res.json(successResponse({ user: userData, token }, 'User updated successfully.'));
                    }
                );
            } else {
                // Insert new user
                pool.query(
                    'INSERT INTO google_login (google_id, email, name, profile_picture, created_at, updated_at) VALUES (?, ?, ?, ?, NOW(), NOW())',
                    [id, email, name, picture],
                    (insertErr) => {
                        if (insertErr) return res.status(500).json(failureResponse(null, 'Database error.'));
                        const token = generateToken(id, email, 'google');
                        res.json(successResponse({ user: userData, token }, 'User created successfully.'));
                    }
                );
            }
        });

    } catch (error) {
        console.error('Error during Google authentication:', error);
        res.status(500).json(failureResponse(null, 'Google authentication failed.'));
    }
};
export const facebookLogin = async (req, res) => {
    const { accessToken } = req.body;
    try {
        // Verify the Facebook access token
        const response = await fetch(`https://graph.facebook.com/me?access_token=${accessToken}&fields=id,name,email,picture`);
        const profile = await response.json();

        if (profile.error) {
            console.error('Error verifying Facebook token:', profile.error);
            return res.status(401).json(failureResponse(profile.error, 'Invalid token'));
        }

        const { id: facebookId, email, name, picture } = profile;

        // Check if user exists in database
        pool.query('SELECT * FROM facebook_login WHERE facebook_id = ?', [facebookId], (error, results) => {
            if (error) {
                console.error('Database query error:', error);
                return res.status(500).json(failureResponse(error, 'Internal server error'));
            }

            if (results.length === 0) {
                // User doesn't exist, create new user
                const newUser = { facebook_id: facebookId, email, name, profile_picture: picture.data.url };
                pool.query('INSERT INTO facebook_login SET ?', newUser, (error, result) => {
                    if (error) {
                        console.error('Error creating new user:', error);
                        return res.status(500).json(failureResponse(error, 'Internal server error'));
                    }
                    const jwtToken = generateToken(result.insertId, email, 'facebook');
                    res.json(successResponse({
                        user: { id: result.insertId, ...newUser },
                        token: jwtToken
                    }, 'Login successful'));
                });
            } else {
                // User exists, update information
                const userId = results[0].id;
                pool.query(
                    'UPDATE facebook_login SET email = ?, name = ?, profile_picture = ? WHERE id = ?',
                    [email, name, picture.data.url, userId],
                    (error) => {
                        if (error) {
                            console.error('Error updating user:', error);
                            return res.status(500).json(failureResponse(error, 'Internal server error'));
                        }
                        const jwtToken = generateToken(userId, email, 'facebook');
                        res.json(successResponse({
                            user: { id: userId, email, name, picture: picture.data.url },
                            token: jwtToken
                        }, 'Login successful'));
                    }
                );
            }
        });
    } catch (error) {
        console.error('Error verifying Facebook token:', error);
        res.status(500).json(failureResponse(error, 'Internal server error'));
    }
};
export const instagramLogin = async (req, res) => {
    const { accessToken } = req.body;

    try {
        // Verify the Instagram access token
        const response = await axios.get(`https://graph.instagram.com/me?fields=id,username,account_type,profile_picture_url&access_token=${accessToken}`);
        const profile = response.data;

        if (!profile || !profile.id) {
            console.error('Error verifying Instagram token:', profile);
            return res.status(401).json(failureResponse(profile, 'Invalid token'));
        }

        const { id: instagramId, username: name, profile_picture_url: profilePicture } = profile;

        // Check if user exists in the database
        pool.query('SELECT * FROM instagram_login WHERE instagram_id = ?', [instagramId], (error, results) => {
            if (error) {
                console.error('Database query error:', error);
                return res.status(500).json(failureResponse(error, 'Internal server error'));
            }

            if (results.length === 0) {
                // User doesn't exist, create new user
                const newUser = { instagram_id: instagramId, name, profile_picture: profilePicture };
                pool.query('INSERT INTO instagram_login SET ?', newUser, (error, result) => {
                    if (error) {
                        console.error('Error creating new user:', error);
                        return res.status(500).json(failureResponse(error, 'Internal server error'));
                    }
                    const jwtToken = generateToken(result.insertId, name, 'instagram');
                    res.json(successResponse({
                        user: { id: result.insertId, ...newUser },
                        token: jwtToken
                    }, 'Login successful'));
                });
            } else {
                // User exists, update information
                const userId = results[0].id;
                pool.query(
                    'UPDATE instagram_login SET name = ?, profile_picture = ? WHERE id = ?',
                    [name, profilePicture, userId],
                    (error) => {
                        if (error) {
                            console.error('Error updating user:', error);
                            return res.status(500).json(failureResponse(error, 'Internal server error'));
                        }
                        const jwtToken = generateToken(userId, name, 'instagram');
                        res.json(successResponse({
                            user: { id: userId, name, profile_picture: profilePicture },
                            token: jwtToken
                        }, 'Login successful'));
                    }
                );
            }
        });
    } catch (error) {
        console.error('Error verifying Instagram token:', error);
        res.status(500).json(failureResponse(error, 'Internal server error'));
    }
};
export const linkedinLogin = async (req, res) => {
    const { accessToken } = req.body;

    try {
        // Verify the LinkedIn access token
        const response = await fetch(
            `https://api.linkedin.com/v2/me?projection=(id,firstName,lastName,profilePicture(displayImage~:playableStreams))`,
            {
                method: 'GET',
                headers: {
                    'Authorization': `Bearer ${accessToken}`,
                },
            }
        );
        const profile = await response.json();

        if (profile.error) {
            console.error('Error verifying LinkedIn token:', profile.error);
            return res.status(401).json(failureResponse(profile.error, 'Invalid token'));
        }

        const { id: linkedinId, firstName, lastName, profilePicture } = profile;

        // Construct name and profile picture URL
        const name = `${firstName.localized.en_US} ${lastName.localized.en_US}`;
        const profilePictureUrl = profilePicture['displayImage~'].elements[0].identifiers[0].identifier;

        // Check if user exists in database
        pool.query('SELECT * FROM linkedin_login WHERE linkedin_id = ?', [linkedinId], (error, results) => {
            if (error) {
                console.error('Database query error:', error);
                return res.status(500).json(failureResponse(error, 'Internal server error'));
            }

            if (results.length === 0) {
                // User doesn't exist, create new user
                const newUser = { linkedin_id: linkedinId, name, profile_picture: profilePictureUrl };
                pool.query('INSERT INTO linkedin_login SET ?', newUser, (error, result) => {
                    if (error) {
                        console.error('Error creating new user:', error);
                        return res.status(500).json(failureResponse(error, 'Internal server error'));
                    }
                    const jwtToken = generateToken(result.insertId, name, 'linkedin');
                    res.json(successResponse({
                        user: { id: result.insertId, ...newUser },
                        token: jwtToken
                    }, 'Login successful'));
                });
            } else {
                // User exists, update information
                const userId = results[0].id;
                pool.query(
                    'UPDATE linkedin_login SET name = ?, profile_picture = ? WHERE id = ?',
                    [name, profilePictureUrl, userId],
                    (error) => {
                        if (error) {
                            console.error('Error updating user:', error);
                            return res.status(500).json(failureResponse(error, 'Internal server error'));
                        }
                        const jwtToken = generateToken(userId, name, 'linkedin');
                        res.json(successResponse({
                            user: { id: userId, name, profile_picture: profilePictureUrl },
                            token: jwtToken
                        }, 'Login successful'));
                    }
                );
            }
        });
    } catch (error) {
        console.error('Error verifying LinkedIn token:', error);
        res.status(500).json(failureResponse(error, 'Internal server error'));
    }
};
export const outlookLogin = async (req, res) => {
    const { accessToken } = req.body;

    try {
        // Verify the Outlook access token and fetch user profile
        const response = await fetch('https://graph.microsoft.com/v1.0/me', {
            method: 'GET',
            headers: {
                'Authorization': `Bearer ${accessToken}`,
                'Content-Type': 'application/json'
            }
        });
        const result = await response.json();

        if (result.error) {
            console.error('Error verifying Outlook token:', result.error);
            return res.status(401).json(failureResponse(result.error, 'Invalid token'));
        }

        const { id: outlookId, displayName, mail, photo } = result;

        // Construct profile picture URL (if available)
        const profilePictureUrl = photo ? photo['@odata.mediaReadLink'] : null;

        // Check if user exists in database
        pool.query('SELECT * FROM outlook_login WHERE outlook_id = ?', [outlookId], (error, results) => {
            if (error) {
                console.error('Database query error:', error);
                return res.status(500).json(failureResponse(error, 'Internal server error'));
            }

            if (results.length === 0) {
                // User doesn't exist, create new user
                const newUser = { outlook_id: outlookId, name: displayName, email: mail, profile_picture: profilePictureUrl };
                pool.query('INSERT INTO outlook_login SET ?', newUser, (error, result) => {
                    if (error) {
                        console.error('Error creating new user:', error);
                        return res.status(500).json(failureResponse(error, 'Internal server error'));
                    }
                    const jwtToken = generateToken(result.insertId, mail, 'outlook');
                    res.json(successResponse({
                        user: { id: result.insertId, ...newUser },
                        token: jwtToken
                    }, 'Login successful'));
                });
            } else {
                // User exists, update information
                const userId = results[0].id;
                pool.query(
                    'UPDATE outlook_login SET name = ?, email = ?, profile_picture = ? WHERE id = ?',
                    [displayName, mail, profilePictureUrl, userId],
                    (error) => {
                        if (error) {
                            console.error('Error updating user:', error);
                            return res.status(500).json(failureResponse(error, 'Internal server error'));
                        }
                        const jwtToken = generateToken(userId, mail, 'outlook');
                        res.json(successResponse({
                            user: { id: userId, name: displayName, email: mail, profile_picture: profilePictureUrl },
                            token: jwtToken
                        }, 'Login successful'));
                    }
                );
            }
        });
    } catch (error) {
        console.error('Error verifying Outlook token:', error);
        res.status(500).json(failureResponse(error, 'Internal server error'));
    }
};

