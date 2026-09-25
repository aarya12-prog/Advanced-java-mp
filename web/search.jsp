<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Advanced Search - Hardware Inventory</title>

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        html, body {
            min-height: 100%;
        }

        body {
            font-family: "Segoe UI", Arial, sans-serif;
            background: #12090C;
            color: #3b2528;
            overflow-x: hidden;
            position: relative;
        }

        body::before {
            content: "";
            position: fixed;
            inset: 0;
            pointer-events: none;
            z-index: 0;

            background-image:
                url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='56' height='48' viewBox='0 0 56 48'%3E%3Cpath d='M14 1L28 9V25L14 33L0 25V9L14 1Z M42 15L56 23V39L42 47L28 39V23L42 15Z' fill='none' stroke='%23D5A94F' stroke-opacity='.08' stroke-width='1'/%3E%3C/svg%3E");

            background-repeat: repeat;
            background-attachment: fixed;
        }

        body::after {
            content: "";
            position: fixed;
            inset: 0;
            pointer-events: none;
            z-index: 0;

            background:
                linear-gradient(
                    135deg,
                    transparent 0%,
                    transparent 45%,
                    rgba(213,169,79,.04) 46%,
                    rgba(213,169,79,.04) 47%,
                    transparent 48%
                );

            background-size: 500px 500px;
            background-attachment: fixed;
        }

        .page-wrapper {
            position: relative;
            z-index: 1;
            min-height: 100vh;
            padding: 36px;
        }

        .card {
            max-width: 1250px;
            margin: 0 auto;

            background: rgba(255,248,238,.97);

            border: 1px solid rgba(213,169,79,.7);
            border-radius: 18px;

            padding: 30px;

            box-shadow:
                0 20px 60px rgba(0,0,0,.45),
                0 0 25px rgba(213,169,79,.08);
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

            box-shadow:
                0 6px 15px rgba(87,21,44,.25);
        }

        .header h1 {
            color: #57152C;
            font-size: 30px;
            font-weight: 700;
        }

        .header p {
            margin-top: 5px;
            color: #765d60;
            font-size: 14px;
        }

        .tabs {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;

            margin-left: auto;
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

        .tab:hover {
            background: #ead8ba;
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

        .filter-card {
            background: #fffaf2;
            border: 1px solid #e3cfa7;
            border-radius: 12px;
            padding: 22px;
        }

        .grid {
            display: grid;
            grid-template-columns:
                repeat(auto-fit, minmax(220px, 1fr));
            gap: 20px;
        }

        .form-group {
            margin-bottom: 5px;
        }

        .form-group label {
            display: block;
            margin-bottom: 7px;

            color: #57152C;

            font-weight: 600;
            font-size: 14px;
        }

        .form-control {
            width: 100%;

            padding: 11px 13px;

            border: 1px solid #d8c39b;
            border-radius: 8px;

            background: #fffdf8;
            color: #3b2528;

            outline: none;
            font-size: 14px;
        }

        .form-control:focus {
            border-color: #D5A94F;

            box-shadow:
                0 0 0 3px rgba(213,169,79,.15);
        }

        .price-range {
            display: grid;
            grid-template-columns: 1fr auto 1fr;
            gap: 10px;
            align-items: center;
        }

        .price-range span {
            color: #765d60;
            font-weight: 600;
        }

        .button-row {
            display: flex;
            gap: 10px;
            margin-top: 22px;
            flex-wrap: wrap;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;

            gap: 8px;

            padding: 11px 18px;

            border: none;
            border-radius: 9px;

            background: #57152C;
            color: #FFE9B2;

            font-size: 14px;
            font-weight: 600;

            cursor: pointer;
            text-decoration: none;
        }

        .btn:hover {
            background: #711F3A;
        }

        .btn-gold {
            background: #D5A94F;
            color: #35171E;
        }

        .btn-gold:hover {
            background: #c5983d;
        }

        .results-info {
            padding: 13px 16px;

            border-radius: 9px;

            margin-bottom: 18px;

            background: #fff1cb;
            color: #806308;

            font-size: 14px;
            font-weight: 600;
        }

        .table-container {
            width: 100%;
            overflow-x: auto;

            border-radius: 12px;
            border: 1px solid #e3cfa7;

            margin-top: 15px;
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
            font-size: 14px;
        }

        td {
            padding: 13px 15px;

            border-bottom: 1px solid #eadfcd;

            font-size: 14px;
        }

        tbody tr:hover {
            background: #fff3dc;
        }

        .item-name {
            color: #57152C;
            font-weight: 700;
        }

        .subtext {
            color: #765d60;
            font-size: 12px;
            margin-top: 3px;
        }

        .price {
            color: #57152C;
            font-weight: 700;
        }

        .badge {
            display: inline-block;

            padding: 5px 10px;

            border-radius: 20px;

            font-size: 12px;
            font-weight: 600;
        }

        .instock {
            background: #dff4e5;
            color: #23733b;
        }

        .lowstock {
            background: #fff0c9;
            color: #896a08;
        }

        .outofstock {
            background: #f9dede;
            color: #9c2929;
        }

        .no-results {
            text-align: center;
            padding: 45px 20px;

            color: #765d60;
        }

        @media (max-width: 850px) {
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
        }
    </style>
</head>

<body>

<div class="page-wrapper">

    <div class="card">

        <!-- HEADER -->
        <div class="header">

            <div class="icon">
                <i class="fa-solid fa-magnifying-glass"></i>
            </div>

            <div>
                <h1>Advanced Hardware Search</h1>
                <p>Search inventory items using detailed filters</p>
            </div>

            <div class="tabs">

                <a href="search" class="tab active">
                    <i class="fa-solid fa-magnifying-glass"></i>
                    Search
                </a>

                <a href="recommend" class="tab">
                    <i class="fa-solid fa-star"></i>
                    Recommend
                </a>

                <a href="feedback?action=view" class="tab">
                    <i class="fa-solid fa-comments"></i>
                    Feedback
                </a>

                <a href="feedback" class="tab">
                    <i class="fa-solid fa-pen"></i>
                    Submit Feedback
                </a>

            </div>
        </div>


        <!-- FILTER SECTION -->
        <div class="section-title">
            <i class="fa-solid fa-sliders"></i>
            <span>Search Filters</span>
        </div>

        <div class="filter-card">

            <form action="search" method="GET">

                <input type="hidden"
                       name="action"
                       value="search">

                <div class="grid">

                    <div class="form-group">
                        <label>Category</label>

                        <select name="category" class="form-control">

                            <option value="All">
                                All Categories
                            </option>

                            <c:forEach items="${categories}" var="cat">

                                <option value="${cat}"
                                    ${filter.category == cat ? 'selected' : ''}>
                                    ${cat}
                                </option>

                            </c:forEach>

                        </select>
                    </div>


                    <div class="form-group">
                        <label>Brand</label>

                        <select name="brand" class="form-control">

                            <option value="All">
                                All Brands
                            </option>

                            <c:forEach items="${brands}" var="br">

                                <option value="${br}"
                                    ${filter.brand == br ? 'selected' : ''}>
                                    ${br}
                                </option>

                            </c:forEach>

                        </select>
                    </div>


                    <div class="form-group">
                        <label>Stock Status</label>

                        <select name="stockStatus" class="form-control">

                            <option value="All">All Status</option>

                            <option value="In Stock"
                                ${filter.stockStatus == 'In Stock' ? 'selected' : ''}>
                                In Stock
                            </option>

                            <option value="Low Stock"
                                ${filter.stockStatus == 'Low Stock' ? 'selected' : ''}>
                                Low Stock
                            </option>

                            <option value="Out of Stock"
                                ${filter.stockStatus == 'Out of Stock' ? 'selected' : ''}>
                                Out of Stock
                            </option>

                        </select>
                    </div>


                    <div class="form-group">
                        <label>Item Status</label>

                        <select name="itemStatus" class="form-control">

                            <option value="All">All Items</option>

                            <option value="Active"
                                ${filter.itemStatus == 'Active' ? 'selected' : ''}>
                                Active
                            </option>

                            <option value="Discontinued"
                                ${filter.itemStatus == 'Discontinued' ? 'selected' : ''}>
                                Discontinued
                            </option>

                        </select>
                    </div>


                    <div class="form-group">

                        <label>Price Range (₹)</label>

                        <div class="price-range">

                            <input type="number"
                                   name="minPrice"
                                   class="form-control"
                                   placeholder="Min"
                                   value="${filter.minPrice}"
                                   step="0.01">

                            <span>to</span>

                            <input type="number"
                                   name="maxPrice"
                                   class="form-control"
                                   placeholder="Max"
                                   value="${filter.maxPrice}"
                                   step="0.01">

                        </div>

                    </div>


                    <div class="form-group">

                        <label>Sort By</label>

                        <select name="sortBy" class="form-control">

                            <option value="item_name"
                                ${filter.sortBy == 'item_name' ? 'selected' : ''}>
                                Name (A-Z)
                            </option>

                            <option value="price_low"
                                ${filter.sortBy == 'price_low' ? 'selected' : ''}>
                                Price: Low to High
                            </option>

                            <option value="price_high"
                                ${filter.sortBy == 'price_high' ? 'selected' : ''}>
                                Price: High to Low
                            </option>

                            <option value="quantity"
                                ${filter.sortBy == 'quantity' ? 'selected' : ''}>
                                Quantity
                            </option>

                        </select>

                    </div>


                    <div class="form-group">

                        <label>Search Keywords</label>

                        <input type="text"
                               name="keyword"
                               class="form-control"
                               placeholder="Search item name..."
                               value="${filter.keyword}">

                    </div>

                </div>


                <div class="button-row">

                    <button type="submit" class="btn btn-gold">
                        <i class="fa-solid fa-magnifying-glass"></i>
                        Search Items
                    </button>

                    <a href="search" class="btn">
                        <i class="fa-solid fa-rotate-left"></i>
                        Reset Filters
                    </a>

                </div>

            </form>

        </div>


        <!-- RESULTS -->
        <div class="section-title">
            <i class="fa-solid fa-table"></i>
            <span>Search Results</span>
        </div>


        <c:if test="${not empty searchError}">
            <div class="results-info">
                <i class="fa-solid fa-triangle-exclamation"></i>
                ${searchError}
            </div>
        </c:if>


        <c:if test="${not empty results}">

            <div class="results-info">
                <i class="fa-solid fa-boxes-stacked"></i>
                Found <strong>${resultCount}</strong> item(s)
            </div>


            <div class="table-container">

                <table>

                    <thead>
                        <tr>
                            <th>Item Details</th>
                            <th>Category</th>
                            <th>Brand</th>
                            <th>Supplier</th>
                            <th>Price</th>
                            <th>Stock Status</th>
                            <th>Location</th>
                        </tr>
                    </thead>

                    <tbody>

                        <c:forEach items="${results}" var="item">

                            <tr>

                                <td>
                                    <div class="item-name">
                                        ${item.itemName}
                                    </div>

                                    <div class="subtext">
                                        Model: ${item.modelNumber}
                                    </div>
                                </td>

                                <td>${item.category}</td>

                                <td>${item.brand}</td>

                                <td>${item.supplierName}</td>

                                <td class="price">

                                    <fmt:formatNumber
                                        value="${item.sellingPrice}"
                                        type="currency"
                                        currencySymbol="₹"/>

                                </td>

                                <td>

                                    <span class="badge ${item.stockStatusClass}">
                                        ${item.stockStatusText}
                                        (${item.quantity})
                                    </span>

                                </td>

                                <td>${item.location}</td>

                            </tr>

                        </c:forEach>

                    </tbody>

                </table>

            </div>

        </c:if>


        <c:if test="${empty results}">

            <div class="no-results">

                <i class="fa-solid fa-box-open"
                   style="font-size:35px;color:#D5A94F;"></i>

                <h3 style="margin-top:12px;">
                    No items to display
                </h3>

                <p style="margin-top:5px;">
                    Try changing your search filters.
                </p>

            </div>

        </c:if>

    </div>

</div>

</body>
</html>