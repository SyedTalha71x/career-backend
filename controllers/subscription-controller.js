import { successResponse, failureResponse } from '../Helper/helper.js'
import { connection } from '../utils/db/db.js'
import moment from 'moment';

export const createSubscriptions = async (req, res) => {
    try {
        const { name, price, valid_till } = req.body;
        const sqlQuery = 'INSERT into subscriptions (name, price, valid_till) VALUES (?,?,?)';
        connection.query(sqlQuery, [name, price, valid_till], (err, result) => {
            if (err) {
                console.error('Database query error:', err);
                return res.status(500).json(failureResponse({ error: 'Internal Server Error' }, 'Subscription Creation Failed'));
            }
            if (result.insertId) {
                return res.status(200).json(successResponse({ id: result.insertId }, 'Subscription has been created'))
            }
            else {
                return res.status(500).json(failureResponse({ error: 'Internal Server Error' }, 'Subscription Creation Failed'));
            }
        })
    }
    catch (error) {
        console.log(error);
        return res.status(500).json(failureResponse({ error: 'Internal Server Error' }, 'Subscription Creation Failed'));
    }
}
export const buySubscriptions = async (req, res) => {
    try {
        const { subscriptionId } = req.body;
        if (!subscriptionId) {
            return res.status(422).json(failureResponse({ error: 'Subscription ID is required' }, 'Failed to purchase Subscription'))
        }
        // Check if user is authenticated ( Token based Checking extract from Signin)
        const userId = req.user.userId;
        if (!userId) {
            return res.status(401).json(failureResponse({ error: 'User not authenticated' }, 'Failed to purchase Subscription'))
        }

        const getSubcriptionQuery = 'SELECT valid_till FROM subscriptions where id = ?';
        connection.query(getSubcriptionQuery, [subscriptionId], (err, result) => {
            if (err) {
                console.error('Database query error:', err);
                return res.status(500).json(failureResponse({ error: 'Internal Server Error' }, 'Failed to purchase Subscription'));
            }
            if (result.length === 0) {
                return res.status(500).json(failureResponse({ error: 'Subscription not Found' }, 'Failed to purchase Subscription'));
            }
            const validTill = result[0].valid_till
            const expiryDate = moment(validTill).format('YYYY-MM-DD HH:mm:ss');

            const insertQuery = 'INSERT INTO user_subscription (subscription_id, user_id, expiry_date, payment_id) VALUES (?, ?, ?, ?)';
            connection.query(insertQuery, [subscriptionId, userId, expiryDate, null], (err, result) => {
                if (err) {
                    console.error('Database query error:', err);
                    return res.status(500).json(failureResponse({ error: 'Internal Server Error' }, 'Failed to purchase Subscription'));
                }
                if (result.insertId) {
                    return res.status(200).json(successResponse({ id: result.insertId }, 'Subscription Purchased Successfully'))
                } else {
                    return res.status(500).json(failureResponse({ error: 'Internal Server Error' }, 'Subscription Purchase Failed'));
                }
            })
        })
    }
    catch (error) {
        console.log(error);
        return res.status(500).json(failureResponse({ error: 'Internal Server Error' }, 'Failed to purchase Subscription'));

    }
}