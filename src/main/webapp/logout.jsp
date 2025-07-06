<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*, javax.servlet.*, javax.servlet.http.*" %>
<%
    // Invalidate the session to log the user out
//    HttpSession session = request.getSession(false);
    if (session != null) {
        session.invalidate(); // Invalidate the session
    }

    // Redirect to the login page or homepage
    response.sendRedirect("login.jsp"); // You can replace "login.jsp" with your homepage URL
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Logging Out...</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                text-align: center;
                padding: 50px;
                background-color: #f1f1f1;
            }
            h1 {
                color: #555;
            }
            p {
                color: #888;
                font-size: 18px;
            }
        </style>
    </head>
    <body>
        <h1>Logging You Out...</h1>
        <p>Please wait while we log you out.</p>
    </body>
</html>
