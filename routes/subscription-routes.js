import express from 'express';
import { createSubscriptions, buySubscriptions } from '../controllers/subscription-controller.js';
import authenticate from '../middleware/authentication.js';

const router = express.Router();

router.post('/create-subscription', createSubscriptions);
router.post('/buy-subscription', authenticate, buySubscriptions)

export default router;
