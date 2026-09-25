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

            z-index: 0;
        }

        .page-wrapper {
            position: relative;
            z-index: 1;
            min-height: 100vh;
            padding: 36px;
        }

        .card {
            max-width: 1200px;
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

        .search-card {
            background: #fffaf2;
            border: 1px solid #e3cfa7;
            border-radius: 12px;
            padding: 20px;
        }

        .search-row {
            display: flex;
            gap: 12px;
        }

        .form-control {
            flex: 1;

            padding: 12px 14px;

            border: 1px solid #d8c39b;
            border-radius: 8px;

            background: #fffdf8;
            color: #3b2528;

            outline: none;
        }

        .form-control:focus {
            border-color: #D5A94F;
            box-shadow: 0 0 0 3px rgba(213,169,79,.15);
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

            font-weight: 600;
            cursor: pointer;
        }

        .btn-gold {
            background: #D5A94F;
            color: #35171E;
        }

        .message {
            padding: 13px 16px;
            border-radius: 9px;
            margin-bottom: 18px;

            background: #fff1cb;
            color: #806308;
        }

        .result-summary {
            margin-bottom: 15px;
            color: #57152C;
            font-size: 14px;
        }

        .result-item {
            background: #fffaf2;

            border: 1px solid #e3cfa7;
            border-radius: 12px;

            margin-bottom: 16px;

            overflow: hidden;
        }

        .result-header {
            padding: 15px 18px;

            background: #f0e5d2;

            border-bottom: 1px solid #e3cfa7;

            display: flex;
            justify-content: space-between;
            gap: 15px;

            flex-wrap: wrap;
        }

        .item-name {
            color: #57152C;
            font-weight: 700;
            font-size: 16px;
        }

        .category {
            color: #765d60;
            font-size: 13px;
            margin-left: 5px;
        }

        .recommend-tag {
            display: inline-block;

            margin-left: 10px;

            padding: 5px 9px;

            background: #D5A94F;
            color: #35171E;

            border-radius: 20px;

            font-size: 11px;
            font-weight: 700;
        }

        .stock-badge {
            display: inline-block;

            padding: 5px 10px;

            background: #57152C;
            color: #FFE9B2;

            border-radius: 20px;

            font-size: 12px;
            font-weight: 600;
        }

        .rating-stars {
            color: #D5A94F;
            font-weight: 700;
            margin-left: 8px;
        }

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
            color: #57152C;
            font-weight: 700;
        }

        .supplier-detail {
            color: #765d60;
            font-size: 13px;
            margin-top: 5px;
        }

        .price-tag {
            color: #57152C;
            font-weight: 700;
            white-space: nowrap;
        }

        .no-results {
            text-align: center;
            padding: 45px 20px;
            color: #765d60;
        }

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

            <div class="tabs">

                <a href="search" class="tab">
                    <i class="fa-solid fa-magnifying-glass"></i>
                    Search
                </a>

                <a href="recommend" class="tab active">
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
                       style="font-size:35px;color:#D5A94F;"></i>

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
                       style="font-size:35px;color:#D5A94F;"></i>

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

                    <span style="color:#765d60;">
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
                                                    color:#765d60;
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