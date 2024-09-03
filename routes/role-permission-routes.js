import express from "express";
import {
  createRole,
  updateRole,
  createPermission,
  updatePermission,
  assignPermissionsToRole,
  assignRoleToUser,
} from "../controllers/role-permission-controller.js";
import { auth } from "../middleware/auth.js";

const router = express.Router();

router.post("/create-role", auth("create-role"), createRole);
router.put("/update-role/:id", auth("update-role"), updateRole);

router.post("/create-permission", auth("create-permission"), createPermission);
router.put(
  "/update-permission/:id",
  auth("update-permission"),
  updatePermission
);

router.post(
  "/assign-permissions-to-role",
  auth("assign-permissions-to-role"),
  assignPermissionsToRole
);
router.post(
  "/assign-role-to-user",
  auth("assign-role-to-user"),
  assignRoleToUser
);


export default router;
