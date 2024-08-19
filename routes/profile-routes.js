import express from 'express';
import { getProfileInfo, updateUsername, updateProfilePicture, requestForOtp, verifyOtp, resetPassword } from '../controllers/profile-controller.js'
import authenticate from '../middleware/authentication.js';
const router = express.Router();

router.get('/show-profile', authenticate, getProfileInfo);
router.put('/update-username', authenticate, updateUsername);
router.put('/update-profile-picture', authenticate, updateProfilePicture);
router.post('/request-for-otp', requestForOtp)
router.post('/verify-otp', verifyOtp)
router.post('/reset-password', resetPassword);


export default router;
