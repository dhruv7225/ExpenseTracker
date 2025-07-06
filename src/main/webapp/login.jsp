<%@ page import="java.sql.*, db.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String message = "";
    if(request.getMethod().equalsIgnoreCase("POST")) {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try (Connection conn = DBConnection.getConnection()) {
            String query = "SELECT * FROM users WHERE email=? AND password=?";
            PreparedStatement ps = conn.prepareStatement(query);
            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                session.setAttribute("userId", rs.getInt("id"));
                session.setAttribute("userName", rs.getString("name"));
                session.setAttribute("email", rs.getString("email"));
                session.setAttribute("pwd", rs.getString("password"));
                response.sendRedirect("dashboard.jsp");
            } else {
                message = "Invalid email or password!";
            }
        } catch(Exception e) {
            message = "Database error: " + e.getMessage();
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Login - Expense Tracker</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', sans-serif;
            background: #f4f6f8;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .header {
            margin-top: 50px;
            font-size: 36px;
            font-weight: bold;
            color: #2c3e50;
        }

        .login-box {
            background: #fff;
            margin-top: 40px;
            padding: 30px 40px;
            width: 100%;
            max-width: 400px;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }

        .login-box h2 {
            margin-bottom: 20px;
            font-size: 24px;
            color: #34495e;
            text-align: center;
        }

        label {
            display: block;
            margin: 12px 0 6px;
            font-weight: 500;
            color: #555;
        }

        input[type="email"],
        input[type="password"] {
            width: 100%;
            padding: 10px;
            border-radius: 8px;
            border: 1px solid #ccc;
            font-size: 15px;
            box-sizing: border-box;
        }

        button {
            width: 100%;
            padding: 12px;
            margin-top: 20px;
            background-color: #2980b9;
            border: none;
            color: white;
            font-size: 16px;
            font-weight: 600;
            border-radius: 8px;
            cursor: pointer;
        }

        button:hover {
            background-color: #3498db;
        }

        .message {
            margin-top: 15px;
            color: red;
            text-align: center;
        }

        .link-box {
            text-align: center;
            margin-top: 10px;
        }

        .link-box a {
            color: #2980b9;
            text-decoration: none;
            font-size: 14px;
        }

        .link-box a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="header">Expense Tracker</div>

    <div class="login-box">
        <h2>Login</h2>
        <form method="post">
            <label for="email">Email</label>
            <input type="email" name="email" id="email" required>

            <label for="password">Password</label>
            <input type="password" name="password" id="password" required>

            <button type="submit">Login</button>
        </form>
        <div class="message"><%= message %></div>
        <div class="link-box">
            <p>Don't have an account? <a href="register.jsp">Register</a></p>
        </div>
    </div>
</body>
</html>
