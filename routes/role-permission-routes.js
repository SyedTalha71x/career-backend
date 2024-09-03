import express from "express";
import {
  createRole,
  updateRole,
  createPermission,
  updatePermission,
  assignPermissionsToRole,
  assignRoleToUser,
  createPermissionModule
} from "../controllers/role-permission-controller.js";
import { auth } from "../middleware/auth.js";

const router = express.Router();

router.post("/create-role", createRole);
router.put("/update-role/:id", updateRole);

router.post("/create-permission", createPermission);
router.put("/update-permission/:id",updatePermission);

router.post("/assign-permissions-to-role",assignPermissionsToRole);
router.post("/assign-role-to-user",assignRoleToUser);

router.post("/create-permission-module", createPermissionModule)


export default router;
