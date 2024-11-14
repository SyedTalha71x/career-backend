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
  getUsers,
  listPermissions,
  getRole,
  getRolePermissions,
  getMostPaths
} from "../controllers/role-permission-controller.js";
import { SuperAdmin } from "../middleware/SuperAdmin.js";
import { AdminAccess } from "../middleware/AdminAccess.js";
import { FullAccess } from "../middleware/FullAccess.js";
import { checkPermission } from "../middleware/checkPermission.js";

const router = express.Router();

router.post("/create-role",FullAccess(),createRole);
router.put("/update-role/:id",FullAccess(), updateRole);
router.get("/get-role", getRole);

router.post("/create-permission-with-module", SuperAdmin(), createPermissionWithModule)
router.put("/update-permission/:id",SuperAdmin(),updatePermission);
router.get("/get-all-permissions", FullAccess(),listPermissions);
router.get("/get-all-permissions-with-role/:roleId", FullAccess(),getRolePermissions);

router.post("/assign-permissions-to-role", SuperAdmin(),assignPermissionsToRole);
router.post("/assign-roles-to-user",SuperAdmin(),assignRolesToUser);

router.post('/create-user', SuperAdmin(), createUser)
router.put('/update-user/:id', SuperAdmin(), updateUser)
router.delete('/delete-user/:id', SuperAdmin(), deleteUser)
router.get('/get-all-users', getUsers)

router.delete('/delete-user/:id', SuperAdmin(), deleteUser)
router.get('/get-most-created-paths', FullAccess(), getMostPaths)

router.get('/manage', checkPermission('manage'), (req,res)=>{
  res.status(200).json({message: 'Yes you can view the reports'})
})

export default router;
