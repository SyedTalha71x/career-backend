import express from "express";
import {
  createPath,
  getPathsWithDetails,
  getPathsForUser,
  getSkillsForUser,
  updatePath,
  geteachskillsforpath,
  changeSkillStatus,
  getSingleBranch,
  getSpecificSkillsWithStepId,
  sendMessage,
  getMessage,
  addSkill, updateSkill, deleteSkill
} from "../controllers/mapping-controller.js";
import multer from "multer";
import authenticate from "../middleware/authentication.js";
import path from "path";
import { v4 as uuidv4 } from "uuid";

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
    fileSize: 5 * 1024 * 1024,
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

router.post("/create-path", upload.single("file"), authenticate, createPath);
router.put("/update-path/:id", upload.single("file"), authenticate, updatePath);
router.get("/get-details-with-path", authenticate, getPathsWithDetails);
router.get("/get-paths-for-user", authenticate, getPathsForUser);
router.get("/get-skills-for-user", authenticate, getSkillsForUser);
router.post("/get-each-skills-with-steps", authenticate, geteachskillsforpath);
router.get("/check-status-of-skills/:id", authenticate, changeSkillStatus);
router.get("/get-single-branch/:id", authenticate, getSingleBranch);
router.get("/get-skills-for-single-step/:id", authenticate, getSpecificSkillsWithStepId);
router.post("/send-message", authenticate,  sendMessage);
router.get("/get-message/:id", authenticate, getMessage)
router.post("/add-skill", addSkill)
router.post("/update-skill/:id", updateSkill)
router.delete("/delete-skill/:id", deleteSkill)

// Error handling middleware
router.use((err, req, res, next) => {
  if (err instanceof multer.MulterError) {
    return res.status(400).json({ error: err.message });
  } else if (err) {
    return res.status(500).json({ error: err.message });
  }
  next();
});

export default router;
