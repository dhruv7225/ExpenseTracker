<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, db.DBConnection" %>
<%
    String userName = (String) session.getAttribute("userName");
    if (userName == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    int userId = (int) session.getAttribute("userId");
    String fName = "";
    String email = "";
    Date registrationDate = null;
    double totalIncome = 0, totalExpense = 0, currentBalance = 0;
    int activeGoalsCount = 0;
    double totalTargetAmount = 0, totalSavedAmount = 0;

    // Fetch user information
    try (Connection conn = DBConnection.getConnection()) {
        String userQuery = "SELECT name, email FROM users WHERE id = ?";
        PreparedStatement ps1 = conn.prepareStatement(userQuery);
        ps1.setInt(1, userId);
        ResultSet rs1 = ps1.executeQuery();
        if (rs1.next()) {
            fName = rs1.getString("name");
            email = rs1.getString("email");

        }

        // Fetch total income
        String incomeQuery = "SELECT SUM(amount) AS total_income FROM income WHERE user_id = ?";
        PreparedStatement incomeStmt = conn.prepareStatement(incomeQuery);
        incomeStmt.setInt(1, userId);
        ResultSet incomeRs = incomeStmt.executeQuery();
        if (incomeRs.next()) {
            totalIncome = incomeRs.getDouble("total_income");
        }

        // Fetch total expense
        String expenseQuery = "SELECT SUM(amount) AS total_expense FROM expenses WHERE user_id = ?";
        PreparedStatement expenseStmt = conn.prepareStatement(expenseQuery);
        expenseStmt.setInt(1, userId);
        ResultSet expenseRs = expenseStmt.executeQuery();
        if (expenseRs.next()) {
            totalExpense = expenseRs.getDouble("total_expense");
        }

        currentBalance = totalIncome - totalExpense;

        // Fetch active goals count and their target amount
        String goalsQuery = "SELECT * FROM goals WHERE user_id = ? AND target_amount > 0";
        PreparedStatement goalsStmt = conn.prepareStatement(goalsQuery);
        goalsStmt.setInt(1, userId);
        ResultSet goalsRs = goalsStmt.executeQuery();
        while (goalsRs.next()) {
            activeGoalsCount++;
            totalTargetAmount += goalsRs.getDouble("target_amount");
        }
        totalSavedAmount = currentBalance;

    } catch (Exception e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
    }
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>User Profile</title>
        <link rel="stylesheet" href="css/style.css">
        <style>
            /*            body {
                            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                            background: #f8f9fa;
                            margin: 0;
                            padding: 0;
                        }*/

            .main-content {
                max-width: 800px;
                margin: auto;
                background: #fff;
                padding: 40px;
                box-shadow: 0 6px 18px rgba(0, 0, 0, 0.1);
                border-radius: 16px;
            }

            h1 {
                text-align: center;
                color: #343a40;
                font-size: 32px;
            }

            .section {
                margin-bottom: 30px;
            }

            .section h3 {
                font-size: 24px;
                color: #007bff;
            }

            .section p {
                font-size: 16px;
                margin: 5px 0;
            }

            .section .highlight {
                font-size: 18px;
                font-weight: bold;
                color: #28a745;
            }

            .progress-bar {
                height: 10px;
                background-color: #e0e0e0;
                border-radius: 5px;
                margin-top: 10px;
            }

            .progress-bar > div {
                height: 100%;
                background-color: #28a745;
                border-radius: 5px;
            }

            .actions {
                text-align: center;
            }

            .actions button {
                background-color: #007bff;
                color: white;
                padding: 12px 24px;
                border: none;
                border-radius: 8px;
                font-size: 16px;
                cursor: pointer;
                transition: background-color 0.3s ease;
                margin: 10px 0;
            }

            .actions button:hover {
                background-color: #0056b3;
            }

            .actions .logout {
                background-color: #e74c3c;
            }

            .actions .logout:hover {
                background-color: #c0392b;
            }

            .stats-grid {
                display: grid;
                grid-template-columns: repeat(2, 1fr);
                gap: 20px;
            }

            .stat-box {
                background-color: #f4f7f9;
                padding: 20px;
                border-radius: 10px;
                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
                text-align: center;
            }

            .stat-box h4 {
                color: #007bff;
            }

            .stat-box p {
                font-size: 18px;
                color: #333;
            }
        </style>
    </head>
    <body>
        <jsp:include page="navbar.jsp" />
        <div class="main-content">
            <h1>Your Profile</h1>

            <!-- User Information Section -->
            <div class="section">
                <h3>Personal Information</h3>
                <p><strong>Name:</strong> <%= fName%></p>
                <p><strong>Email:</strong> <%= email%></p>
            </div>

            <!-- Financial Summary Section -->
            <div class="section">
                <h3>Financial Summary</h3>
                <div class="stats-grid">
                    <div class="stat-box">
                        <h4>Total Income</h4>
                        <p class="highlight">₹<%= totalIncome%></p>
                    </div>
                    <div class="stat-box">
                        <h4>Total Expenses</h4>
                        <p class="highlight">₹<%= totalExpense%></p>
                    </div>
                    <div class="stat-box">
                        <h4>Current Balance</h4>
                        <p class="highlight">₹<%= currentBalance%></p>
                    </div>
                    <div class="stat-box">
                        <h4>Active Goals</h4>
                        <p class="highlight"><%= activeGoalsCount%> goals</p>
                    </div>
                </div>
            </div>

            <!-- Goals Overview Section -->
            <div class="section">
                <h3>Goals Overview</h3>
                <p><strong>Total Target Amount:</strong> ₹<%= totalTargetAmount%></p>
                <p><strong>Total Saved Amount:</strong> ₹<%= totalSavedAmount%></p>

                <p><strong>Overall Progress:</strong></p>
                <div class="progress-bar">
                    <div style="width: <%= totalTargetAmount == 0 ? 0 : (totalSavedAmount / totalTargetAmount) * 100%>%;"></div>
                </div>
                <p>
                    <%= totalTargetAmount == 0 ? "0%" : String.format("%.2f", (totalSavedAmount / totalTargetAmount) * 100) + "%"%>
                </p>

            </div>

            <!-- Settings Section -->
            <div class="section actions">
                <h3>Settings</h3>
                <form action="changePassword.jsp" method="post">
                    <button type="submit">Change Password</button>
                </form>
                <form action="logout.jsp" method="post">
                    <button type="submit" class="logout">Logout</button>
                </form>
            </div>
        </div>



    </body>
</html>
