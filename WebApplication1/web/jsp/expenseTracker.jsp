<%-- 
    Document   : expenseTracker
    Created on : 03-Aug-2026, 10:10:22 pm
    Author     : dines
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Expense Tracker</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .expense-summary {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin: 20px 0;
        }
        .summary-card {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            text-align: center;
            border-left: 4px solid #007bff;
        }
        .summary-card h3 {
            margin: 0;
            color: #666;
            font-size: 14px;
        }
        .summary-card .amount {
            font-size: 24px;
            font-weight: bold;
            color: #dc3545;
            margin: 10px 0 0 0;
        }
        .category-badge {
            display: inline-block;
            padding: 3px 10px;
            border-radius: 12px;
            font-size: 12px;
            background: #e9ecef;
            color: #495057;
        }
        .category-badge.rent { background: #ffd6d6; color: #721c24; }
        .category-badge.utilities { background: #d1ecf1; color: #0c5460; }
        .category-badge.salaries { background: #d4edda; color: #155724; }
        .category-badge.supplies { background: #fff3cd; color: #856404; }
        .category-badge.logistics { background: #d6d8db; color: #383d41; }
        .category-badge.maintenance { background: #f8d7da; color: #721c24; }
        .category-badge.marketing { background: #cce5ff; color: #004085; }
        .category-badge.insurance { background: #d6d8db; color: #383d41; }
        .delete-btn {
            color: #dc3545;
            text-decoration: none;
            cursor: pointer;
        }
        .delete-btn:hover { text-decoration: underline; }
        .chart-container {
            margin-top: 30px;
            padding: 20px;
            background: #f8f9fa;
            border-radius: 8px;
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Navigation -->
        <div class="nav">
            <a href="${pageContext.request.contextPath}/itemList">Items</a>
            <a href="${pageContext.request.contextPath}/addItem">Add Item</a>
            <a href="${pageContext.request.contextPath}/expense">Expenses</a>
            <a href="${pageContext.request.contextPath}/profitLoss">Profit/Loss</a>
        </div>
        
        <h1>Expense Tracker</h1>
        
        <!-- Display Messages -->
        <% if (request.getParameter("message") != null) { %>
            <div class="alert alert-success"><%= request.getParameter("message") %></div>
        <% } %>
        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
        <% } %>
        
        <!-- Summary Cards -->
        <div class="expense-summary">
            <div class="summary-card">
                <h3>Total Expenses</h3>
                <p class="amount">₹<fmt:formatNumber value="${totalExpenses}" pattern="#,##0.00"/></p>
            </div>
            <div class="summary-card">
                <h3>Total Expenses This Month</h3>
                <p class="amount">₹<fmt:formatNumber value="${totalExpenses}" pattern="#,##0.00"/></p>
            </div>
            <div class="summary-card">
                <h3>Number of Expenses</h3>
                <p class="amount" style="color: #007bff;">${expenses.size()}</p>
            </div>
        </div>
        
        <!-- Add Expense Form -->
        <div style="background: #f8f9fa; padding: 20px; border-radius: 8px; margin-bottom: 30px;">
            <h3>Add New Expense</h3>
            <form action="${pageContext.request.contextPath}/expense" method="post">
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">
                    <div class="form-group">
                        <label>Expense Name:</label>
                        <input type="text" name="expenseName" required>
                    </div>
                    <div class="form-group">
                        <label>Category:</label>
                        <select name="category" required>
                            <option value="Rent">Rent</option>
                            <option value="Utilities">Utilities</option>
                            <option value="Salaries">Salaries</option>
                            <option value="Supplies">Supplies</option>
                            <option value="Logistics">Logistics</option>
                            <option value="Maintenance">Maintenance</option>
                            <option value="Marketing">Marketing</option>
                            <option value="Insurance">Insurance</option>
                            <option value="Other">Other</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Amount (₹):</label>
                        <input type="number" step="0.01" name="amount" required>
                    </div>
                    <div class="form-group">
                        <label>Date:</label>
                        <input type="date" name="expenseDate" value="<%= java.time.LocalDate.now() %>" required>
                    </div>
                    <div class="form-group" style="grid-column: 1 / -1;">
                        <label>Description:</label>
                        <textarea name="description" rows="2"></textarea>
                    </div>
                </div>
                <button type="submit" class="btn btn-primary" style="margin-top: 10px;">Add Expense</button>
            </form>
        </div>
        
        <!-- Expense List -->
        <h3>Expense History</h3>
        <table>
            <thead>
                <tr>
                    <th>Date</th>
                    <th>Name</th>
                    <th>Category</th>
                    <th>Amount</th>
                    <th>Description</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${expenses}" var="expense">
                    <tr>
                        <td>${expense.expenseDate}</td>
                        <td>${expense.expenseName}</td>
                        <td>
                            <span class="category-badge ${expense.category.toLowerCase()}">
                                ${expense.category}
                            </span>
                        </td>
                        <td>₹<fmt:formatNumber value="${expense.amount}" pattern="#,##0.00"/></td>
                        <td>${expense.description}</td>
                        <td>
                            <a href="${pageContext.request.contextPath}/expense?action=delete&id=${expense.expenseId}" 
                               class="delete-btn" 
                               onclick="return confirm('Are you sure you want to delete this expense?')">
                                Delete
                            </a>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty expenses}">
                    <tr>
                        <td colspan="6" style="text-align: center; color: #666;">No expenses recorded yet.</td>
                    </tr>
                </c:if>
            </tbody>
        </table>
        
        <!-- Category Breakdown -->
        <div class="chart-container">
            <h4>Expenses by Category</h4>
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                <c:forEach items="${categoryExpenses}" var="category">
                    <div style="padding: 10px; border-bottom: 1px solid #ddd;">
                        <strong>${category[0]}</strong>
                        <span style="float: right;">₹<fmt:formatNumber value="${category[1]}" pattern="#,##0.00"/></span>
                    </div>
                </c:forEach>
                <c:if test="${empty categoryExpenses}">
                    <div style="grid-column: 1 / -1; text-align: center; color: #666;">No category data available.</div>
                </c:if>
            </div>
        </div>
    </div>
</body>
</html>
