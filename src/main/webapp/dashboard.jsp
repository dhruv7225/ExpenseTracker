<%@ page import="java.sql.*, java.util.*, db.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String userName = (String) session.getAttribute("userName");
    if (userName == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int userId = (int) session.getAttribute("userId");

    java.time.LocalDate now = java.time.LocalDate.now();
    int selectedMonthNum = now.getMonthValue();
    int selectedYear = now.getYear();

    String selectedMonthStr = request.getParameter("month");
    if (selectedMonthStr != null && !selectedMonthStr.isEmpty()) {
        try {
            String[] parts = selectedMonthStr.split("-");
            selectedYear = Integer.parseInt(parts[0]);
            selectedMonthNum = Integer.parseInt(parts[1]);
        } catch (Exception e) {
            out.println("<p style='color:red;'>Invalid month format.</p>");
        }
    }

    double totalIncome = 0;
    double totalExpense = 0;
    List<String> expenseLabels = new ArrayList<>();
    List<Double> expenseData = new ArrayList<>();
    List<String> incomeLabels = new ArrayList<>();
    List<Double> incomeData = new ArrayList<>();
    List<String> monthLabels = new ArrayList<>();
    List<Double> monthlyIncome = new ArrayList<>();
    List<Double> monthlyExpense = new ArrayList<>();

    try {
        Connection conn = DBConnection.getConnection();

        PreparedStatement incomeStmt = conn.prepareStatement("SELECT SUM(amount) FROM income WHERE user_id=? AND MONTH(income_date)=? AND YEAR(income_date)=?");
        incomeStmt.setInt(1, userId);
        incomeStmt.setInt(2, selectedMonthNum);
        incomeStmt.setInt(3, selectedYear);
        ResultSet incomeRs = incomeStmt.executeQuery();
        if (incomeRs.next()) {
            totalIncome = incomeRs.getDouble(1);
        }

        PreparedStatement expenseStmt = conn.prepareStatement("SELECT SUM(amount) FROM expenses WHERE user_id=? AND MONTH(expense_date)=? AND YEAR(expense_date)=?");
        expenseStmt.setInt(1, userId);
        expenseStmt.setInt(2, selectedMonthNum);
        expenseStmt.setInt(3, selectedYear);
        ResultSet expenseRs = expenseStmt.executeQuery();
        if (expenseRs.next()) {
            totalExpense = expenseRs.getDouble(1);
        }

        PreparedStatement catExpStmt = conn.prepareStatement("SELECT category, SUM(amount) FROM expenses WHERE user_id=? AND MONTH(expense_date)=? AND YEAR(expense_date)=? GROUP BY category");
        catExpStmt.setInt(1, userId);
        catExpStmt.setInt(2, selectedMonthNum);
        catExpStmt.setInt(3, selectedYear);
        ResultSet catExpRs = catExpStmt.executeQuery();
        while (catExpRs.next()) {
            expenseLabels.add(catExpRs.getString("category"));
            expenseData.add(catExpRs.getDouble("SUM(amount)"));
        }

        PreparedStatement catIncStmt = conn.prepareStatement("SELECT source, SUM(amount) FROM income WHERE user_id=? AND MONTH(income_date)=? AND YEAR(income_date)=? GROUP BY source");
        catIncStmt.setInt(1, userId);
        catIncStmt.setInt(2, selectedMonthNum);
        catIncStmt.setInt(3, selectedYear);
        ResultSet catIncRs = catIncStmt.executeQuery();
        while (catIncRs.next()) {
            incomeLabels.add(catIncRs.getString("source"));
            incomeData.add(catIncRs.getDouble("SUM(amount)"));
        }

        for (int m = 1; m <= 12; m++) {
            monthLabels.add(java.time.Month.of(m).name().substring(0, 3));

            PreparedStatement inc = conn.prepareStatement("SELECT SUM(amount) FROM income WHERE user_id=? AND MONTH(income_date)=? AND YEAR(income_date)=?");
            inc.setInt(1, userId);
            inc.setInt(2, m);
            inc.setInt(3, selectedYear);
            ResultSet incRs = inc.executeQuery();
            if (incRs.next()) {
                monthlyIncome.add(incRs.getDouble(1));
            }
            inc.close();

            PreparedStatement exp = conn.prepareStatement("SELECT SUM(amount) FROM expenses WHERE user_id=? AND MONTH(expense_date)=? AND YEAR(expense_date)=?");
            exp.setInt(1, userId);
            exp.setInt(2, m);
            exp.setInt(3, selectedYear);
            ResultSet expRs = exp.executeQuery();
            if (expRs.next()) {
                monthlyExpense.add(expRs.getDouble(1));
            }
            exp.close();
        }

        conn.close();
    } catch (Exception e) {
        out.println("<p style='color:red;'>Database Error: " + e.getMessage() + "</p>");
    }

    double balance = totalIncome - totalExpense;
%>

<!DOCTYPE html>
<html>
    <head>
        <title>Dashboard</title>
        <link rel="stylesheet" href="css/style.css">
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <style>
            .chart-container {
                width: 40%;
                margin: 30px;
                float: left;
            }
            .chart-full {
                width: 70%;
                margin: 20px auto;
                clear: both;
            }
            .bar{
                width: 50%;
                /*height: 30%;*/
                margin-top: 120px;
            }
            .summary-boxes {
                display: flex;
                gap: 20px;
                margin-bottom: 30px;
            }
            .box {
                flex: 1;
                padding: 20px;
                font-size: 18px;
                border-radius: 10px;
                color: #fff;
            }
            .green {
                background-color: #43aa8b;
            }
            .red {
                background-color: #f94144;
            }
            .blue {
                background-color: #577590;
            }

            h3 {
                text-align: center;
                margin-bottom: 30px;
            }
            .filter{
                color: white;
                background-color: #007bff;
            }
            h1{
                text-align: center;
            }
            


        </style>
    </head>
    <body>

        <jsp:include page="navbar.jsp" />


        <div class="main-content">
            <h1>Welcome, <%= userName%>!</h1>
            
                <form method="get" style="margin-bottom: 20px;" >
                    <label for="month">Select Month:</label>
                    <input type="month" name="month" id="month" value="<%= selectedYear%>-<%= (selectedMonthNum < 10 ? "0" + selectedMonthNum : selectedMonthNum)%>">
                    <input type="submit" value="Filter" class="filter">
                </form>
           


            <div class="summary-boxes">
                <div class="box green">Total Income: ₹<%= String.format("%.2f", totalIncome)%></div>
                <div class="box red">Total Expenses: ₹<%= String.format("%.2f", totalExpense)%></div>
                <div class="box blue">Balance: ₹<%= String.format("%.2f", balance)%></div>
            </div>

            <div class="chart-container">
                <h3>Expenses (Pie Chart)</h3>
                <canvas id="expensePieChart"></canvas>
            </div>

            <div class="chart-container bar">
                <h3>Income (Bar Chart)</h3>
                <canvas id="incomeBarChart"></canvas>
            </div>

            <div class="chart-full">
                <h3>Expenses (Bar Chart)</h3>
                <canvas id="expenseBarChart"></canvas>
            </div>
            <div class="chart-full">
                <h3>Total Income vs Expense (Monthly - <%= selectedYear%>)</h3>
                <canvas id="monthlyLineChart"></canvas>
            </div>

        </div>

        <script>
            const expenseLabels = <%= expenseLabels.toString().replace("[", "['").replace("]", "']").replace(", ", "', '")%>;
            const expenseData = <%= expenseData.toString()%>;
            const incomeLabels = <%= incomeLabels.toString().replace("[", "['").replace("]", "']").replace(", ", "', '")%>;
            const incomeData = <%= incomeData.toString()%>;

            new Chart(document.getElementById('expensePieChart'), {
                type: 'pie',
                data: {
                    labels: expenseLabels,
                    datasets: [{
                            label: 'Expenses by Category',
                            data: expenseData,
                            backgroundColor: ['#f94144', '#f3722c', '#f8961e', '#90be6d', '#577590']
                        }]
                }
            });

            new Chart(document.getElementById('incomeBarChart'), {
                type: 'bar',
                data: {
                    labels: incomeLabels,
                    datasets: [{
                            label: 'Income by Source',
                            data: incomeData,
                            backgroundColor: '#43aa8b'
                        }]
                }
            });

            new Chart(document.getElementById('expenseBarChart'), {
                type: 'bar',
                data: {
                    labels: expenseLabels,
                    datasets: [{
                            label: 'Expenses by Category',
                            data: expenseData,
                            backgroundColor: '#f8961e'
                        }]
                }
            });

            const monthLabels = <%= monthLabels.toString().replace("[", "['").replace("]", "']").replace(", ", "', '")%>;
            const monthlyIncome = <%= monthlyIncome.toString()%>;
            const monthlyExpense = <%= monthlyExpense.toString()%>;

            new Chart(document.getElementById('monthlyLineChart'), {
                type: 'line',
                data: {
                    labels: monthLabels,
                    datasets: [
                        {
                            label: 'Income',
                            data: monthlyIncome,
                            borderColor: '#43aa8b',
                            fill: false
                        },
                        {
                            label: 'Expense',
                            data: monthlyExpense,
                            borderColor: '#f94144',
                            fill: false
                        }
                    ]
                },
                options: {
                    responsive: true,
                    plugins: {
                        legend: {
                            position: 'top',
                        }
                    }
                }
            });

        </script>

    </body>
</html>
