<%-- 
    Document   : reduceStock
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

    <title>Reduce Stock</title>

    <link rel="stylesheet" href="css/style.css">

</head>

<body>

    <!-- Header -->
    <div class="page-header">

        <h1>➖ Reduce Stock</h1>

    </div>

    <!-- Form Card -->
    <div class="card">

        <form action="ReduceStockServlet" method="post">

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

            <label for="quantity">Quantity</label>

            <input
                type="number"
                id="quantity"
                name="quantity"
                min="1"
                placeholder="Enter quantity"
                required>

            <label for="referenceNote">Reference Note</label>

            <input
                type="text"
                id="referenceNote"
                name="referenceNote"
                placeholder="Enter reference (optional)">

            <input type="submit" value="➖ Reduce Stock">

        </form>

        <div style="text-align:center; margin-top:25px;">

            <a href="index.jsp" class="back">

                🏠 Back to Dashboard

            </a>

        </div>

    </div>

</body>

</html>