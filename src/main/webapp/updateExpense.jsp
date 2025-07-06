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
    int expenseId = Integer.parseInt(request.getParameter("id"));
    String category = "", description = "";
    double amount = 0;
    String expenseDate = "";

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        category = request.getParameter("category");
        amount = Double.parseDouble(request.getParameter("amount"));
        description = request.getParameter("description");
        expenseDate = request.getParameter("expense_date");

        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement("UPDATE expenses SET category=?, amount=?, description=?, expense_date=? WHERE id=? AND user_id=?");
            ps.setString(1, category);
            ps.setDouble(2, amount);
            ps.setString(3, description);
            ps.setString(4, expenseDate);
            ps.setInt(5, expenseId);
            ps.setInt(6, userId);

            int result = ps.executeUpdate();
            if (result > 0) {
                message = "Expense updated successfully!";
            } else {
                message = "Failed to update expense.";
            }
            ps.close();
            conn.close();
            response.sendRedirect("viewExpenses.jsp");

        } catch (Exception e) {
            message = "Error: " + e.getMessage();
        }
    } else {
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement("SELECT * FROM expenses WHERE id=? AND user_id=?");
            ps.setInt(1, expenseId);
            ps.setInt(2, userId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                category = rs.getString("category");
                amount = rs.getDouble("amount");
                description = rs.getString("description");
                expenseDate = rs.getString("expense_date");
            }

            rs.close();
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
    <title>Update Expense</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
<jsp:include page="navbar.jsp" />

<div class="main-content">
    <h1>Update Expense</h1>
    <% if (!message.isEmpty()) { %>
        <p style="color: green;"><%= message %></p>
    <% } %>

    <form method="post" class="form-box">
        <label>Category:</label>
        <select name="category" required>
            <option value="Food" <%= category.equals("Food") ? "selected" : "" %>>Food</option>
            <option value="Travel" <%= category.equals("Travel") ? "selected" : "" %>>Travel</option>
            <option value="Shopping" <%= category.equals("Shopping") ? "selected" : "" %>>Shopping</option>
            <option value="Bills" <%= category.equals("Bills") ? "selected" : "" %>>Bills</option>
            <option value="Others" <%= category.equals("Others") ? "selected" : "" %>>Others</option>
        </select>

        <label>Amount (₹):</label>
        <input type="number" name="amount" step="0.01" value="<%= amount %>" required>

        <label>Description:</label>
        <input type="text" name="description" value="<%= description %>">

        <label>Date:</label>
        <input type="date" name="expense_date" value="<%= expenseDate %>" required>

        <input type="submit" value="Update Expense">

    </form>

</div>
</body>
</html>
