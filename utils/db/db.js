import mysql from 'mysql';
import { config as configDotenv } from 'dotenv';
configDotenv();

let pool;

function connectToDB() {
    if (!pool) {
        pool = mysql.createPool({
            connectionLimit: 10,
            host: process.env.MYSQL_HOST,
            user: process.env.MYSQL_USER,
            password: process.env.MYSQL_PASSWORD,
            database: process.env.MYSQL_DATABASE
        });

        pool.on('connection', (connection) => {
            console.log('Database connection established with ID:', connection.threadId);
        });

        pool.on('error', (err) => {
            console.error('Database error:', err);
        });

        console.log('Database connection pool created.');
    }
    return pool;
}

export { connectToDB };
