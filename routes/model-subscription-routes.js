import express from 'express';
import authenticate from '../middleware/authentication.js';
import {redirectStripe, getModelSubscription, confirmModelSubscription} from '../controllers/training-model-controller.js';

const router = express.Router();

router.post('/redirect-subscription', authenticate, redirectStripe);
router.get('/get-model-subscription', authenticate, getModelSubscription);
router.post('/confirm-model-subscription', authenticate, confirmModelSubscription);

export default router;