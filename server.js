import { connectToDB } from "./utils/db/db.js";
import express from "express";
import cors from "cors";
import UserRoutes from './routes/user-routes.js'
import { configDotenv } from "dotenv";
import cookieParser from "cookie-parser";
import bodyParser from "body-parser";
import fileRoutes from './routes/file-routes.js'
import fileUpload from "express-fileupload";
import profileRoutes from "./routes/profile-routes.js";
import subscriptionRoutes from './routes/subscription-routes.js'

configDotenv();

// Database Setup
connectToDB();

// EXPRESS SETUP WITH CORS
const app = express();
app.use(cors({
    origin: 'http://localhost:5173', // Allow requests from your frontend's origin
    methods: 'GET,POST',
    credentials: true
}));


//Validations Setup
app.use(bodyParser.json());
app.use(cookieParser());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(fileUpload());


app.get('/', (req, res) => {
    res.send({ message: 'Hello' });
});

// ROUTES
app.use('/api', UserRoutes);
app.use('/api', fileRoutes);
app.use('/api', profileRoutes);
app.use('/api', subscriptionRoutes)

// SERVER ACTION
// const PORT = process.env.PORT;
const PORT = process.env.PORT;
app.listen(PORT, '192.168.18.194', () => {
    console.log(`Server is running on http://192.168.18.194:${PORT}`);
});

