import express from 'express';
import { Signup, Login, checkEmail, changePassword, googleLogin, linkedinLogin, verifyAuth } from '../controllers/user-controller.js';
import authenticate from '../middleware/authentication.js'

const router = express.Router();

router.post('/register', Signup);
router.post('/login', Login);
router.post('/reset-password', authenticate, changePassword);
router.post('/check-email', checkEmail);
router.post('/google-login', googleLogin);
router.get('/linkedin-login', linkedinLogin);
router.get('/verify-auth', verifyAuth);

export default router;
