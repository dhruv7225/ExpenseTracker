<%@ page import="java.sql.*, db.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.itextpdf.kernel.pdf.PdfWriter" %>
<%@ page import="com.itextpdf.layout.Document" %>
<%@ page import="com.itextpdf.layout.element.Paragraph" %>
<%@ page import="com.itextpdf.layout.element.Table" %>
<%@ page import="com.itextpdf.layout.element.Cell" %>
<%@ page import="com.itextpdf.kernel.pdf.PdfDocument" %>
<%@ page import="java.io.FileOutputStream" %>


<% String userName = (String) session.getAttribute("userName");
    if (userName == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>    

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Financial Report</title>
    <link rel="stylesheet" href="css/style.css"> <!-- Your existing CSS -->
    <style>
/*        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f8f9fa;
            margin: 0;
            padding: 0;
        }*/

        .main-content {
            max-width: 600px;
            margin: 80px auto;
            background: #fff;
            padding: 40px ;
            
            box-shadow: 0 6px 18px rgba(0, 0, 0, 0.1);
            border-radius: 16px;
        }

        h1, h2 {
            text-align: center;
            color: #343a40;
        }

        label {
            font-weight: bold;
            display: block;
            margin-bottom: 10px;
        }

        input[type="month"] {
            padding: 10px;
            width: 100%;
            border: 1px solid #ced4da;
            border-radius: 8px;
            margin-bottom: 20px;
        }

        input[type="submit"] {
            background-color: #007bff;
            color: white;
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 16px;
            transition: background-color 0.3s ease;
        }

        input[type="submit"]:hover {
            background-color: #0056b3;
        }

        hr {
            margin: 40px 0;
            border: 0;
            border-top: 1px solid #dee2e6;
        }

        form {
            margin-top: 20px;
        }
    </style>
</head>
<body>

<jsp:include page="navbar.jsp" />

<div class="main-content">
    <h1>📄 Generate Financial Report</h1>

    <form action="report.jsp" method="get">
        <label for="month">📅 Select Month:</label>
        <input type="month" id="month" name="month" required>
        <input type="submit" value="📥 Generate Report">
    </form>

    <hr>

    <%
        String selectedMonth = request.getParameter("month");
        if (selectedMonth != null) {
    %>
        <h2>📊 Report for <%= selectedMonth %></h2>
        <form action="generateReport.jsp" method="get">
            <input type="hidden" name="month" value="<%= selectedMonth %>">
            <input type="submit" value="⬇️ Download Report (PDF)">
        </form>
    <%
        }
    %>
</div>

</body>
</html>
