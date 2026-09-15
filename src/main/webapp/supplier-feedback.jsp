<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ taglib prefix="c"
           uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Supplier Feedback</title>

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
            max-width: 900px;
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

        .feedback-form {
            background: #fffaf2;

            border: 1px solid #e3cfa7;
            border-radius: 12px;

            padding: 24px;
        }

        .form-group {
            margin-bottom: 18px;
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

        textarea.form-control {
            min-height: 110px;
            resize: vertical;
        }

        .grid {
            display: grid;
            grid-template-columns:
                repeat(2, minmax(0,1fr));

            gap: 18px;
        }

        .star-rating {
            direction: rtl;

            display: inline-flex;

            gap: 5px;

            font-size: 34px;
        }

        .star-rating input {
            display: none;
        }

        .star-rating label {
            color: #d8c39b;

            cursor: pointer;

            margin: 0;
            padding: 0;
        }

        .star-rating label:hover,
        .star-rating label:hover ~ label,
        .star-rating input:checked ~ label {
            color: #D5A94F;
        }

        .stats-card {
            margin-top: 20px;

            background: #f0e5d2;

            border: 1px solid #e3cfa7;

            border-radius: 12px;

            padding: 20px;

            text-align: center;
        }

        .stats-card h3 {
            color: #57152C;
            margin-bottom: 10px;
        }

        .rating-display {
            color: #D5A94F;
            font-size: 34px;
        }

        .rating-number {
            color: #765d60;
            margin-top: 5px;
        }

        .button-row {
            display: flex;
            gap: 10px;

            margin-top: 20px;
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

        .btn-gold {
            background: #D5A94F;
            color: #35171E;
        }

        @media(max-width:750px) {

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

        }

    </style>

    <script>

        function loadSupplierData() {

            var supplierId =
                document.getElementById('supplierId').value;

            if (supplierId) {

                window.location.href =
                    'feedback?supplierId=' +
                    supplierId;

            }

        }

        function validateForm() {

            var rating =
                document.querySelector(
                    'input[name="rating"]:checked'
                );

            if (!rating) {

                alert('Please select a rating!');

                return false;
            }

            return true;
        }

    </script>

</head>

<body>

<div class="page-wrapper">

    <div class="card">

        <!-- HEADER -->

        <div class="header">

            <div class="icon">
                <i class="fa-solid fa-comment-dots"></i>
            </div>

            <div>

                <h1>Supplier Feedback</h1>

                <p>
                    Rate suppliers and record your experience
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

                <a href="feedback" class="tab active">
                    <i class="fa-solid fa-pen"></i>
                    Feedback
                </a>

                <a href="feedback?action=view" class="tab">
                    <i class="fa-solid fa-clock-rotate-left"></i>
                    History
                </a>

            </div>

        </div>


        <!-- FORM -->

        <div class="section-title">

            <i class="fa-solid fa-pen-to-square"></i>

            <span>Submit Supplier Feedback</span>

        </div>


        <div class="feedback-form">

            <form action="feedback"
                  method="POST"
                  onsubmit="return validateForm()">


                <div class="form-group">

                    <label for="supplierId">
                        Select Supplier
                    </label>

                    <select name="supplierId"
                            id="supplierId"
                            class="form-control"
                            onchange="loadSupplierData()"
                            required>

                        <option value="">
                            -- Choose Supplier --
                        </option>

                        <c:forEach items="${suppliers}"
                                   var="supplier">

                            <option value="${supplier.key}"
                                ${param.supplierId == supplier.key
                                  ? 'selected' : ''}>

                                ${supplier.value}

                            </option>

                        </c:forEach>

                    </select>

                </div>


                <div class="grid">

                    <c:if test="${not empty items}">

                        <div class="form-group">

                            <label for="itemId">
                                Related Item
                                <span style="font-weight:400;">
                                    (Optional)
                                </span>
                            </label>

                            <select name="itemId"
                                    id="itemId"
                                    class="form-control">

                                <option value="">
                                    -- Select Item --
                                </option>

                                <c:forEach items="${items}"
                                           var="item">

                                    <option value="${item.key}">
                                        ${item.value}
                                    </option>

                                </c:forEach>

                            </select>

                        </div>

                    </c:if>


                    <c:if test="${not empty orders}">

                        <div class="form-group">

                            <label for="orderId">
                                Purchase Order
                                <span style="font-weight:400;">
                                    (Optional)
                                </span>
                            </label>

                            <select name="orderId"
                                    id="orderId"
                                    class="form-control">

                                <option value="">
                                    -- Select Order --
                                </option>

                                <c:forEach items="${orders}"
                                           var="order">

                                    <option value="${order.key}">
                                        ${order.value}
                                    </option>

                                </c:forEach>

                            </select>

                        </div>

                    </c:if>

                </div>


                <div class="form-group">

                    <label>
                        Supplier Rating
                    </label>

                    <div class="star-rating">

                        <input type="radio"
                               id="star5"
                               name="rating"
                               value="5"
                               required>

                        <label for="star5">★</label>


                        <input type="radio"
                               id="star4"
                               name="rating"
                               value="4">

                        <label for="star4">★</label>


                        <input type="radio"
                               id="star3"
                               name="rating"
                               value="3">

                        <label for="star3">★</label>


                        <input type="radio"
                               id="star2"
                               name="rating"
                               value="2">

                        <label for="star2">★</label>


                        <input type="radio"
                               id="star1"
                               name="rating"
                               value="1">

                        <label for="star1">★</label>

                    </div>

                </div>


                <div class="form-group">

                    <label for="comments">
                        Comments
                    </label>

                    <textarea name="comments"
                              id="comments"
                              class="form-control"
                              placeholder="Describe your experience with the supplier..."
                              required></textarea>

                </div>


                <c:if test="${not empty stats}">

                    <div class="stats-card">

                        <h3>
                            Supplier Rating Statistics
                        </h3>

                        <div class="rating-display">

                            <c:forEach begin="1"
                                       end="5"
                                       var="star">

                                ${star <= stats.avgRating
                                  ? '★' : '☆'}

                            </c:forEach>

                        </div>

                        <div class="rating-number">

                            ${stats.avgRating} / 5.0

                            (${stats.totalFeedback} reviews)

                        </div>

                    </div>

                </c:if>


                <div class="button-row">

                    <button type="submit"
                            class="btn btn-gold">

                        <i class="fa-solid fa-paper-plane"></i>

                        Submit Feedback

                    </button>

                    <a href="feedback"
                       class="btn">

                        <i class="fa-solid fa-rotate-left"></i>

                        Reset

                    </a>

                </div>

            </form>

        </div>

    </div>

</div>

</body>

</html>