<%-- 
    Document   : viewStock
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

    <title>Current Stock</title>

    <link rel="stylesheet" href="css/style.css">

</head>

<body>

    <!-- Header -->
    <div class="page-header">

        <h1>📋 Current Stock</h1>

    </div>

    <!-- Table Card -->
    <div class="table-card">

        <table>

            <thead>

                <tr>

                    <th>Item ID</th>
                    <th>Item Name</th>
                    <th>Quantity</th>
                    <th>Location</th>
                    <th>Reorder Level</th>
                    <th>Safety Stock</th>

                </tr>

            </thead>

            <tbody>

                <%

                    List<Stock> stockList = (List<Stock>) request.getAttribute("stockList");

                    if(stockList != null){

                        for(Stock stock : stockList){

                %>

                <tr>

                    <td><%= stock.getItemId() %></td>

                    <td><%= stock.getItemName() %></td>

                    <td><%= stock.getQuantity() %></td>

                    <td><%= stock.getLocation() %></td>

                    <td><%= stock.getReorderLevel() %></td>

                    <td><%= stock.getSafetyStock() %></td>

                </tr>

                <%

                        }

                    }

                %>

            </tbody>

        </table>

        <div style="text-align:center; margin-top:30px;">

            <a href="index.jsp" class="back">

                🏠 Back to Dashboard

            </a>

        </div>

    </div>

</body>

</html>