import jwt from 'jsonwebtoken';
import { connectToDB } from '../utils/db/db.js';

const pool = connectToDB();
export const auth = (requiredPermission = null) => {
  return async (req, res, next) => {
    try {
      const { authorization } = req.headers;

      if (!authorization || !authorization.startsWith('Bearer ')) {
        return res.status(401).json({ status: false, message: 'Unauthorized Access' });
      }

      const token = authorization.split(' ')[1];

      if (!token) {
        return res.status(401).json({ status: false, message: 'Unauthorized Access' });
      }

      // Verify the token
      const verifiedToken = jwt.verify(token, process.env.KEY);

      if (!verifiedToken) {
        return res.status(401).json({ status: false, message: 'Unauthorized Access' });
      }

      // Fetch user with role and permissions using roles_to_users table
      const userQuery = `
        SELECT u.*, r.name AS role, CONCAT('[', GROUP_CONCAT('"', p.name, '"' SEPARATOR ','), ']') AS permissions
        FROM users u
        LEFT JOIN roles_to_users ru ON ru.user_id = u.id
        LEFT JOIN roles r ON ru.role_id = r.id
        LEFT JOIN role_to_permission rp ON rp.role_id = ru.role_id
        LEFT JOIN permissions p ON p.id = rp.permission_id
        WHERE u.id = ? GROUP BY u.id
      `;

      pool.query(userQuery, [verifiedToken.userId], (err, results) => {
        if (err) {
          console.error('Database query error:', err);
          return res.status(500).json({ status: false, message: 'Internal Server Error' });
        }

        if (!results.length) {
          return res.status(403).json({ status: false, message: 'Forbidden' });
        }

        const user = results[0];
        user.permissions = user.permissions ? JSON.parse(user.permissions) : [];

        console.log('User:', user); 
        console.log('Role ID:', user.role_id); 

        // If user is an admin, bypass permission checks
        if (user.role_id === 1) {
          req.user = user;
          return next();
        }

        // Check if the user has the required permission
        if (requiredPermission && !user.permissions.includes(requiredPermission)) {
          console.log(`Required Permission: ${requiredPermission}, User Permissions: ${user.permissions}`);
          return res.status(403).json({ status: false, message: 'Access Denied - Missing Permission' });
        }

        // User is authorized
        req.user = user;
        next();
      });
    } catch (error) {
      console.error('Token verification error:', error);
      return res.status(401).json({ status: false, message: 'Unauthorized Access' });
    }
  };
};
