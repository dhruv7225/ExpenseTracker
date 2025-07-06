<%@ page import="java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Currency Converter</title>
        <link rel="stylesheet" href="css/style.css">
        
        <style>
            body {
                font-family: Arial, sans-serif;
            }
            .main-content {
                /*margin-left: 220px;*/
                padding: 20px;
            }
            
            .converter-box, .table-box {
                max-width: 80%;
                margin: auto;
                background: #f7f7f7;
                padding: 30px;
                border-radius: 12px;
                margin-bottom: 30px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }
            .converter-box{
                max-width: 60%;
            }
            h2 {
                text-align: center;
            }
            label {
                display: block;
                margin: 10px 0 5px;
            }
            select, input[type="number"] {
                width: 100%;
                padding: 8px;
                margin-bottom: 15px;
                border-radius: 6px;
                border: 1px solid #ccc;
            }
            input[type="submit"] {
                background: #43aa8b;
                color: white;
                border: none;
                padding: 10px;
                border-radius: 6px;
                cursor: pointer;
            }
            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 15px;
            }
            table, th, td {
                border: 1px solid #ddd;
            }
            th {
                background-color: #43aa8b;
                color: white;
                padding: 10px;
            }
            td {
                text-align: center;
                padding: 10px;
            }
        </style>
    </head>
    <body>

        <jsp:include page="navbar.jsp" />

        <div class="main-content">
            <div class="converter-box">
                <h2>Currency Converter</h2>
                <form method="post">
                    <label for="amount">Amount:</label>
                    <input type="number" name="amount" step="0.01" required>

                    <label for="fromCurrency">From:</label>
                    <select name="fromCurrency" required>
                        <option value="USD">USD ($)</option>
                        <option value="INR">INR (₹)</option>
                        <option value="EUR">EUR (€)</option>
                        <option value="GBP">GBP (£)</option>
                        <option value="JPY">JPY (¥)</option>
                        <option value="AUD">AUD (A$)</option>
                        <option value="CAD">CAD (C$)</option>
                        <option value="CHF">CHF (Fr)</option>
                        <option value="CNY">CNY (¥)</option>
                    </select>

                    <label for="toCurrency">To:</label>
                    <select name="toCurrency" required>
                        <option value="USD">USD ($)</option>
                        <option value="INR">INR (₹)</option>
                        <option value="EUR">EUR (€)</option>
                        <option value="GBP">GBP (£)</option>
                        <option value="JPY">JPY (¥)</option>
                        <option value="AUD">AUD (A$)</option>
                        <option value="CAD">CAD (C$)</option>
                        <option value="CHF">CHF (Fr)</option>
                        <option value="CNY">CNY (¥)</option>
                    </select>

                    <input type="submit" value="Convert">
                </form>

                <%
                    String from = request.getParameter("fromCurrency");
                    String to = request.getParameter("toCurrency");
                    String amtStr = request.getParameter("amount");

                    if (from != null && to != null && amtStr != null) {
                        double amount = Double.parseDouble(amtStr);
                        double rate = 1.0;

                        if (from.equals("INR") && to.equals("USD")) {
                            rate = 0.012;
                        } else if (from.equals("USD") && to.equals("INR")) {
                            rate = 83.0;
                        } else if (from.equals("EUR") && to.equals("USD")) {
                            rate = 1.08;
                        } else if (from.equals("USD") && to.equals("EUR")) {
                            rate = 0.93;
                        } else if (from.equals("GBP") && to.equals("USD")) {
                            rate = 1.24;
                        } else if (from.equals("USD") && to.equals("GBP")) {
                            rate = 0.81;
                        } else if (from.equals("JPY") && to.equals("USD")) {
                            rate = 0.0067;
                        } else if (from.equals("USD") && to.equals("JPY")) {
                            rate = 149.0;
                        } else if (from.equals("AUD") && to.equals("USD")) {
                            rate = 0.66;
                        } else if (from.equals("USD") && to.equals("AUD")) {
                            rate = 1.52;
                        } else if (from.equals("CAD") && to.equals("USD")) {
                            rate = 0.74;
                        } else if (from.equals("USD") && to.equals("CAD")) {
                            rate = 1.35;
                        } else if (from.equals("CHF") && to.equals("USD")) {
                            rate = 1.10;
                        } else if (from.equals("USD") && to.equals("CHF")) {
                            rate = 0.91;
                        } else if (from.equals("CNY") && to.equals("USD")) {
                            rate = 0.14;
                        } else if (from.equals("USD") && to.equals("CNY")) {
                            rate = 7.25;
                        }

                        double converted = amount * rate;
                %>
                <h3>Converted Amount: <%= String.format("%.2f", converted)%> <%= to%></h3>
                <% }%>
            </div>

            <div class="table-box">
                <h2>Exchange Rates (1 USD = X Currency)</h2>
                <table>
                    <tr>
                        <th>Currency</th>
                        <th>Code</th>
                        <th>Value per USD</th>
                    </tr>
                    <tr><td>Indian Rupee</td><td>INR</td><td>₹83.00</td></tr>
                    <tr><td>Euro</td><td>EUR</td><td>€0.93</td></tr>
                    <tr><td>British Pound</td><td>GBP</td><td>£0.81</td></tr>
                    <tr><td>Japanese Yen</td><td>JPY</td><td>¥149.00</td></tr>
                    <tr><td>Australian Dollar</td><td>AUD</td><td>A$1.52</td></tr>
                    <tr><td>Canadian Dollar</td><td>CAD</td><td>C$1.35</td></tr>
                    <tr><td>Swiss Franc</td><td>CHF</td><td>Fr0.91</td></tr>
                    <tr><td>Chinese Yuan</td><td>CNY</td><td>¥7.25</td></tr>
                </table>
            </div>
        </div>

    </body>
</html>
