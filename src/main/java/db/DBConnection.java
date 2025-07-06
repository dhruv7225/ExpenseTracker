package db;

import java.sql.*;

public class DBConnection {
    public static Connection getConnection() throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/expense_tracker_db", "root", "12345678"
        );
    }
    public static Statement getStatement() throws SQLException,Exception {
        return getConnection().createStatement();
    }
}
