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
import com.inventory.model.Expense;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.math.BigDecimal;

public class ExpenseDAO {
    
    // Add new expense
    public boolean addExpense(Expense expense) throws SQLException {
        String sql = "INSERT INTO expenses (expense_name, category, amount, expense_date, description) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, expense.getExpenseName());
            pstmt.setString(2, expense.getCategory());
            pstmt.setBigDecimal(3, expense.getAmount());
            pstmt.setDate(4, expense.getExpenseDate());
            pstmt.setString(5, expense.getDescription());
            
            return pstmt.executeUpdate() > 0;
        }
    }
    
    // Get all expenses
    public List<Expense> getAllExpenses() throws SQLException {
        List<Expense> expenses = new ArrayList<>();
        String sql = "SELECT * FROM expenses ORDER BY expense_date DESC";
        
        try (Connection conn = DatabaseConfig.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Expense expense = new Expense();
                expense.setExpenseId(rs.getInt("expense_id"));
                expense.setExpenseName(rs.getString("expense_name"));
                expense.setCategory(rs.getString("category"));
                expense.setAmount(rs.getBigDecimal("amount"));
                expense.setExpenseDate(rs.getDate("expense_date"));
                expense.setDescription(rs.getString("description"));
                expense.setCreatedAt(rs.getTimestamp("created_at"));
                expenses.add(expense);
            }
        }
        return expenses;
    }
    
    // Get expenses by date range
    public List<Expense> getExpensesByDateRange(String startDate, String endDate) throws SQLException {
        List<Expense> expenses = new ArrayList<>();
        String sql = "SELECT * FROM expenses WHERE expense_date BETWEEN ? AND ? ORDER BY expense_date DESC";
        
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, startDate);
            pstmt.setString(2, endDate);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Expense expense = new Expense();
                expense.setExpenseId(rs.getInt("expense_id"));
                expense.setExpenseName(rs.getString("expense_name"));
                expense.setCategory(rs.getString("category"));
                expense.setAmount(rs.getBigDecimal("amount"));
                expense.setExpenseDate(rs.getDate("expense_date"));
                expense.setDescription(rs.getString("description"));
                expense.setCreatedAt(rs.getTimestamp("created_at"));
                expenses.add(expense);
            }
        }
        return expenses;
    }
    
    // Get total expenses by date range
    public BigDecimal getTotalExpensesByDateRange(String startDate, String endDate) throws SQLException {
        String sql = "SELECT SUM(amount) as total FROM expenses WHERE expense_date BETWEEN ? AND ?";
        
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, startDate);
            pstmt.setString(2, endDate);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getBigDecimal("total") != null ? rs.getBigDecimal("total") : BigDecimal.ZERO;
            }
        }
        return BigDecimal.ZERO;
    }
    
    // Get expenses by category
    public List<Object[]> getExpensesByCategory(String startDate, String endDate) throws SQLException {
        List<Object[]> categoryExpenses = new ArrayList<>();
        String sql = "SELECT category, SUM(amount) as total FROM expenses " +
                     "WHERE expense_date BETWEEN ? AND ? GROUP BY category ORDER BY total DESC";
        
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, startDate);
            pstmt.setString(2, endDate);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Object[] row = new Object[2];
                row[0] = rs.getString("category");
                row[1] = rs.getBigDecimal("total");
                categoryExpenses.add(row);
            }
        }
        return categoryExpenses;
    }
    
    // Delete expense
    public boolean deleteExpense(int expenseId) throws SQLException {
        String sql = "DELETE FROM expenses WHERE expense_id = ?";
        
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, expenseId);
            return pstmt.executeUpdate() > 0;
        }
    }
}
