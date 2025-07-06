<%@ page import="java.sql.*, db.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String message = "";
    if(request.getMethod().equalsIgnoreCase("POST")) {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement check = conn.prepareStatement("SELECT * FROM users WHERE email=?");
            check.setString(1, email);
            ResultSet rs = check.executeQuery();

            if (rs.next()) {
                message = "Email already registered!";
            } else {
                PreparedStatement ps = conn.prepareStatement("INSERT INTO users (name, email, password) VALUES (?, ?, ?)");
                ps.setString(1, name);
                ps.setString(2, email);
                ps.setString(3, password); // You can hash this later
                ps.executeUpdate();
                message = "Registration successful! <a href='login.jsp'>Login here</a>";
            }
        } catch(Exception e) {
            message = "Database error: " + e.getMessage();
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Register - Expense Tracker</title>
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

        .register-box {
            background: #fff;
            margin-top: 40px;
            padding: 30px 40px;
            width: 100%;
            max-width: 400px;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }

        .register-box h2 {
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

        input[type="text"],
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
            text-align: center;
            color: green;
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

    <div class="register-box">
        <h2>Register</h2>
        <form method="post">
            <label for="name">Name</label>
            <input type="text" name="name" id="name" required>

            <label for="email">Email</label>
            <input type="email" name="email" id="email" required>

            <label for="password">Password</label>
            <input type="password" name="password" id="password" required>

            <button type="submit">Register</button>
        </form>
        <div class="message"><%= message %></div>
        <div class="link-box">
            <p>Already have an account? <a href="login.jsp">Login</a></p>
        </div>
    </div>
</body>
</html>
