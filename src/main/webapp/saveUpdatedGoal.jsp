<%@ page import="java.sql.*, db.DBConnection" %>
<%
    String userName = (String) session.getAttribute("userName");
    if (userName == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    int userId = (int) session.getAttribute("userId");

    // Make sure it's a POST request
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        try {
            int goalId = Integer.parseInt(request.getParameter("goalId"));
            String newTitle = request.getParameter("goalName");
            double newTarget = Double.parseDouble(request.getParameter("targetAmount"));
            String newDeadline = request.getParameter("deadline");

            try (Connection conn = DBConnection.getConnection()) {
                String updateQuery = "UPDATE goals SET title = ?, target_amount = ?, target_date = ? WHERE id = ? AND user_id = ?";
                PreparedStatement ps = conn.prepareStatement(updateQuery);
                ps.setString(1, newTitle);
                ps.setDouble(2, newTarget);
                ps.setString(3, newDeadline);
                ps.setInt(4, goalId);
                ps.setInt(5, userId);

                int rows = ps.executeUpdate();
                if (rows > 0) {
                    response.sendRedirect("goals.jsp"); // Redirect after successful update
                    return;
                } else {
                    out.println("<p>Failed to update the goal. Please try again.</p>");
                }
            }
        } catch (Exception e) {
            out.println("<p>Error updating goal: " + e.getMessage() + "</p>");
        }
    } else {
        response.sendRedirect("goals.jsp");
    }
%>
