package com.hardware.utils;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    // Update these with your MySQL credentials
    private static final String URL = "jdbc:mysql://localhost:3306/hardware_inventory";
    private static final String USERNAME = "root";        // Your MySQL username
    private static final String PASSWORD = "shreya@07";            // Your MySQL password
    
    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(URL, USERNAME, PASSWORD);
        } catch (ClassNotFoundException e) {
            throw new SQLException("MySQL Driver not found! Please add MySQL Connector JAR.", e);
        }
    }
}