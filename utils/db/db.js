import mysql from 'mysql';
import { configDotenv } from 'dotenv';
configDotenv();

let connection;

function connectToDB() {
    connection = mysql.createConnection({
        host: process.env.MYSQL_HOST,
        user: process.env.MYSQL_USER,
        password: process.env.MYSQL_PASSWORD,
        database: process.env.MYSQL_DATABASE
    });
    connection.connect((err) => {
        if (err) throw err;
        console.log("Database Connected...");
    });
    return connection;
}

export { connectToDB, connection };