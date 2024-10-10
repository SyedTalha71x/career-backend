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
import NotificationRoutes from './routes/notification-routes.js'
import path from 'path';
import MappingRoutes from './routes/mapping-routes.js';
import { fileURLToPath } from 'url';
import { networkInterfaces } from 'os';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Load environment variables
configDotenv(); 

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
app.use('/api', NotificationRoutes)

// SERVER ACTION
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    function getServerIp() {
        const networkInterf = networkInterfaces();
        for (const interfaceName in networkInterf) {
            const interf = networkInterf[interfaceName];
            for (const alias of interf) {
                if (alias.family === 'IPv4' && !alias.internal) {
                    return alias.address;
                }
            }
        }
        return 'Unknown IP';
    }
    console.log(`Server is running on http://${getServerIp()}:${PORT}`);
});


