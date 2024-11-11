import express from "express";
import {
  createRole,
  updateRole,
  updatePermission,
  assignPermissionsToRole,
  assignRolesToUser,
  createPermissionWithModule,
  createUser,
  deleteUser,
  updateUser
} from "../controllers/role-permission-controller.js";
import { checkRole } from "../middleware/checkRole.js";

const router = express.Router();

router.post("/create-role", createRole);
router.put("/update-role/:id", updateRole);

router.post("/create-permission-with-module", createPermissionWithModule)
router.put("/update-permission/:id",updatePermission);

router.post("/assign-permissions-to-role",assignPermissionsToRole);
router.post("/assign-roles-to-user",assignRolesToUser);

router.post('/create-user', checkRole(), createUser)
router.put('/update-user/:id', checkRole(), updateUser)
router.delete('/delete-user/:id', checkRole(), deleteUser)



export default router;
