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
                linear-gradient(
                    135deg,
                    #eef6f8 0%,
                    #e6f1f4 50%,
                    #f5fafb 100%
                );

            color: var(--text-dark);

            min-height: 100vh;
        }

        /* Subtle background pattern */

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

            max-width: 1000px;

            margin: auto;

            background: rgba(255,255,255,.98);

            border: 1px solid var(--border);

            border-radius: 18px;

            padding: 30px;

            box-shadow:
                0 15px 45px rgba(31,70,87,.12);
        }

        /* =========================
           HEADER
           ========================= */

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

            box-shadow:
                0 7px 18px rgba(40,88,109,.18);
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

        /* =========================
           TOP NAVIGATION
           ========================= */

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

            box-shadow:
                0 5px 12px rgba(40,88,109,.16);
        }

        /* =========================
           SECTION TITLE
           ========================= */

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

        /* =========================
           FEEDBACK FORM
           ========================= */

        .feedback-form {

            background: #f8fbfc;

            border: 1px solid var(--border);

            border-radius: 12px;

            padding: 24px;

            box-shadow:
                0 5px 15px rgba(31,70,87,.05);
        }

        .form-group {

            margin-bottom: 18px;
        }

        .form-group label {

            display: block;

            margin-bottom: 7px;

            color: var(--teal-dark);

            font-weight: 600;

            font-size: 14px;
        }

        .form-control {

            width: 100%;

            padding: 11px 13px;

            border: 1px solid #c5d8de;

            border-radius: 8px;

            background: #ffffff;

            color: var(--text-dark);

            outline: none;

            font-size: 14px;

            transition: .2s ease;
        }

        .form-control:focus {

            border-color: var(--teal-accent);

            box-shadow:
                0 0 0 3px rgba(63,127,149,.12);
        }

        textarea.form-control {

            min-height: 110px;

            resize: vertical;
        }

        /* =========================
           GRID
           ========================= */

        .grid {

            display: grid;

            grid-template-columns:
                repeat(2, minmax(0,1fr));

            gap: 18px;
        }

        /* =========================
           STAR RATING
           ========================= */

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

            color: #c8d9de;

            cursor: pointer;

            margin: 0;

            padding: 0;

            transition: .15s ease;
        }

        .star-rating label:hover,
        .star-rating label:hover ~ label,
        .star-rating input:checked ~ label {

            color: var(--teal-highlight);
        }

        /* =========================
           STATISTICS
           ========================= */

        .stats-card {

            margin-top: 20px;

            background: var(--teal-light);

            border: 1px solid var(--border);

            border-radius: 12px;

            padding: 20px;

            text-align: center;
        }

        .stats-card h3 {

            color: var(--teal-dark);

            margin-bottom: 10px;
        }

        .rating-display {

            color: var(--teal-accent);

            font-size: 34px;
        }

        .rating-number {

            color: var(--text-muted);

            margin-top: 5px;
        }

        /* =========================
           BUTTONS
           ========================= */

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

            background: var(--teal-main);

            color: #ffffff;

            font-size: 14px;

            font-weight: 600;

            cursor: pointer;

            text-decoration: none;

            transition: .2s ease;
        }

        .btn:hover {

            background: var(--teal-dark);

            transform: translateY(-1px);

            box-shadow:
                0 5px 14px rgba(40,88,109,.18);
        }

        .btn-teal {

            background: var(--teal-accent);

            color: #ffffff;
        }

        .btn-teal:hover {

            background: var(--teal-dark);
        }

        /* =========================
           RESPONSIVE
           ========================= */

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

                justify-content: flex-start;
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


        <!-- =========================
             HEADER
             ========================= -->

        <div class="header">

            <div class="icon">

                <i class="fa-solid fa-comment-dots"></i>

            </div>


            <div>

                <h1>
                    Supplier Feedback
                </h1>

                <p>
                    Rate suppliers and record your experience
                </p>

            </div>


            <!-- TOP NAVIGATION -->

            <div class="tabs">

                <!-- HOME -->

                <a href="index.jsp" class="tab">

                    <i class="fa-solid fa-house"></i>

                    Home

                </a>


                <!-- FEEDBACK -->

                <a href="feedback" class="tab active">

                    <i class="fa-solid fa-pen"></i>

                    Feedback 

                </a>


                <!-- HISTORY -->

                <a href="feedback?action=view" class="tab">

                    <i class="fa-solid fa-clock-rotate-left"></i>

                    FeedBack History

                </a>

            </div>

        </div>


        <!-- =========================
             FORM TITLE
             ========================= -->

        <div class="section-title">

            <i class="fa-solid fa-pen-to-square"></i>

            <span>
                Submit Supplier Feedback
            </span>

        </div>


        <!-- =========================
             FEEDBACK FORM
             ========================= -->

        <div class="feedback-form">

            <form action="feedback"
                  method="POST"
                  onsubmit="return validateForm()">


                <!-- SUPPLIER -->

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


                <!-- OPTIONAL FIELDS -->

                <div class="grid">


                    <!-- ITEM -->

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


                    <!-- ORDER -->

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


                <!-- RATING -->

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


                <!-- COMMENTS -->

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


                <!-- STATISTICS -->

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


                <!-- BUTTONS -->

                <div class="button-row">


                    <button type="submit"
                            class="btn btn-teal">

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
