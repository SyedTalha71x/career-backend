import express from 'express';
import { createSubscriptions, purchaseSubscription, getSubscription, confirmSubscription, checkUserSubscription, checkPathSubscription, checkTrainingPlanSubscription } from '../controllers/subscription-controller.js';
import authenticate from '../middleware/authentication.js';

const router = express.Router();

router.post('/create-subscription', createSubscriptions);
router.post('/purchase-subscription', authenticate, purchaseSubscription)
router.post('/confirm-subscription', authenticate, confirmSubscription)
router.get('/get-subscription', getSubscription)
router.get('/check-user-subscription', authenticate, checkUserSubscription)
router.get('/check-path-subscription-limit', authenticate, checkPathSubscription)
router.get('/check-training-plan-subscription-limit', authenticate, checkTrainingPlanSubscription)


export default router;
