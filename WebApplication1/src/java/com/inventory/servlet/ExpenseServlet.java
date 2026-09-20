/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.inventory.servlet;

import com.inventory.dao.ExpenseDAO;
import com.inventory.model.Expense;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.util.List;

@WebServlet("/expense")
public class ExpenseServlet extends HttpServlet {
    
    private ExpenseDAO expenseDAO;
    
    @Override
    public void init() {
        expenseDAO = new ExpenseDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        try {
            if ("delete".equals(action)) {
                int expenseId = Integer.parseInt(request.getParameter("id"));
                expenseDAO.deleteExpense(expenseId);
                response.sendRedirect(request.getContextPath() + "/expense?message=Expense deleted successfully");
                return;
            }
            
            // Get all expenses
            List<Expense> expenses = expenseDAO.getAllExpenses();
            request.setAttribute("expenses", expenses);
            
            // Get total expenses
            BigDecimal totalExpenses = expenseDAO.getTotalExpensesByDateRange("2000-01-01", "2100-12-31");
            request.setAttribute("totalExpenses", totalExpenses);
            
            // Get expenses by category
            List<Object[]> categoryExpenses = expenseDAO.getExpensesByCategory("2000-01-01", "2100-12-31");
            request.setAttribute("categoryExpenses", categoryExpenses);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading expenses: " + e.getMessage());
        }
        
        request.getRequestDispatcher("/jsp/expenseTracker.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            String expenseName = request.getParameter("expenseName");
            String category = request.getParameter("category");
            BigDecimal amount = new BigDecimal(request.getParameter("amount"));
            Date expenseDate = Date.valueOf(request.getParameter("expenseDate"));
            String description = request.getParameter("description");
            
            Expense expense = new Expense(expenseName, category, amount, expenseDate, description);
            boolean success = expenseDAO.addExpense(expense);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/expense?message=Expense added successfully");
            } else {
                request.setAttribute("error", "Failed to add expense");
                doGet(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: " + e.getMessage());
            doGet(request, response);
        }
    }
}