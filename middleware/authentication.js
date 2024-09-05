import jwt from 'jsonwebtoken';

const SECRET_KEY = process.env.KEY;

const authenticate = (req, res, next) => {
    // Extract token from Authorization header (assuming Bearer token format)
    const authHeader = req.header('Authorization');
    const token = authHeader?.replace('Bearer ', '');

    if (!token) {
        return res.status(401).json({ message: 'Access denied' });
    }

    try {
        // Verify token using jsonwebtoken
        const decoded = jwt.verify(token, SECRET_KEY);

        req.user = decoded;
        next();
    } catch (err) {
        console.error('Token verification error:', err);
        res.status(400).json({ message: 'Invalid or expired token' });
    }
};

export default authenticate;
