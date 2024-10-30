import { connectToDB } from "../utils/db/db.js";
import { successResponse, failureResponse } from "../Helper/helper.js";
import Stripe from "stripe";
import moment from "moment";

const pool = connectToDB();
const stripe = new Stripe(process.env.STRIPE_SECRET_KEY);

// 1. Redirect to Stripe for Payment
export const redirectStripe = async (req, res) => {
    const { branchId } = req.body;

    if (!branchId) {
        return res.status(422).json(failureResponse({ error: 'branchId is required' }, 'Failed to purchase Subscription'));
    }

    // Checking if user is authenticated
    const userId = req.user?.userId;
    if (!userId) {
        return res.status(401).json(failureResponse({ error: 'User not authenticated' }, 'Failed to purchase Subscription'));
    }

    try {
        const session = await stripe.checkout.sessions.create({
            payment_method_types: ['card'],
            line_items: [
                {
                    price_data: {
                        currency: 'usd',
                        product_data: {
                            name: `Branch ID: ${branchId}`,
                        },
                        unit_amount: 1000, 
                    },
                    quantity: 1,
                },
            ],
            mode: 'payment',
            success_url: `${process.env.FRONTEND_URL}/get-pdf/${branchId}?session_id={CHECKOUT_SESSION_ID}`,
            cancel_url: `${process.env.FRONTEND_URL}/cancel`,
            client_reference_id: branchId,
        });

        return res.status(200).json(successResponse({ sessionId: session.id, url: session.url }, 'Checkout Session Created Successfully'));
    } catch (error) {
        console.error('Error creating Stripe checkout session:', error);
        return res.status(500).json(failureResponse({ error: 'Internal Server Error' }, 'Failed to Checkout'));
    }
};

// 2. Confirm Subscription after Payment Success
export const confirmModelSubscription = async (req, res) => {
    try {
        const { sessionId, branchId } = req.body;

        if (!sessionId || !branchId) {
            return res.status(422).json(
                failureResponse({ error: 'Session ID and Branch ID are required' }, 'Failed to confirm Subscription')
            );
        }

        const session = await stripe.checkout.sessions.retrieve(sessionId);

        if (!session || session.payment_status !== 'paid') {
            return res.status(400).json(failureResponse({ error: 'Payment not completed' }, 'Failed to confirm Subscription'));
        }

        const paymentIntentId = session.payment_intent;
        const expiryDate = moment().add(30, 'days').format('YYYY-MM-DD');

        const saveUserSubscription = () => {
            return new Promise((resolve, reject) => {
                const insertUserSubscriptionQuery = `
                    INSERT INTO model_subscription (user_id, branch_id, amount, payment_id, created_at, updated_at)
                    VALUES (?, ?, ?, ?, NOW(), NOW())
                `;
                pool.query(
                    insertUserSubscriptionQuery,
                    [req.user.userId, branchId, session.amount_total / 100, paymentIntentId],
                    (err, result) => {
                        if (err) return reject(err);
                        resolve(result);
                    }
                );
            });
        };

        await saveUserSubscription();
        return res.status(200).json(successResponse({}, 'Subscription confirmed successfully'));
    } catch (error) {
        console.error('Error confirming subscription:', error);
        return res.status(500).json(failureResponse({ error: 'Internal Server Error' }, 'Failed to confirm Subscription'));
    }
};


// 3. checking download status
export const checkDownloadStatus = async (req, res) => {
    try {
        const { branchId } = req.body;

        if (!branchId) {
            return res.status(422).json(failureResponse({ error: 'branchId is required' }, 'Failed to check download status'));
        }

        const query = 'SELECT id FROM model_subscription WHERE branch_id = ?';
        pool.query(query, [branchId], (err, results) => {
            if (err) {
                console.log('Database error:', err);
                return res.status(500).json(failureResponse({ error: 'Internal Server Error' }, 'Failed to check download status'));
            }

            if (results.length > 0) {
                return res.status(200).json(successResponse({ downloadStatus: true }, 'Branch ID found, download status is true'));
            }

            return res.status(404).json(failureResponse({ downloadStatus: false }, 'Branch ID not found'));
        });
    } catch (error) {
        console.error('Error checking download status:', error);
        return res.status(500).json(failureResponse({ error: 'Internal Server Error' }, 'Failed to check download status'));
    }
};

// 4. getting all model subscription
export const getModelSubscription = async (req, res) => {
    try {
        const query = 'SELECT id, amount, payment_id, branch_id FROM model_subscription';
        pool.query(query, (err, results) => {
            if (err) {
                console.log(err);
                return res.status(500).json(failureResponse({ error: 'Internal Server Error' }, 'Failed to fetch subscriptions'));
            }
            res.status(200).json({ data: results });
        });
    } catch (error) {
        console.log(error);
        return res.status(500).json(failureResponse({ error: 'Internal Server Error' }, 'Failed to fetch subscriptions'));
    }
}; 