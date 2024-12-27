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
  addSkill, updateSkill, deleteSkill, getSinglePathDetailWithMap, checkRemainingPlans, editStepTitle
} from "../controllers/mapping-controller.js";
import multer from "multer";
import authenticate from "../middleware/authentication.js";
import path from "path";
import { v4 as uuidv4 } from "uuid";
import { FullAccess } from "../middleware/FullAccess.js";
import { CheckUserAdminBoth } from "../middleware/checkUserAdminBoth.js";
import { FullCustomAccess } from "../middleware/fullcustomAccess.js";

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
    fileSize: 10 * 1024 * 1024,
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
router.post("/send-message", upload.single("file"), authenticate,  sendMessage);
router.get("/get-message/:id", authenticate, getMessage)
router.post("/add-skill", authenticate, addSkill)
router.post("/update-skill/:id", authenticate, updateSkill)
router.delete("/delete-skill/:id",authenticate, deleteSkill)
router.get('/get-single-path-detail/:pathId', FullCustomAccess(), getSinglePathDetailWithMap)
router.get('/check-remaining-plans', authenticate, checkRemainingPlans)
router.post('/edit-step-title/:stepId', CheckUserAdminBoth(), editStepTitle)


// Error handling middleware
router.use((err, req, res, next) => {
  if (err instanceof multer.MulterError) {
    console.log(err.message);
    return res.status(400).json({ error: err.message, message: 'Error 1' });
  } else if (err) {
    console.log(err.message);

    return res.status(500).json({ error: err.message, message: 'Error 2' });
  }
  next();
});

export default router;
