import { successResponse, failureResponse } from "../Helper/helper.js";
import { connectToDB } from "../utils/db/db.js";
import moment from "moment-timezone";
import Stripe from "stripe";

const stripe = new Stripe(process.env.STRIPE_SECRET_KEY);

const pool = connectToDB();

export const createSubscriptions = async (req, res) => {
  try {
    const { name, price, valid_till } = req.body;
    const sqlQuery =
      "INSERT into subscriptions (name, price, valid_till) VALUES (?,?,?)";
    pool.query(sqlQuery, [name, price, valid_till], (err, result) => {
      if (err) {
        console.error("Database query error:", err);
        return res
          .status(500)
          .json(
            failureResponse(
              { error: "Internal Server Error" },
              "Subscription Creation Failed"
            )
          );
      }
      if (result.insertId) {
        return res
          .status(200)
          .json(
            successResponse(
              { id: result.insertId },
              "Subscription has been created"
            )
          );
      } else {
        return res
          .status(500)
          .json(
            failureResponse(
              { error: "Internal Server Error" },
              "Subscription Creation Failed"
            )
          );
      }
    });
  } catch (error) {
    console.log(error);
    return res
      .status(500)
      .json(
        failureResponse(
          { error: "Internal Server Error" },
          "Subscription Creation Failed"
        )
      );
  }
};
export const purchaseSubscription = async (req, res) => {
  try {
    const { subscriptionId } = req.body;

    if (!subscriptionId) {
      return res
        .status(422)
        .json(
          failureResponse(
            { error: "Subscription ID is required" },
            "Failed to purchase Subscription"
          )
        );
    }

    // Check if user is authenticated
    const userId = req.user?.userId;
    if (!userId) {
      return res
        .status(401)
        .json(
          failureResponse(
            { error: "User not authenticated" },
            "Failed to purchase Subscription"
          )
        );
    }

    const subscription = await new Promise((resolve, reject) => {
      const query =
        "SELECT name, price, valid_till FROM subscriptions WHERE id = ?";
      pool.query(query, [subscriptionId], (err, result) => {
        if (err) return reject(err);
        if (result.length === 0)
          return reject(new Error("Subscription not found"));
        resolve(result[0]);
      });
    });

    const unitAmount = Math.round(subscription.price * 100);

    const getFrontendUrl = () => {
      if (process.env.NODE_ENV === "development") {
        return process.env.FRONTEND_URL;
      } else if (process.env.NODE_ENV === "production") {
        return process.env.PRODUCTION_URL;
      } else {
        return process.env.FRONTEND_URL;
      }
    };
    const session = await stripe.checkout.sessions.create({
      payment_method_types: ["card"],
      line_items: [
        {
          price_data: {
            currency: "gbp",
            product_data: { name: subscription.name },
            unit_amount: unitAmount,
          },
          quantity: 1,
        },
      ],
      mode: "payment",
      success_url: `${getFrontendUrl()}/success?session_id={CHECKOUT_SESSION_ID}`,
      cancel_url: `${getFrontendUrl()}/cancel`,
      client_reference_id: subscriptionId,
    });

    const insert_activity_logs =
      "INSERT INTO activity_logs (name, user_id) VALUES (?,?)";

    pool.query(
      insert_activity_logs,
      [`Subscription purchased: ${subscription.name}`, userId],
      (err) => {
        if (err) {
          console.log(err);
          return res.status(500).json({ error: "Internal Server Error" });
        }
      }
    );

    if (session) {
      return res
        .status(200)
        .json(
          successResponse(
            { sessionId: session.id },
            "Checkout Session Created Successfully"
          )
        );
    } else {
      return res
        .status(500)
        .json(
          failureResponse(
            { error: "Failed to create Stripe session" },
            "Failed to Checkout"
          )
        );
    }
  } catch (error) {
    console.error("Error creating checkout session:", error);
    return res
      .status(500)
      .json(
        failureResponse(
          { error: "Internal Server Error" },
          "Failed to Checkout"
        )
      );
  }
};
export const getSubscription = async (req, res) => {
  try {
    const query =
      "SELECT id, name, price, valid_till, description, points FROM subscriptions";
    pool.query(query, (err, results) => {
      if (err) {
        console.log(err);
        return res
          .status(500)
          .json(
            failureResponse(
              { error: "Internal Server Error" },
              "Failed to Checkout"
            )
          );
      }
      res.status(200).json({ data: results });
    });
  } catch (error) {
    console.log(error);
    return res
      .status(500)
      .json(
        failureResponse(
          { error: "Internal Server Error" },
          "Failed to Checkout"
        )
      );
  }
};

export const confirmSubscription = async (req, res) => {
  try {
    const { sessionId } = req.body;

    if (!sessionId) {
      return res
        .status(422)
        .json(
          failureResponse(
            { error: "Session ID is required" },
            "Failed to confirm Subscription"
          )
        );
    }

    // Retrieve the session from Stripe
    const session = await stripe.checkout.sessions.retrieve(sessionId);

    if (!session) {
      return res
        .status(404)
        .json(
          failureResponse(
            { error: "Session not found" },
            "Failed to confirm Subscription"
          )
        );
    }

    // Check if the session status is 'paid'
    if (session.payment_status !== "paid") {
      return res
        .status(400)
        .json(
          failureResponse(
            { error: "Payment not completed" },
            "Failed to confirm Subscription"
          )
        );
    }

    const paymentIntentId = session.payment_intent;

    const subscriptionId = session.client_reference_id;

    if (!subscriptionId) {
      return res
        .status(400)
        .json(
          failureResponse(
            { error: "Subscription ID missing" },
            "Failed to confirm Subscription"
          )
        );
    }

    const getSubscription = () => {
      return new Promise((resolve, reject) => {
        const getSubscriptionQuery =
          "SELECT valid_till FROM subscriptions WHERE id = ?";
        pool.query(getSubscriptionQuery, [subscriptionId], (err, result) => {
          if (err) return reject(err);
          if (result.length === 0)
            return reject(new Error("Subscription not found"));
          resolve(result[0]);
        });
      });
    };

    const subscription = await getSubscription();

    const expiryDate = moment()
      .add(subscription.valid_till, "days")
      .tz("Asia/Karachi") // Set timezone to Asia/Karachi
      .format("YYYY-MM-DD HH:mm:ss"); // Format for MySQL

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
    return res
      .status(200)
      .json({ success: true, message: "Subscription confirmed successfully" });
  } catch (error) {
    console.error("Error confirming subscription:", error);
    return res
      .status(500)
      .json(
        failureResponse(
          { error: "Internal Server Error" },
          "Failed to confirm Subscription"
        )
      );
  }
};

export const checkUserSubscription = async (req, res) => {
  const userId = req.user?.userId;

  if (!userId) {
    return res.status(401).json({ error: "Unauthorized" });
  }

  const checkPathQuery =
    "SELECT COUNT(*) as pathCount FROM path WHERE user_id = ?";

  const query = `
    SELECT us.expiry_date
    FROM user_subscription us
    WHERE us.user_id = ? AND us.expiry_date > NOW()
    LIMIT 1;
  `;
  try {
    pool.query(checkPathQuery, [userId], (err, results) => {
      if (err) {
        console.log(err);
        return res.status(500).json({ message: "Internal Server Error" });
      }

      const pathCount = results[0]?.pathCount || 0;

      if (pathCount > 0) {
        pool.query(query, [userId], (err, subResults) => {
          if (err) {
            console.log(err);
            return res.status(500).json({ message: "Internal Server Error" });
          }
          if (subResults.length === 0) {
            return res.json({
              Subscription_Status: false,
              message:
                "You need to purchase a subscription to create a new path.",
            });
          }

          return res.status(200).json({
            Subscription_Status: false,
            message: "Yes you can create a new path",
          });
        });
      } else {
        return res.status(200).json({
          Subscription_Status: true,
          message: "Yes you can create your first path for free",
        });
      }
    });
  } catch (error) {
    console.error("Unexpected error", error);
    return res.status(500).json({ error: "Internal server error" });
  }
};

export const checkPathSubscription = (req, res) => {
  try {
    const userId = req.user?.userId;

    if (!userId) {
      return res.status(401).json({
        error: "User not authenticated",
        Subscription_Status: false,
      });
    }

    const checkPathQuery = `
      SELECT COUNT(*) as pathCount
      FROM path
      WHERE user_id = ?
    `;

    const subscriptionQuery = `
      SELECT 
          us.current_path, 
          s.total_path,
          s.id AS subscription_id,
          us.expiry_date
      FROM user_subscription AS us
      JOIN subscriptions AS s ON us.subscription_id = s.id
      WHERE us.user_id = ? AND us.expiry_date > NOW()
      ORDER BY us.expiry_date DESC
      LIMIT 1;
    `;

    // Step 1: Check how many paths the user has already created
    pool.query(checkPathQuery, [userId], (err, pathResults) => {
      if (err) {
        console.error("Database error (path count):", err);
        return res.status(500).json({ error: "Internal Server Error" });
      }

      const pathCount = pathResults[0]?.pathCount || 0;

      // Allow the first path for free
      if (pathCount === 0) {
        return res.status(200).json({
          message: "First path is free to create.",
          Subscription_Status: true,
        });
      }

      // Step 2: Check the user's subscription status
      pool.query(subscriptionQuery, [userId], (err, subResults) => {
        if (err) {
          console.error("Database error (subscription):", err);
          return res.status(500).json({ error: "Internal Server Error" });
        }

        if (!subResults.length) {
          return res.status(200).json({
            error:
              "No active subscription found. Please purchase a subscription to create more paths.",
            Subscription_Status: false,
          });
        }

        const { current_path, subscription_id, expiry_date } = subResults[0];

        const timezone = "Asia/Karachi";
        const isSubscriptionValid = moment()
          .tz(timezone)
          .isBefore(moment(expiry_date).tz(timezone));

        if (!isSubscriptionValid) {
          return res.status(200).json({
            error:
              "Your subscription has expired. Please purchase to create more paths.",
            Subscription_Status: false,
          });
        }

        let pathLimit;
        switch (subscription_id) {
          case 1: // Pioneer
            pathLimit = 15;
            break;
          case 2: // Navigator
            pathLimit = 6;
            break;
          case 3: // Explorer
            pathLimit = 2;
            break;
          default:
            return res.status(400).json({ error: "Unknown subscription type" });
        }

        if (current_path >= pathLimit) {
          return res.status(200).json({
            error: "Subscription limit reached. Upgrade your plan.",
            Subscription_Status: false,
          });
        }

        res.status(200).json({
          message: "Path creation is allowed.",
          Subscription_Status: true,
        });
      });
    });
  } catch (error) {
    console.error("Unexpected error:", error);
    return res.status(500).json({ error: "Internal Server Error" });
  }
};

export const checkTrainingPlanSubscription = (req, res) => {
  try {
    const userId = req.user?.userId;

    if (!userId) {
      return res.status(401).json({
        error: "User not authenticated",
        TrainingPlan_Status: false,
      });
    }

    const subscriptionQuery = `
    SELECT 
      us.current_training_plan, 
      s.total_training_plan,
      s.id AS subscription_id,
      us.expiry_date
    FROM user_subscription AS us
    JOIN subscriptions AS s ON us.subscription_id = s.id
    WHERE us.user_id = ? 
    AND us.expiry_date > NOW()  -- Sirf active subscriptions check hongi
    ORDER BY us.created_at DESC  -- Sabse latest active subscription fetch karega
    LIMIT 1;
  `;

    pool.query(subscriptionQuery, [userId], (err, subResults) => {
      if (err) {
        console.error("Database error:", err);
        return res.status(500).json({ error: "Internal Server Error" });
      }

      if (!subResults.length) {
        return res.status(200).json({
          error:
            "No active subscription found. Please purchase a subscription to create a training plan.",
          TrainingPlan_Status: false,
        });
      }

      const { current_training_plan, subscription_id } = subResults[0];

      let trainingPlanLimit;
      switch (subscription_id) {
        case 1: // Pioneer
          trainingPlanLimit = 3;
          break;
        case 2: // Navigator
          trainingPlanLimit = 1;
          break;
        case 3: // Explorer
          trainingPlanLimit = 0;
          break;
        default:
          return res.status(400).json({ error: "Unknown subscription type" });
      }

      if (current_training_plan >= trainingPlanLimit) {
        return res.status(200).json({
          error: "Training plan limit reached. Upgrade your plan.",
          TrainingPlan_Status: false,
        });
      }

      res.status(200).json({
        message: "Training plan creation is allowed.",
        Subscription_Status: true,
      });
    });
  } catch (error) {
    console.error("Unexpected error:", error);
    return res.status(500).json({ error: "Internal Server Error" });
  }
};
