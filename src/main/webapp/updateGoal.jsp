<%@ page import="java.sql.*, db.DBConnection" %>
<%
    String userName = (String) session.getAttribute("userName");
    if (userName == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    int userId = (int) session.getAttribute("userId");
    int goalId = Integer.parseInt(request.getParameter("goalId"));

    String title = "";
    double targetAmount = 0;
    Date deadline = null;

    try (Connection conn = DBConnection.getConnection()) {
        String query = "SELECT * FROM goals WHERE id = ? AND user_id = ?";
        PreparedStatement ps = conn.prepareStatement(query);
        ps.setInt(1, goalId);
        ps.setInt(2, userId);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            title = rs.getString("title");
            targetAmount = rs.getDouble("target_amount");
            deadline = rs.getDate("target_date");
        } else {
            out.println("<p>Goal not found.</p>");
            return;
        }
    } catch (Exception e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Update Goal</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .container {
            width: 90%;
            max-width: 600px;
            margin: 40px auto;
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
            margin: 12px 0;
            border-radius: 8px;
            border: 1px solid #ccc;
            font-size: 16px;
        }
        button {
            background-color: #3498db;
            color: white;
            border: none;
            cursor: pointer;
        }
        button:hover {
            background-color: #2980b9;
        }
    </style>
</head>
<body>
    <%@ include file="navbar.jsp" %>
    <div class="container">
        <h2>Update Your Goal</h2>
        <form action="saveUpdatedGoal.jsp" method="post">
            <input type="hidden" name="goalId" value="<%= goalId %>">
            <input type="text" name="goalName" value="<%= title %>" placeholder="Goal Name" required>
            <input type="number" name="targetAmount" value="<%= targetAmount %>" placeholder="Target Amount" required>
            <input type="date" name="deadline" value="<%= deadline %>" required>
            <button type="submit">Save Changes</button>
        </form>
    </div>
</body>
</html>
