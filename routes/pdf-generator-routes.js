import express from 'express'
import {generatePdfReport} from '../controllers/pdf-generator-controller.js'
import authenticate from '../middleware/authentication.js';
const router = express.Router();

router.get("/generate/:id", authenticate, generatePdfReport)
export default router