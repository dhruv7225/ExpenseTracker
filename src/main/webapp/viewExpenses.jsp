<%@ page import="java.sql.*, db.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--<%@page import="/Users/dhruv/NetBeansProjects/expense/src/main/webapp/navbar.jsp" %>--%>
<%
    String userName = (String) session.getAttribute("userName");
    if (userName == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int userId = (int) session.getAttribute("userId");
%>
<!DOCTYPE html>
<html>
    <head>
        <title>View Expenses</title>
        <link rel="stylesheet" href="css/style.css">
        <style>
            body {
                margin: 0;
                font-family: 'Segoe UI', sans-serif;
                background: #f4f6f8;
            }

            .main-content {
                margin-left: 280px;
                padding: 30px;
            }

            h1 {
                text-align: center;
                color: black;
                margin-bottom: 30px;
                margin-right: 80px; 
            }

            .form-box {
                background: #fff;
                padding: 20px;
                max-width: 500px;
                border-radius: 10px;
                box-shadow: 0 2px 6px rgba(0,0,0,0.1);
            }

            .form-box label {
                display: block;
                margin-top: 12px;
                font-weight: bold;
            }

            .form-box input, .form-box select {
                width: 100%;
                padding: 8px;
                margin-top: 6px;
                border-radius: 5px;
                border: 1px solid #ccc;
            }

            .form-box input[type="submit"] {
                margin-top: 20px;
                background: #2980b9;
                color: #fff;
                border: none;
                cursor: pointer;
                font-weight: bold;
            }

            .form-box input[type="submit"]:hover {
                background: #3498db;
            }

            .message {
                background: #dff0d8;
                color: #3c763d;
                padding: 10px;
                margin-bottom: 15px;
                border-radius: 5px;
            }

            table {
                width: 100%;
                background: #fff;
                border-collapse: collapse;
                margin-top: 20px;
                border-radius: 10px;
                overflow: hidden;
            }

            table th, table td {
                padding: 12px;
                border-bottom: 1px solid #ddd;
                text-align: left;
            }

            table th {
                background: #ecf0f1;
            }

        </style>
    </head>
    <body>
        <jsp:include page="navbar.jsp" />


        <div class="main-content">
            <h1>Expenses</h1>
            <table>
                <thead>
                    <tr>
                        <th>Category</th>
                        <th>Amount (₹)</th>
                        <th>Description</th>
                        <th>Date</th>
                        <th>Actions</th> <!-- Added column for Update/Delete -->
                    </tr>
                </thead>
                <tbody>
                    <%
                        try {
                            Connection conn = DBConnection.getConnection();
                            PreparedStatement ps = conn.prepareStatement("SELECT id, category, amount, description, expense_date FROM expenses WHERE user_id = ? ORDER BY expense_date DESC");
                            ps.setInt(1, userId);
                            ResultSet rs = ps.executeQuery();

                            while (rs.next()) {
                                int expenseId = rs.getInt("id");
                    %>
                    <tr>
                        <td><%= rs.getString("category")%></td>
                        <td>₹<%= rs.getDouble("amount")%></td>
                        <td><%= rs.getString("description")%></td>
                        <td><%= rs.getDate("expense_date")%></td>
                        <td>
                            <form action="updateExpense.jsp" method="get" style="display:inline;">
                                <input type="hidden" name="id" value="<%= expenseId%>">
                                <input type="submit" value="Update" style="background:#27ae60; color:white; border:none; padding:5px 10px; border-radius:5px;">
                            </form>
                            <form action="deleteExpense.jsp" method="post" style="display:inline;">
                                <input type="hidden" name="id" value="<%= expenseId%>">
                                <input type="submit" value="Delete" style="background:#c0392b; color:white; border:none; padding:5px 10px; border-radius:5px;" onclick="return confirm('Are you sure you want to delete this expense?');">
                            </form>
                        </td>
                    </tr>
                    <%
                        }
                        rs.close();
                        ps.close();
                        conn.close();
                    } catch (Exception e) {
                    %>
                    <tr><td colspan="5">Error: <%= e.getMessage()%></td></tr>
                    <%
                        }
                    %>
                </tbody>
            </table>

        </div>

    </body>
</html>
