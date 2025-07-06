<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, db.DBConnection" %>
<%
    int userId = (int) session.getAttribute("userId");
    String currentPassword = "";
    String newPassword = "";
    String confirmPassword = "";
    String message = "";
    
    if (request.getMethod().equalsIgnoreCase("POST")) {
        currentPassword = request.getParameter("currentPassword");
        newPassword = request.getParameter("newPassword");
        confirmPassword = request.getParameter("confirmPassword");

        // Check if passwords are null or empty
        if (newPassword == null || confirmPassword == null || newPassword.isEmpty() || confirmPassword.isEmpty()) {
            message = "New password and confirm password cannot be empty!";
        } else {
            // Validate inputs and check if passwords match
            if (newPassword.equals(confirmPassword)) {
                try (Connection conn = DBConnection.getConnection()) {
                    String query = "SELECT password FROM users WHERE id = ?";
                    PreparedStatement ps = conn.prepareStatement(query);
                    ps.setInt(1, userId);
                    ResultSet rs = ps.executeQuery();
                    
                    if (rs.next()) {
                        String storedPassword = rs.getString("password");

                        if (storedPassword.equals(currentPassword)) {
                            // Update password
                            String updateQuery = "UPDATE users SET password = ? WHERE id = ?";
                            PreparedStatement updatePs = conn.prepareStatement(updateQuery);
                            updatePs.setString(1, newPassword);
                            updatePs.setInt(2, userId);
                            int rowsUpdated = updatePs.executeUpdate();
                            
                            if (rowsUpdated > 0) {
                                message = "Password updated successfully!";
                            } else {
                                message = "Error updating password!";
                            }
                        } else {
                            message = "Current password is incorrect!";
                        }
                    }
                } catch (Exception e) {
                    message = "Error: " + e.getMessage();
                }
            } else {
                message = "New password and confirm password do not match!";
            }
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Change Password</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f8f9fa;
            margin: 0;
            padding: 0;
        }

        .main-content {
            max-width: 600px;
            margin: 80px auto;
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

        .form-group {
            margin-bottom: 20px;
        }

        label {
            font-weight: bold;
            font-size: 16px;
            color: #343a40;
        }

        input {
            width: 100%;
            padding: 12px;
            margin-top: 5px;
            border: 1px solid #ced4da;
            border-radius: 8px;
            font-size: 16px;
        }

        button {
            width: 100%;
            padding: 12px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        button:hover {
            background-color: #0056b3;
        }

        .message {
            text-align: center;
            font-size: 16px;
            margin-top: 20px;
            font-weight: bold;
        }

        .message.success {
            color: green;
        }

        .message.error {
            color: red;
        }

        .back-link {
            text-align: center;
            margin-top: 30px;
        }

        .back-link a {
            color: #007bff;
            text-decoration: none;
        }

        .back-link a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <%@ include file="navbar.jsp" %>

    <div class="main-content">
        <h1>Change Your Password</h1>
        
        <!-- Display any messages after form submission -->
        <div class="message <%= message.equals("Password updated successfully!") ? "success" : "error" %>">
            <%= message %>
        </div>

        <form method="post" action="changePassword.jsp">
            <div class="form-group">
                <label for="currentPassword">Current Password</label>
                <input type="password" id="currentPassword" name="currentPassword" required>
            </div>

            <div class="form-group">
                <label for="newPassword">New Password</label>
                <input type="password" id="newPassword" name="newPassword" required>
            </div>

            <div class="form-group">
                <label for="confirmPassword">Confirm New Password</label>
                <input type="password" id="confirmPassword" name="confirmPassword" required>
            </div>

            <button type="submit">Update Password</button>
        </form>

        <div class="back-link">
            <a href="profile.jsp">Back to Profile</a>
        </div>
    </div>

</body>
</html>
