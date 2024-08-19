import express from 'express';
import { Signup, Login, checkEmail, changePassword, googlelogin, facebookLogin, instagramLogin, linkedinLogin, outlookLogin } from '../controllers/user-controller.js';
import authenticate from '../middleware/authentication.js'

const router = express.Router();

router.post('/register', Signup);
router.post('/login', Login);
// router.post('/reset-password', authenticate, changePassword);
router.post('/check-email', checkEmail);
router.post('/google-login', googlelogin);
router.post('/facebook-login', facebookLogin);
router.post('/instagram-login', instagramLogin);
router.post('/linkdein-login', linkedinLogin);
router.post('/outlook-login', outlookLogin);

export default router;
