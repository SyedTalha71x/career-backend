import jwt from 'jsonwebtoken';
import { connectToDB } from '../utils/db/db.js';

const pool = connectToDB();

export const checkPermission = (requiredPermission) => {
  return (req, res, next) => {
    const { authorization } = req.headers;

    if (!authorization || !authorization.startsWith('Bearer ')) {
      return res.status(401).json({ status: false, message: 'Unauthorized Access' });
    }

    const token = authorization.split(' ')[1];
    console.log(token);
    

    try {
      const decoded = jwt.verify(token, process.env.KEY);
      const userId = decoded.userId; 
      console.log(userId);
      

      const getRoleQuery = `
        SELECT r.id, r.name 
        FROM roles r 
        LEFT JOIN role_to_users ru ON r.id = ru.role_id 
        WHERE ru.user_id = ?
      `;

      pool.query(getRoleQuery, [userId], (roleErr, roleResults) => {
        if (roleErr || roleResults.length === 0) {
          console.log("Role fetching error or no role found:", roleErr);
          return res.status(403).json({ error: "Access Denied: Role not found" });
        }

        const roleId = roleResults[0].id;

        const checkPermissionQuery = `
          SELECT p.name 
          FROM permissions p 
          JOIN permission_to_role pr ON p.id = pr.permission_id 
          WHERE pr.role_id = ? AND p.name = ?
        `;

        pool.query(checkPermissionQuery, [roleId, requiredPermission], (permErr, permResults) => {
          if (permErr || permResults.length === 0) {
            console.log("Permission check error or permission not found:", permErr);
            return res.status(403).json({ error: "Access Denied: Permission not assigned" });
          }
          next();
        });
      });
    } catch (err) {
      console.log("Token verification error:", err);
      return res.status(401).json({ error: 'Access Denied: Invalid token' });
    }
  };
};
