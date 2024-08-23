import express from 'express';
import { getProfileInfo, updateUsername, changePasswordProfile, requestForOtp, verifyOtp, resetPassword, updateProfilePicture } from '../controllers/profile-controller.js'
import authenticate from '../middleware/authentication.js';
import multer from 'multer';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const storage = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, 'uploads/'); // specify the folder to save uploaded files
    },
    filename: function (req, file, cb) {
        cb(null, `${Date.now()}-${file.originalname}`); // specify the filename format
    },
});
// Initialize upload
const upload = multer({
    storage: storage,
    limits: { fileSize: 1024 * 1024 * 5 }, // limit the file size to 5MB
    fileFilter: function (req, file, cb) {
        const filetypes = /jpeg|jpg|png/; // restrict file types to jpeg, jpg, and png
        const extname = filetypes.test(path.extname(file.originalname).toLowerCase());
        const mimetype = filetypes.test(file.mimetype);

        if (mimetype && extname) {
            return cb(null, true);
        } else {
            cb(new Error('Only images are allowed!'));
        }
    },
});

const router = express.Router();

router.get('/show-profile', authenticate, getProfileInfo);
router.put('/update-username', authenticate, updateUsername);
router.post('/request-for-otp', requestForOtp)
router.post('/verify-otp', verifyOtp)
router.post('/reset-password', resetPassword);
router.post('/update-profile-picture', upload.single('file'), authenticate, updateProfilePicture);
router.put('/change-profile-password', authenticate, changePasswordProfile)


export default router;