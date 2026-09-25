<%@ page language="java"
contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core"
prefix="c" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"
prefix="fmt" %>

<!DOCTYPE html>

<html lang="en">

<head>

```
<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>Supplier Feedback History</title>

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
        background: #eef6f8;
        color: #243b44;
        min-height: 100vh;
    }

    body::before {
        content: "";
        position: fixed;
        inset: 0;
        pointer-events: none;

        background-image:
            linear-gradient(
                rgba(40, 88, 109, 0.025) 1px,
                transparent 1px
            ),
            linear-gradient(
                90deg,
                rgba(40, 88, 109, 0.025) 1px,
                transparent 1px
            );

        background-size: 40px 40px;
    }

    .page-wrapper {
        position: relative;
        z-index: 1;

        min-height: 100vh;
        padding: 35px;
    }

    .card {
        max-width: 1200px;
        margin: auto;

        background: #ffffff;

        border: 1px solid #c9dce2;
        border-radius: 18px;

        padding: 30px;

        box-shadow:
            0 12px 35px rgba(40, 88, 109, 0.10);
    }

    /* HEADER */

    .header {
        display: flex;
        align-items: center;
        gap: 18px;

        padding-bottom: 22px;
        margin-bottom: 25px;

        border-bottom: 2px solid #3f7f95;
    }

    .icon {
        width: 58px;
        height: 58px;

        display: flex;
        align-items: center;
        justify-content: center;

        background: #28586d;
        color: #ffffff;

        border-radius: 14px;

        font-size: 23px;

        flex-shrink: 0;
    }

    .header h1 {
        color: #28586d;
        font-size: 29px;
        font-weight: 700;
    }

    .header p {
        margin-top: 5px;
        color: #71858d;
        font-size: 14px;
    }

    /* TOP NAVIGATION */

    .tabs {
        margin-left: auto;

        display: flex;
        flex-wrap: wrap;
        gap: 8px;
    }

    .tab {
        display: inline-flex;
        align-items: center;
        gap: 7px;

        padding: 9px 15px;

        border-radius: 8px;

        background: #eaf3f6;
        color: #28586d;

        text-decoration: none;

        font-size: 13px;
        font-weight: 600;

        transition: 0.2s ease;
    }

    .tab:hover {
        background: #dcecf1;
    }

    .tab.active {
        background: #28586d;
        color: #ffffff;
    }

    /* SECTION */

    .section-title {
        color: #28586d;

        font-size: 20px;
        font-weight: 700;

        margin: 25px 0 15px;

        display: flex;
        align-items: center;
        gap: 10px;
    }

    .section-title i {
        color: #3f7f95;
    }

    /* ALERTS */

    .alert {
        padding: 13px 16px;

        border-radius: 9px;

        margin-bottom: 18px;

        font-size: 14px;
    }

    .alert-success {
        background: #e1f4e6;
        color: #236b36;
    }

    .alert-error {
        background: #f8dddd;
        color: #962d2d;
    }

    /* TABLE */

    .table-container {
        width: 100%;
        overflow-x: auto;

        border-radius: 12px;
        border: 1px solid #c9dce2;
    }

    table {
        width: 100%;
        border-collapse: collapse;

        background: #ffffff;
    }

    th {
        background: #28586d;
        color: #ffffff;

        padding: 14px 15px;

        text-align: left;

        font-size: 14px;
        font-weight: 600;
    }

    td {
        padding: 13px 15px;

        border-bottom: 1px solid #e2edf0;

        font-size: 14px;

        color: #344f59;
    }

    tbody tr:hover {
        background: #f3f8fa;
    }

    tbody tr:last-child td {
        border-bottom: none;
    }

    /* SUPPLIER */

    .supplier-name {
        color: #28586d;
        font-weight: 700;
    }

    /* RATING */

    .stars {
        color: #3f7f95;
        font-size: 18px;
        letter-spacing: 1px;
    }

    .rating-badge {
        display: inline-block;

        margin-top: 4px;

        padding: 5px 9px;

        border-radius: 20px;

        font-size: 12px;
        font-weight: 700;
    }

    .rating-5 {
        background: #28586d;
        color: #ffffff;
    }

    .rating-4 {
        background: #3f7f95;
        color: #ffffff;
    }

    .rating-3 {
        background: #dcecf1;
        color: #28586d;
    }

    .rating-2 {
        background: #eaf3f6;
        color: #71858d;
    }

    .rating-1 {
        background: #f9dede;
        color: #962d2d;
    }

    /* EMPTY STATE */

    .no-data {
        text-align: center;

        padding: 50px 20px;

        color: #71858d;
    }

    .no-data i {
        color: #3f7f95;
        font-size: 40px;
    }

    .no-data h3 {
        color: #28586d;
    }

    /* SUBMIT BUTTON */

    .submit-link {
        display: inline-flex;
        align-items: center;
        gap: 8px;

        margin-top: 15px;

        padding: 11px 18px;

        background: #28586d;
        color: #ffffff;

        border-radius: 9px;

        text-decoration: none;

        font-size: 14px;
        font-weight: 600;

        transition: 0.2s ease;
    }

    .submit-link:hover {
        background: #1f4657;
    }

    /* RESPONSIVE */

    @media(max-width: 850px) {

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

    @media(max-width: 600px) {

        .header h1 {
            font-size: 23px;
        }

        .tab {
            padding: 8px 11px;
            font-size: 12px;
        }

        th,
        td {
            padding: 11px 10px;
        }

    }

</style>
```

</head>

<body>

<div class="page-wrapper">

```
<div class="card">

    <!-- HEADER -->

    <div class="header">

        <div class="icon">
            <i class="fa-solid fa-comments"></i>
        </div>

        <div>

            <h1>Supplier Feedback History</h1>

            <p>
                Review supplier ratings and feedback submissions
            </p>

        </div>

        <!-- ONLY HOME, FEEDBACK AND HISTORY -->

        <div class="tabs">

            <a href="index.jsp" class="tab">

                <i class="fa-solid fa-house"></i>

                Home

            </a>

            <a href="feedback" class="tab">

                <i class="fa-solid fa-pen"></i>

                Submit Feedback

            </a>

            <a href="feedback?action=view"
               class="tab active">

                <i class="fa-solid fa-clock-rotate-left"></i>

                Feedback History

            </a>

        </div>

    </div>


    <!-- SECTION -->

    <div class="section-title">

        <i class="fa-solid fa-message"></i>

        <span>Feedback Records</span>

    </div>


    <!-- MESSAGES -->

    <c:if test="${not empty sessionScope.message}">

        <div class="alert alert-${sessionScope.messageType}">

            <i class="fa-solid fa-circle-info"></i>

            ${sessionScope.message}

        </div>

        <c:remove var="message"
                  scope="session"/>

        <c:remove var="messageType"
                  scope="session"/>

    </c:if>


    <!-- DATA -->

    <c:if test="${not empty feedbackList}">

        <div class="table-container">

            <table>

                <thead>

                    <tr>

                        <th>Date</th>

                        <th>Supplier</th>

                        <th>Item</th>

                        <th>Rating</th>

                        <th>Comments</th>

                    </tr>

                </thead>


                <tbody>

                    <c:forEach
                        items="${feedbackList}"
                        var="feedback">

                        <tr>

                            <td>

                                <fmt:formatDate
                                    value="${feedback.feedbackDate}"
                                    pattern="dd-MMM-yyyy HH:mm"/>

                            </td>


                            <td>

                                <span class="supplier-name">

                                    ${feedback.supplierName}

                                </span>

                            </td>


                            <td>

                                ${feedback.itemName != null
                                  ? feedback.itemName
                                  : 'N/A'}

                            </td>


                            <td>

                                <span class="stars">

                                    ${feedback.starRating}

                                </span>

                                <br>

                                <span class="rating-badge
                                             rating-${feedback.rating}">

                                    ${feedback.rating}/5

                                </span>

                            </td>


                            <td>

                                ${feedback.comments}

                            </td>

                        </tr>

                    </c:forEach>

                </tbody>

            </table>

        </div>

    </c:if>


    <!-- EMPTY STATE -->

    <c:if test="${empty feedbackList}">

        <div class="no-data">

            <i class="fa-solid fa-comments"></i>

            <h3 style="margin-top:12px;">

                No feedback submissions yet

            </h3>

            <p style="margin-top:5px;">

                Be the first to rate your suppliers!

            </p>

            <a href="feedback"
               class="submit-link">

                <i class="fa-solid fa-pen"></i>

                Submit Feedback

            </a>

        </div>

    </c:if>

</div>
```

</div>

</body>

</html>
