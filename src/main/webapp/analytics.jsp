<%--
Document   : analytics
Created on : 15 Sept 2026, 3:15:33 pm
Author     : aarya Thorat
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.text.DecimalFormat" %>

<!DOCTYPE html>

<html>

<head>
<meta charset="UTF-8">

<title>Inventory Analytics</title>

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<!-- FONT AWESOME -->
<link
    rel="stylesheet"
    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
>

<style>

    * {
        box-sizing: border-box;
        margin: 0;
        padding: 0;
    }

    :root {
        --teal-dark: #1f4657;
        --teal-main: #28586d;
        --teal-accent: #3f7f95;
        --teal-light: #eef6f8;
        --teal-soft: #eaf3f6;
        --teal-highlight: #72b9ca;

        --text-dark: #243b44;
        --text-muted: #71858d;

        --border: #c9dce2;
        --white: #ffffff;
    }

    html {
        min-height: 100%;
    }

    body {

        min-height: 100vh;

        font-family:
            "Segoe UI",
            Arial,
            sans-serif;

        color: var(--text-dark);

        background:
            linear-gradient(
                135deg,
                #eef6f8 0%,
                #e6f1f4 50%,
                #f5fafb 100%
            );

        overflow-x: hidden;

        position: relative;
    }


    /* =====================================================
       SUBTLE BACKGROUND
       ===================================================== */

    body::before {

        content: "";

        position: fixed;

        inset: 0;

        z-index: 0;

        pointer-events: none;

        background-image:
            linear-gradient(
                rgba(63,127,149,.035) 1px,
                transparent 1px
            ),
            linear-gradient(
                90deg,
                rgba(63,127,149,.035) 1px,
                transparent 1px
            );

        background-size: 40px 40px;
    }


    /* =====================================================
       PAGE WRAPPER
       ===================================================== */

    .page-wrapper {

        min-height: 100vh;

        padding: 28px 30px 35px;

        position: relative;

        z-index: 1;
    }


    /* =====================================================
       MAIN CARD
       ===================================================== */

    .card {

        width: 100%;

        max-width: 1180px;

        margin: 0 auto;

        padding: 28px 30px 32px;

        background: rgba(255,255,255,.97);

        border: 1px solid var(--border);

        border-radius: 18px;

        box-shadow:
            0 15px 45px rgba(31,70,87,.12);
    }


    /* =====================================================
       HEADER
       ===================================================== */

    .header {

        display: flex;

        align-items: center;

        justify-content: space-between;

        gap: 20px;

        margin-bottom: 25px;

        padding-bottom: 20px;

        border-bottom: 2px solid #d5e5ea;

        flex-wrap: wrap;
    }


    .header-left {

        display: flex;

        align-items: center;

        gap: 15px;
    }


    .icon {

        width: 54px;

        height: 54px;

        border-radius: 14px;

        display: flex;

        align-items: center;

        justify-content: center;

        background: var(--teal-main);

        color: #ffffff;

        box-shadow:
            0 7px 18px rgba(40,88,109,.18);

        font-size: 22px;
    }


    h1 {

        font-size: 29px;

        color: var(--teal-dark);

        letter-spacing: .1px;
    }


    h1 span {

        color: var(--teal-accent);
    }


    .subtitle {

        margin-top: 4px;

        font-size: 13px;

        color: var(--text-muted);
    }


    /* =====================================================
       HORIZONTAL TABS
       ===================================================== */

    .tabs {

        display: flex;

        gap: 8px;

        flex-wrap: wrap;

        justify-content: flex-end;
    }


    .tabs a {

        display: inline-flex;

        align-items: center;

        gap: 7px;

        text-decoration: none;

        color: var(--teal-dark);

        padding: 9px 15px;

        border-radius: 8px;

        font-size: 13px;

        font-weight: 600;

        border: 1px solid transparent;

        background: #edf4f6;

        transition: .2s ease;
    }


    .tabs a:hover {

        background: #dcecf1;

        border-color: #bdd4dc;
    }


    .tabs a.active {

        color: #ffffff;

        background: var(--teal-main);

        border-color: var(--teal-main);

        box-shadow:
            0 5px 12px rgba(40,88,109,.16);
    }


    /* =====================================================
       SECTION TITLE
       ===================================================== */

    .section-title {

        display: flex;

        align-items: center;

        gap: 13px;

        margin: 8px 0 18px;
    }


    .section-title h2 {

        font-size: 17px;

        color: var(--teal-dark);

        white-space: nowrap;
    }


    .section-title h2 i {

        color: var(--teal-accent);

        margin-right: 7px;
    }


    .section-line {

        height: 1px;

        flex: 1;

        background:
            linear-gradient(
                90deg,
                var(--teal-accent),
                transparent
            );
    }


    /* =====================================================
       ERROR
       ===================================================== */

    .error-box {

        background: #f8dddd;

        border: 1px solid #e0aeb4;

        color: #962d2d;

        padding: 14px 16px;

        border-radius: 10px;

        margin-bottom: 20px;

        font-size: 13px;

        word-break: break-word;
    }


    /* =====================================================
       SUMMARY CARDS
       ===================================================== */

    .metrics {

        display: grid;

        grid-template-columns:
            repeat(5, 1fr);

        gap: 14px;

        margin-bottom: 28px;
    }


    .metric {

        min-height: 130px;

        padding: 18px;

        border-radius: 14px;

        background:
            linear-gradient(
                145deg,
                #ffffff,
                #f2f8fa
            );

        border: 1px solid var(--border);

        box-shadow:
            0 7px 18px rgba(31,70,87,.08);

        display: flex;

        flex-direction: column;

        justify-content: center;
    }


    .metric-icon {

        width: 38px;

        height: 38px;

        border-radius: 10px;

        display: flex;

        align-items: center;

        justify-content: center;

        background: var(--teal-main);

        color: #ffffff;

        margin-bottom: 10px;

        font-size: 16px;
    }


    .metric-value {

        font-size: 25px;

        font-weight: 800;

        color: var(--teal-dark);

        line-height: 1.1;
    }


    .metric-label {

        font-size: 12px;

        font-weight: 600;

        color: var(--text-muted);

        margin-top: 5px;
    }


    /* =====================================================
       ANALYTICS GRID
       ===================================================== */

    .analytics-grid {

        display: grid;

        grid-template-columns:
            1fr 1fr;

        gap: 18px;

        margin-bottom: 25px;
    }


    .panel {

        background: #f8fbfc;

        border: 1px solid var(--border);

        border-radius: 15px;

        padding: 20px;

        box-shadow:
            0 7px 18px rgba(31,70,87,.06);
    }


    .panel h3 {

        color: var(--teal-dark);

        font-size: 15px;

        margin-bottom: 17px;

        display: flex;

        align-items: center;

        gap: 8px;
    }


    .panel h3 i {

        color: var(--teal-accent);
    }


    /* =====================================================
       STOCK STATUS
       ===================================================== */

    .stock-status {

        display: flex;

        align-items: center;

        gap: 28px;

        min-height: 210px;
    }


    .donut {

        width: 155px;

        height: 155px;

        border-radius: 50%;

        display: flex;

        align-items: center;

        justify-content: center;

        flex-shrink: 0;

        background:
            conic-gradient(
                #28586d
                0deg
                var(--critical-degree),

                #72b9ca
                var(--critical-degree)
                var(--low-degree),

                #6b9a72
                var(--low-degree)
                360deg
            );
    }


    .donut-inner {

        width: 105px;

        height: 105px;

        border-radius: 50%;

        background: #ffffff;

        display: flex;

        align-items: center;

        justify-content: center;

        flex-direction: column;

        border: 2px solid var(--border);
    }


    .donut-inner strong {

        font-size: 25px;

        color: var(--teal-dark);
    }


    .donut-inner span {

        font-size: 10px;

        color: var(--text-muted);

        font-weight: 700;
    }


    .legend {

        flex: 1;
    }


    .legend-row {

        display: flex;

        align-items: center;

        justify-content: space-between;

        margin: 12px 0;

        font-size: 13px;

        color: var(--text-dark);
    }


    .legend-left {

        display: flex;

        align-items: center;

        gap: 8px;

        font-weight: 600;
    }


    .legend-dot {

        width: 10px;

        height: 10px;

        border-radius: 50%;
    }


    .dot-critical {

        background: #28586d;
    }


    .dot-low {

        background: #72b9ca;
    }


    .dot-healthy {

        background: #6b9a72;
    }


    .legend-number {

        font-weight: 800;

        color: var(--teal-dark);
    }


    /* =====================================================
       CATEGORY TABLE
       ===================================================== */

    .mini-table {

        width: 100%;

        border-collapse: collapse;

        overflow: hidden;
    }


    .mini-table th {

        background: var(--teal-main);

        color: #ffffff;

        padding: 11px 10px;

        font-size: 11px;

        text-align: left;

        border-bottom: 2px solid var(--teal-highlight);
    }


    .mini-table td {

        padding: 10px;

        font-size: 12px;

        color: var(--text-dark);

        border-bottom: 1px solid #e2edf0;
    }


    .mini-table tbody tr:nth-child(even) {

        background: #f6fafb;
    }


    .mini-table tbody tr:hover {

        background: #edf6f8;
    }


    .stock-number {

        font-weight: 800;

        color: var(--teal-dark);
    }


    /* =====================================================
       ALERT TABLE
       ===================================================== */

    .full-panel {

        margin-top: 5px;
    }


    .table-wrap {

        overflow-x: auto;

        border-radius: 12px;

        border: 1px solid var(--border);

        background: #ffffff;
    }


    table {

        width: 100%;

        border-collapse: collapse;
    }


    thead th {

        background: var(--teal-main);

        color: #ffffff;

        padding: 13px 12px;

        text-align: left;

        font-size: 12px;

        border-bottom: 2px solid var(--teal-highlight);

        white-space: nowrap;
    }


    tbody td {

        padding: 12px;

        font-size: 12px;

        color: var(--text-dark);

        border-bottom: 1px solid #e2edf0;
    }


    tbody tr:nth-child(even) {

        background: #f7fafb;
    }


    tbody tr:hover {

        background: #edf6f8;
    }


    .badge {

        display: inline-flex;

        align-items: center;

        padding: 5px 10px;

        border-radius: 999px;

        font-size: 10px;

        font-weight: 800;
    }


    .badge-critical {

        background: #f8dddd;

        color: #962d2d;

        border: 1px solid #e0aeb4;
    }


    .badge-low {

        background: #e4f1d9;

        color: #4d7047;

        border: 1px solid #bfd4b5;
    }


    .empty {

        text-align: center;

        padding: 28px !important;

        color: var(--text-muted) !important;
    }


    .empty i {

        font-size: 28px;

        color: #6b9a72;

        margin-bottom: 8px;
    }


    /* =====================================================
       FOOTER
       ===================================================== */

    .footer {

        display: flex;

        align-items: center;

        justify-content: space-between;

        gap: 15px;

        margin-top: 24px;

        padding-top: 16px;

        border-top: 1px solid var(--border);

        font-size: 11px;

        color: var(--text-muted);
    }


    .footer a {

        text-decoration: none;

        color: var(--teal-main);

        font-weight: 800;
    }


    /* =====================================================
       RESPONSIVE
       ===================================================== */

    @media(max-width:1050px) {

        .metrics {

            grid-template-columns:
                repeat(3,1fr);
        }
    }


    @media(max-width:800px) {

        .analytics-grid {

            grid-template-columns: 1fr;
        }

        .metrics {

            grid-template-columns:
                repeat(2,1fr);
        }

        .stock-status {

            flex-direction: column;

            justify-content: center;
        }
    }


    @media(max-width:550px) {

        .page-wrapper {

            padding: 10px;
        }

        .card {

            padding: 20px 15px;

            border-radius: 15px;
        }

        .metrics {

            grid-template-columns: 1fr;
        }

        .header {

            align-items: flex-start;

            flex-direction: column;
        }

        .tabs {

            width: 100%;
        }

        .tabs a {

            flex: 1;

            justify-content: center;

            text-align: center;
        }

        h1 {

            font-size: 24px;
        }
    }


    body,
    body::before,
    .card {

        animation: none !important;
    }

</style>
</head>

<body>

<div class="page-wrapper">

<div class="card">


    <!-- =================================================
         HEADER
         ================================================= -->

    <div class="header">

        <div class="header-left">

            <div class="icon">

                <i class="fa-solid fa-chart-line"></i>

            </div>


            <div>

                <h1>
                    Inventory
                    <span>Analytics</span>
                </h1>

                <div class="subtitle">
                    Inventory health and stock performance overview
                </div>

            </div>

        </div>


        <!-- HORIZONTAL NAVIGATION -->

        <div class="tabs">

            <!-- ANALYTICS FIRST -->

            <a href="AnalyticsServlet"
               class="active">

                <i class="fa-solid fa-chart-line"></i>

                Analytics

            </a>


            <!-- LOW STOCK -->

            <a href="ReorderServlet">

                <i class="fa-solid fa-triangle-exclamation"></i>

                Low Stock

            </a>


            <!-- REORDER HISTORY -->

            <a href="ReorderHistoryServlet">

                <i class="fa-solid fa-clock-rotate-left"></i>

                Reorder History

            </a>

        </div>

    </div>


    <!-- =================================================
         ERROR MESSAGE
         ================================================= -->

    <%

        String errorMessage =
                (String) request.getAttribute("errorMessage");

        if(errorMessage != null){

    %>

        <div class="error-box">

            <i class="fa-solid fa-circle-exclamation"></i>

            Unable to load analytics:

            <%= errorMessage %>

        </div>

    <%

        }

    %>


    <%

        Integer totalProducts =
                (Integer) request.getAttribute("totalProducts");

        Integer totalStock =
                (Integer) request.getAttribute("totalStock");

        Integer lowStockProducts =
                (Integer) request.getAttribute("lowStockProducts");

        Integer criticalStockProducts =
                (Integer) request.getAttribute("criticalStockProducts");

        Double inventoryValue =
                (Double) request.getAttribute("inventoryValue");


        if(totalProducts == null)
            totalProducts = 0;

        if(totalStock == null)
            totalStock = 0;

        if(lowStockProducts == null)
            lowStockProducts = 0;

        if(criticalStockProducts == null)
            criticalStockProducts = 0;

        if(inventoryValue == null)
            inventoryValue = 0.0;


        DecimalFormat moneyFormat =
                new DecimalFormat("#,##0.00");

    %>


    <!-- =================================================
         OVERVIEW
         ================================================= -->

    <div class="section-title">

        <h2>

            <i class="fa-solid fa-gauge-high"></i>

            Inventory Overview

        </h2>

        <div class="section-line"></div>

    </div>


    <div class="metrics">


        <!-- TOTAL PRODUCTS -->

        <div class="metric">

            <div class="metric-icon">

                <i class="fa-solid fa-box"></i>

            </div>

            <div class="metric-value">

                <%= totalProducts %>

            </div>

            <div class="metric-label">

                Total Products

            </div>

        </div>


        <!-- TOTAL STOCK -->

        <div class="metric">

            <div class="metric-icon">

                <i class="fa-solid fa-cubes"></i>

            </div>

            <div class="metric-value">

                <%= totalStock %>

            </div>

            <div class="metric-label">

                Total Stock Units

            </div>

        </div>


        <!-- LOW STOCK -->

        <div class="metric">

            <div class="metric-icon">

                <i class="fa-solid fa-triangle-exclamation"></i>

            </div>

            <div class="metric-value">

                <%= lowStockProducts %>

            </div>

            <div class="metric-label">

                Low Stock Products

            </div>

        </div>


        <!-- CRITICAL -->

        <div class="metric">

            <div class="metric-icon">

                <i class="fa-solid fa-circle-exclamation"></i>

            </div>

            <div class="metric-value">

                <%= criticalStockProducts %>

            </div>

            <div class="metric-label">

                Critical Stock

            </div>

        </div>


        <!-- VALUE -->

        <div class="metric">

            <div class="metric-icon">

                <i class="fa-solid fa-indian-rupee-sign"></i>

            </div>

            <div class="metric-value"
                 style="font-size:20px;">

                ₹<%= moneyFormat.format(inventoryValue) %>

            </div>

            <div class="metric-label">

                Inventory Value

            </div>

        </div>

    </div>


    <!-- =================================================
         CHART / CATEGORY
         ================================================= -->

    <div class="analytics-grid">


        <!-- STOCK STATUS -->

        <div class="panel">

            <h3>

                <i class="fa-solid fa-chart-pie"></i>

                Stock Status Distribution

            </h3>


            <%

                Integer healthyStock =
                        (Integer)
                        request.getAttribute("healthyStock");

                Integer lowStock =
                        (Integer)
                        request.getAttribute("lowStock");

                Integer criticalStock =
                        (Integer)
                        request.getAttribute("criticalStock");


                if(healthyStock == null)
                    healthyStock = 0;

                if(lowStock == null)
                    lowStock = 0;

                if(criticalStock == null)
                    criticalStock = 0;


                int totalStatus =
                        healthyStock
                        + lowStock
                        + criticalStock;


                double criticalDegree = 0;

                double lowDegree = 0;


                if(totalStatus > 0){

                    criticalDegree =
                            (criticalStock * 360.0)
                            / totalStatus;

                    lowDegree =
                            criticalDegree
                            +
                            (lowStock * 360.0)
                            / totalStatus;
                }

            %>


            <div class="stock-status">


                <div
                    class="donut"
                    style="
                        --critical-degree:<%= criticalDegree %>deg;
                        --low-degree:<%= lowDegree %>deg;
                    "
                >

                    <div class="donut-inner">

                        <strong>
                            <%= totalStatus %>
                        </strong>

                        <span>
                            PRODUCTS
                        </span>

                    </div>

                </div>


                <div class="legend">


                    <div class="legend-row">

                        <div class="legend-left">

                            <span
                                class="legend-dot dot-healthy">
                            </span>

                            Healthy Stock

                        </div>

                        <span class="legend-number">

                            <%= healthyStock %>

                        </span>

                    </div>


                    <div class="legend-row">

                        <div class="legend-left">

                            <span
                                class="legend-dot dot-low">
                            </span>

                            Low Stock

                        </div>

                        <span class="legend-number">

                            <%= lowStock %>

                        </span>

                    </div>


                    <div class="legend-row">

                        <div class="legend-left">

                            <span
                                class="legend-dot dot-critical">
                            </span>

                            Critical Stock

                        </div>

                        <span class="legend-number">

                            <%= criticalStock %>

                        </span>

                    </div>


                </div>

            </div>

        </div>


        <!-- CATEGORY ANALYSIS -->

        <div class="panel">

            <h3>

                <i class="fa-solid fa-layer-group"></i>

                Category-wise Inventory

            </h3>


            <%

                List<Map<String,Object>> categoryList =

                    (List<Map<String,Object>>)

                    request.getAttribute("categoryList");

            %>


            <div class="table-wrap">

                <table class="mini-table">

                    <thead>

                        <tr>

                            <th>
                                Category
                            </th>

                            <th>
                                Products
                            </th>

                            <th>
                                Stock Units
                            </th>

                        </tr>

                    </thead>


                    <tbody>


                    <%

                        if(categoryList != null
                           && !categoryList.isEmpty()){

                            for(Map<String,Object> row :
                                categoryList){

                    %>

                        <tr>

                            <td>

                                <%= row.get("category") %>

                            </td>

                            <td>

                                <%= row.get("productCount") %>

                            </td>

                            <td class="stock-number">

                                <%= row.get("stockCount") %>

                            </td>

                        </tr>

                    <%

                            }

                        }else{

                    %>

                        <tr>

                            <td
                                colspan="3"
                                class="empty"
                            >

                                No category data available.

                            </td>

                        </tr>

                    <%

                        }

                    %>


                    </tbody>

                </table>

            </div>

        </div>

    </div>


    <!-- =================================================
         ALERT PRODUCTS
         ================================================= -->

    <div class="section-title">

        <h2>

            <i class="fa-solid fa-bell"></i>

            Inventory Alerts

        </h2>

        <div class="section-line"></div>

    </div>


    <div class="panel full-panel">


        <h3>

            <i class="fa-solid fa-triangle-exclamation"></i>

            Products Requiring Attention

        </h3>


        <%

            List<Map<String,Object>> alertList =

                (List<Map<String,Object>>)

                request.getAttribute("alertList");

        %>


        <div class="table-wrap">

            <table>

                <thead>

                    <tr>

                        <th>
                            Product ID
                        </th>

                        <th>
                            Product Name
                        </th>

                        <th>
                            Category
                        </th>

                        <th>
                            Current Qty
                        </th>

                        <th>
                            Safety Stock
                        </th>

                        <th>
                            Reorder Level
                        </th>

                        <th>
                            Status
                        </th>

                    </tr>

                </thead>


                <tbody>


                <%

                    if(alertList != null
                       && !alertList.isEmpty()){

                        for(Map<String,Object> row :
                            alertList){

                            String status =
                                String.valueOf(
                                    row.get("status")
                                );

                            String badgeClass =
                                status.equals("Critical")
                                ? "badge-critical"
                                : "badge-low";

                %>

                    <tr>

                        <td>

                            #<%= row.get("itemId") %>

                        </td>


                        <td>

                            <strong>
                                <%= row.get("itemName") %>
                            </strong>

                        </td>


                        <td>

                            <%= row.get("category") %>

                        </td>


                        <td>

                            <strong>
                                <%= row.get("quantity") %>
                            </strong>

                        </td>


                        <td>

                            <%= row.get("safetyStock") %>

                        </td>


                        <td>

                            <%= row.get("reorderLevel") %>

                        </td>


                        <td>

                            <span
                                class="badge <%= badgeClass %>"
                            >

                                <%= status %>

                            </span>

                        </td>

                    </tr>

                <%

                        }

                    }else{

                %>

                    <tr>

                        <td
                            colspan="7"
                            class="empty"
                        >

                            <i
                                class="fa-solid fa-circle-check"
                                style="display:block;"
                            ></i>

                            <strong>
                                All inventory levels are healthy
                            </strong>

                            <br>

                            No products currently require attention.

                        </td>

                    </tr>

                <%

                    }

                %>


                </tbody>

            </table>

        </div>

    </div>


    <!-- =================================================
         FOOTER
         ================================================= -->

    <div class="footer">

        <div>

            <i
                class="fa-solid fa-circle"
                style="
                    color:#28586d;
                    font-size:8px;
                "
            ></i>

            Inventory Analytics Dashboard

        </div>


        <div>

            <a href="ReorderServlet">

                View Low Stock

                <i
                    class="fa-solid fa-arrow-right"
                ></i>

            </a>

        </div>

    </div>


</div>
</div>

</body>

</html>
