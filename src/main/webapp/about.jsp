<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>About - Expense Tracker</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .main-content {
            margin-left: 250px;
            padding: 30px;
            font-family: 'Segoe UI', sans-serif;
            background-color: #f9f9f9;
            min-height: 100vh;
        }

        .about-box {
            background-color: #fff;
            border-radius: 15px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            padding: 40px;
            max-width: 900px;
            margin: auto;
        }

        .about-box h1 {
            color: #333;
            margin-bottom: 25px;
            text-align: center;
            font-size: 36px;
        }

        .about-box ul {
            list-style: none;
            padding-left: 0;
        }

        .about-box li {
            margin-bottom: 20px;
            font-size: 18px;
            line-height: 1.6;
            padding-left: 30px;
            position: relative;
        }

        .about-box li::before {
            content: '✓';
            position: absolute;
            left: 0;
            color: #577590;
            font-weight: bold;
        }

        .highlight {
            font-weight: bold;
            color: #577590;
        }

        .footer {
            margin-top: 40px;
            text-align: center;
            font-size: 14px;
            color: #888;
        }

        @media screen and (max-width: 768px) {
            .main-content {
                margin-left: 0;
                padding: 20px;
            }

            .about-box {
                padding: 25px;
            }

            .about-box h1 {
                font-size: 28px;
            }

            .about-box li {
                font-size: 16px;
            }
        }
    </style>
</head>
<body>

    <jsp:include page="navbar.jsp" />

    <div class="main-content">
        <div class="about-box">
            <h1>About Expense Tracker</h1>
            <ul>
                <li><span class="highlight">Purpose:</span> Helps users manage personal finances by tracking incomes and expenses.</li>
                <li><span class="highlight">Key Features:</span>
                    <ul style="list-style: disc; margin-left: 20px; margin-top: 10px;">
                        <li>Add & manage income and expenses</li>
                        <li>View categorized charts (pie & bar)</li>
                        <li>Filter data by month and year</li>
                        <li>Track overall balance and spending habits</li>
                    </ul>
                </li>
                <li><span class="highlight">Technology Stack:</span> Java, JSP, JDBC, MySQL, HTML/CSS, Chart.js</li>
                <li><span class="highlight">User Interface:</span> Simple, responsive, and visually clean UI for ease of use</li>
                <li><span class="highlight">Who is it for:</span> Anyone who wants to understand and improve their financial habits</li>
            </ul>
            <div class="footer">Made with ❤️ for better financial tracking.</div>
        </div>
    </div>

</body>
</html>
