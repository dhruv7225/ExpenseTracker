<%@ page import="java.sql.*, db.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Goal</title>
    <link rel="stylesheet" href="css/style.css">  <!-- Your existing CSS -->
</head>
<body>

<%-- Include Navbar --%>
<jsp:include page="navbar.jsp" />

<div class="main-content">
    <h1>Add New Goal</h1>
    
    <form action="addGoal.jsp" method="post">
        <label for="goalTitle">Goal Title:</label>
        <input type="text" id="goalTitle" name="goalTitle" required><br>

        <label for="goalDescription">Description:</label>
        <textarea id="goalDescription" name="goalDescription" required></textarea><br>

        <label for="goalDeadline">Deadline:</label>
        <input type="date" id="goalDeadline" name="goalDeadline" required><br>

        <input type="submit" value="Add Goal">
    </form>

    <%-- Add Goal Logic --%>
    <%
        String userName = (String) session.getAttribute("userName");
    if (userName == null) {
        response.sendRedirect("login.jsp");
        return;
    }
        if (request.getMethod().equalsIgnoreCase("POST")) {
            String goalTitle = request.getParameter("goalTitle");
            String goalDescription = request.getParameter("goalDescription");
            String goalDeadline = request.getParameter("goalDeadline");

            try (Connection conn = DBConnection.getConnection()) {
                String query = "INSERT INTO goals (goal_title, description, deadline) VALUES (?, ?, ?)";
                PreparedStatement ps = conn.prepareStatement(query);
                ps.setString(1, goalTitle);
                ps.setString(2, goalDescription);
                ps.setString(3, goalDeadline);

                int result = ps.executeUpdate();
                if (result > 0) {
                    out.println("<p>Goal added successfully!</p>");
                } else {
                    out.println("<p>Failed to add goal. Please try again.</p>");
                }
            } catch (Exception e) {
                out.println("<p>Error: " + e.getMessage() + "</p>");
            }
        }
    %>
</div>

</body>
</html>
