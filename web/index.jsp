<%-- 
    Document   : index
    Created on : 31 Jul 2026, 8:02:24 pm
    Author     : Sajiv.v
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html>

<head>

    <title>Stock Management</title>

    <link rel="stylesheet" href="css/style.css">

</head>

<body>

    <div class="dashboard-header">

        <h1>Inventory Control System</h1>

        <h2>Stock Management Dashboard</h2>

    </div>


    <div class="menu">

        <a href="AddStockServlet">

            <div class="option">
                📦
                <br>
                Add Stock
            </div>

        </a>


        <a href="ReduceStockServlet">

            <div class="option">
                📤
                <br>
                Reduce Stock
            </div>

        </a>


        <a href="UpdateStockServlet">

            <div class="option">
                🔄
                <br>
                Update Stock
            </div>

        </a>


        <a href="ViewStockServlet">

            <div class="option">
                📊
                <br>
                View Current Stock
            </div>

        </a>


        <a href="ViewStockMovementServlet">

            <div class="option">
                📜
                <br>
                View Stock Movement
            </div>

        </a>

    </div>

</body>

</html>