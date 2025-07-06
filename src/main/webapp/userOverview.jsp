<%@ page import="java.sql.*, java.util.*, db.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>User Overview</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f5f6fa;
            margin: 0;
            padding: 0;
        }
        .container {
            margin-left: 250px;
            padding: 30px;
        }
        h1 {
            text-align: center;
            color: #2f3542;
        }
        .card-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
            margin-top: 30px;
        }
        .user-card {
            background-color: white;
            padding: 20px;
            border-radius: 15px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            transition: 0.3s ease-in-out;
        }
        .user-card:hover {
            transform: scale(1.02);
            box-shadow: 0 6px 15px rgba(0,0,0,0.15);
        }
        .user-card h3 {
            margin: 0;
            font-size: 22px;
            color: #3742fa;
        }
        .user-card p {
            margin: 5px 0;
            color: #57606f;
        }
        .summary {
            font-weight: bold;
            color: #2ed573;
        }
    </style>
</head>
<body>

<jsp:include page="navbar.jsp" />

<div class="container">
    <h1>User Financial Overview</h1>

    <div class="card-grid">
        <%
            try {
                Connection conn = DBConnection.getConnection();

                PreparedStatement userStmt = conn.prepareStatement("SELECT id, name, email FROM users");
                ResultSet usersRs = userStmt.executeQuery();

                while (usersRs.next()) {
                    int uid = usersRs.getInt("id");
                    String name = usersRs.getString("name");
                    String email = usersRs.getString("email");

                    double income = 0, expense = 0;

                    PreparedStatement incStmt = conn.prepareStatement("SELECT SUM(amount) FROM income WHERE user_id=?");
                    incStmt.setInt(1, uid);
                    ResultSet incRs = incStmt.executeQuery();
                    if (incRs.next()) income = incRs.getDouble(1);

                    PreparedStatement expStmt = conn.prepareStatement("SELECT SUM(amount) FROM expenses WHERE user_id=?");
                    expStmt.setInt(1, uid);
                    ResultSet expRs = expStmt.executeQuery();
                    if (expRs.next()) expense = expRs.getDouble(1);
        %>
        <div class="user-card">
            <h3><%= name %></h3>
            <p>Email: <%= email %></p>
            <p class="summary">Total Income: ₹<%= String.format("%.2f", income) %></p>
            <p class="summary" style="color: #e74c3c;">Total Expenses: ₹<%= String.format("%.2f", expense) %></p>
            <p class="summary" style="color: #1e90ff;">Balance: ₹<%= String.format("%.2f", income - expense) %></p>
        </div>
        <%
                }
                conn.close();
            } catch (Exception e) {
                out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
            }
        %>
    </div>
</div>

</body>
</html>
