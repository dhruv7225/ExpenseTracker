<%@ page import="java.sql.*, db.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String userName = (String) session.getAttribute("userName");
    if (userName == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int userId = (int) session.getAttribute("userId");
    String message = "";

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String category = request.getParameter("category");
        String amountStr = request.getParameter("amount");
        String description = request.getParameter("description");
        String expenseDate = request.getParameter("expense_date");

        try {
            double amount = Double.parseDouble(amountStr);

            Connection conn = DBConnection.getConnection();
            String sql = "INSERT INTO expenses (user_id, category, amount, expense_date, description) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setString(2, category);
            ps.setDouble(3, amount);
            ps.setString(4, expenseDate);
            ps.setString(5, description);
            int result = ps.executeUpdate();

            if (result > 0) {
                message = "Expense added successfully!";
            } else {
                message = "Failed to add expense.";
            }

            ps.close();
            conn.close();
        } catch (Exception e) {
            message = "Error: " + e.getMessage();
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Add Expense</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins&display=swap" rel="stylesheet">
    <<link rel="stylesheet" href="css/style.css"/>
    <style>
/*        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f0f4f8;
            margin: 0;
            padding: 0;
        }*/

        .main-content {
            max-width: 600px;
            margin: 40px auto;
            background: #fff;
            padding: 30px 50px;
            border-radius: 12px;
            box-shadow: 0 8px 16px rgba(0,0,0,0.1);
        }

        h1 {
            text-align: center;
            margin-bottom: 25px;
            color: #333;
        }

        .form-box label {
            display: block;
            margin-bottom: 8px;
            color: #444;
            font-weight: 500;
        }

        .form-box input,
        .form-box select {
            width: 100%;
            padding: 10px 12px;
            margin-bottom: 20px;
            border: 1px solid #ccc;
            border-radius: 8px;
            font-size: 14px;
        }

        .form-box input[type="submit"] {
            background-color: #4CAF50;
            color: white;
            border: none;
            cursor: pointer;
            font-weight: bold;
            transition: background-color 0.3s ease;
        }

        .form-box input[type="submit"]:hover {
            background-color: #45a049;
        }

        p {
            text-align: center;
            font-weight: bold;
        }
    </style>
</head>
<body>

<jsp:include page="navbar.jsp" />

<div class="main-content">
    <h1>Add Expense</h1>

    <% if (!message.isEmpty()) { %>
        <p style="color: green;"><%= message %></p>
    <% } %>

    <form method="post" class="form-box">
        <label>Category:</label>
        <select name="category" required>
            <option value="">--Select--</option>
            <option value="Food">Food</option>
            <option value="Travel">Travel</option>
            <option value="Shopping">Shopping</option>
            <option value="Bills">Bills</option>
            <option value="Others">Others</option>
        </select>

        <label>Amount (₹):</label>
        <input type="number" step="0.01" name="amount" required>

        <label>Description:</label>
        <input type="text" name="description" placeholder="Optional">

        <label>Date:</label>
        <input type="date" name="expense_date" required>

        <input type="submit" value="Add Expense">
    </form>
</div>

</body>
</html>
