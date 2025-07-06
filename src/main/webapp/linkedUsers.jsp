<%@ page import="java.sql.*, db.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String userName = (String) session.getAttribute("userName");
    if (userName == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int userId = (int) session.getAttribute("userId");
    String message = request.getParameter("message");
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Link Another User</title>
        <link rel="stylesheet" href="css/style.css">
        <style>
            body {
                /*margin: 0;*/
                font-family: 'Segoe UI', sans-serif;
                background: #f4f6f8;
            }
            .main-content {
                margin-left: 280px;
                padding: 30px;
            }
            .form-box {
                background: #fff;
                padding: 20px;
                max-width: 500px;
                border-radius: 10px;
                box-shadow: 0 2px 6px rgba(0,0,0,0.1);
                padding: 35px;
            }
            .form-box label {
                display: block;
                margin-top: 12px;
                font-weight: bold;
            }
            .form-box input {
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
            .linked-users {
                display: flex;
                flex-wrap: wrap;
                gap: 20px;
                margin-top: 20px;
            }
            .user-card {
                background: #fff;
                padding: 20px;
                border-radius: 10px;
                box-shadow: 0 2px 6px rgba(0,0,0,0.1);
                cursor: pointer;
                width: 200px;
                text-align: center;
            }
            .user-card:hover {
                background-color: #f0f4f7;
            }
            .user-card h4 {
                margin-bottom: 10px;
            }
        </style>
    </head>
    <body>
        <jsp:include page="navbar.jsp" />
        <div class="main-content">
            <h1>Link Another User</h1>

            <% if (message != null) {%>
            <div style="color: red;"><%= message%></div>
            <% } %>

            <div class="form-box">
                <form method="POST">
                    <label for="email">Enter User's Email:</label>
                    <input type="email" name="email" id="email" required>
                    <label for="password">Enter User's Password:</label>
                    <input type="password" name="password" id="password" required>
                    <input type="submit" value="Link User">
                </form>
            </div>

            <h2>Linked Users</h2>
            <div class="linked-users">
                <%
                    try {
                        String email = request.getParameter("email");
                        String password = request.getParameter("password");
                        Connection conn;
                        if (email != null && password != null) {
                            conn = DBConnection.getConnection();
                            PreparedStatement ps = conn.prepareStatement("SELECT id, name FROM users WHERE email = ? AND password = ?");
                            ps.setString(1, email);
                            ps.setString(2, password);
                            ResultSet rs = ps.executeQuery();

                            if (rs.next()) {
                                int linkedUserId = rs.getInt("id");

                                // Insert the link into the database
                                PreparedStatement insertPs = conn.prepareStatement("INSERT INTO linked_users (user_id, linked_user_id) VALUES (?, ?)");
                                insertPs.setInt(1, userId);
                                insertPs.setInt(2, linkedUserId);
                                insertPs.executeUpdate();

                                // Display success message
                                message = "User linked successfully!";
                                session.setAttribute("linkedUserEmail", "user2@email.com");
                                //response.sendRedirect("linkedDashboard.jsp");

                                response.sendRedirect("linkedUsers.jsp?message=" + message);
                                return;
                            } else {
                                message = "Invalid credentials. Please try again.";
                            }

                            rs.close();
                            ps.close();
                            conn.close();
                        }
                        String deleteEmail = request.getParameter("deleteEmail");
                        if (deleteEmail != null) {
                            conn = DBConnection.getConnection();
                            PreparedStatement psDelete = conn.prepareStatement(
                                    "DELETE FROM linked_users WHERE user_id = ? AND linked_user_id = (SELECT id FROM users WHERE email = ?)");
                            psDelete.setInt(1, userId);
                            psDelete.setString(2, deleteEmail);
                            psDelete.executeUpdate();
                            psDelete.close();
                            conn.close();

                            response.sendRedirect("linkedUsers.jsp?message=User+unlinked+successfully!");
                            return;
                        }

                        // Fetch and display the linked users
                        conn = DBConnection.getConnection();
                        PreparedStatement psUsers = conn.prepareStatement("SELECT u.name, u.email FROM users u JOIN linked_users lu ON u.id = lu.linked_user_id WHERE lu.user_id = ?");
                        psUsers.setInt(1, userId);
                        ResultSet rsUsers = psUsers.executeQuery();

                        while (rsUsers.next()) {
                            String linkedUserName = rsUsers.getString("name");
                            String linkedUserEmail = rsUsers.getString("email");


                %>
                <form method="post" style="display:inline;">
                    <input type="hidden" name="deleteEmail" value="<%= linkedUserEmail%>">
                    <div class="user-card" onclick="window.location.href = 'linkedDashboard.jsp?userEmail=<%= linkedUserEmail%>'">
                        <h4><%= linkedUserName%></h4>
                        <p><%= linkedUserEmail%></p>
                        <button type="submit" name="delete" style="margin-top:10px; background:#e74c3c; color:white; border:none; padding:5px 10px; border-radius:5px; cursor:pointer;" onclick="event.stopPropagation();">Delete</button>
                    </div>
                </form>

                <%
                        }
                        rsUsers.close();
                        psUsers.close();
                        conn.close();
                    } catch (Exception e) {
                        out.println("<p>Error: " + e.getMessage() + "</p>");
                    }
                %>
            </div>
        </div>
    </body>
</html>
