import express from "express";
import {
  createRole,
  updateRole,
  updatePermission,
  assignPermissionsToRole,
  assignRolesToUser,
  createPermissionWithModule
} from "../controllers/role-permission-controller.js";
import { auth } from "../middleware/auth.js";

const router = express.Router();

router.post("/create-role", createRole);
router.put("/update-role/:id", updateRole);

router.post("/create-permission-with-module", createPermissionWithModule)
router.put("/update-permission/:id",updatePermission);

router.post("/assign-permissions-to-role",assignPermissionsToRole);
router.post("/assign-roles-to-user",assignRolesToUser);



export default router;
