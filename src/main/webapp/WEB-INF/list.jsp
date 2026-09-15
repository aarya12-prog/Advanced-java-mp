<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ taglib prefix="c"
           uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Hardware Inventory</title>

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>

        /* USE THE SAME COMMON THEME FROM THE OTHER JSPs */

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: "Segoe UI", Arial, sans-serif;
            background: #12090C;
            color: #3b2528;
            min-height: 100vh;
        }

        body::before {
            content: "";
            position: fixed;
            inset: 0;
            pointer-events: none;

            background-image:
                url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='56' height='48' viewBox='0 0 56 48'%3E%3Cpath d='M14 1L28 9V25L14 33L0 25V9L14 1Z M42 15L56 23V39L42 47L28 39V23L42 15Z' fill='none' stroke='%23D5A94F' stroke-opacity='.08' stroke-width='1'/%3E%3C/svg%3E");
        }

        .page-wrapper {
            position: relative;
            z-index: 1;

            min-height: 100vh;
            padding: 36px;
        }

        .card {
            max-width: 1350px;
            margin: auto;

            background: rgba(255,248,238,.97);

            border: 1px solid rgba(213,169,79,.7);
            border-radius: 18px;

            padding: 30px;

            box-shadow:
                0 20px 60px rgba(0,0,0,.45);
        }

        .header {
            display: flex;
            align-items: center;
            gap: 18px;

            padding-bottom: 22px;
            margin-bottom: 25px;

            border-bottom: 2px solid #D5A94F;
        }

        .icon {
            width: 58px;
            height: 58px;

            display: flex;
            align-items: center;
            justify-content: center;

            background: #57152C;
            color: #D5A94F;

            border-radius: 14px;
            font-size: 24px;
        }

        .header h1 {
            color: #57152C;
            font-size: 30px;
        }

        .header p {
            margin-top: 5px;
            color: #765d60;
            font-size: 14px;
        }

        .tabs {
            margin-left: auto;

            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }

        .tab {
            padding: 9px 15px;

            border-radius: 8px;

            background: #f0e5d2;
            color: #57152C;

            text-decoration: none;

            font-size: 13px;
            font-weight: 600;
        }

        .tab.active {
            background: #57152C;
            color: #FFE9B2;
        }

        .section-title {
            color: #57152C;

            font-size: 20px;
            font-weight: 700;

            margin: 25px 0 15px;

            display: flex;
            align-items: center;
            gap: 10px;
        }

        .section-title i {
            color: #D5A94F;
        }

        .grid {
            display: grid;
            grid-template-columns:
                repeat(3, 1fr);

            gap: 20px;
        }

        .stat-card {
            background: #fffaf2;

            border: 1px solid #e3cfa7;

            border-radius: 12px;

            padding: 20px;
        }

        .stat-icon {
            color: #D5A94F;
            font-size: 22px;
        }

        .stat-card h3 {
            margin-top: 10px;

            color: #57152C;

            font-size: 26px;
        }

        .stat-card p {
            color: #765d60;
            font-size: 13px;
        }

        .action-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;

            gap: 15px;

            margin-bottom: 20px;
        }

        .search-box {
            display: flex;
            gap: 10px;

            flex: 1;
        }

        .form-control {
            width: 100%;

            padding: 11px 13px;

            border: 1px solid #d8c39b;
            border-radius: 8px;

            background: #fffdf8;
            color: #3b2528;

            outline: none;
        }

        .btn {
            display: inline-flex;

            align-items: center;
            justify-content: center;

            gap: 8px;

            padding: 11px 16px;

            border: none;
            border-radius: 9px;

            background: #57152C;
            color: #FFE9B2;

            text-decoration: none;

            font-size: 14px;
            font-weight: 600;

            cursor: pointer;

            white-space: nowrap;
        }

        .btn-gold {
            background: #D5A94F;
            color: #35171E;
        }

        .btn-edit {
            background: #f0e5d2;
            color: #57152C;
        }

        .btn-delete {
            background: #f9dede;
            color: #962d2d;
        }

        .table-container {
            width: 100%;
            overflow-x: auto;

            border-radius: 12px;
            border: 1px solid #e3cfa7;
        }

        table {
            width: 100%;
            border-collapse: collapse;

            background: #fffaf2;
        }

        th {
            background: #57152C;
            color: #FFE9B2;

            padding: 14px 15px;

            text-align: left;

            font-size: 13px;
        }

        td {
            padding: 13px 15px;

            border-bottom: 1px solid #eadfcd;

            font-size: 14px;
        }

        tbody tr:hover {
            background: #fff3dc;
        }

        .badge {
            display: inline-block;

            padding: 5px 10px;

            border-radius: 20px;

            font-size: 12px;
            font-weight: 600;
        }

        .badge-available {
            background: #dff4e5;
            color: #23733b;
        }

        .badge-in-use {
            background: #dceeff;
            color: #24628c;
        }

        .badge-repair {
            background: #fff0c9;
            color: #896a08;
        }

        .badge-retired {
            background: #f9dede;
            color: #9c2929;
        }

        .alert {
            padding: 13px 16px;

            border-radius: 9px;

            margin-bottom: 18px;

            background: #e1f4e6;
            color: #236b36;
        }

        .empty-state {
            text-align: center;
            padding: 50px;
            color: #765d60;
        }

        @media(max-width:850px) {

            .page-wrapper {
                padding: 20px;
            }

            .card {
                padding: 20px;
            }

            .header {
                flex-wrap: wrap;
            }

            .tabs {
                width: 100%;
                margin-left: 0;
            }

            .grid {
                grid-template-columns: 1fr;
            }

            .action-bar {
                flex-direction: column;
                align-items: stretch;
            }

            .search-box {
                width: 100%;
            }

        }

    </style>

</head>

<body>

<div class="page-wrapper">

    <div class="card">

        <!-- HEADER -->

        <div class="header">

            <div class="icon">
                <i class="fa-solid fa-boxes-stacked"></i>
            </div>

            <div>

                <h1>Hardware Inventory</h1>

                <p>
                    Manage and monitor hardware inventory items
                </p>

            </div>

            <div class="tabs">

                <a href="hardware"
                   class="tab active">

                    <i class="fa-solid fa-boxes-stacked"></i>
                    Inventory

                </a>

                <a href="hardware?action=new"
                   class="tab">

                    <i class="fa-solid fa-plus"></i>
                    Add Hardware

                </a>

                <a href="search"
                   class="tab">

                    <i class="fa-solid fa-magnifying-glass"></i>
                    Search

                </a>

                <a href="recommend"
                   class="tab">

                    <i class="fa-solid fa-star"></i>
                    Recommend

                </a>

            </div>

        </div>


        <!-- MESSAGE -->

        <c:if test="${not empty sessionScope.message}">

            <div class="alert">

                <i class="fa-solid fa-circle-check"></i>

                ${sessionScope.message}

            </div>

            <c:remove var="message"
                      scope="session"/>

        </c:if>


        <c:if test="${not empty sessionScope.error}">

            <div class="alert"
                 style="background:#f9dede;color:#962d2d;">

                <i class="fa-solid fa-triangle-exclamation"></i>

                ${sessionScope.error}

            </div>

            <c:remove var="error"
                      scope="session"/>

        </c:if>


        <!-- STATISTICS -->

        <div class="section-title">

            <i class="fa-solid fa-chart-column"></i>

            <span>Inventory Overview</span>

        </div>


        <div class="grid">

            <div class="stat-card">

                <div class="stat-icon">
                    <i class="fa-solid fa-boxes-stacked"></i>
                </div>

                <h3>${totalItems}</h3>

                <p>Total Items</p>

            </div>


            <div class="stat-card">

                <div class="stat-icon">
                    <i class="fa-solid fa-circle-check"></i>
                </div>

                <h3>${availableItems}</h3>

                <p>Available</p>

            </div>


            <div class="stat-card">

                <div class="stat-icon">
                    <i class="fa-solid fa-user-check"></i>
                </div>

                <h3>${inUseItems}</h3>

                <p>In Use</p>

            </div>

        </div>


        <!-- SEARCH / ACTIONS -->

        <div class="section-title">

            <i class="fa-solid fa-list"></i>

            <span>Hardware Records</span>

        </div>


        <div class="action-bar">

            <form action="hardware"
                  method="get"
                  class="search-box">

                <input type="hidden"
                       name="action"
                       value="search">

                <input type="text"
                       name="keyword"
                       class="form-control"
                       placeholder="Search hardware..."
                       value="${keyword}">

                <button type="submit"
                        class="btn">

                    <i class="fa-solid fa-magnifying-glass"></i>
                    Search

                </button>


                <c:if test="${not empty keyword}">

                    <a href="hardware"
                       class="btn">

                        <i class="fa-solid fa-xmark"></i>
                        Clear

                    </a>

                </c:if>

            </form>


            <a href="hardware?action=new"
               class="btn btn-gold">

                <i class="fa-solid fa-plus"></i>
                Add Hardware

            </a>

        </div>


        <!-- TABLE -->

        <div class="table-container">

            <c:choose>

                <c:when test="${empty hardwareList}">

                    <div class="empty-state">

                        <i class="fa-solid fa-box-open"
                           style="font-size:40px;color:#D5A94F;"></i>

                        <h3 style="margin-top:12px;">
                            No hardware items found
                        </h3>

                        <a href="hardware?action=new"
                           class="btn btn-gold"
                           style="margin-top:15px;">

                            <i class="fa-solid fa-plus"></i>
                            Add First Item

                        </a>

                    </div>

                </c:when>


                <c:otherwise>

                    <table>

                        <thead>

                            <tr>

                                <th>ID</th>
                                <th>Name</th>
                                <th>Category</th>
                                <th>Brand</th>
                                <th>Serial No.</th>
                                <th>Qty</th>
                                <th>Price (₹)</th>
                                <th>Status</th>
                                <th>Location</th>
                                <th>Actions</th>

                            </tr>

                        </thead>


                        <tbody>

                            <c:forEach var="item"
                                       items="${hardwareList}">

                                <tr>

                                    <td>
                                        <strong>#${item.id}</strong>
                                    </td>

                                    <td>
                                        <strong style="color:#57152C;">
                                            ${item.hardwareName}
                                        </strong>
                                    </td>

                                    <td>${item.category}</td>

                                    <td>${item.brand}</td>

                                    <td>${item.serialNumber}</td>

                                    <td>${item.quantity}</td>

                                    <td>
                                        ₹${item.unitPrice}
                                    </td>

                                    <td>

                                        <c:choose>

                                            <c:when test="${item.status == 'Available'}">

                                                <span class="badge badge-available">
                                                    Available
                                                </span>

                                            </c:when>

                                            <c:when test="${item.status == 'In Use'}">

                                                <span class="badge badge-in-use">
                                                    In Use
                                                </span>

                                            </c:when>

                                            <c:when test="${item.status == 'Under Repair'}">

                                                <span class="badge badge-repair">
                                                    Repair
                                                </span>

                                            </c:when>

                                            <c:otherwise>

                                                <span class="badge badge-retired">
                                                    Retired
                                                </span>

                                            </c:otherwise>

                                        </c:choose>

                                    </td>

                                    <td>
                                        ${item.location}
                                    </td>

                                    <td>

                                        <div style="display:flex;
                                                    gap:6px;">

                                            <a href="hardware?action=edit&id=${item.id}"
                                               class="btn btn-edit">

                                                <i class="fa-solid fa-pen"></i>
                                                Edit

                                            </a>

                                            <a href="hardware?action=delete&id=${item.id}"
                                               class="btn btn-delete"
                                               onclick="return confirm('Delete this item?')">

                                                <i class="fa-solid fa-trash"></i>
                                                Delete

                                            </a>

                                        </div>

                                    </td>

                                </tr>

                            </c:forEach>

                        </tbody>

                    </table>

                </c:otherwise>

            </c:choose>

        </div>

    </div>

</div>

</body>

</html>