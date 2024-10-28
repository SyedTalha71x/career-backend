import { successResponse, failureResponse } from '../Helper/helper.js'
import { connectToDB } from '../utils/db/db.js'
import moment from 'moment';
import Stripe from 'stripe';

const stripe = new Stripe(process.env.STRIPE_SECRET_KEY)

const pool = connectToDB();

export const createSubscriptions = async (req, res) => {
    try {
        const { name, price, valid_till } = req.body;
        const sqlQuery = 'INSERT into subscriptions (name, price, valid_till) VALUES (?,?,?)';
        pool.query(sqlQuery, [name, price, valid_till], (err, result) => {
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
};

export const purchaseSubscription = async (req, res) => {
    try {
        const { subscriptionId } = req.body;

        if (!subscriptionId) {
            return res.status(422).json(failureResponse({ error: 'Subscription ID is required' }, 'Failed to purchase Subscription'));
        }

        // Check if user is authenticated
        const userId = req.user?.userId;
        if (!userId) {
            return res.status(401).json(failureResponse({ error: 'User not authenticated' }, 'Failed to purchase Subscription'));
        }

        // Get subscription details from the database
        const subscription = await new Promise((resolve, reject) => {
            const query = 'SELECT name, price, valid_till FROM subscriptions WHERE id = ?';
            pool.query(query, [subscriptionId], (err, result) => {
                if (err) return reject(err);
                if (result.length === 0) return reject(new Error('Subscription not found'));
                resolve(result[0]);
            });
        });

        const unitAmount = Math.round(subscription.price * 100);

        // Create a Stripe checkout session
        const session = await stripe.checkout.sessions.create({
            payment_method_types: ['card'],
            line_items: [{
                price_data: {
                    currency: 'usd',
                    product_data: { name: subscription.name },
                    unit_amount: unitAmount,
                },
                quantity: 1,
            }],
            mode: 'payment',
            success_url: `${process.env.FRONTEND_URL}/success?session_id={CHECKOUT_SESSION_ID}`,
            cancel_url: `${process.env.FRONTEND_URL}/cancel`,
            client_reference_id: subscriptionId,
        });

        if (session) {
            return res.status(200).json(successResponse({ sessionId: session.id }, 'Checkout Session Created Successfully'));
        } else {
            return res.status(500).json(failureResponse({ error: 'Failed to create Stripe session' }, 'Failed to Checkout'));
        }
    } catch (error) {
        console.error('Error creating checkout session:', error);
        return res.status(500).json(failureResponse({ error: 'Internal Server Error' }, 'Failed to Checkout'));
    }
};
export const getSubscription = async (req, res) => {
    try {
        const query = 'SELECT id, name, price FROM subscriptions';
        pool.query(query, (err, results) => {
            if (err) {
                console.log(err);
                return res.status(500).json(failureResponse({ error: 'Internal Server Error' }, 'Failed to Checkout'));
            }
            res.status(200).json({ data: results });
        });
    } catch (error) {
        console.log(error);
        return res.status(500).json(failureResponse({ error: 'Internal Server Error' }, 'Failed to Checkout'));
    }
};
export const confirmSubscription = async (req, res) => {
    try {
        const { sessionId } = req.body;

        if (!sessionId) {
            return res.status(422).json(failureResponse({ error: 'Session ID is required' }, 'Failed to confirm Subscription'));
        }

        // Retrieve the session from Stripe
        const session = await stripe.checkout.sessions.retrieve(sessionId);

        if (!session) {
            return res.status(404).json(failureResponse({ error: 'Session not found' }, 'Failed to confirm Subscription'));
        }

        // Check if the session status is 'paid'
        if (session.payment_status !== 'paid') {
            return res.status(400).json(failureResponse({ error: 'Payment not completed' }, 'Failed to confirm Subscription'));
        }

        // Extract the payment intent ID from the session
        const paymentIntentId = session.payment_intent;

        // Retrieve the subscriptionId from the session
        const subscriptionId = session.client_reference_id;

        if (!subscriptionId) {
            return res.status(400).json(failureResponse({ error: 'Subscription ID missing' }, 'Failed to confirm Subscription'));
        }

        // Get subscription details from the database
        const getSubscription = () => {
            return new Promise((resolve, reject) => {
                const getSubscriptionQuery = 'SELECT valid_till FROM subscriptions WHERE id = ?';
                pool.query(getSubscriptionQuery, [subscriptionId], (err, result) => {
                    if (err) return reject(err);
                    if (result.length === 0) return reject(new Error('Subscription not found'));
                    resolve(result[0]);
                });
            });
        };

        const subscription = await getSubscription();
        const expiryDate = moment().add(subscription.valid_till, 'days').format('YYYY-MM-DD');

        // Save user subscription to the database
        const saveUserSubscription = () => {
            return new Promise((resolve, reject) => {
                const insertUserSubscriptionQuery = `
                    INSERT INTO user_subscription (subscription_id, user_id, expiry_date, payment_id, created_at, updated_at)
                    VALUES (?, ?, ?, ?, NOW(), NOW())
                `;
                pool.query(
                    insertUserSubscriptionQuery,
                    [subscriptionId, req.user.userId, expiryDate, paymentIntentId],
                    (err, result) => {
                        if (err) return reject(err);
                        resolve(result);
                    }
                );
            });
        };

        await saveUserSubscription();
        return res.status(200).json({ success: true, message: 'Subscription confirmed successfully' });


    } catch (error) {
        console.error('Error confirming subscription:', error);
        return res.status(500).json(failureResponse({ error: 'Internal Server Error' }, 'Failed to confirm Subscription'));
    }
};
export const checkUserSubscription = async (req, res) => {
    const userId = req.user?.userId; 

  if (!userId) {
    return res.status(401).json({ error: 'Unauthorized' });
  }

  const query = `
    SELECT us.expiry_date
    FROM user_subscription us
    WHERE us.user_id = ? AND us.expiry_date > NOW()
    LIMIT 1;
  `;

  pool.query(query, [userId], (error, results) => {
    if (error) {
      console.error('Error executing query', error);
      return res.status(500).json({ error: 'Internal server error' });
    }

    // If no result is returned, it means the subscription has expired or doesn't exist
    if (results.length === 0) {
      return res.json({ Subscription_Status: false });
    }

    // If we get a result, the subscription is still active
    res.json({ Subscription_Status: true });
  });
};

