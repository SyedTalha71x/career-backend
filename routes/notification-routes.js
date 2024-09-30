import { getNotifications, updateSeenAllNotificationsForSpecificUser, updateReadAllNotificationsForSpecificUser, updateReadNotificationForSpecificUser, updateUnReadNotificationForSpecificUser, createPathNotification} from '../controllers/notification-controller.js'
import express from 'express'
import authenticate from '../middleware/authentication.js';

const router = express.Router();

// router.post('/create-notification', authenticate, createNotifications)
router.get('/get-notifications', getNotifications)
router.put('/update-seen-all-notifications-for-specific-user', authenticate, updateSeenAllNotificationsForSpecificUser)
router.put('/update-read-all-notifications-for-specfic-user', authenticate, updateReadAllNotificationsForSpecificUser)
router.put('/update-read-notification-for-specfic-user/:id', authenticate, updateReadNotificationForSpecificUser)
router.put('/update-unread-notification-for-specfic-user/:id', authenticate, updateUnReadNotificationForSpecificUser)
router.post('/create-path-analyse-notifications/:id', authenticate, createPathNotification)


export default router;

