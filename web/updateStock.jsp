<%-- 
    Document   : updateStock
    Created on : 31 Jul 2026
    Author     : Sajiv.v
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Stock" %>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <title>Update Stock</title>

    <link rel="stylesheet" href="css/style.css">

</head>

<body>

    <!-- Header -->
    <div class="page-header">

        <h1>✏️ Update Stock</h1>

    </div>

    <!-- Form Card -->
    <div class="card">

        <form action="UpdateStockServlet" method="post">

            <label for="itemId">Select Item</label>

            <select name="itemId" id="itemId" required>

                <%
                    List<Stock> itemList = (List<Stock>) request.getAttribute("itemList");

                    if(itemList != null){

                        for(Stock stock : itemList){
                %>

                    <option value="<%= stock.getItemId() %>">

                        <%= stock.getItemName() %>

                    </option>

                <%
                        }
                    }
                %>

            </select>

            <label for="newQuantity">New Quantity</label>

            <input
                type="number"
                id="newQuantity"
                name="newQuantity"
                min="0"
                placeholder="Enter new quantity"
                required>

            <label for="referenceNote">Reference Note</label>

            <input
                type="text"
                id="referenceNote"
                name="referenceNote"
                placeholder="Enter reference (optional)">

            <input type="submit" value="✏️ Update Stock">

        </form>

        <div style="text-align:center; margin-top:25px;">

            <a href="index.jsp" class="back">

                🏠 Back to Dashboard

            </a>

        </div>

    </div>

</body>

</html>