<%@ page import="java.sql.*, db.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String userName = (String) session.getAttribute("userName");
    if (userName == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int userId = (int) session.getAttribute("userId");
    int expenseId = Integer.parseInt(request.getParameter("id"));

    try {
        Connection conn = DBConnection.getConnection();
        PreparedStatement ps = conn.prepareStatement("DELETE FROM expenses WHERE id=? AND user_id=?");
        ps.setInt(1, expenseId);
        ps.setInt(2, userId);
        ps.executeUpdate();
        ps.close();
        conn.close();
    } catch (Exception e) {
        // Optionally log error
    }

    response.sendRedirect("viewExpenses.jsp");
%>
