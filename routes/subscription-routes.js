import express from 'express';
import { createSubscriptions, purchaseSubscription, getSubscription, confirmSubscription } from '../controllers/subscription-controller.js';
import authenticate from '../middleware/authentication.js';

const router = express.Router();

router.post('/create-subscription', createSubscriptions);
router.post('/purchase-subscription', authenticate, purchaseSubscription)
router.post('/confirm-subscription', authenticate, confirmSubscription)
router.get('/get-subscription', getSubscription)

export default router;
