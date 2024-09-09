import { connectToDB } from "../utils/db/db.js";
import nodemailer from 'nodemailer'
import otpGenerator from 'otp-generator'
import moment from "moment";
import { successResponse, failureResponse } from '../Helper/helper.js'
import { hashPassword, verifyPassword } from "../Security/security.js";

const pool = connectToDB();

const transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
        user: process.env.EMAIL_USER,
        pass: process.env.EMAIL_PASS,
    },
})
export const getProfileInfo = async (req, res) => {
    try {
        const { userId, authType } = req.user; // Extract userId and authType from the token
        console.log('User ID:', userId, 'Auth Type:', authType);

        if (!userId || !authType) {
            return res.status(400).json(failureResponse({}, 'User not authenticated'));
        }

        if (authType === 'standard') {
            // Handle standard authentication
            pool.query(
                'SELECT username, email, profile_picture FROM users WHERE id = ?',
                [userId],
                (err, results) => {
                    if (err) {
                        console.error('Database query error:', err);
                        return res.status(500).json(failureResponse({}, 'Internal server error'));
                    }

                    if (results.length > 0) {
                        const user = results[0];
                        const response = {
                            username: user.username,
                            email: user.email,
                            profile_picture: user.profile_picture ? `http://192.168.18.194:8001/uploads/${user.profile_picture}` : null,
                        };
                        return res.status(200).json(successResponse(response, 'User profile retrieved successfully'));
                    } else {
                        return res.status(404).json(failureResponse({}, 'User not found'));
                    }
                }
            );
        } else {
            // Handle social logins (Google, LinkedIn, Outlook, Facebook)
            let table, idField;

            switch (authType.toLowerCase()) {
                case 'google':
                    table = 'google_login';
                    idField = 'google_id';
                    break;
                case 'linkedin':
                    table = 'linkedin_login';
                    idField = 'linkedin_id';
                    break;
                case 'outlook':
                    table = 'outlook_login';
                    idField = 'outlook_id';
                    break;
                case 'facebook':
                    table = 'facebook_login';
                    idField = 'facebook_id';
                    break;
                default:
                    return res.status(400).json(failureResponse({}, 'Invalid authentication type'));
            }

            pool.query(
                `SELECT name as username, email, profile_picture FROM ${table} WHERE ${idField} = ?`,
                [userId],
                (err, results) => {
                    if (err) {
                        console.error(`Database query error for ${table}:`, err);
                        return res.status(500).json(failureResponse({}, 'Internal server error'));
                    }

                    if (results.length > 0) {
                        const user = results[0];
                        const response = {
                            username: user.username,
                            email: user.email,
                            profile_picture: user.profile_picture ? `http:// 192.168.18.194:8001/uploads/${user.profile_picture}` : null,
                        };
                        return res.status(200).json(successResponse(response, 'Social login profile retrieved successfully'));
                    } else {
                        return res.status(404).json(failureResponse({}, 'User not found in social login table'));
                    }
                }
            );
        }
    } catch (error) {
        console.error('Internal server error:', error);
        return res.status(500).json(failureResponse({}, 'Internal Server Error'));
    }
};
export const updateUsername = async (req, res) => {
    try {
        const userId = req.user?.userId; // Get the user ID from the request, assuming authentication middleware sets req.user
        const { newUsername } = req.body; // Get the new username from the request body

        if (!userId) {
            return res.status(422).json(failureResponse({ error: 'User Id is required' }, 'Updation Failed'))
            // return res.status(422).json({ message: "User ID are required." });
        }
        if (!newUsername) {
            return res.status(422).json(failureResponse({ error: 'User name is required' }, 'Updation Failed'))
            // return res.status(422).json({ message: "newUsername are required." });
        }

        // Determine which table to update based on the user authentication method
        const userTable = req.user.authType; // This should be set by your authentication middleware
        console.log(`Updating username for auth type: ${userTable}`);

        // Update query based on the user's auth type
        let updateQuery = '';
        switch (userTable) {
            case 'standard':
                updateQuery = 'UPDATE users SET username = ? WHERE id = ?';
                break;
            case 'google':
                updateQuery = 'UPDATE google_login SET name = ? WHERE google_id = ?'; // Assuming google_id is the correct column
                break;
            case 'linkedin':
                updateQuery = 'UPDATE linkedin_login SET name = ? WHERE linkedin_id = ?'; // Assuming linkedin_id is the correct column
                break;
            case 'outlook':
                updateQuery = 'UPDATE outlook_login SET name = ? WHERE outlook_id = ?'; // Assuming outlook_id is the correct column
                break;
            case 'facebook':
                updateQuery = 'UPDATE facebook_login SET name = ? WHERE facebook_id = ?'; // Assuming facebook_id is the correct column
                break;
            default:
                return res.status(400).json(failureResponse({ error: 'Invalid Authentication Type' }, 'Updation Failed'))
        }
        // Execute the update query
        pool.query(updateQuery, [newUsername, userId], (err, results) => {
            if (err) {
                console.error("Database query error:", err);
                return res.status(500).json(failureResponse({ error: 'Database Internal Server Error' }, 'Updation Failed'))
            }

            // Check if the user was actually updated
            if (results.affectedRows === 0) {
                console.log(`No rows updated. Query: ${updateQuery}, UserID: ${userId}`);
                return res.status(500).json(failureResponse({ error: 'User not found or username not updated' }, 'Updation Failed'))
            }

            res.status(200).json(successResponse({ newUsername }, 'Username is updated Successfully'));
        });
    } catch (error) {
        console.error("Server error:", error);
        res.status(500).json(failureResponse({ message: 'Internal server error' }, 'Updation Failed'));
    }
};
export const updateProfilePicture = async (req, res) => {
    try {
        // Check if a file is uploaded
        if (!req.file) {
            return res.status(400).json(failureResponse({ error: 'No file uploaded' }, 'Profile Picture Update Failed'));
        }

        const profilePictureUrl = req.file.filename;
        const userId = req.user?.userId; // Get the user ID from the request, assuming authentication middleware sets req.user
        const authType = req.user?.authType; // Get the authentication type

        if (!userId) {
            return res.status(422).json(failureResponse({ error: 'User is not Authenticated' }, 'Profile Picture Update Failed'));
        }

        if (!profilePictureUrl) {
            return res.status(422).json(failureResponse({ error: 'Profile Picture Url is required' }, 'Profile Picture Update Failed'));
        }

        // Determine which table to update based on the user authentication method
        let updateQuery = '';
        switch (authType) {
            case 'standard':
                updateQuery = 'UPDATE users SET profile_picture = ? WHERE id = ?';
                break;
            case 'google':
                updateQuery = 'UPDATE google_login SET profile_picture = ? WHERE google_id = ?';
                break;
            case 'linkedin':
                updateQuery = 'UPDATE linkedin_login SET profile_picture = ? WHERE linkedin_id = ?';
                break;
            case 'outlook':
                updateQuery = 'UPDATE outlook_login SET profile_picture = ? WHERE outlook_id = ?';
                break;
            case 'facebook':
                updateQuery = 'UPDATE facebook_login SET profile_picture = ? WHERE facebook_id = ?';
                break;
            default:
                return res.status(400).json(failureResponse({ error: 'Invalid Authentication Type' }, 'Profile Picture Update Failed'));
        }

        // Execute the update query
        pool.query(updateQuery, [profilePictureUrl, userId], (err, results) => {
            if (err) {
                console.error("Database query error:", err);
                return res.status(500).json(failureResponse({ error: 'Internal server error' }, 'Profile Picture Update Failed'));
            }

            // Check if the user was actually updated
            if (results.affectedRows === 0) {
                return res.status(404).json(failureResponse({ error: 'User not found or profile picture not updated' }, 'Profile Picture Update Failed'));
            }

            res.status(200).json(successResponse({ filepath: profilePictureUrl }, 'Profile Picture Updated Successfully'));
        });
    } catch (error) {
        console.error("Server error:", error);
        res.status(500).json(failureResponse({ error: 'Internal server error' }, 'Profile Picture Update Failed'));
    }
};
export const requestForOtp = async (req, res) => {
    try {
        const { email } = req.body;

        // Check if the email exists in the database
        const checkUserSql = 'SELECT * FROM users WHERE email = ?';
        pool.query(checkUserSql, [email], (err, results) => {
            if (err) {
                console.error('Database query error:', err);
                return res.status(500).json(failureResponse({ error: 'Internal Server Error' }, 'OTP Verification failed'));
            }

            if (results.length === 0) {
                return res.status(404).json(failureResponse({ error: 'User not found' }, 'OTP Verification failed'));
            }

            // Generate OTP and expiration
            const otp = otpGenerator.generate(6, { upperCase: false, specialChars: false });
            const expiration = moment().add(10, 'minutes').format('YYYY-MM-DD HH:mm:ss'); // Set expiration to 10 minutes

            // Update user record with the OTP and expiration time
            const updateOtpSql = 'UPDATE users SET otp = ?, otp_expiration = ? WHERE email = ?';
            pool.query(updateOtpSql, [otp, expiration, email], (err, result) => {
                if (err) {
                    console.error('Database update error:', err);
                    return res.status(500).json(failureResponse({ error: 'Internal Server Error' }, 'OTP Verification failed'));
                }

                if (result.affectedRows === 0) {
                    return res.status(404).json(failureResponse({ error: 'User not found' }, 'OTP Verification failed'));
                }

                // Send OTP via email
                const mailOptions = {
                    from: process.env.EMAIL_USER,
                    to: email,
                    subject: 'Password Reset OTP',
                    text: `Your OTP for password reset is ${otp}. It will expire in 10 minutes.`,
                };

                transporter.sendMail(mailOptions, (err, info) => {
                    if (err) {
                        console.error('Email sending error:', err);
                        return res.status(500).json(failureResponse({ error: 'Failed to send OTP email' }, 'OTP Verification failed'));
                    }

                    res.status(200).json(successResponse({ message: `OTP has been sent to ${email}` }, 'OTP Verification Successful'));
                });
            });
        });

    } catch (error) {
        console.error('Request for OTP error:', error);
        return res.status(500).json(failureResponse({ error: 'Internal Server Error' }, 'OTP Verification failed'));
    }
};
export const verifyOtp = (req, res) => {
    try {
        const { otp } = req.body;

        if (!otp) {
            return res.status(400).json(failureResponse({ error: 'OTP is required' }, 'OTP Verification Failed'));
        }

        const sql = 'SELECT email, otp_expiration FROM users WHERE otp = ?';
        pool.query(sql, [otp], (err, results) => {
            if (err) {
                console.error('Database query error:', err);
                return res.status(500).json(failureResponse({ error: 'Internal Server Error' }, 'OTP Verification Failed'));
            }

            if (results.length === 0) {
                return res.status(404).json(failureResponse({ error: 'Invalid OTP' }, 'OTP Verification Failed'));
            }

            const { email, otp_expiration } = results[0];
            const currentDate = moment();
            const otpExpirationDate = moment(otp_expiration);

            if (currentDate.isAfter(otpExpirationDate)) {
                return res.status(400).json(failureResponse({ error: 'OTP has expired' }, 'OTP Verification Failed'));
            }

            res.status(200).json(successResponse({ message: 'OTP is valid', email }, 'OTP Verification Successful'));
        });
    } catch (error) {
        console.error('OTP verification error:', error);
        return res.status(500).json(failureResponse({ error: 'Internal Server Error' }, 'OTP Verification failed'));
    }
};
export const resetPassword = async (req, res) => {
    try {
        const { email, newPassword, confirmPassword } = req.body;

        // Validate request body
        if (!email || !newPassword || !confirmPassword) {
            return res.status(400).json(failureResponse({ error: 'All fields are required' }, 'Password Reset Failed'));
        }

        if (newPassword !== confirmPassword) {
            return res.status(400).json(failureResponse({ error: 'Passwords do not match' }, 'Password Reset Failed'));
        }

        // Fetch the user from the database
        const fetchUserSql = 'SELECT * FROM users WHERE email = ?';
        pool.query(fetchUserSql, [email], async (err, results) => {
            if (err) {
                console.error('Database query error:', err);
                return res.status(500).json(failureResponse({ error: 'Internal Server Error' }, 'Password Reset Failed'));
            }

            if (results.length === 0) {
                return res.status(404).json(failureResponse({ error: 'User not found' }, 'Password Reset Failed'));
            }

            const hashedPassword = hashPassword(newPassword);
            // Update the user's password and clear the OTP and OTP expiration
            const updatePasswordSql = 'UPDATE users SET password = ?, otp = NULL, otp_expiration = NULL WHERE email = ?';
            pool.query(updatePasswordSql, [hashedPassword, email], (err, result) => {
                if (err) {
                    console.error('Database update error:', err);
                    return res.status(500).json(failureResponse({ error: 'Internal Server Error' }, 'Password Reset Failed'));
                }

                if (result.affectedRows === 0) {
                    return res.status(404).json(failureResponse({ error: 'Password update failed' }, 'Password Reset Failed'));
                }

                res.status(200).json(successResponse({ message: 'Password has been updated successfully' }, 'Password Reset Successful'));
            });
        });
    } catch (error) {
        console.error('Password reset error:', error);
        return res.status(500).json(failureResponse({ error: 'Internal Server Error' }, 'Password Reset Failed'));
    }
};
export const changePasswordProfile = async (req, res) => {
    try {
        const { currentPassword, newPassword, confirmPassword } = req.body;

        // Validate request body
        if (!currentPassword || !newPassword || !confirmPassword) {
            return res.status(400).json(failureResponse({ error: 'All fields are required' }, 'Password Change Failed'));
        }

        if (newPassword !== confirmPassword) {
            return res.status(400).json(failureResponse({ error: 'New passwords do not match' }, 'Password Change Failed'));
        }

        const userId = req.user?.userId; // Assuming user ID is available from authentication middleware

        if (!userId) {
            return res.status(422).json(failureResponse({ error: 'User Id is required' }, 'Password Change Failed'));
        }

        // Fetch the user from the database
        const fetchUserSql = 'SELECT password FROM users WHERE id = ?';
        pool.query(fetchUserSql, [userId], async (err, results) => {
            if (err) {
                console.error('Database query error:', err);
                return res.status(500).json(failureResponse({ error: 'Internal Server Error' }, 'Password Change Failed'));
            }

            if (results.length === 0) {
                return res.status(404).json(failureResponse({ error: 'User not found' }, 'Password Change Failed'));
            }

            const user = results[0];
            const isMatch = verifyPassword(user.password, currentPassword);

            if (!isMatch) {
                return res.status(400).json(failureResponse({ error: 'Current password is incorrect' }, 'Password Change Failed'));
            }

            const hashedPassword = hashPassword(newPassword);

            // Update the user's password
            const updatePasswordSql = 'UPDATE users SET password = ? WHERE id = ?';
            pool.query(updatePasswordSql, [hashedPassword, userId], (err, result) => {
                if (err) {
                    console.error('Database update error:', err);
                    return res.status(500).json(failureResponse({ error: 'Internal Server Error' }, 'Password Change Failed'));
                }

                if (result.affectedRows === 0) {
                    return res.status(404).json(failureResponse({ error: 'Password update failed' }, 'Password Change Failed'));
                }

                return res.status(200).json(successResponse({ message: 'Password has been updated successfully' }, 'Password Change Successful'));
            });
        });
    } catch (error) {
        console.error('Password change error:', error);
        return res.status(500).json(failureResponse({ error: 'Internal Server Error' }, 'Password Change Failed'));
    }
};
