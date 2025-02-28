import jwt from 'jsonwebtoken';

const SECRET_KEY = process.env.KEY; 

const authenticate = (req, res, next) => {

    const authHeader = req.header('Authorization');

    if (!authHeader || !authHeader.startsWith('Bearer ')) {
        return res.status(401).json({ message: 'Access denied. No token provided.' });
    }

    const token = authHeader.split(' ')[1];
    console.log("parsed token -------------", token);
    
    if (!token) {
        return res.status(401).json({ message: 'Access denied. Malformed token.' });
    }

    try {
        const decoded = jwt.verify(token, SECRET_KEY);
        console.log(decoded, 'ffffffffffffffff')
        req.user = decoded;
        next();
    } catch (err) {
     
        console.log(err,'kajndsijniwlkawndoasn');
        if (err.name === 'JsonWebTokenError') {
            return res.status(401).json({ message: 'Invalid token.' });
        }
        if (err.name === 'TokenExpiredError') {
            return res.status(401).json({ message: 'Token expired.' });
        }
    }
};

export default authenticate;
