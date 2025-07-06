<%@ page import="java.sql.*, java.util.*, db.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String linkedUserEmail = request.getParameter("userEmail");
    String selectedMonth = request.getParameter("month");
    String linkedUserName="";
    if (selectedMonth == null || selectedMonth.isEmpty()) {
        java.util.Calendar cal = java.util.Calendar.getInstance();
        int currentMonth = cal.get(java.util.Calendar.MONTH) + 1;
        selectedMonth = String.format("%02d", currentMonth);
    }

    List<String> expenseCategories = new ArrayList<>();
    List<Double> expenseAmounts = new ArrayList<>();
    List<Map<String, String>> expenseTable = new ArrayList<>();

    try {
        Connection conn = DBConnection.getConnection();
        
        PreparedStatement ps0=conn.prepareStatement("SELECT * from users where email=?");
        ps0.setString(1, linkedUserEmail);
        ResultSet rs0=ps0.executeQuery();
        rs0.next();
        linkedUserName=rs0.getString("name");

        
        
        
        
        PreparedStatement ps;

        ps = conn.prepareStatement("SELECT category, SUM(amount) FROM expenses WHERE user_id = (SELECT id FROM users WHERE email=?) AND MONTH(expense_date)=? GROUP BY category");
        ps.setString(1, linkedUserEmail);
        ps.setInt(2, Integer.parseInt(selectedMonth));

        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            expenseCategories.add(rs.getString(1));
            expenseAmounts.add(rs.getDouble(2));
        }

        // For detailed table
        PreparedStatement tablePs = conn.prepareStatement("SELECT category, amount, description, DATE(expense_date) FROM expenses WHERE user_id = (SELECT id FROM users WHERE email=?) AND MONTH(expense_date)=?");
        tablePs.setString(1, linkedUserEmail);
        tablePs.setInt(2, Integer.parseInt(selectedMonth));

        ResultSet trs = tablePs.executeQuery();
        while (trs.next()) {
            Map<String, String> row = new HashMap<>();
            row.put("category", trs.getString("category"));
            row.put("amount", trs.getString("amount"));
            row.put("description", trs.getString("description"));
            row.put("expense_date", trs.getString("DATE(expense_date)"));
            expenseTable.add(row);
        }

    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Linked Dashboard</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link rel="stylesheet" href="css/style.css"/>
    <style>
        .filter-box {
            margin-bottom: 20px;
            text-align: center;
        }

        .chart-container {
            width: 300px;
            height: 300px;
            margin: 30px auto;
        }

        table {
            width: 90%;
            margin: 30px auto;
            border-collapse: collapse;
            background: white;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }

        th, td {
            border: 1px solid #ddd;
            padding: 12px;
            text-align: center;
        }

        th {
            background-color: #007bff;
            color: white;
        }

        tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        tr:hover {
            background-color: #e0f7fa;
        }

        .filter-btn {
            padding: 7px 20px;
            background: #007bff;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            margin-left: 10px;
        }

        h2, h3 {
            text-align: center;
            margin-top: 20px;
        }
    </style>
</head>
<body>
<jsp:include page="navbar.jsp" />

<div class="main-content">
    <h2>Dashboard of <%= linkedUserName %></h2>

    <div class="filter-box">
        <form method="get" action="linkedDashboard.jsp">
            <input type="hidden" name="userEmail" value="<%= linkedUserEmail %>">
            <label>Select Month:</label>
            <select name="month">
                <option value="">--All--</option>
                <% for (int i = 1; i <= 12; i++) {
                    String monthValue = String.format("%02d", i); %>
                    <option value="<%= monthValue %>" <%= selectedMonth.equals(monthValue) ? "selected" : "" %>>
                        <%= new java.text.DateFormatSymbols().getMonths()[i - 1] %>
                    </option>
                <% } %>
            </select>
            <button type="submit" class="filter-btn">Filter</button>
        </form>
    </div>

    <div class="chart-container">
        <canvas id="expenseChart" width="300" height="300"></canvas>
    </div>

    <script>
        const categories = <%= expenseCategories.toString().replace("[", "['").replace("]", "']").replace(", ", "', '") %>;
        const amounts = <%= expenseAmounts.toString() %>;

        new Chart(document.getElementById('expenseChart'), {
            type: 'pie',
            data: {
                labels: categories,
                datasets: [{
                    label: 'Expenses',
                    data: amounts,
                    backgroundColor: ['#f94144', '#f3722c', '#f8961e', '#43aa8b', '#577590', '#ffafcc', '#80ed99']
                }]
            },
            options: {
                responsive: false,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'bottom'
                    }
                }
            }
        });
    </script>

    <h3>Detailed Expense Table</h3>
    <table>
        <tr>
            <th>Category</th>
            <th>Amount</th>
            <th>Description</th>
            <th>Date</th>
        </tr>
        <% for (Map<String, String> row : expenseTable) { %>
            <tr>
                <td><%= row.get("category") %></td>
                <td><%= row.get("amount") %></td>
                <td><%= row.get("description") %></td>
                <td><%= row.get("expense_date") %></td>
            </tr>
        <% } %>
    </table>
</div>
</body>
</html>
