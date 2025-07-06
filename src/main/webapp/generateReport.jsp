<%@ page import="java.sql.*, db.DBConnection" %>
<%@ page import="java.io.*" %>
<%@ page import="com.itextpdf.kernel.pdf.PdfDocument" %>
<%@ page import="com.itextpdf.kernel.pdf.PdfWriter" %>
<%@ page import="com.itextpdf.layout.Document" %>
<%@ page import="com.itextpdf.layout.element.Paragraph" %>
<%@ page import="com.itextpdf.layout.element.Table" %>
<%@ page import="com.itextpdf.layout.element.Cell" %>
<%@ page import="com.itextpdf.kernel.font.PdfFont" %>
<%@ page import="com.itextpdf.kernel.font.PdfFontFactory" %>
<%@ page import="com.itextpdf.io.font.constants.StandardFonts" %>

<head>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">

</head>
<%
    String userName = (String) session.getAttribute("userName");
    if (userName == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String selectedMonth = request.getParameter("month");
    if (selectedMonth == null || selectedMonth.isEmpty()) {
        selectedMonth = "2025-04"; // fallback for April 2025
    }

    response.setContentType("application/pdf");
    response.setHeader("Content-Disposition", "attachment; filename=Financial_Report_" + selectedMonth.replaceAll("\\s+", "_") + ".pdf");

    try (Connection conn = DBConnection.getConnection()) {

        PreparedStatement ps1 = conn.prepareStatement("SELECT source, amount,income_date,description FROM income WHERE DATE_FORMAT(income_date, '%Y-%m') = ? and user_id=?");
        PreparedStatement ps2 = conn.prepareStatement("SELECT category, amount,expense_date,description FROM expenses WHERE DATE_FORMAT(expense_date, '%Y-%m') = ? and user_id=?");

        ps1.setString(1, selectedMonth);
        ps2.setString(1, selectedMonth);
        
        ps1.setInt(2, (int)session.getAttribute("userId"));
        ps2.setInt(2, (int)session.getAttribute("userId"));
        
        ResultSet rs1 = ps1.executeQuery();
        ResultSet rs2 = ps2.executeQuery();

        PdfWriter writer = new PdfWriter(response.getOutputStream());
        PdfDocument pdfDoc = new PdfDocument(writer);
        Document document = new Document(pdfDoc);

        PdfFont headerFont = PdfFontFactory.createFont(StandardFonts.HELVETICA_BOLD);
        PdfFont bodyFont = PdfFontFactory.createFont(StandardFonts.HELVETICA);

        Paragraph title = new Paragraph("Financial Report for " + selectedMonth)
                .setFont(headerFont)
                .setFontSize(16)
                .setTextAlignment(com.itextpdf.layout.properties.TextAlignment.CENTER)
                .setMarginBottom(20);
        document.add(title);

        Paragraph incomeTitle = new Paragraph("Income:")
                .setFont(headerFont)
                .setFontSize(14)
                .setMarginBottom(10);
        document.add(incomeTitle);

        Table incomeTable = new Table(4);
        incomeTable.setWidth(com.itextpdf.layout.properties.UnitValue.createPercentValue(100)).setMarginBottom(10);
        incomeTable.addCell(new Cell().add(new Paragraph("Source").setFont(headerFont).setTextAlignment(com.itextpdf.layout.properties.TextAlignment.CENTER).setMargin(5))
                .setBackgroundColor(new com.itextpdf.kernel.colors.DeviceRgb(0, 153, 255)));
        incomeTable.addCell(new Cell().add(new Paragraph("Amount").setFont(headerFont).setTextAlignment(com.itextpdf.layout.properties.TextAlignment.CENTER).setMargin(5))
                .setBackgroundColor(new com.itextpdf.kernel.colors.DeviceRgb(0, 153, 255)));
        incomeTable.addCell(new Cell().add(new Paragraph("income_date").setFont(headerFont).setTextAlignment(com.itextpdf.layout.properties.TextAlignment.CENTER).setMargin(5))
                .setBackgroundColor(new com.itextpdf.kernel.colors.DeviceRgb(0, 153, 255)));
        incomeTable.addCell(new Cell().add(new Paragraph("description").setFont(headerFont).setTextAlignment(com.itextpdf.layout.properties.TextAlignment.CENTER).setMargin(5))
                .setBackgroundColor(new com.itextpdf.kernel.colors.DeviceRgb(0, 153, 255)));

        double totalIncome = 0;
        while (rs1.next()) {
            double amount = rs1.getDouble("amount");
            totalIncome += amount;

            incomeTable.addCell(new Cell().add(new Paragraph(rs1.getString("source")).setFont(bodyFont).setTextAlignment(com.itextpdf.layout.properties.TextAlignment.CENTER).setMargin(5)));
            incomeTable.addCell(new Cell().add(new Paragraph("\u20B9" + amount).setFont(bodyFont).setTextAlignment(com.itextpdf.layout.properties.TextAlignment.CENTER).setMargin(5)));
            incomeTable.addCell(new Cell().add(new Paragraph(rs1.getString("income_date")).setFont(bodyFont).setTextAlignment(com.itextpdf.layout.properties.TextAlignment.CENTER).setMargin(5)));
            incomeTable.addCell(new Cell().add(new Paragraph(rs1.getString("description")).setFont(bodyFont).setTextAlignment(com.itextpdf.layout.properties.TextAlignment.CENTER).setMargin(5)));
        }
        document.add(incomeTable);

        Paragraph expenseTitle = new Paragraph("Expenses:")
                .setFont(headerFont)
                .setFontSize(14)
                .setMarginTop(20)
                .setMarginBottom(10);
        document.add(expenseTitle);

        Table expenseTable = new Table(4);
        expenseTable.setWidth(com.itextpdf.layout.properties.UnitValue.createPercentValue(100)).setMarginBottom(10);
        expenseTable.addCell(new Cell().add(new Paragraph("Category").setFont(headerFont).setTextAlignment(com.itextpdf.layout.properties.TextAlignment.CENTER).setMargin(5))
                .setBackgroundColor(new com.itextpdf.kernel.colors.DeviceRgb(255, 99, 71)));
        expenseTable.addCell(new Cell().add(new Paragraph("Amount").setFont(headerFont).setTextAlignment(com.itextpdf.layout.properties.TextAlignment.CENTER).setMargin(5))
                .setBackgroundColor(new com.itextpdf.kernel.colors.DeviceRgb(255, 99, 71)));
        expenseTable.addCell(new Cell().add(new Paragraph("expense_date").setFont(headerFont).setTextAlignment(com.itextpdf.layout.properties.TextAlignment.CENTER).setMargin(5))
                .setBackgroundColor(new com.itextpdf.kernel.colors.DeviceRgb(255, 99, 71)));
        expenseTable.addCell(new Cell().add(new Paragraph("description").setFont(headerFont).setTextAlignment(com.itextpdf.layout.properties.TextAlignment.CENTER).setMargin(5))
                .setBackgroundColor(new com.itextpdf.kernel.colors.DeviceRgb(255, 99, 71)));

        double totalExpense = 0;
        while (rs2.next()) {
            double amount = rs2.getDouble("amount");
            totalExpense += amount;

            expenseTable.addCell(new Cell().add(new Paragraph(rs2.getString("category")).setFont(bodyFont).setTextAlignment(com.itextpdf.layout.properties.TextAlignment.CENTER).setMargin(5)));
            expenseTable.addCell(new Cell().add(new Paragraph("\u20B9" + amount).setFont(bodyFont).setTextAlignment(com.itextpdf.layout.properties.TextAlignment.CENTER).setMargin(5)));
            expenseTable.addCell(new Cell().add(new Paragraph(rs2.getString("expense_date")).setFont(bodyFont).setTextAlignment(com.itextpdf.layout.properties.TextAlignment.CENTER).setMargin(5)));
            expenseTable.addCell(new Cell().add(new Paragraph(rs2.getString("description")).setFont(bodyFont).setTextAlignment(com.itextpdf.layout.properties.TextAlignment.CENTER).setMargin(5)));
        }
        document.add(expenseTable);

        double balance = totalIncome - totalExpense;

        Paragraph summaryTitle = new Paragraph("Summary:")
                .setFont(headerFont)
                .setFontSize(14)
                .setMarginTop(20)
                .setMarginBottom(10);
        document.add(summaryTitle);

        Table summaryTable = new Table(2);
        summaryTable.setWidth(com.itextpdf.layout.properties.UnitValue.createPercentValue(50)).setMarginBottom(10);
        summaryTable.addCell(new Cell().add(new Paragraph("Total Income").setFont(headerFont).setMargin(5)));
        summaryTable.addCell(new Cell().add(new Paragraph("\u20B9" + totalIncome).setFont(bodyFont).setMargin(5)));
        summaryTable.addCell(new Cell().add(new Paragraph("Total Expenses").setFont(headerFont).setMargin(5)));
        summaryTable.addCell(new Cell().add(new Paragraph("\u20B9" + totalExpense).setFont(bodyFont).setMargin(5)));
        summaryTable.addCell(new Cell().add(new Paragraph("Balance Remaining").setFont(headerFont).setMargin(5)));
        summaryTable.addCell(new Cell().add(new Paragraph("\u20B9" + balance).setFont(bodyFont).setMargin(5)));

        document.add(summaryTable);

        document.close();
        out.println("PDF Report generated successfully!");

    } catch (Exception e) {
        out.println("Error generating PDF: " + e.getMessage());
        e.printStackTrace(new PrintWriter(out));
    }
%>
