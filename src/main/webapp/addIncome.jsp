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
        String source = request.getParameter("source");
        String amountStr = request.getParameter("amount");
        String description = request.getParameter("description");
        String incomeDate = request.getParameter("income_date");

        try {
            double amount = Double.parseDouble(amountStr);

            // Insert income data into the database
            Connection conn = DBConnection.getConnection();
            String sql = "INSERT INTO income (user_id, source, amount, income_date, description) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setString(2, source);
            ps.setDouble(3, amount);
            ps.setString(4, incomeDate);
            ps.setString(5, description);
            int result = ps.executeUpdate();

            if (result > 0) {
                message = "Income added successfully!";
            } else {
                message = "Failed to add income.";
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
        <title>Add Income</title>
        <link rel="stylesheet" href="css/style.css">
        <style>
            /* Global Styles */
            body {
                font-family: 'Arial', sans-serif;
                margin: 0;
                padding: 0;
                background-color: #f4f6f9;
                color: #333;
            }

            h1 {
                text-align: center;
                color: black;
                margin-bottom: 30px;
            }



            .main-content {
                max-width: 600px;
                margin: 40px auto;
                background: #fff;
                padding: 30px 50px;
                border-radius: 12px;
                box-shadow: 0 8px 16px rgba(0,0,0,0.1);
            }

            /* Form Styling */
/*            .form-box {
                width: 100%;
                max-width: 500px;
                margin: 0 auto;
                padding: 20px;
                background-color: #fff;
                border-radius: 8px;
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            }*/

            .form-box label {
                font-size: 16px;
                margin-bottom: 10px;
                display: block;
                color: #555;
            }

            .form-box input[type="text"],
            .form-box input[type="number"],
            .form-box input[type="date"] {
                width: 100%;
                padding: 12px;
                margin-bottom: 15px;
                border: 1px solid #ccc;
                border-radius: 6px;
                box-sizing: border-box;
                font-size: 14px;
            }

            .form-box input[type="submit"] {
                width: 100%;
                padding: 12px;
                background-color: #4CAF50;
                color: white;
                border: none;
                border-radius: 6px;
                cursor: pointer;
                font-size: 16px;
                transition: background-color 0.3s;
            }

            .form-box input[type="submit"]:hover {
                background-color: #45a049;
            }

            /* Success/Error Messages */
            p {
                text-align: center;
                font-size: 16px;
                color: green;
            }

            p.error {
                color: red;
            }

        </style>

    </head>
    <body>

        <jsp:include page="navbar.jsp" />

        <div class="main-content" >
            <h1>Add Income</h1>

            <% if (!message.isEmpty()) {%>
            <p style="color: green;"><%= message%></p>
            <% }%>

            <form method="post" class="form-box">
                <label>Source:</label>
                <input type="text" name="source" required>

                <label>Amount (₹):</label>
                <input type="number" step="0.01" name="amount" required>

                <label>Description:</label>
                <input type="text" name="description" placeholder="Optional">

                <label>Date:</label>
                <input type="date" name="income_date" required>

                <input type="submit" value="Add Income">
            </form>
        </div>

    </body>
</html>
