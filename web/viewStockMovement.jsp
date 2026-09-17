<%-- 
    Document   : viewStockMovement
    Created on : 31 Jul 2026
    Author     : Sajiv.v
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.StockMovement" %>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <title>Stock Movement History</title>

    <link rel="stylesheet" href="css/style.css">

</head>

<body>

    <!-- Header -->
    <div class="page-header">

        <h1>📈 Stock Movement History</h1>

    </div>

    <!-- Table Card -->
    <div class="table-card">

        <table>

            <thead>

                <tr>

                    <th>Movement ID</th>
                    <th>Item ID</th>
                    <th>Movement Type</th>
                    <th>Quantity</th>
                    <th>Reference Note</th>
                    <th>Movement Date</th>

                </tr>

            </thead>

            <tbody>

                <%

                    List<StockMovement> movementList =
                            (List<StockMovement>) request.getAttribute("movementList");

                    if(movementList != null){

                        for(StockMovement movement : movementList){

                %>

                <tr>

                    <td><%= movement.getMovementId() %></td>

                    <td><%= movement.getItemId() %></td>

                    <td><%= movement.getMovementType() %></td>

                    <td><%= movement.getQuantity() %></td>

                    <td><%= movement.getReferenceNote() %></td>

                    <td><%= movement.getMovementDate() %></td>

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