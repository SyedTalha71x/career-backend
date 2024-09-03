import { connectToDB } from "./utils/db/db.js";
import express from "express";
import cors from "cors";
import UserRoutes from './routes/user-routes.js'
import { configDotenv } from "dotenv";
import cookieParser from "cookie-parser";
import bodyParser from "body-parser";
import fileRoutes from './routes/file-routes.js'
import profileRoutes from "./routes/profile-routes.js";
import rolePermissionRoutes from './routes/role-permission-routes.js'
import subscriptionRoutes from './routes/subscription-routes.js'
import path from 'path';
import MappingRoutes from './routes/mapping-routes.js'
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

configDotenv();

// Database Setup
connectToDB();

// EXPRESS SETUP WITH CORS
const app = express();
app.use(cors());

//Validations Setup
app.use(bodyParser.json());
app.use(cookieParser());
app.use(express.json());
// app.use(express.urlencoded({ extended: true }));
// app.use(fileUpload());
// app.use('/uploads', express.static(path.join(__dirname, 'uploads')));


// ROUTES
app.use('/api', UserRoutes);
app.use('/api', fileRoutes);
app.use('/api', profileRoutes);
app.use('/api', subscriptionRoutes)
app.use('/api', rolePermissionRoutes)
app.use('/api', MappingRoutes)

// SERVER ACTION
const PORT = process.env.PORT;
app.listen(PORT,() => {
    console.log(`Server is running on http://localhost:${PORT}`);
});

