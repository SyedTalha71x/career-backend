import express from "express";
import { createPath, getPathsWithDetails, getPathsForUser, getSkillsForUser , updatePath, geteachskillsforpath, changeSkillStatus, getSinglePath, getSpecificSkillsWithStepId} from "../controllers/mapping-controller.js";
import multer from "multer";
import authenticate from "../middleware/authentication.js";
import path from 'path'
import { v4 as uuidv4 } from 'uuid';


const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, "uploads/");
  },
  filename: (req, file, cb) => {
    const ext = path.extname(file.originalname);
    const fileName = `${uuidv4()}${ext}`; 
    cb(null, fileName);
  },
});

const upload = multer({
  storage: storage,
  limits: {
    fileSize: 5 * 1024 * 1024, // 5MB size limit
  },
  fileFilter: (req, file, cb) => {
    const fileTypes = /pdf|doc|docx|png|jpg|jpeg/;
    const extname = fileTypes.test(
      path.extname(file.originalname).toLowerCase()
    );
    if (extname) {
      cb(null, true);
    } else {
      cb(new Error("Only .pdf, .doc, .png, .jpg formats allowed!"));
    }
  },
});

const router = express.Router();
router.post("/create-path", authenticate, createPath);
router.put("/update-path/:id", upload.single('file'), authenticate, updatePath);
router.get("/get-details-with-path", authenticate, getPathsWithDetails)
router.get("/get-paths-for-user", authenticate, getPathsForUser)
router.get("/get-skills-for-user", authenticate, getSkillsForUser)
router.post("/get-each-skills-with-steps", authenticate, geteachskillsforpath)
router.get("/check-status-of-skills/:id", authenticate, changeSkillStatus)
router.get("/get-single-path/:id", authenticate, getSinglePath)
router.get("/get-skills-for-single-step/:id", authenticate, getSpecificSkillsWithStepId)

export default router;
