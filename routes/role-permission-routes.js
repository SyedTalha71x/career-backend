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
  updateUser,
  getUsers
} from "../controllers/role-permission-controller.js";
import { SuperAdmin } from "../middleware/SuperAdmin.js";
import { AdminAccess } from "../middleware/AdminAccess.js";

const router = express.Router();

router.post("/create-role", createRole);
router.put("/update-role/:id", updateRole);

router.post("/create-permission-with-module", SuperAdmin(), createPermissionWithModule)
router.put("/update-permission/:id",SuperAdmin(),updatePermission);

router.post("/assign-permissions-to-role", AdminAccess(),assignPermissionsToRole);
router.post("/assign-roles-to-user",AdminAccess(),assignRolesToUser);

router.post('/create-user', SuperAdmin(), createUser)
router.put('/update-user/:id', SuperAdmin(), updateUser)
router.delete('/delete-user/:id', SuperAdmin(), deleteUser)
router.get('/get-all-users', getUsers)


export default router;
