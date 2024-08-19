import fs from 'fs';
import path from 'path';
import os from 'os';


// Get the user's desktop directory
const desktopDir = path.join(os.homedir(), 'Desktop');

export const uploadFile = async (req, res) => {
    try {
        if (!req.body.base64String) {
            return res.status(400).json({ message: 'No base64 string provided' });
        }
        const { chunkNumber, totalChunks, fileName, base64String } = req.body;

        // Convert the base64 string to a buffer
        const chunkBuffer = Buffer.from(base64String, 'base64');

        const uploadDir = path.join(desktopDir, 'uploads');

        // If file not exists then create a new file in the directory
        if (!fs.existsSync(uploadDir)) {
            fs.mkdirSync(uploadDir, { recursive: true });
        }

        const filePath = path.join(uploadDir, fileName);
        const tempFilePath = `${filePath}.part`;

        // Use fs.promises for better async/await hand ling
        const fsPromises = fs.promises;

        // Append the buffer to the temporary file
        await fsPromises.appendFile(tempFilePath, chunkBuffer);

        if (parseInt(chunkNumber) + 1 === parseInt(totalChunks)) {
            // All chunks are received; rename the temp file to the final file
            await fsPromises.rename(tempFilePath, filePath);

            // Get file details
            const stats = await fsPromises.stat(filePath);
            return res.send({
                message: 'Upload successful',
                file: {
                    name: fileName,
                    size: stats.size,
                    path: filePath
                }
            });

        } else {
            return res.send({ message: 'Chunk upload successful' });
        }
    } catch (error) {
        console.error('Unexpected error:', error);
        return res.status(500).json({ message: 'Internal Server Error' });
    }
};
