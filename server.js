import { connectToDB } from "./utils/db/db.js";
import express from "express";
import cors from "cors";
import UserRoutes from './routes/user-routes.js';
import { config as configDotenv } from "dotenv";
import cookieParser from "cookie-parser";
import bodyParser from "body-parser";
import fileRoutes from './routes/file-routes.js';
import profileRoutes from "./routes/profile-routes.js";
import rolePermissionRoutes from './routes/role-permission-routes.js';
import subscriptionRoutes from './routes/subscription-routes.js';
import path from 'path';
import MappingRoutes from './routes/mapping-routes.js';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

configDotenv(); // Load environment variables

// Database Setup
connectToDB();

// EXPRESS SETUP WITH CORS
const app = express();
app.use(cors());
app.use(cookieParser());
app.use(bodyParser.json());
app.use(express.json()); // Handles JSON payloads

// Serve static files from 'uploads' directory
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));
// console.log('Uploads directory:', path.resolve(__dirname, 'uploads'));


// ROUTES
app.use('/api', UserRoutes);
app.use('/api', fileRoutes);
app.use('/api', profileRoutes);
app.use('/api', subscriptionRoutes);
app.use('/api', rolePermissionRoutes);
app.use('/api', MappingRoutes);

// SERVER ACTION
const PORT = process.env.PORT || 3000; // Default to port 3000 if not specified
app.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});


