import express from "express";
import {
  createRole,
  updateRole,
  updateModuleAndPermissions,
  assignPermissionsToRole,
  assignRolesToUser,
  createPermissionWithModule,
  createUser,
  deleteUser,
  updateUser,
  getUsers,
  listPermissions,
  getRole,
  getRolePermissions,
  getMostPaths,
  getActivityLogs,
  adminDeleteSkill,
  adminUpdateSkill,
  getAllSkills,
  getAllPaths,
  updatePathPrompt,
  getAnalytics,
  getAllSkillsWithUserId,
  deletePathData,
  assignUserToSubAdmin,
  FilteringUsers
} from "../controllers/role-permission-controller.js";
import { SuperAdmin } from "../middleware/SuperAdmin.js";
import { AdminAccess } from "../middleware/AdminAccess.js";
import { FullAccess } from "../middleware/FullAccess.js";
import { checkPermission } from "../middleware/checkPermission.js";
import authenticate from "../middleware/authentication.js";
import { FullCustomAccess } from "../middleware/fullcustomAccess.js";
const router = express.Router();

router.post("/create-role",FullAccess(),createRole);
router.put("/update-role/:id",FullAccess(), updateRole);
router.get("/get-role", getRole);

router.post("/create-permission-with-module", SuperAdmin(), createPermissionWithModule)
router.post("/update-permission",SuperAdmin(),updateModuleAndPermissions);
router.get("/get-all-permissions", FullAccess(),listPermissions);
router.get("/get-all-permissions-with-role/:roleId", FullAccess(),getRolePermissions);

router.post("/assign-permissions-to-role", SuperAdmin(),assignPermissionsToRole);
router.post("/assign-roles-to-user",SuperAdmin(),assignRolesToUser);

router.post('/create-user', SuperAdmin(), createUser)
router.put('/update-user/:id', SuperAdmin(), updateUser)
router.delete('/delete-user/:id', SuperAdmin(), deleteUser)
router.get('/get-all-users', FullCustomAccess(), getUsers)

router.get('/get-activity-logs', FullCustomAccess(), getActivityLogs)

router.post('/update-skill-for-admin-panel/:skillId', FullAccess(), adminUpdateSkill)
router.delete('/delete-skill-for-admin-panel/:skillId', FullAccess(), adminDeleteSkill)
router.get('/get-all-skills-for-admin-panel', FullAccess(), getAllSkills )
router.get('/get-all-paths-for-admin-panel', FullCustomAccess(), getAllPaths)
router.post('/update-path-prompt-for-admin-panel/:pathId', FullAccess(), updatePathPrompt)

router.get('/get-most-created-paths', FullCustomAccess(), getMostPaths)
router.get('/get-analytics', FullAccess(), getAnalytics)
router.get('/get-all-skills-with-userid/:userId', FullAccess(), getAllSkillsWithUserId)
router.delete('/delete-path-related-data/:pathId', FullAccess(), deletePathData)

router.post('/assign-users-to-subadmin', SuperAdmin(), assignUserToSubAdmin)
router.get('/searching-users', SuperAdmin(), FilteringUsers)


export default router;
