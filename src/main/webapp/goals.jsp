<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, db.DBConnection" %>
<%--<%@ page session="true" %>--%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Financial Goals</title>
        <link rel="stylesheet" href="css/style.css">
        <style>
            .container {
                width: 90%;
                max-width: 800px;
                margin: 30px auto;
                background: #fff;
                padding: 40px;
                border-radius: 12px;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            }
            h2 {
                text-align: center;
                color: #2c3e50;
            }
            input, button {
                width: 100%;
                padding: 10px;
                margin: 10px 0;
                border-radius: 8px;
                border: 1px solid #ccc;
            }
            button {
                background-color: #3498db;
                color: white;
                border: none;
                cursor: pointer;
            }
            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 20px;
            }
            th, td {
                padding: 12px;
                border: 1px solid #ddd;
                text-align: center;
            }
            th {
                background-color: #f1f1f1;
            }
            .progress-bar {
                height: 20px;
                background-color: #e0e0e0;
                border-radius: 10px;
                overflow: hidden;
                margin-bottom: 5px;
            }
            .progress-bar > div {
                height: 100%;
                background-color: #2ecc71;
            }
            .actions button {
                width: auto;
                padding: 6px 12px;
                margin: 0 5px;
                font-size: 14px;
            }
        </style>
    </head>
    <body>
        <%@ include file="navbar.jsp" %>
        <div class="container">
            <h2>Set Your Financial Goals</h2>
            <form method="post">
                <input type="text" name="goalName" placeholder="Goal Name" required>
                <input type="number" name="targetAmount" placeholder="Target Amount" required>
                <input type="date" name="deadline" required>
                <button type="submit">Add Goal</button>
            </form>

            <hr>
            <h3>Your Goals</h3>

            <%
                String userName = (String) session.getAttribute("userName");
                if (userName == null) {
                    response.sendRedirect("login.jsp");
                    return;
                }
                // Add goal logic
                if (request.getMethod().equalsIgnoreCase("POST")) {
                    // Get form data
                    String goalName = request.getParameter("goalName");
                    double targetAmount = Double.parseDouble(request.getParameter("targetAmount"));
                    String deadline = request.getParameter("deadline");

                    int userId = (int) session.getAttribute("userId");
                    if (userId != 0) {
                        try (Connection conn = DBConnection.getConnection()) {
                            // Insert the new goal into the database
                            String insertQuery = "INSERT INTO goals (user_id, title, target_amount, saved_amount, target_date) VALUES (?, ?, ?, 0, ?)";
                            PreparedStatement ps = conn.prepareStatement(insertQuery);
                            ps.setInt(1, userId);
                            ps.setString(2, goalName);
                            ps.setDouble(3, targetAmount);
                            ps.setString(4, deadline);
                            int rowsAffected = ps.executeUpdate();

                            if (rowsAffected > 0) {
                                out.println("<p>Goal added successfully!</p>");
                            }
                        } catch (Exception e) {
                            out.println("<p>Error adding goal: " + e.getMessage() + "</p>");
                        }
                    }
                }

                // Fetch goals from the database
                int userId = (int) session.getAttribute("userId");
                if (userId == 0) {
                    out.println("<p>You need to log in to view your goals.</p>");
                    return;
                }

                try (Connection conn = DBConnection.getConnection()) {
                    // Query to fetch goals for the user
                    String query = "SELECT * FROM goals WHERE user_id = ?";
                    PreparedStatement ps2 = conn.prepareStatement(query);
                    ps2.setInt(1, userId);
                    ResultSet rs2 = ps2.executeQuery();

                    if (!rs2.next()) {
                        out.println("<p>You don't have any goals yet.</p>");
                    } else {
            %>

            <table>
                <tr>
                    <th>Name</th>
                    <th>Target (₹)</th>
                    <th>Saved (₹)</th>
                    <th>Progress</th>
                    <th>Deadline</th>
                    <th>Actions</th>
                </tr>

                <%
                    do {
                %>
                <tr>
                    <td><%= rs2.getString("title")%></td>
                    <td><%= rs2.getDouble("target_amount")%></td>
                    <td><%
                        // Fetch total income
                        String incomeQuery = "SELECT SUM(amount) AS total_income FROM income WHERE user_id = ?";
                        PreparedStatement incomeStmt = conn.prepareStatement(incomeQuery);
                        incomeStmt.setInt(1, userId);
                        ResultSet incomeRs = incomeStmt.executeQuery();
                        double totalIncome = 0;
                        if (incomeRs.next()) {
                            totalIncome = incomeRs.getDouble("total_income");
                        }

                        // Fetch total expense
                        String expenseQuery = "SELECT SUM(amount) AS total_expense FROM expenses WHERE user_id = ?";
                        PreparedStatement expenseStmt = conn.prepareStatement(expenseQuery);
                        expenseStmt.setInt(1, userId);
                        ResultSet expenseRs = expenseStmt.executeQuery();
                        double totalExpense = 0;
                        if (expenseRs.next()) {
                            totalExpense = expenseRs.getDouble("total_expense");
                        }

                        double availableSavings = totalIncome - totalExpense;
                        %>
                        <%= availableSavings%></td>
                    <td>
                        <%
                            double target = rs2.getDouble("target_amount");
                            double progressPercent = (availableSavings > 0) ? Math.min((availableSavings / target) * 100, 100) : 0;
                        %>
                        <div class="progress-bar">
                            <div style="width: <%= progressPercent%>%;"></div>
                        </div>

                        <div>
                            <%= String.format("%.2f", progressPercent) + " %"%>
                        </div>
                    </td>
                    <td><%= rs2.getDate("target_date")%></td>
                    <td class="actions">
                        <form action="updateGoal.jsp" method="post" style="display:inline;">
                            <input type="hidden" name="goalId" value="<%= rs2.getInt("id")%>">
                            <button type="submit">Update</button>
                        </form>
                        <form action="deleteGoal.jsp" method="post" style="display:inline;">
                            <input type="hidden" name="goalId" value="<%= rs2.getInt("id")%>">
                            <button type="submit" style="background-color:#e74c3c;">Delete</button>
                        </form>
                    </td>
                </tr>
                <%
                    } while (rs2.next());
                %>
            </table>

            <%
                    }
                } catch (Exception e) {
                    out.println("<p>Error fetching goals: " + e.getMessage() + "</p>");
                }
            %>
        </div>
    </body>
</html>
