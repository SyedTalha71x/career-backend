import CryptoJS from 'crypto-js';
import jwt from 'jsonwebtoken';
import path from 'path'

const SECRET_KEY = process.env.KEY;
const TOKEN_EXPIRATION = '1hr';

export function hashPassword(password) {
    const hash = CryptoJS.HmacSHA256(password, SECRET_KEY).toString();
    return hash;
}

export function verifyPassword(storedHash, password) {
    const hash = CryptoJS.HmacSHA256(password, SECRET_KEY).toString();
    return hash === storedHash;
}

export function generateToken(userId, email, authType) {
    const payload = { userId, email, authType };
    const token = jwt.sign(payload, SECRET_KEY, { expiresIn: TOKEN_EXPIRATION });
    return token;
}
export function fileFilter(req, file, cb) {
    const allowedFileTypes = ['.pdf', '.doc', '.docx'];
    const extname = path.extname(file.originalname).toLowerCase();
    if (allowedFileTypes.includes(extname)) {
        cb(null, true)
    }
    else {
        cb(new Error('Invalid File Type, Only pdf and doc files are allowes'));
    }
}

export function generateOTP() {
    return CryptoJS.randomInt(100000, 999999).toString(); // Generate a 6-digit OTP
}
