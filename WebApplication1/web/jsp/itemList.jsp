<%-- 
    Document   : itemList
    Created on : 02-Aug-2026, 4:40:28 pm
    Author     : dines
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Item List</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="container">
        <div class="nav">
            <a href="${pageContext.request.contextPath}/itemList">Items</a>
            <a href="${pageContext.request.contextPath}/addItem">Add Item</a>
            <a href="${pageContext.request.contextPath}/expense">Expenses</a>
            <a href="${pageContext.request.contextPath}/profitLoss">Profit/Loss</a>
        </div>
        
        <h1>Item List</h1>
        
        <% if (request.getParameter("message") != null) { %>
            <div class="alert alert-success">
                <%= request.getParameter("message") %>
            </div>
        <% } %>
        
        <div class="actions">
            <a href="${pageContext.request.contextPath}/addItem" class="btn btn-primary">Add New Item</a>
        </div>
        
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Category</th>
                    <th>Brand</th>
                    <th>Model</th>
                    <th>Purchase Price</th>
                    <th>Selling Price</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${items}" var="item">
                    <tr>
                        <td>${item.itemId}</td>
                        <td>${item.itemName}</td>
                        <td>${item.category}</td>
                        <td>${item.brand}</td>
                        <td>${item.modelNumber}</td>
                        <td>₹${item.purchasePrice}</td>
                        <td>₹${item.sellingPrice}</td>
                        <td>
                            <span style="color: ${item.status == 'Active' ? 'green' : 'red'}">
                                ${item.status}
                            </span>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</body>
</html>