import jwt from 'jsonwebtoken';
import { connectToDB } from '../utils/db/db.js';

const pool = connectToDB();

export const SuperAdmin = () => {
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

      const verifiedToken = jwt.verify(token, process.env.KEY);

      if (!verifiedToken) {
        return res.status(401).json({ status: false, message: 'Unauthorized Access' });
      }

      pool.query('SELECT * FROM users WHERE id = ?', [verifiedToken.userId], (userErr, userResults) => {
        if (userErr) {
          console.error('Database query error (users):', userErr);
          return res.status(500).json({ status: false, message: 'Internal Server Error' });
        }

        if (!userResults.length) {
          return res.status(403).json({ status: false, message: 'Forbidden No Roles Found' });
        }

        const user = userResults[0];

        pool.query('SELECT role_id FROM role_to_users WHERE user_id = ?', [user.id], (roleErr, roleResults) => {
          if (roleErr) {
            console.error('Database query error (roles_to_users):', roleErr);
            return res.status(500).json({ status: false, message: 'Internal Server Error' });
          }

          if (!roleResults.length) {
            return res.status(403).json({ status: false, message: 'Forbidden, No Roles Found' });
          }

          const roleId = roleResults[0].role_id;
          user.role_id = roleId;

          // if user is Super Admin then he have access
          if (roleId === 1) {
            req.user = user;
            return next(); 
          }

          return res.status(403).json({ status: false, message: 'Access Denied - Super Admin only have access' });
        });
      });
    } catch (error) {
      console.error('Token verification error:', error);
      return res.status(401).json({ status: false, message: 'Unauthorized Access' });
    }
  };
};
