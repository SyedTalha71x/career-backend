import CryptoJS from "crypto-js";
import jwt from "jsonwebtoken";
import path from "path";
import fs from 'fs'
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Use __dirname as needed


const SECRET_KEY = process.env.KEY;
const TOKEN_EXPIRATION = "1hr";

export function hashPassword(password) {
  const hash = CryptoJS.HmacSHA256(password, SECRET_KEY).toString();
  return hash;
}
export function verifyPassword(storedHash, password) {
  const hash = CryptoJS.HmacSHA256(password, SECRET_KEY).toString();
  return hash === storedHash;
}
export function generateToken(userId, email, authType, roleId = null) {
  const payload = { userId, email, authType };

  // Add roleId to payload only if it's provided
  if (roleId) {
    payload.roleId = roleId;
  }

  // Generate token with secret key and expiration from environment variables
  try {
    const token = jwt.sign(payload, SECRET_KEY, {
      expiresIn: TOKEN_EXPIRATION || "1h", // Default to 1 hour if not set
    });
    return token;
  } catch (error) {
    console.error("Error generating token:", error);
    throw new Error("Token generation failed");
  }
}
export function fileFilter(req, file, cb) {
  const allowedFileTypes = [".pdf", ".doc", ".docx"];
  const extname = path.extname(file.originalname).toLowerCase();
  if (allowedFileTypes.includes(extname)) {
    cb(null, true);
  } else {
    cb(new Error("Invalid File Type, Only pdf and doc files are allowes"));
  }
}
export function generateOTP() {
  return CryptoJS.randomInt(100000, 999999).toString(); // Generate a 6-digit OTP
}
export function generateRandomColor() {
  let n = (Math.random() * 0xfffff * 1000000).toString(16);
  return "#" + n.slice(0, 6);
}
export function saveBase64File(base64String, callback) {
  // Extract mime type from base64 string
  const mimeTypeMatch = base64String.match(/^data:(.*?);base64,/);
  if (!mimeTypeMatch) {
    return callback(new Error('Invalid base64 string'));
  }
  const mimeType = mimeTypeMatch[1];
  const fileExtension = mimeType.split('/')[1];  // Extract the file extension (e.g., png, pdf, docx)

  // Remove the data URL prefix
  const base64Data = base64String.replace(/^data:.*,/, '');
  const fileName = `upload_${Date.now()}.${fileExtension}`;  // Use dynamic file extension
  const uploadDir = path.join(__dirname, 'uploads');
  const filePath = path.join(uploadDir, fileName);

  // Ensure the uploads directory exists
  if (!fs.existsSync(uploadDir)) {
    fs.mkdirSync(uploadDir);
  }

  // Write the file
  fs.writeFile(filePath, base64Data, 'base64', err => {
    if (err) return callback(err);
    callback(null, fileName);
  });
}