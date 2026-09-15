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
            background: #12090C;
            color: #3b2528;
            min-height: 100vh;
        }

        body::before {
            content: "";
            position: fixed;
            inset: 0;

            background-image:
                url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='56' height='48' viewBox='0 0 56 48'%3E%3Cpath d='M14 1L28 9V25L14 33L0 25V9L14 1Z M42 15L56 23V39L42 47L28 39V23L42 15Z' fill='none' stroke='%23D5A94F' stroke-opacity='.08' stroke-width='1'/%3E%3C/svg%3E");

            pointer-events: none;
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
            flex-wrap: wrap;
            gap: 8px;
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

        .supplier-name {
            color: #57152C;
            font-weight: 700;
        }

        .stars {
            color: #D5A94F;
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
            background: #57152C;
            color: #FFE9B2;
        }

        .rating-4 {
            background: #7a2939;
            color: #FFE9B2;
        }

        .rating-3 {
            background: #fff0c9;
            color: #896a08;
        }

        .rating-2 {
            background: #f1e5d7;
            color: #765d60;
        }

        .rating-1 {
            background: #f9dede;
            color: #962d2d;
        }

        .no-data {
            text-align: center;
            padding: 50px 20px;

            color: #765d60;
        }

        .no-data i {
            color: #D5A94F;
            font-size: 40px;
        }

        .submit-link {
            display: inline-flex;
            align-items: center;
            gap: 8px;

            margin-top: 15px;

            padding: 11px 18px;

            background: #57152C;
            color: #FFE9B2;

            border-radius: 9px;

            text-decoration: none;

            font-size: 14px;
            font-weight: 600;
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

        }

    </style>

</head>

<body>

<div class="page-wrapper">

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


            <div class="tabs">

                <a href="search" class="tab">
                    <i class="fa-solid fa-magnifying-glass"></i>
                    Search
                </a>

                <a href="recommend" class="tab">
                    <i class="fa-solid fa-star"></i>
                    Recommend
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

</div>

</body>

</html>