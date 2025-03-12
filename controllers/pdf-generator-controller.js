import PDFDocument from "pdfkit";
import fs from "fs";
import path from "path";
import { connectToDB } from "../utils/db/db.js";

const pool = connectToDB();
const uploadsDir = path.join(process.cwd(), "uploads");

if (!fs.existsSync(uploadsDir)) {
  fs.mkdirSync(uploadsDir, { recursive: true });
}

function generatePDF(data, branchId) {
  const branchDir = path.join(uploadsDir, `pdf`);
  if (!fs.existsSync(branchDir)) {
    fs.mkdirSync(branchDir, { recursive: true });
  }

  const doc = new PDFDocument({ margin: 50 });
  const filePath = path.join(
    branchDir,
    `CareerDevelopmentPlan_${branchId}.pdf`
  );
  const writeStream = fs.createWriteStream(filePath);
  doc.pipe(writeStream);

  doc.fontSize(24).fillColor("blue").text("Career Development Plan", {
    align: "center",
  });
  doc.moveDown(2);

  function addSectionHeader(title) {
    doc.fillColor("black").fontSize(18).text(title, { underline: true });
    doc.moveDown(1);
  }

  function addSubSectionHeader(title) {
    doc.fillColor("black").fontSize(14).text(title, { underline: true });
    doc.moveDown(0.5);
  }

  function addSectionContent(content) {
    if (content !== undefined && content !== null) {
      doc.fontSize(12).fillColor("black").text(content.toString());
      doc.moveDown(0.5);
    }
  }

  // User and Plan Information
  addSectionHeader("User Information");
  addSectionContent(`Username: ${data.username || "N/A"}`);
  addSectionContent(`Email: ${data.email || "N/A"}`);
  addSectionContent(
    `Date of Plan Creation: ${new Date().toLocaleDateString()}`
  );
  doc.moveDown(2);

  // Career Goals Overview
  addSectionHeader("Career Goals Overview");
  if (data.career_goals_overview.length > 0) {
    data.career_goals_overview.forEach((goal) => {
      addSectionContent(`Title: ${goal.title || "N/A"}`);
      addSectionContent(
        `Type: ${
          goal.type === "s"
            ? "Short Term"
            : goal.type === "l"
            ? "Long Term"
            : "N/A"
        }`
      );
      addSectionContent(`Completion Date: ${goal.completion_date || "N/A"}`);
      doc.moveDown();
    });
  } else {
    addSectionContent("No career goals data available");
  }

  // Skill Gap Analysis
  addSectionHeader("Skill Gap Analysis");
  if (data.skill_gap_analysis.length > 0) {
    data.skill_gap_analysis.forEach((skill, index) => {
      doc.text(`${index + 1}. ${skill.title || "N/A"}`, { underline: false });
      doc.moveDown(0.5);
      addSectionContent(`Priority: ${skill.priority || "N/A"}`);
      addSectionContent(`Status: ${skill.status || "N/A"}`);

      addSubSectionHeader("Resources");
      if (skill.resources.length > 0) {
        skill.resources.forEach((resource) => {
          addSectionContent(`- ${resource.title || "N/A"}`);
          addSectionContent(`  Platform: ${resource.platform || "N/A"}`);
          addSectionContent(`  Link: ${resource.link || "N/A"}`);
        });
      } else {
        addSectionContent("No resources available for this skill gap");
      }
      doc.moveDown();
    });
  } else {
    addSectionContent("No skill gap analysis data available");
  }

  // Training Activities
  addSectionHeader("Training Activities");
  if (data.training_activities.length > 0) {
    data.training_activities.forEach((activity) => {
      addSectionContent(`Title: ${activity.title || "N/A"}`);
      addSectionContent(
        `Expected Outcomes: ${activity.expected_outcomes || "N/A"}`
      );
      addSectionContent(
        `Progress Measurement: ${activity.progress_measurement || "N/A"}`
      );
      addSectionContent(`Duration: ${activity.duration || "N/A"}`);
      addSectionContent(
        `Date: ${new Date(activity.date).toLocaleDateString() || "N/A"}`
      );
      addSectionContent(`Responsible: ${activity.responsible || "N/A"}`);
      doc.moveDown();
    });
  } else {
    addSectionContent("No training activities data available");
  }

  // Career Path Progression Map
  addSectionHeader("Career Path Progression Map");
  if (data.career_path_progression_map.length > 0) {
    data.career_path_progression_map.forEach((path) => {
      addSectionContent(`Role: ${path.role || "N/A"}`);
      addSectionContent(`Suggested Timing: ${path.suggested_timing || "N/A"}`);
      doc.moveDown();
    });
  } else {
    addSectionContent("No career path progression data available");
  }

  // Action Plan Summary
  addSectionHeader("Action Plan Summary");
  if (data.action_plan_summary.length > 0) {
    data.action_plan_summary.forEach((action) => {
      addSectionContent(`Action: ${action.action || "N/A"}`);
      addSectionContent(`Responsibility: ${action.responsibility || "N/A"}`);
      doc.moveDown();
    });
  } else {
    addSectionContent("No action plan data available");
  }

  // Next Steps Recommendations
  addSectionHeader("Next Steps Recommendations");
  if (data.next_steps_recommendations.length > 0) {
    data.next_steps_recommendations.forEach((step) => {
      addSectionContent(`${step.recommendations || "N/A"}`, true);
      doc.moveDown(0.5);
    });
  } else {
    addSectionContent("No next steps recommendations available");
  }

  // Training Plan
  addSectionHeader("Training Plan");
  if (data.training_plan.length > 0) {
    data.training_plan.forEach((plan) => {
      addSectionContent(
        `Plan Recommendation: ${plan.plan_recommendation || "N/A"}`
      );
      doc.moveDown();
    });
  } else {
    addSectionContent("No training plan data available");
  }

  doc.moveDown(2);
  addSectionHeader("Signature");
  doc.fontSize(10).text("User Signature_________________________", {
    align: "left",
    continued: true,
  });
  doc.text("Supervisor Signature: _________________________", {
    align: "right",
  });

  return new Promise((resolve, reject) => {
    writeStream.on("finish", () => resolve(filePath));
    writeStream.on("error", reject);
    doc.end();
  });
}
export const generatePdfReport = async (req, res) => {
  try {
    const branchId = req.params.id;
    const userId = req.user.userId;

    if (!userId) {
      return res.status(400).json({ message: "User is not authenticated" });
    }

    const userQuery = `SELECT username, email FROM users WHERE id = ?;`;
    const userInfo = await new Promise((resolve, reject) => {
      pool.query(userQuery, [userId], (error, results) => {
        if (error) return reject(error);
        resolve(results[0]);
      });
    });

    // Step 1: Fetch training plan based on branch_id
    const trainingPlanQuery = `SELECT id, plan_recommendation FROM trainning_plan WHERE branch_id = ?;`;
    const trainingPlanResults = await new Promise((resolve, reject) => {
      pool.query(trainingPlanQuery, [branchId], (error, results) => {
        if (error) return reject(error);
        resolve(results);
      });
    });
    if (!trainingPlanResults.length) {
      return res
        .status(404)
        .json({ message: "No training plan found for this branch ID" });
    }

    const planId = trainingPlanResults[0].id;

    // Step 2: Fetch career goals overview based on plan_id
    const careerGoalsQuery = `SELECT title, type, completion_date FROM career_goals_overview WHERE plan_id = ?;`;
    const careerGoalsResults = await new Promise((resolve, reject) => {
      pool.query(careerGoalsQuery, [planId], (error, results) => {
        if (error) return reject(error);
        resolve(results);
      });
    });

    // Step 3: Fetch skill gap analysis based on plan_id
    const skillGapQuery = `SELECT id, title, priority, status FROM skill_gap_analysis WHERE plan_id = ?;`;
    const skillGapResults = await new Promise((resolve, reject) => {
      pool.query(skillGapQuery, [planId], (error, results) => {
        if (error) return reject(error);
        resolve(results);
      });
    });

    // Step 4: Fetch skill gap analysis resources based on skill_gap_analysis_id
    const skillGapResourceIds = skillGapResults.map((row) => row.id);
    let skillGapResourcesResults = [];

    if (skillGapResourceIds.length) {
      const skillGapResourcesQuery = `
        SELECT sgr.skill_gap_analysis_id, sgr.title, sgr.platform, sgr.link 
        FROM skill_gap_analysis_resources sgr
        WHERE sgr.skill_gap_analysis_id IN (?)
      `;
      skillGapResourcesResults = await new Promise((resolve, reject) => {
        pool.query(
          skillGapResourcesQuery,
          [skillGapResourceIds],
          (error, results) => {
            if (error) return reject(error);
            resolve(results);
          }
        );
      });
    }

    // Step 5: Fetch training activities based on plan_id
    const trainingActivitiesQuery = `SELECT title, expected_outcomes, progress_measurement, duration, date, responsible FROM training_activities WHERE plan_id = ?;`;
    const trainingActivitiesResults = await new Promise((resolve, reject) => {
      pool.query(trainingActivitiesQuery, [planId], (error, results) => {
        if (error) return reject(error);
        resolve(results);
      });
    });

    // Step 6: Fetch career path progression map based on plan_id
    const careerPathQuery = `SELECT role, suggested_timing FROM career_path_progression_map WHERE plan_id = ?;`;
    const careerPathResults = await new Promise((resolve, reject) => {
      pool.query(careerPathQuery, [planId], (error, results) => {
        if (error) return reject(error);
        resolve(results);
      });
    });

    // Step 7: Fetch action plan summary based on plan_id
    const actionPlanQuery = `SELECT action, responsiblity FROM action_plan_summary WHERE plan_id = ?;`;
    const actionPlanResults = await new Promise((resolve, reject) => {
      pool.query(actionPlanQuery, [planId], (error, results) => {
        if (error) return reject(error);
        resolve(results);
      });
    });

    // Step 8: Fetch next steps recommendations based on plan_id
    const nextStepsQuery = `SELECT recommendations FROM next_steps_recommendations WHERE plan_id = ?;`;
    const nextStepsResults = await new Promise((resolve, reject) => {
      pool.query(nextStepsQuery, [planId], (error, results) => {
        if (error) return reject(error);
        resolve(results);
      });
    });

    // Fetch Model Subscription Data
    const model_subscription = `SELECT payment_id, amount FROM model_subscription WHERE branch_id = ?;`;
    const modelSubscriptionResult = await new Promise((resolve, reject) => {
      pool.query(model_subscription, [branchId], (error, results) => {
        if (error) return reject(error);
        resolve(results);
      });
    });

    const data = {
      username: userInfo.username,
      email: userInfo.email,
      training_plan: trainingPlanResults.map((row) => ({
        id: row.id,
        plan_recommendation: row.plan_recommendation,
      })),
      career_goals_overview: careerGoalsResults.map((row) => ({
        title: row.title,
        type: row.type,
        completion_date: row.completion_date,
      })),
      skill_gap_analysis: skillGapResults.map((row) => ({
        id: row.id,
        title: row.title,
        priority: row.priority,
        status: row.status,
        resources: skillGapResourcesResults.filter(
          (resource) => resource.skill_gap_analysis_id === row.id
        ),
      })),
      training_activities: trainingActivitiesResults.map((row) => ({
        title: row.title,
        expected_outcomes: row.expected_outcomes,
        progress_measurement: row.progress_measurement,
        duration: row.duration,
        date: row.date,
        responsible: row.responsible,
      })),
      career_path_progression_map: careerPathResults.map((row) => ({
        role: row.role,
        suggested_timing: row.suggested_timing,
      })),
      model_subscription: modelSubscriptionResult.map((row) => ({
        payment_id: row.payment_id,
        amount: row.amount,
      })),
      action_plan_summary: actionPlanResults.map((row) => ({
        action: row.action,
        responsibility: row.responsiblity,
      })),
      next_steps_recommendations: nextStepsResults.map((row) => ({
        recommendations: row.recommendations,
      })),
    };

    const insert_into_activity_logs =
      "INSERT INTO activity_logs (name, user_id) VALUES (?,?)";

    const trainingPlanTitle = trainingPlanResults[0]?.plan_recommendation.slice(
      0,
      20
    );
    pool.query(
      insert_into_activity_logs,
      [`Created Training Plan: ${trainingPlanTitle}`, userId],
      (err) => {
        if (err) {
          console.log(err);
          return res.status(500).json({ error: "Internal Server Error" });
        }
      }
    );

    const updateSubscriptionQuery = `
    UPDATE user_subscription
    SET current_training_plan = COALESCE(current_training_plan, 0) + 1
    WHERE id = (
        SELECT id FROM (
            SELECT MAX(id) as id
            FROM user_subscription
            WHERE user_id = ?
            AND expiry_date > NOW()
        ) as latest_subscription
    );
    `;
    
    await new Promise((resolve, reject) => {
      pool.query(updateSubscriptionQuery, [userId], (error, results) => {
        if (error) return reject(error);
        resolve(results);
      });
    });
    
    const pdfPath = await generatePDF(data, branchId);

    const baseUrl = `${req.protocol}://${req.get("host")}`;
    const relativePath = path.relative(process.cwd(), pdfPath);
    const downloadUrl = `${baseUrl}/${relativePath.replace(/\\/g, "/")}`;

    res.download(pdfPath, `CareerDevelopmentPlan_${branchId}.pdf`, (err) => {
      if (err) {
        console.error("Error sending file:", err);
        res.status(500).send("Error downloading file");
      }
    });
  } catch (err) {
    console.error("Error generating PDF report:", err);
    res
      .status(500)
      .json({ message: "Error generating PDF report", error: err });
  }
};
