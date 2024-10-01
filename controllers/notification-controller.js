import { failureResponse, successResponse } from "../Helper/helper.js";
import { connectToDB } from "../utils/db/db.js";
import { createNotifications } from "../Helper/helper.js";

const pool = connectToDB();

// export const createNotifications = (req, res) => {
//   try {
//     const userId = req.user?.userId;
//     const { title, description, link } = req.body;

//     if (!userId) {
//       return res
//         .status(400)
//         .json(
//           failureResponse(
//             { error: "User not authenticated" },
//             "Failed to create the notifications"
//           )
//         );
//     }

//     if (!title || !description || !link) {
//       return res
//         .status(400)
//         .json({ error: "Please provide all required fields" });
//     }

//     const query = `
//     INSERT INTO notifications (user_id, title, description, link, \`read\`, \`seen\`)
//     VALUES (?, ?, ?, ?, 0, 0)
//   `;

//     pool.query(query, [userId, title, description, link], (error, results) => {
//       if (error) {
//         console.error("Error inserting notification:", error);
//         return res.status(500).json({ error: "Failed to create notification" });
//       }

//       res.status(200).json(
//         successResponse({
//           message: "Notification created successfully",
//           notificationId: results.insertId,
//         })
//       );
//     });
//   } catch (error) {
//     console.log(error);
//     return res
//       .status(500)
//       .json(
//         failureResponse(
//           { error: "Internal Server Error" },
//           "Failed to create Notification"
//         )
//       );
//   }
// };
export const getNotifications = (req, res) => {
  try {
    const sqlQuery = `
    SELECT * FROM notifications ORDER BY id DESC LIMIT 10;`;
    const unseenCountQuery =
      "SELECT COUNT(*) AS unseenCount FROM notifications WHERE seen = 0";

    pool.query(sqlQuery, (err, notifications) => {
      if (err) {
        console.error(err);
        return res
          .status(500)
          .json(failureResponse({}, "Internal server error"));
      }
      pool.query(unseenCountQuery, (err, unseenResult) => {
        if (err) {
          console.error(err);
          return res
            .status(500)
            .json(failureResponse({}, "Internal server error"));
        }
        const unseen_count = unseenResult[0].unseenCount;
        return res
          .status(200)
          .json(
            successResponse(
              { unseen_count, notifications },
              "Notification fetch successfully"
            )
          );
      });
    });
  } catch (error) {
    console.log(error);
    return res
      .status(500)
      .json(
        failureResponse(
          { error: "Internal Server Error" },
          "Failed to get Notification"
        )
      );
  }
};
export const updateSeenAllNotificationsForSpecificUser = (req, res) => {
  try {
    const userId = req.user?.userId;
    if (!userId) {
      return res
        .status(400)
        .json(
          failureResponse(
            { error: "User not authenticated" },
            "Failed to seen the notifications"
          )
        );
    }
    const sqlQuery = `UPDATE notifications SET seen = 1 WHERE user_id = ?`;
    pool.query(sqlQuery, [userId], (err, results) => {
      if (err) {
        console.error(err);
        return res
          .status(500)
          .json(
            failureResponse(
              { error: "Internal Server Error" },
              "Failed to seen the notifications"
            )
          );
      }
      if (results.affectedRows === 0) {
        return res
          .status(404)
          .json(failureResponse({}, "No notifications found to update seen"));
      }
      return res
        .status(200)
        .json(successResponse({ message: "Notifications marked as seen" }));
    });
  } catch (error) {
    console.log(error);
    return res
      .status(500)
      .json(
        failureResponse(
          { error: "Internal Server Error" },
          "Failed to get Notification"
        )
      );
  }
};
export const updateReadAllNotificationsForSpecificUser = (req, res) => {
  try {
    const userId = req.user?.userId;
    if (!userId) {
      return res
        .status(400)
        .json(
          failureResponse(
            { error: "User not authenticated" },
            "Failed to read the notifications"
          )
        );
    }
    const sqlQuery = `UPDATE notifications SET \`read\` = 1 WHERE user_id = ?`;
    pool.query(sqlQuery, [userId], (err, results) => {
      if (err) {
        console.error(err);
        return res
          .status(500)
          .json(
            failureResponse(
              { error: "Internal Server Error" },
              "Failed to read the notifications"
            )
          );
      }
      if (results.affectedRows === 0) {
        return res
          .status(404)
          .json(failureResponse({}, "No notifications found to update read"));
      }
      return res
        .status(200)
        .json(successResponse({ message: "Notifications marked as read" }));
    });
  } catch (error) {
    console.log(error);
    return res
      .status(500)
      .json(
        failureResponse(
          { error: "Internal Server Error" },
          "Failed to read Notification"
        )
      );
  }
};
export const updateReadNotificationForSpecificUser = (req, res) => {
  try {
    const notificationId = req.params.id;
    const userId = req.user?.userId;
    if (!userId) {
      return res
        .status(500)
        .json(
          failureResponse(
            { error: "User is not authenticated" },
            "Failed to read the specific notification"
          )
        );
    }
    if (!notificationId) {
      return res
        .status(500)
        .json(
          failureResponse(
            { error: "Notification Id is required" },
            "Failed to read the specific notification"
          )
        );
    }

    const sqlQuery =
      "UPDATE notifications set `read` = 1 WHERE id = ? AND user_id = ?";

    pool.query(sqlQuery, [notificationId, userId], (err, results) => {
      if (err) {
        console.log(err);
        return res
          .status(500)
          .json(
            failureResponse(
              { error: "Internal Server Error" },
              "Failed to read the specific notification"
            )
          );
      }
      if (results.affectedRows === 0) {
        return res
          .status(404)
          .json(failureResponse({}, "No notification found to update read"));
      }
      return res
        .status(200)
        .json(
          successResponse({ message: "Notification is read successfully" })
        );
    });
  } catch (error) {
    console.log(error);
    return res
      .status(500)
      .json(
        failureResponse(
          { error: "Internal Server Error" },
          "Failed to read the specific notification"
        )
      );
  }
};
export const updateUnReadNotificationForSpecificUser = (req, res) => {
  try {
    const notificationId = req.params.id;
    const userId = req.user?.userId;
    if (!userId) {
      return res
        .status(500)
        .json(
          failureResponse(
            { error: "User is not authenticated" },
            "Failed to unread the specific notification"
          )
        );
    }
    if (!notificationId) {
      return res
        .status(500)
        .json(
          failureResponse(
            { error: "Notification Id is required" },
            "Failed to unread the specific notification"
          )
        );
    }

    const sqlQuery =
      "UPDATE notifications set `read` = 0 WHERE id = ? AND user_id = ?";

    pool.query(sqlQuery, [notificationId, userId], (err, results) => {
      if (err) {
        console.log(err);
        return res
          .status(500)
          .json(
            failureResponse(
              { error: "Internal Server Error" },
              "Failed to unread the specific notification"
            )
          );
      }
      if (results.affectedRows === 0) {
        return res
          .status(404)
          .json(failureResponse({}, "No notification found to update unread"));
      }
      return res
        .status(200)
        .json(
          successResponse({ message: "Notification is unread successfully" })
        );
    });
  } catch (error) {
    console.log(error);
    return res
      .status(500)
      .json(
        failureResponse(
          { error: "Internal Server Error" },
          "Failed to unread the specific notification"
        )
      );
  }
};
export const createPathNotification = (req, res) => {
  try {
    const PathId = req.params.id;
    const userId = req.user?.userId;
    if (!userId) {
      return res
        .status(500)
        .json(
          failureResponse(
            { error: "User is not authenticated" },
            "Failed to read the specific notification"
          )
        );
    }

    const sqlQuery = "SELECT * FROM path WHERE id = ? ";
    pool.query(sqlQuery, [PathId], (err, pathResults) => {
      if (err) {
        console.log(err);
        return res
          .status(500)
          .json(
            failureResponse(
              { error: "Internal Server Error" },
              "Failed to create the notifications"
            )
          );
      }
      const pathTitle = pathResults[0].title;

      const modifiedDescription = "This path has been analyse";
      const modifiedLink = null;

      const notifications = createNotifications(
        userId,
        pathTitle,
        modifiedDescription,
        modifiedLink
      );

      const insertNotifcatonQuery = `INSERT INTO notifications (user_id, title, description, link, \`read\`, \`seen\`) VALUES (?, ?, ?, ?, 0, 0)`;

      pool.query(
        insertNotifcatonQuery,
        [
          notifications.user_id,
          notifications.title,
          notifications.description,
          notifications.link,
        ],
        (err, results) => {
          if (err) {
            console.error("Error inserting notification:", err);
            return res
              .status(500)
              .json({ err: "Failed to create notification" });
          }

          return res
            .status(200)
            .json(
              successResponse({
                message: "Notification created",
                notificationId: results.insertId,
              })
            );
        }
      );
    });
  } catch (error) {
    console.log(error);
    return res
      .status(500)
      .json(
        failureResponse(
          { error: "Internal Server Error" },
          "Failed to create notification"
        )
      );
  }
};
