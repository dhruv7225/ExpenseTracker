<%@ page import="java.sql.*, db.DBConnection" %>
<%  
    String userName = (String) session.getAttribute("userName");
    if (userName == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    int userId = (int) session.getAttribute("userId");
    int goalId = Integer.parseInt(request.getParameter("goalId"));

    try (Connection conn = DBConnection.getConnection()) {
        String deleteQuery = "DELETE FROM goals WHERE id = ? AND user_id = ?";
        PreparedStatement ps = conn.prepareStatement(deleteQuery);
        ps.setInt(1, goalId);
        ps.setInt(2, userId);
        int rows = ps.executeUpdate();

        if (rows > 0) {
            response.sendRedirect("goals.jsp");
        } else {
            out.println("<p>Unable to delete goal or goal not found.</p>");
        }
    } catch (Exception e) {
        out.println("<p>Error deleting goal: " + e.getMessage() + "</p>");
    }
%>
