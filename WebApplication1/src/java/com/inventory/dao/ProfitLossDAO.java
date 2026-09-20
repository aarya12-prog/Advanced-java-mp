/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.inventory.dao;

/**
 *
 * @author dines
 */

import com.inventory.config.DatabaseConfig;
import com.inventory.model.ProfitLossReport;
import java.math.BigDecimal;
import java.sql.*;
import java.util.*;

public class ProfitLossDAO {
    
    // Get complete profit/loss report for a date range
    public ProfitLossReport getProfitLossReport(String startDate, String endDate) throws SQLException {
        ProfitLossReport report = new ProfitLossReport();
        
        // Calculate sales and purchase cost
        String salesSql = "SELECT " +
                         "COALESCE(SUM(s.quantity_sold * s.selling_price), 0) as total_sales, " +
                         "COALESCE(SUM(s.quantity_sold * i.purchase_price), 0) as total_purchase_cost " +
                         "FROM sales s " +
                         "JOIN items i ON s.item_id = i.item_id " +
                         "WHERE s.sale_date BETWEEN ? AND ?";
        
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(salesSql)) {
            
            pstmt.setString(1, startDate);
            pstmt.setString(2, endDate);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                BigDecimal totalSales = rs.getBigDecimal("total_sales");
                BigDecimal totalPurchaseCost = rs.getBigDecimal("total_purchase_cost");
                
                report.setTotalSales(totalSales);
                report.setTotalPurchaseCost(totalPurchaseCost);
                report.setGrossProfit(totalSales.subtract(totalPurchaseCost));
            }
        }
        
        // Get total expenses
        String expenseSql = "SELECT COALESCE(SUM(amount), 0) as total_expenses FROM expenses " +
                           "WHERE expense_date BETWEEN ? AND ?";
        
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(expenseSql)) {
            
            pstmt.setString(1, startDate);
            pstmt.setString(2, endDate);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                BigDecimal totalExpenses = rs.getBigDecimal("total_expenses");
                report.setTotalExpenses(totalExpenses);
                
                BigDecimal grossProfit = report.getGrossProfit();
                report.setNetProfit(grossProfit.subtract(totalExpenses));
            }
        }
        
        // Get sales by category
        String salesByCategorySql = "SELECT i.category, COALESCE(SUM(s.quantity_sold * s.selling_price), 0) as total " +
                                   "FROM sales s " +
                                   "JOIN items i ON s.item_id = i.item_id " +
                                   "WHERE s.sale_date BETWEEN ? AND ? " +
                                   "GROUP BY i.category ORDER BY total DESC";
        
        Map<String, BigDecimal> salesByCategory = new HashMap<>();
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(salesByCategorySql)) {
            
            pstmt.setString(1, startDate);
            pstmt.setString(2, endDate);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                salesByCategory.put(rs.getString("category"), rs.getBigDecimal("total"));
            }
        }
        report.setSalesByCategory(salesByCategory);
        
        // Get expenses by category
        String expensesByCategorySql = "SELECT category, COALESCE(SUM(amount), 0) as total " +
                                      "FROM expenses " +
                                      "WHERE expense_date BETWEEN ? AND ? " +
                                      "GROUP BY category ORDER BY total DESC";
        
        Map<String, BigDecimal> expensesByCategory = new HashMap<>();
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(expensesByCategorySql)) {
            
            pstmt.setString(1, startDate);
            pstmt.setString(2, endDate);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                expensesByCategory.put(rs.getString("category"), rs.getBigDecimal("total"));
            }
        }
        report.setExpensesByCategory(expensesByCategory);
        
        // Get monthly profit trend (last 6 months)
        String monthlyProfitSql = "SELECT " +
                                 "DATE_FORMAT(s.sale_date, '%Y-%m') as month, " +
                                 "COALESCE(SUM(s.quantity_sold * s.selling_price), 0) as sales, " +
                                 "COALESCE(SUM(s.quantity_sold * i.purchase_price), 0) as cost " +
                                 "FROM sales s " +
                                 "JOIN items i ON s.item_id = i.item_id " +
                                 "WHERE s.sale_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH) " +
                                 "GROUP BY DATE_FORMAT(s.sale_date, '%Y-%m') " +
                                 "ORDER BY month";
        
        Map<String, BigDecimal> monthlyProfit = new LinkedHashMap<>();
        try (Connection conn = DatabaseConfig.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(monthlyProfitSql)) {
            
            while (rs.next()) {
                String month = rs.getString("month");
                BigDecimal sales = rs.getBigDecimal("sales");
                BigDecimal cost = rs.getBigDecimal("cost");
                monthlyProfit.put(month, sales.subtract(cost));
            }
        }
        report.setMonthlyProfit(monthlyProfit);
        
        return report;
    }
}
