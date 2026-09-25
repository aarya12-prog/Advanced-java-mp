<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Supplier Recommendation</title>

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

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

        body {
            font-family: "Segoe UI", Arial, sans-serif;
            background:
                linear-gradient(135deg, #eef6f8 0%, #e6f1f4 50%, #f5fafb 100%);
            color: var(--text-dark);
            min-height: 100vh;
        }

        body::before {
            content: "";
            position: fixed;
            inset: 0;
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
            z-index: 0;
        }

        .page-wrapper {
            position: relative;
            z-index: 1;
            min-height: 100vh;
            padding: 32px;
        }

        .card {
            max-width: 1200px;
            margin: auto;

            background: rgba(255,255,255,.98);

            border: 1px solid #c9dce2;
            border-radius: 18px;

            padding: 30px;

            box-shadow:
                0 15px 45px rgba(31,70,87,.12);
        }

        /* HEADER */

        .header {
            display: flex;
            align-items: center;
            gap: 18px;

            padding-bottom: 22px;
            margin-bottom: 25px;

            border-bottom: 2px solid #d5e5ea;
        }

        .icon {
            width: 58px;
            height: 58px;

            display: flex;
            align-items: center;
            justify-content: center;

            background: var(--teal-main);
            color: #ffffff;

            border-radius: 14px;
            font-size: 24px;

            box-shadow: 0 7px 18px rgba(40,88,109,.18);
        }

        .header h1 {
            color: var(--teal-dark);
            font-size: 30px;
            letter-spacing: -.3px;
        }

        .header p {
            margin-top: 5px;
            color: var(--text-muted);
            font-size: 14px;
        }

        /* NAVIGATION */

        .tabs {
            margin-left: auto;
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
            justify-content: flex-end;
        }

        .tab {
            padding: 9px 15px;
            border-radius: 8px;

            background: #edf4f6;
            color: var(--teal-dark);

            text-decoration: none;
            font-size: 13px;
            font-weight: 600;

            border: 1px solid transparent;

            transition: .2s ease;
        }

        .tab:hover {
            background: #dcecf1;
            border-color: #bdd4dc;
            transform: translateY(-1px);
        }

        .tab.active {
            background: var(--teal-main);
            color: #ffffff;
            box-shadow: 0 5px 12px rgba(40,88,109,.16);
        }

        /* SECTION TITLE */

        .section-title {
            color: var(--teal-dark);
            font-size: 20px;
            font-weight: 700;

            margin: 25px 0 15px;

            display: flex;
            align-items: center;
            gap: 10px;
        }

        .section-title i {
            color: var(--teal-accent);
        }

        /* SEARCH */

        .search-card {
            background: #f8fbfc;
            border: 1px solid var(--border);
            border-radius: 12px;
            padding: 20px;

            box-shadow: 0 5px 15px rgba(31,70,87,.05);
        }

        .search-row {
            display: flex;
            gap: 12px;
        }

        .form-control {
            flex: 1;

            padding: 12px 14px;

            border: 1px solid #c5d8de;
            border-radius: 8px;

            background: #ffffff;
            color: var(--text-dark);

            outline: none;
            font-size: 14px;

            transition: .2s ease;
        }

        .form-control::placeholder {
            color: #91a2a8;
        }

        .form-control:focus {
            border-color: var(--teal-accent);
            box-shadow: 0 0 0 3px rgba(63,127,149,.12);
        }

        /* BUTTONS */

        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;

            gap: 8px;

            padding: 11px 18px;

            border: none;
            border-radius: 9px;

            background: var(--teal-main);
            color: #ffffff;

            font-weight: 600;
            cursor: pointer;

            transition: .2s ease;
        }

        .btn:hover {
            background: var(--teal-dark);
            transform: translateY(-1px);
            box-shadow: 0 5px 14px rgba(40,88,109,.18);
        }

        .btn-gold {
            background: var(--teal-accent);
            color: #ffffff;
        }

        .btn-gold:hover {
            background: var(--teal-dark);
        }

        /* MESSAGE */

        .message {
            padding: 13px 16px;
            border-radius: 9px;
            margin-bottom: 18px;

            background: #e8f3f6;
            border: 1px solid #c4dce3;
            color: var(--teal-dark);
        }

        /* RESULT SUMMARY */

        .result-summary {
            margin-bottom: 15px;
            color: var(--teal-dark);
            font-size: 14px;
        }

        /* RESULT ITEM */

        .result-item {
            background: #ffffff;

            border: 1px solid var(--border);
            border-radius: 12px;

            margin-bottom: 16px;

            overflow: hidden;

            box-shadow: 0 5px 16px rgba(31,70,87,.06);

            transition: .2s ease;
        }

        .result-item:hover {
            border-color: #a9c8d2;
            box-shadow: 0 8px 22px rgba(31,70,87,.09);
            transform: translateY(-1px);
        }

        .result-header {
            padding: 15px 18px;

            background: var(--teal-light);

            border-bottom: 1px solid var(--border);

            display: flex;
            justify-content: space-between;
            gap: 15px;

            flex-wrap: wrap;
        }

        .item-name {
            color: var(--teal-dark);
            font-weight: 700;
            font-size: 16px;
        }

        .category {
            color: var(--text-muted);
            font-size: 13px;
            margin-left: 5px;
        }

        .recommend-tag {
            display: inline-block;

            margin-left: 10px;

            padding: 5px 9px;

            background: #d8edf2;
            color: var(--teal-dark);

            border: 1px solid #b7d7df;

            border-radius: 20px;

            font-size: 11px;
            font-weight: 700;
        }

        .stock-badge {
            display: inline-block;

            padding: 5px 10px;

            background: var(--teal-main);
            color: #ffffff;

            border-radius: 20px;

            font-size: 12px;
            font-weight: 600;
        }

        .rating-stars {
            color: var(--teal-accent);
            font-weight: 700;
            margin-left: 8px;
        }

        /* RESULT BODY */

        .result-body {
            padding: 17px 18px;
        }

        .supplier-row {
            display: flex;
            justify-content: space-between;
            gap: 20px;
            align-items: center;
        }

        .supplier-name {
            color: var(--teal-dark);
            font-weight: 700;
        }

        .supplier-detail {
            color: var(--text-muted);
            font-size: 13px;
            margin-top: 5px;
        }

        .price-tag {
            color: var(--teal-dark);
            font-weight: 700;
            white-space: nowrap;
        }

        /* EMPTY STATE */

        .no-results {
            text-align: center;
            padding: 45px 20px;
            color: var(--text-muted);

            background: #f9fcfd;
            border: 1px dashed #c7dce2;
            border-radius: 12px;
        }

        .no-results i {
            color: var(--teal-accent) !important;
        }

        .no-results h3 {
            color: var(--teal-dark);
        }

        /* RESPONSIVE */

        @media(max-width:800px) {

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
                justify-content: flex-start;
            }

            .search-row {
                flex-direction: column;
            }

            .supplier-row {
                flex-direction: column;
                align-items: flex-start;
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
                <i class="fa-solid fa-star"></i>
            </div>

            <div>
                <h1>Supplier Recommendation</h1>
                <p>Find the most suitable supplier for an inventory item</p>
            </div>
           
            <div class="tabs"> <a href="index.jsp" class="tab"> <i class="fa-solid fa-house"></i> Home </a> </div>

            

        </div>


        <!-- SEARCH -->

        <div class="section-title">

            <i class="fa-solid fa-magnifying-glass"></i>

            <span>Find Supplier Recommendation</span>

        </div>
        

        <div class="search-card">

            <div class="search-row">

                <input type="text"
                       id="keyword"
                       class="form-control"
                       placeholder="Search for an item..."
                       value="${param.q}">

                <button type="button"
                        class="btn btn-gold"
                        onclick="doSearch()">

                    <i class="fa-solid fa-wand-magic-sparkles"></i>
                    Recommend

                </button>

            </div>
                       

        </div>


        <!-- MESSAGE -->

        <c:if test="${not empty sessionScope.message}">

            <div class="message" style="margin-top:20px;">

                <i class="fa-solid fa-circle-info"></i>

                ${sessionScope.message}

            </div>

            <c:remove var="message" scope="session"/>
            <c:remove var="messageType" scope="session"/>

        </c:if>


        <!-- RESULTS -->

        <div class="section-title">

            <i class="fa-solid fa-ranking-star"></i>

            <span>Supplier Recommendations</span>

        </div>


        <c:choose>

            <c:when test="${empty param.q}">

                <div class="no-results">

                    <i class="fa-solid fa-lightbulb"
                       style="font-size:35px;"></i>

                    <h3 style="margin-top:12px;">
                        Search for an item
                    </h3>

                    <p style="margin-top:5px;">
                        Enter an item name to get supplier recommendations.
                    </p>

                </div>

            </c:when>


            <c:when test="${empty results}">

                <div class="no-results">

                    <i class="fa-solid fa-box-open"
                       style="font-size:35px;"></i>

                    <h3 style="margin-top:12px;">
                        No suppliers found
                    </h3>

                    <p style="margin-top:5px;">
                        No suppliers found for
                        "<strong>${param.q}</strong>".
                    </p>

                </div>

            </c:when>


            <c:otherwise>

                <div class="result-summary">

                    Showing
                    <strong>${results.size()}</strong>
                    result(s) for
                    "<strong>${param.q}</strong>"

                    <span style="color:#71858d;">
                        — sorted by best stock &amp; feedback
                    </span>

                </div>


                <c:forEach items="${results}"
                           var="rec"
                           varStatus="loop">

                    <div class="result-item">

                        <div class="result-header">

                            <div>

                                <span class="item-name">
                                    ${rec.item.itemName}
                                </span>

                                <span class="category">
                                    (${rec.item.category})
                                </span>

                                <c:if test="${loop.index == 0}">

                                    <span class="recommend-tag">
                                        ★ BEST RECOMMENDATION
                                    </span>

                                </c:if>

                            </div>


                            <div>

                                <span class="stock-badge">

                                    <i class="fa-solid fa-box"></i>

                                    ${rec.currentStock} in stock

                                </span>

                                <c:if test="${rec.feedbackCount > 0}">

                                    <span class="rating-stars">

                                        <fmt:formatNumber
                                            value="${rec.averageRating}"
                                            pattern="#0.0"/>

                                        ★

                                    </span>

                                </c:if>

                            </div>

                        </div>


                        <div class="result-body">

                            <div class="supplier-row">

                                <div>

                                    <div class="supplier-name">
                                        ${rec.supplier.supplierName}
                                    </div>

                                    <div class="supplier-detail">

                                        Contact:
                                        ${rec.supplier.contactPerson}

                                        &bull;

                                        ${rec.supplier.phone}

                                        &bull;

                                        ${rec.supplier.email}

                                    </div>

                                </div>


                                <div>

                                    <span class="price-tag">
                                        Price: ₹${rec.item.purchasePrice}
                                    </span>

                                    <c:if test="${rec.feedbackCount > 0}">

                                        <div style="font-size:12px;
                                                    color:#71858d;
                                                    margin-top:4px;">

                                            ${rec.feedbackCount} reviews

                                        </div>

                                    </c:if>

                                </div>

                            </div>

                        </div>

                    </div>

                </c:forEach>

            </c:otherwise>

        </c:choose>

    </div>

</div>


<script>

function doSearch() {

    var input =
        document.getElementById('keyword');

    var keyword =
        input.value.trim();

    if (keyword === '') {

        alert('Please enter an item name.');

        return;
    }

    window.location.href =
        'recommend?q=' +
        encodeURIComponent(keyword);
}


document.getElementById('keyword')
    .addEventListener('keydown', function(e) {

        if (e.key === 'Enter') {
            doSearch();
        }

    });

</script>

</body>
</html>