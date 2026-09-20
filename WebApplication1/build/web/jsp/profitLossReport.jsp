<%-- 
    Document   : profitLossReport
    Created on : 03-Aug-2026, 10:11:46 pm
    Author     : dines
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Profit & Loss Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .dashboard-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin: 20px 0;
        }
        .metric-card {
            padding: 25px;
            border-radius: 10px;
            text-align: center;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .metric-card h3 {
            margin: 0;
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: #666;
        }
        .metric-card .value {
            font-size: 32px;
            font-weight: bold;
            margin: 10px 0 5px 0;
        }
        .metric-card .sub {
            font-size: 12px;
            color: #666;
        }
        .positive { color: #28a745; }
        .negative { color: #dc3545; }
        .neutral { color: #007bff; }
        .card-blue { background: #e3f2fd; border-left: 4px solid #007bff; }
        .card-green { background: #e8f5e9; border-left: 4px solid #28a745; }
        .card-red { background: #ffebee; border-left: 4px solid #dc3545; }
        .card-orange { background: #fff3e0; border-left: 4px solid #ff9800; }
        .card-purple { background: #f3e5f5; border-left: 4px solid #9c27b0; }
        
        .section {
            margin-top: 30px;
            padding: 20px;
            background: #f8f9fa;
            border-radius: 8px;
        }
        .section h3 {
            margin-top: 0;
            border-bottom: 2px solid #007bff;
            padding-bottom: 10px;
        }
        .two-column {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
        }
        .category-item {
            display: flex;
            justify-content: space-between;
            padding: 8px 0;
            border-bottom: 1px solid #eee;
        }
        .category-item .bar-container {
            flex: 1;
            margin: 0 15px;
            background: #e9ecef;
            border-radius: 10px;
            height: 20px;
            overflow: hidden;
        }
        .category-item .bar {
            height: 100%;
            background: #007bff;
            border-radius: 10px;
            transition: width 0.5s;
        }
        .category-item .bar.green { background: #28a745; }
        .category-item .bar.red { background: #dc3545; }
        .category-item .bar.orange { background: #ff9800; }
        .category-item .bar.purple { background: #9c27b0; }
        
        .filter-form {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            display: flex;
            gap: 15px;
            align-items: flex-end;
            flex-wrap: wrap;
        }
        .filter-form .form-group {
            margin-bottom: 0;
        }
        .filter-form label {
            font-size: 12px;
            margin-bottom: 2px;
        }
        .filter-form input {
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        
        .monthly-trend {
            margin-top: 30px;
        }
        .trend-bar {
            display: flex;
            gap: 10px;
            align-items: flex-end;
            height: 150px;
            padding: 10px 0;
        }
        .trend-item {
            flex: 1;
            display: flex;
            flex-direction: column;
            align-items: center;
        }
        .trend-item .bar {
            width: 30px;
            background: #007bff;
            border-radius: 4px 4px 0 0;
            min-height: 5px;
            transition: height 0.5s;
        }
        .trend-item .bar.positive { background: #28a745; }
        .trend-item .bar.negative { background: #dc3545; }
        .trend-item .month {
            font-size: 11px;
            margin-top: 5px;
            color: #666;
        }
        .trend-item .amount {
            font-size: 10px;
            color: #333;
            font-weight: bold;
        }
        
        @media (max-width: 768px) {
            .two-column { grid-template-columns: 1fr; }
            .dashboard-grid { grid-template-columns: 1fr 1fr; }
            .filter-form { flex-direction: column; }
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
        
        <h1>Profit & Loss Dashboard</h1>
        
        <!-- Messages -->
        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
        <% } %>
        
        <!-- Date Filter -->
        <form action="${pageContext.request.contextPath}/profitLoss" method="get" class="filter-form">
            <div class="form-group">
                <label for="startDate">Start Date:</label>
                <input type="date" id="startDate" name="startDate" value="${startDate}">
            </div>
            <div class="form-group">
                <label for="endDate">End Date:</label>
                <input type="date" id="endDate" name="endDate" value="${endDate}">
            </div>
            <button type="submit" class="btn btn-primary">Update Report</button>
        </form>
        
        <!-- Summary Cards -->
        <div class="dashboard-grid">
            <div class="metric-card card-blue">
                <h3>Total Sales</h3>
                <div class="value" style="color: #007bff;">₹<fmt:formatNumber value="${report.totalSales}" pattern="#,##0.00"/></div>
                <div class="sub">Revenue from all sales</div>
            </div>
            
            <div class="metric-card card-red">
                <h3>Total Expenses</h3>
                <div class="value negative">₹<fmt:formatNumber value="${report.totalExpenses}" pattern="#,##0.00"/></div>
                <div class="sub">All operational costs</div>
            </div>
            
            <div class="metric-card card-green">
                <h3>Gross Profit</h3>
                <div class="value ${report.grossProfit >= 0 ? 'positive' : 'negative'}">
                    ₹<fmt:formatNumber value="${report.grossProfit}" pattern="#,##0.00"/>
                </div>
                <div class="sub">Sales - Cost of Goods Sold</div>
            </div>
            
            <div class="metric-card card-purple">
                <h3>Net Profit</h3>
                <div class="value ${report.netProfit >= 0 ? 'positive' : 'negative'}">
                    ₹<fmt:formatNumber value="${report.netProfit}" pattern="#,##0.00"/>
                </div>
                <div class="sub">Gross Profit - Expenses</div>
            </div>
        </div>
        
        <!-- Additional Metrics -->
        <div class="dashboard-grid">
            <div class="metric-card card-orange">
                <h3>Profit Margin</h3>
                <div class="value ${profitMargin >= 20 ? 'positive' : (profitMargin >= 10 ? 'neutral' : 'negative')}">
                    <fmt:formatNumber value="${profitMargin}" pattern="#0.0"/>%
                </div>
                <div class="sub">Net Profit / Total Sales × 100</div>
            </div>
            <div class="metric-card card-blue">
                <h3>Cost of Goods Sold</h3>
                <div class="value neutral">₹<fmt:formatNumber value="${report.totalPurchaseCost}" pattern="#,##0.00"/></div>
                <div class="sub">Total purchase cost of sold items</div>
            </div>
        </div>
        
        <!-- Category Breakdown -->
        <div class="section">
            <h3>Sales & Expenses by Category</h3>
            <div class="two-column">
                <!-- Sales by Category -->
                <div>
                    <h4 style="color: #007bff;">📊 Sales by Category</h4>
                    <c:forEach items="${report.salesByCategory}" var="entry">
                        <div class="category-item">
                            <span><strong>${entry.key}</strong></span>
                            <span>₹<fmt:formatNumber value="${entry.value}" pattern="#,##0.00"/></span>
                        </div>
                    </c:forEach>
                    <c:if test="${empty report.salesByCategory}">
                        <p style="color: #666;">No sales data available</p>
                    </c:if>
                </div>
                
                <!-- Expenses by Category -->
                <div>
                    <h4 style="color: #dc3545;">📊 Expenses by Category</h4>
                    <c:forEach items="${report.expensesByCategory}" var="entry">
                        <div class="category-item">
                            <span><strong>${entry.key}</strong></span>
                            <span>₹<fmt:formatNumber value="${entry.value}" pattern="#,##0.00"/></span>
                        </div>
                    </c:forEach>
                    <c:if test="${empty report.expensesByCategory}">
                        <p style="color: #666;">No expense data available</p>
                    </c:if>
                </div>
            </div>
        </div>
        
        <!-- Monthly Trend -->
        <div class="section monthly-trend">
            <h3>📈 Monthly Profit Trend (Last 6 Months)</h3>
            <div class="trend-bar">
                <c:forEach items="${report.monthlyProfit}" var="entry">
                    <div class="trend-item">
                        <c:set var="profit" value="${entry.value}" />
                        <c:set var="maxProfit" value="100000" />
                        <c:set var="height" value="${profit > 0 ? (profit / maxProfit * 100) : 0}" />
                        <div class="bar ${profit >= 0 ? 'positive' : 'negative'}" 
                             style="height: ${height > 150 ? 150 : height}px;">
                        </div>
                        <div class="amount">₹<fmt:formatNumber value="${profit}" pattern="#,##0"/></div>
                        <div class="month">${entry.key}</div>
                    </div>
                </c:forEach>
                <c:if test="${empty report.monthlyProfit}">
                    <div style="width: 100%; text-align: center; color: #666; padding: 40px 0;">
                        No monthly data available yet
                    </div>
                </c:if>
            </div>
        </div>
        
        <!-- Summary Table -->
        <div class="section">
            <h3>📋 Summary</h3>
            <table>
                <thead>
                    <tr>
                        <th>Metric</th>
                        <th>Amount</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td><strong>Total Sales</strong></td>
                        <td>₹<fmt:formatNumber value="${report.totalSales}" pattern="#,##0.00"/></td>
                        <td style="color: #007bff;">Revenue</td>
                    </tr>
                    <tr>
                        <td><strong>Cost of Goods Sold</strong></td>
                        <td>₹<fmt:formatNumber value="${report.totalPurchaseCost}" pattern="#,##0.00"/></td>
                        <td style="color: #ff9800;">Cost</td>
                    </tr>
                    <tr>
                        <td><strong>Gross Profit</strong></td>
                        <td>₹<fmt:formatNumber value="${report.grossProfit}" pattern="#,##0.00"/></td>
                        <td style="color: ${report.grossProfit >= 0 ? '#28a745' : '#dc3545'};">
                            ${report.grossProfit >= 0 ? '✅ Profit' : '❌ Loss'}
                        </td>
                    </tr>
                    <tr>
                        <td><strong>Total Expenses</strong></td>
                        <td>₹<fmt:formatNumber value="${report.totalExpenses}" pattern="#,##0.00"/></td>
                        <td style="color: #dc3545;">Operating Cost</td>
                    </tr>
                    <tr style="font-weight: bold; background: #f0f0f0;">
                        <td><strong>NET PROFIT / LOSS</strong></td>
                        <td style="font-size: 18px; color: ${report.netProfit >= 0 ? '#28a745' : '#dc3545'};">
                            ₹<fmt:formatNumber value="${report.netProfit}" pattern="#,##0.00"/>
                        </td>
                        <td style="color: ${report.netProfit >= 0 ? '#28a745' : '#dc3545'};">
                            ${report.netProfit >= 0 ? '🟢 PROFITABLE' : '🔴 LOSS'}
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>