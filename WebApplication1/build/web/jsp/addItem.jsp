<%-- 
    Document   : addItem
    Created on : 02-Aug-2026, 4:39:34 pm
    Author     : dines
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add New Item</title>
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
        
        <h1>Add New Item</h1>
        
        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger">
                <%= request.getAttribute("error") %>
            </div>
        <% } %>
        
        <form action="${pageContext.request.contextPath}/addItem" method="post">
            <div class="form-group">
                <label for="itemName">Item Name:</label>
                <input type="text" id="itemName" name="itemName" required>
            </div>
            
            <div class="form-group">
                <label for="category">Category:</label>
                <select id="category" name="category" required>
                    <option value="Computer">Computer</option>
                    <option value="Laptop">Laptop</option>
                    <option value="Printer">Printer</option>
                    <option value="Networking">Networking</option>
                    <option value="Monitor">Monitor</option>
                    <option value="Accessories">Accessories</option>
                    <option value="Computer Component">Computer Component</option>
                </select>
            </div>
            
            <div class="form-group">
                <label for="brand">Brand:</label>
                <input type="text" id="brand" name="brand">
            </div>
            
            <div class="form-group">
                <label for="modelNumber">Model Number:</label>
                <input type="text" id="modelNumber" name="modelNumber">
            </div>
            
            <div class="form-group">
                <label for="description">Description:</label>
                <textarea id="description" name="description" rows="3"></textarea>
            </div>
            
            <div class="form-group">
                <label for="supplierId">Supplier ID:</label>
                <input type="number" id="supplierId" name="supplierId" required>
            </div>
            
            <div class="form-group">
                <label for="purchasePrice">Purchase Price (₹):</label>
                <input type="number" step="0.01" id="purchasePrice" name="purchasePrice" required>
            </div>
            
            <div class="form-group">
                <label for="sellingPrice">Selling Price (₹):</label>
                <input type="number" step="0.01" id="sellingPrice" name="sellingPrice" required>
            </div>
            
            <div class="form-group">
                <label for="status">Status:</label>
                <select id="status" name="status">
                    <option value="Active">Active</option>
                    <option value="Discontinued">Discontinued</option>
                </select>
            </div>
            
            <button type="submit" class="btn btn-primary">Add Item</button>
            <a href="${pageContext.request.contextPath}/itemList" class="btn btn-secondary">Cancel</a>
        </form>
    </div>
</body>
</html>