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

    html,
    body {
        width: 100%;
        min-height: 100%;
    }

    body {
        font-family: "Segoe UI", Arial, sans-serif;
        background: #eef6f8;
        color: #243b44;
        overflow-x: hidden;
    }

    /* =========================
       PAGE
       ========================= */

    .page-wrapper {
        width: 100%;
        min-height: 100vh;
        padding: 28px;
    }

    .card {
        width: 100%;
        min-height: calc(100vh - 56px);

        background: #ffffff;

        border: 1px solid #d7e6eb;
        border-radius: 16px;

        padding: 30px;

        box-shadow: 0 8px 30px rgba(31, 70, 87, 0.08);
    }

    /* =========================
       HEADER
       ========================= */

    .header {
        display: flex;
        align-items: center;
        gap: 16px;

        padding-bottom: 22px;
        margin-bottom: 25px;

        border-bottom: 1px solid #d8e6eb;
    }

    .icon {
        width: 54px;
        height: 54px;

        display: flex;
        align-items: center;
        justify-content: center;

        background: #28586d;
        color: #ffffff;

        border-radius: 12px;

        font-size: 21px;

        box-shadow: 0 5px 14px rgba(40, 88, 109, 0.18);
    }

    .header h1 {
        color: #1f4657;
        font-size: 27px;
        font-weight: 700;
        letter-spacing: -0.3px;
    }

    .header p {
        margin-top: 5px;
        color: #71858d;
        font-size: 14px;
    }

    /* =========================
       TOP TABS
       ========================= */

    .tabs {
        display: flex;
        flex-wrap: wrap;
        gap: 8px;

        margin-left: auto;
    }

    .tab {
        padding: 9px 14px;

        border-radius: 8px;

        background: #eef5f7;
        color: #28586d;

        text-decoration: none;

        font-size: 13px;
        font-weight: 600;

        transition: all 0.2s ease;
    }

    .tab:hover {
        background: #dcecf1;
        color: #1f4657;
    }

    .tab.active {
        background: #28586d;
        color: #ffffff;
    }

    /* =========================
       SECTION TITLE
       ========================= */

    .section-title {
        color: #1f4657;

        font-size: 19px;
        font-weight: 700;

        margin: 24px 0 14px;

        display: flex;
        align-items: center;
        gap: 10px;
    }

    .section-title i {
        color: #3f7f95;
        font-size: 17px;
    }

    /* =========================
       FILTER CARD
       ========================= */

    .filter-card {
        background: #f8fbfc;

        border: 1px solid #d8e7ec;
        border-radius: 12px;

        padding: 22px;
    }

    .grid {
        display: grid;

        grid-template-columns:
            repeat(auto-fit, minmax(220px, 1fr));

        gap: 18px;
    }

    .form-group {
        margin-bottom: 4px;
    }

    .form-group label {
        display: block;

        margin-bottom: 7px;

        color: #28586d;

        font-weight: 600;
        font-size: 13px;
    }

    .form-control {
        width: 100%;

        padding: 11px 13px;

        border: 1px solid #cbdde3;
        border-radius: 8px;

        background: #ffffff;
        color: #263e47;

        outline: none;

        font-size: 14px;

        transition: all 0.2s ease;
    }

    .form-control:hover {
        border-color: #9ebbc5;
    }

    .form-control:focus {
        border-color: #3f7f95;

        box-shadow:
            0 0 0 3px rgba(63, 127, 149, 0.12);
    }

    /* =========================
       PRICE RANGE
       ========================= */

    .price-range {
        display: grid;

        grid-template-columns: 1fr auto 1fr;

        gap: 10px;

        align-items: center;
    }

    .price-range span {
        color: #71858d;
        font-weight: 600;
        font-size: 13px;
    }

    /* =========================
       BUTTONS
       ========================= */

    .button-row {
        display: flex;

        gap: 10px;

        margin-top: 21px;

        flex-wrap: wrap;
    }

    .btn {
        display: inline-flex;

        align-items: center;
        justify-content: center;

        gap: 8px;

        padding: 11px 18px;

        border: none;
        border-radius: 8px;

        background: #28586d;
        color: #ffffff;

        font-size: 14px;
        font-weight: 600;

        cursor: pointer;

        text-decoration: none;

        transition: all 0.2s ease;
    }

    .btn:hover {
        background: #1f4657;

        transform: translateY(-1px);

        box-shadow:
            0 5px 12px rgba(40, 88, 109, 0.15);
    }

    .btn-primary {
        background: #28586d;
        color: #ffffff;
    }

    .btn-primary:hover {
        background: #1f4657;
    }

    .btn-light {
        background: #eaf3f6;
        color: #28586d;
    }

    .btn-light:hover {
        background: #dcecf1;
        color: #1f4657;
        box-shadow: none;
    }

    /* =========================
       RESULTS INFO
       ========================= */

    .results-info {
        padding: 12px 15px;

        border-radius: 8px;

        margin-bottom: 16px;

        background: #eaf4f7;

        border: 1px solid #d3e6ec;

        color: #28586d;

        font-size: 14px;

        font-weight: 600;
    }

    .results-info i {
        margin-right: 5px;
    }

    /* =========================
       TABLE
       ========================= */

    .table-container {
        width: 100%;

        overflow-x: auto;

        border-radius: 11px;

        border: 1px solid #d8e6eb;

        margin-top: 12px;
    }

    table {
        width: 100%;

        border-collapse: collapse;

        background: #ffffff;

        min-width: 900px;
    }

    th {
        background: #28586d;

        color: #ffffff;

        padding: 14px 15px;

        text-align: left;

        font-size: 13px;

        font-weight: 600;

        white-space: nowrap;
    }

    td {
        padding: 13px 15px;

        border-bottom: 1px solid #e7eef1;

        font-size: 13px;

        color: #40545c;
    }

    tbody tr {
        transition: background 0.15s ease;
    }

    tbody tr:hover {
        background: #f4f9fa;
    }

    tbody tr:last-child td {
        border-bottom: none;
    }

    /* =========================
       ITEM DETAILS
       ========================= */

    .item-name {
        color: #28586d;

        font-weight: 700;

        font-size: 14px;
    }

    .subtext {
        color: #84959b;

        font-size: 12px;

        margin-top: 3px;
    }

    .price {
        color: #28586d;

        font-weight: 700;
    }

    /* =========================
       STATUS BADGES
       ========================= */

    .badge {
        display: inline-block;

        padding: 5px 10px;

        border-radius: 20px;

        font-size: 11px;

        font-weight: 600;

        white-space: nowrap;
    }

    .instock {
        background: #e4f4ea;
        color: #267044;
    }

    .lowstock {
        background: #fff4d8;
        color: #866b14;
    }

    .outofstock {
        background: #fbe5e5;
        color: #a03c3c;
    }

    /* =========================
       NO RESULTS
       ========================= */

    .no-results {
        text-align: center;

        padding: 55px 20px;

        color: #7c8d93;

        border: 1px dashed #cddfe5;

        border-radius: 11px;

        background: #f9fbfc;
    }

    .no-results i {
        font-size: 36px;

        color: #3f7f95 !important;
    }

    .no-results h3 {
        margin-top: 13px;

        color: #28586d;

        font-size: 17px;
    }

    .no-results p {
        margin-top: 5px;

        font-size: 13px;

        color: #7c8d93;
    }

    /* =========================
       RESPONSIVE
       ========================= */

    @media (max-width: 1000px) {

        .header {
            flex-wrap: wrap;
        }

        .tabs {
            width: 100%;
            margin-left: 0;
        }

    }

    @media (max-width: 700px) {

        .page-wrapper {
            padding: 12px;
        }

        .card {
            min-height: calc(100vh - 24px);
            padding: 20px;
            border-radius: 12px;
        }

        .header h1 {
            font-size: 22px;
        }

        .grid {
            grid-template-columns: 1fr;
        }

        .button-row {
            width: 100%;
        }

        .btn {
            width: 100%;
        }

    }

</style>

</head>

<body>

<div class="page-wrapper">


<div class="card">

    <!-- =========================
         HEADER
         ========================= -->

    <div class="header">

        <div class="icon">
            <i class="fa-solid fa-magnifying-glass"></i>
        </div>

        <div>
            <h1>Advanced Hardware Search</h1>

            <p>
                Search inventory items using detailed filters
            </p>
        </div>

        

    </div>


    <!-- =========================
         FILTER SECTION
         ========================= -->

    <div class="section-title">

        <i class="fa-solid fa-sliders"></i>

        <span>
            Search Filters
        </span>

    </div>


    <div class="filter-card">

        <form action="search" method="GET">

            <input type="hidden"
                   name="action"
                   value="search">


            <div class="grid">


                <!-- CATEGORY -->

                <div class="form-group">

                    <label>
                        Category
                    </label>

                    <select name="category"
                            class="form-control">

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


                <!-- BRAND -->

                <div class="form-group">

                    <label>
                        Brand
                    </label>

                    <select name="brand"
                            class="form-control">

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


                <!-- STOCK STATUS -->

                <div class="form-group">

                    <label>
                        Stock Status
                    </label>

                    <select name="stockStatus"
                            class="form-control">

                        <option value="All">
                            All Status
                        </option>

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


                <!-- ITEM STATUS -->

                <div class="form-group">

                    <label>
                        Item Status
                    </label>

                    <select name="itemStatus"
                            class="form-control">

                        <option value="All">
                            All Items
                        </option>

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


                <!-- PRICE -->

                <div class="form-group">

                    <label>
                        Price Range (₹)
                    </label>

                    <div class="price-range">

                        <input type="number"
                               name="minPrice"
                               class="form-control"
                               placeholder="Min"
                               value="${filter.minPrice}"
                               step="0.01">

                        <span>
                            to
                        </span>

                        <input type="number"
                               name="maxPrice"
                               class="form-control"
                               placeholder="Max"
                               value="${filter.maxPrice}"
                               step="0.01">

                    </div>

                </div>


                <!-- SORT -->

                <div class="form-group">

                    <label>
                        Sort By
                    </label>

                    <select name="sortBy"
                            class="form-control">

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


                <!-- KEYWORD -->

                <div class="form-group">

                    <label>
                        Search Keywords
                    </label>

                    <input type="text"
                           name="keyword"
                           class="form-control"
                           placeholder="Search item name..."
                           value="${filter.keyword}">

                </div>

            </div>


            <!-- BUTTONS -->

            <div class="button-row">

                <button type="submit"
                        class="btn btn-primary">

                    <i class="fa-solid fa-magnifying-glass"></i>

                    Search Items

                </button>


                <a href="search"
                   class="btn btn-light">

                    <i class="fa-solid fa-rotate-left"></i>

                    Reset Filters

                </a>

            </div>

        </form>

    </div>


    <!-- =========================
         RESULTS
         ========================= -->

    <div class="section-title">

        <i class="fa-solid fa-table"></i>

        <span>
            Search Results
        </span>

    </div>


    <!-- SEARCH ERROR -->

    <c:if test="${not empty searchError}">

        <div class="results-info">

            <i class="fa-solid fa-triangle-exclamation"></i>

            ${searchError}

        </div>

    </c:if>


    <!-- RESULTS -->

    <c:if test="${not empty results}">

        <div class="results-info">

            <i class="fa-solid fa-boxes-stacked"></i>

            Found
            <strong>${resultCount}</strong>
            item(s)

        </div>


        <div class="table-container">

            <table>

                <thead>

                    <tr>

                        <th>
                            Item Details
                        </th>

                        <th>
                            Category
                        </th>

                        <th>
                            Brand
                        </th>

                        <th>
                            Supplier
                        </th>

                        <th>
                            Price
                        </th>

                        <th>
                            Stock Status
                        </th>

                        <th>
                            Location
                        </th>

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


                            <td>
                                ${item.category}
                            </td>


                            <td>
                                ${item.brand}
                            </td>


                            <td>
                                ${item.supplierName}
                            </td>


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


                            <td>
                                ${item.location}
                            </td>

                        </tr>

                    </c:forEach>

                </tbody>

            </table>

        </div>

    </c:if>


    <!-- NO RESULTS -->

    <c:if test="${empty results}">

        <div class="no-results">

            <i class="fa-solid fa-box-open"></i>

            <h3>
                No items to display
            </h3>

            <p>
                Try changing your search filters.
            </p>

        </div>

    </c:if>

</div>


</div>

</body>
</html>
