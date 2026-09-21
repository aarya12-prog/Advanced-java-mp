<%@ page import="java.sql.*, com.hardware.utils.DBConnection" %>

<%
    // Check if admin is logged in
    if (session == null || session.getAttribute("isLoggedIn") == null) {
        response.sendRedirect(request.getContextPath() + "/admin/login.jsp");
        return;
    }

    String adminName = (String) session.getAttribute("adminName");
%>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <title>View Items - Hardware Management</title>

    <!-- Font Awesome -->
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">


    <style>

        /* =========================================
           GLOBAL
        ========================================= */

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }


        body {

            font-family: Arial, Helvetica, sans-serif;

            background:
                radial-gradient(
                    circle at 20% 20%,
                    rgba(150, 110, 30, 0.12),
                    transparent 25%
                ),

                radial-gradient(
                    circle at 80% 70%,
                    rgba(150, 110, 30, 0.10),
                    transparent 25%
                ),

                #10090b;

            color: #4d2630;

            min-height: 100vh;
        }


        /* =========================================
           WRAPPER
        ========================================= */

        #wrapper {

            display: flex;

            min-height: 100vh;
        }


        /* =========================================
           SIDEBAR
        ========================================= */

        #sidebar-wrapper {

            width: 250px;

            min-height: 100vh;

            background:
                linear-gradient(
                    180deg,
                    #160a0d,
                    #260d16
                );

            border-right: 1px solid #9c7428;

            box-shadow:
                5px 0 25px rgba(0, 0, 0, 0.5);

            color: #f5e8c8;

            transition: 0.3s;

            flex-shrink: 0;
        }


        .sidebar-heading {

            padding: 28px 15px;

            text-align: center;

            border-bottom: 1px solid #74551f;

            color: #e5c36b;

            font-size: 19px;

            font-weight: bold;
        }


        .sidebar-heading i {

            color: #e5c36b;

            margin-right: 8px;
        }


        .list-group {

            margin-top: 25px;
        }


        .list-group a {

            display: block;

            padding: 15px 25px;

            color: #eadfca;

            text-decoration: none;

            border-left: 4px solid transparent;

            transition: 0.3s;
        }


        .list-group a i {

            width: 25px;

            color: #d5ae55;
        }


        .list-group a:hover {

            background:
                rgba(151, 103, 28, 0.15);

            color: #ffffff;

            border-left:
                4px solid #d5ae55;
        }


        .list-group a.active {

            background: #651b36;

            color: #ffffff;

            border-left:
                4px solid #e0b957;

            box-shadow:
                inset 0 0 15px rgba(0, 0, 0, 0.25);
        }


        .list-group a.active i {

            color: #f1cf72;
        }


        .logout {

            color: #d99b8e !important;
        }


        .logout i {

            color: #d99b8e !important;
        }


        /* =========================================
           PAGE CONTENT
        ========================================= */

        #page-content-wrapper {

            width: 100%;

            min-height: 100vh;
        }


        /* =========================================
           NAVBAR
        ========================================= */

        .navbar {

            height: 80px;

            background: #eee9df;

            border-bottom:
                1px solid #c8a65b;

            display: flex;

            align-items: center;

            padding: 0 30px;

            box-shadow:
                0 3px 15px rgba(0, 0, 0, 0.25);
        }


        #menu-toggle {

            background: #651b36;

            color: white;

            border: none;

            width: 42px;

            height: 42px;

            border-radius: 10px;

            cursor: pointer;

            font-size: 16px;

            transition: 0.25s;
        }


        #menu-toggle:hover {

            background: #7c2443;

            transform: translateY(-1px);
        }


        .admin-info {

            margin-left: auto;

            color: #5b2836;

            font-weight: bold;
        }


        .admin-info i {

            color: #7b1e3d;

            margin-right: 5px;
        }


        /* =========================================
           MAIN CONTAINER
        ========================================= */

        .main-container {

            margin: 30px;

            background: #f1eee7;

            border: 2px solid #b9954c;

            border-radius: 20px;

            padding: 30px;

            box-shadow:
                0 15px 40px rgba(0, 0, 0, 0.45);
        }


        /* =========================================
           PAGE TITLE
        ========================================= */

        .page-title {

            color: #651b36;

            font-size: 30px;

            font-weight: bold;

            margin-bottom: 25px;

            display: flex;

            align-items: center;

            gap: 12px;
        }


        .page-title i {

            color: #bd963b;
        }


        /* =========================================
           ALERTS
        ========================================= */

        .alert {

            padding: 13px 18px;

            border-radius: 9px;

            margin-bottom: 20px;

            font-size: 14px;

            position: relative;
        }


        .alert-success {

            background: #eee7cf;

            color: #5c531f;

            border-left:
                4px solid #9d852d;

            border-top:
                1px solid #d3bf7d;
        }


        .alert-danger {

            background: #f2dddd;

            color: #702e36;

            border-left:
                4px solid #8a263e;

            border-top:
                1px solid #d7aaaa;
        }


        .alert i {

            margin-right: 6px;
        }


        .alert-close {

            position: absolute;

            right: 14px;

            top: 7px;

            border: none;

            background: transparent;

            color: inherit;

            font-size: 20px;

            cursor: pointer;
        }


        /* =========================================
           ITEMS CARD
        ========================================= */

        .card {

            background: #fffdf8;

            border: 1px solid #c6a455;

            border-radius: 15px;

            overflow: hidden;

            box-shadow:
                0 5px 18px rgba(
                    71,
                    39,
                    23,
                    0.15
                );

            margin-top: 15px;
        }


        .card-header {

            min-height: 65px;

            padding: 15px 20px;

            background: #651b36;

            color: white;

            border-bottom:
                3px solid #c6a455;

            display: flex;

            align-items: center;

            font-size: 17px;

            font-weight: bold;
        }


        .card-header > i {

            color: #e5c36b;

            margin-right: 8px;
        }


        /* =========================================
           ADD NEW ITEM BUTTON
        ========================================= */

        .add-button {

            margin-left: auto;

            background: #e0b957;

            color: #4d2630;

            padding: 9px 15px;

            border-radius: 7px;

            text-decoration: none;

            font-size: 13px;

            font-weight: bold;

            border: 1px solid #f0d27a;

            transition: 0.25s;
        }


        .add-button:hover {

            background: #f1cf72;

            color: #4d2630;

            transform: translateY(-1px);

            box-shadow:
                0 4px 10px rgba(
                    0,
                    0,
                    0,
                    0.18
                );
        }


        .add-button i {

            margin-right: 5px;
        }


        /* =========================================
           CARD BODY
        ========================================= */

        .card-body {

            padding: 22px;

            background: #fffdf8;
        }


        /* =========================================
           TABLE RESPONSIVE
        ========================================= */

        .table-responsive {

            width: 100%;

            overflow-x: auto;
        }


        /* =========================================
           TABLE
        ========================================= */

        .table {

            width: 100%;

            border-collapse: collapse;

            min-width: 950px;

            font-size: 14px;
        }


        /* =========================================
           TABLE HEADER
        ========================================= */

        .table thead th {

            background: #651b36;

            color: #f8eac7;

            padding: 14px 12px;

            text-align: left;

            border-bottom:
                3px solid #c6a455;

            font-size: 13px;

            white-space: nowrap;
        }


        .table thead th:first-child {

            border-top-left-radius: 6px;
        }


        .table thead th:last-child {

            border-top-right-radius: 6px;
        }


        /* =========================================
           TABLE BODY
        ========================================= */

        .table tbody td {

            padding: 13px 12px;

            border-bottom:
                1px solid #eadfce;

            color: #57333d;

            vertical-align: middle;

            background: #fffdf8;
        }


        .table tbody tr:nth-child(even) td {

            background: #f7f0e4;
        }


        .table tbody tr:hover td {

            background: #eee4d1;

            transition: 0.2s;
        }


        /* =========================================
           PRODUCT PHOTO
        ========================================= */

        .product-image {

            width: 60px;

            height: 60px;

            object-fit: cover;

            border-radius: 8px;

            border:
                2px solid #c6a455;

            background: #f3ecdf;
        }


        .no-image {

            width: 60px;

            height: 60px;

            background: #f3ecdf;

            border-radius: 8px;

            display: flex;

            align-items: center;

            justify-content: center;

            border:
                2px dashed #c6a455;

            color: #9b8a78;
        }


        .no-image i {

            font-size: 20px;
        }


        /* =========================================
           STATUS BADGES
        ========================================= */

        .badge {

            display: inline-block;

            padding: 6px 11px;

            border-radius: 20px;

            font-size: 11px;

            font-weight: bold;

            white-space: nowrap;
        }


        .badge-active {

            background: #e8dfb9;

            color: #5d501e;

            border:
                1px solid #c9b55f;
        }


        .badge-inactive {

            background: #e6ded8;

            color: #6c5b53;

            border:
                1px solid #bcaea5;
        }


        /* =========================================
           ACTION BUTTONS
        ========================================= */

        .action-buttons {

            display: flex;

            gap: 7px;
        }


        .action-btn {

            width: 34px;

            height: 34px;

            display: inline-flex;

            align-items: center;

            justify-content: center;

            border-radius: 7px;

            text-decoration: none;

            transition: 0.25s;

            font-size: 13px;
        }


        /* EDIT */

        .edit-btn {

            background: #e6c15c;

            color: #4d3b12;

            border:
                1px solid #c49b30;
        }


        .edit-btn:hover {

            background: #f1cf72;

            color: #3f300c;

            transform: translateY(-2px);
        }


        /* DELETE */

        .delete-btn {

            background: #7d2942;

            color: white;

            border:
                1px solid #8d3850;
        }


        .delete-btn:hover {

            background: #9a3150;

            color: white;

            transform: translateY(-2px);
        }


        /* =========================================
           NO ITEMS
        ========================================= */

        .no-items {

            text-align: center;

            padding: 35px 20px !important;

            color: #806d62 !important;

            font-size: 14px;
        }


        .no-items a {

            color: #7b1e3d;

            font-weight: bold;

            text-decoration: none;
        }


        .no-items a:hover {

            text-decoration: underline;
        }


        /* =========================================
           ERROR IN TABLE
        ========================================= */

        .table-error {

            text-align: center;

            padding: 25px !important;

            color: #8a263e !important;

            background: #f6e3e0 !important;
        }


        /* =========================================
           SIDEBAR TOGGLE
        ========================================= */

        #wrapper.toggled #sidebar-wrapper {

            margin-left: -250px;
        }


        /* =========================================
           RESPONSIVE
        ========================================= */

        @media (max-width: 900px) {

            .main-container {

                margin: 20px;

                padding: 20px;
            }

        }


        @media (max-width: 700px) {

            #sidebar-wrapper {

                width: 210px;
            }


            #wrapper.toggled #sidebar-wrapper {

                margin-left: -210px;
            }


            .main-container {

                margin: 15px;

                padding: 18px;

                border-radius: 15px;
            }


            .page-title {

                font-size: 24px;
            }


            .navbar {

                padding: 0 18px;
            }


            .card-header {

                flex-wrap: wrap;

                gap: 10px;
            }


            .add-button {

                margin-left: auto;
            }

        }

    </style>

</head>


<body>


<div id="wrapper">


    <!-- =====================================
         SIDEBAR
    ====================================== -->

    <div id="sidebar-wrapper">


        <div class="sidebar-heading">

            <i class="fas fa-tools"></i>

            Hardware Admin

        </div>


        <div class="list-group">


            <a href="${pageContext.request.contextPath}/admin/dashboard.jsp">

                <i class="fas fa-chart-pie"></i>

                Dashboard

            </a>


            <a href="${pageContext.request.contextPath}/admin/add-item.jsp">

                <i class="fas fa-plus-circle"></i>

                Add Item

            </a>


            <a href="${pageContext.request.contextPath}/admin/view-items.jsp"
               class="active">

                <i class="fas fa-list"></i>

                View Items

            </a>


            <a href="${pageContext.request.contextPath}/admin/profile.jsp">

                <i class="fas fa-user"></i>

                My Profile

            </a>


            <a href="${pageContext.request.contextPath}/admin/logout"
               class="logout">

                <i class="fas fa-sign-out-alt"></i>

                Logout

            </a>


        </div>

    </div>


    <!-- =====================================
         PAGE CONTENT
    ====================================== -->

    <div id="page-content-wrapper">


        <!-- NAVBAR -->

        <nav class="navbar">


            <button id="menu-toggle">

                <i class="fas fa-bars"></i>

            </button>


            <div class="admin-info">

                <i class="fas fa-user-circle"></i>

                <%= adminName %>

            </div>


        </nav>


        <!-- =====================================
             MAIN CONTAINER
        ====================================== -->

        <div class="main-container">


            <!-- PAGE TITLE -->

            <div class="page-title">

                <i class="fas fa-boxes-stacked"></i>

                All Items

            </div>


            <!-- =====================================
                 SUCCESS MESSAGE
            ====================================== -->

            <%
                String success = request.getParameter("success");

                if (success != null) {
            %>

                <div class="alert alert-success"
                     id="successAlert">

                    <i class="fas fa-check-circle"></i>

                    <%= success %>


                    <button type="button"
                            class="alert-close"
                            onclick="closeAlert('successAlert')">

                        &times;

                    </button>

                </div>

            <%
                }
            %>


            <!-- =====================================
                 ERROR MESSAGE
            ====================================== -->

            <%
                String error = request.getParameter("error");

                if (error != null) {
            %>

                <div class="alert alert-danger"
                     id="errorAlert">

                    <i class="fas fa-exclamation-circle"></i>

                    <%= error %>


                    <button type="button"
                            class="alert-close"
                            onclick="closeAlert('errorAlert')">

                        &times;

                    </button>

                </div>

            <%
                }
            %>


            <!-- =====================================
                 ITEMS CARD
            ====================================== -->

            <div class="card">


                <!-- CARD HEADER -->

                <div class="card-header">

                    <i class="fas fa-list"></i>

                    Item List


                    <a href="${pageContext.request.contextPath}/admin/add-item.jsp"
                       class="add-button">

                        <i class="fas fa-plus"></i>

                        Add New Item

                    </a>

                </div>


                <!-- CARD BODY -->

                <div class="card-body">


                    <div class="table-responsive">


                        <table class="table">


                            <!-- TABLE HEADER -->

                            <thead>

                                <tr>

                                    <th>ID</th>

                                    <th>Photo</th>

                                    <th>Name</th>

                                    <th>Category</th>

                                    <th>Brand</th>

                                    <th>Price (Rs.)</th>

                                    <th>Qty</th>

                                    <th>Status</th>

                                    <th>Actions</th>

                                </tr>

                            </thead>


                            <!-- TABLE BODY -->

                            <tbody>


                            <%

                                try (
                                    Connection conn =
                                        DBConnection.getConnection()
                                ) {


                                    String sql =
                                        "SELECT i.*, inv.quantity " +
                                        "FROM items i " +
                                        "LEFT JOIN inventory inv " +
                                        "ON i.item_id = inv.item_id " +
                                        "ORDER BY i.created_at DESC";


                                    PreparedStatement stmt =
                                        conn.prepareStatement(sql);


                                    ResultSet rs =
                                        stmt.executeQuery();


                                    if (!rs.isBeforeFirst()) {

                            %>


                                <tr>

                                    <td colspan="9"
                                        class="no-items">

                                        <i class="fas fa-box-open"></i>

                                        No items found.

                                        <a href="${pageContext.request.contextPath}/admin/add-item.jsp">

                                            Add your first item!

                                        </a>

                                    </td>

                                </tr>


                            <%

                                    }


                                    while (rs.next()) {

                            %>


                                <tr>


                                    <!-- ID -->

                                    <td>

                                        <%= rs.getInt("item_id") %>

                                    </td>


                                    <!-- PHOTO -->

                                    <td>

                                        <%

                                            String photoPath =
                                                rs.getString("photo_path");


                                            if (
                                                photoPath != null &&
                                                !photoPath.isEmpty()
                                            ) {

                                        %>


                                            <img
                                                src="${pageContext.request.contextPath}/<%= photoPath %>"
                                                alt="Product"
                                                class="product-image">


                                        <%

                                            } else {

                                        %>


                                            <div class="no-image">

                                                <i class="fas fa-camera"></i>

                                            </div>


                                        <%

                                            }

                                        %>

                                    </td>


                                    <!-- NAME -->

                                    <td>

                                        <%= rs.getString("item_name") %>

                                    </td>


                                    <!-- CATEGORY -->

                                    <td>

                                        <%= rs.getString("category") %>

                                    </td>


                                    <!-- BRAND -->

                                    <td>

                                        <%= rs.getString("brand") != null
                                            ? rs.getString("brand")
                                            : "-" %>

                                    </td>


                                    <!-- PRICE -->

                                    <td>

                                        Rs.
                                        <%= rs.getDouble("selling_price") %>

                                    </td>


                                    <!-- QUANTITY -->

                                    <td>

                                        <%= rs.getInt("quantity") %>

                                    </td>


                                    <!-- STATUS -->

                                    <td>


                                        <%

                                            String itemStatus =
                                                rs.getString("status");

                                            boolean isActive =
                                                "Active".equals(itemStatus);

                                        %>


                                        <span class="badge
                                            <%= isActive
                                                ? "badge-active"
                                                : "badge-inactive" %>">

                                            <%= itemStatus %>

                                        </span>


                                    </td>


                                    <!-- ACTIONS -->

                                    <td>


                                        <div class="action-buttons">


                                            <!-- EDIT -->

                                            <a
                                                href="${pageContext.request.contextPath}/admin/edit-item.jsp?id=<%= rs.getInt("item_id") %>"
                                                class="action-btn edit-btn"
                                                title="Edit Item">

                                                <i class="fas fa-edit"></i>

                                            </a>


                                            <!-- DELETE -->

                                            <a
                                                href="${pageContext.request.contextPath}/admin/delete-item?id=<%= rs.getInt("item_id") %>"
                                                class="action-btn delete-btn"
                                                title="Delete Item"
                                                onclick="return confirm('Are you sure you want to delete this item?')">

                                                <i class="fas fa-trash"></i>

                                            </a>


                                        </div>


                                    </td>


                                </tr>


                            <%

                                    }


                                    rs.close();

                                    stmt.close();


                                } catch (Exception e) {

                                    e.printStackTrace();

                            %>


                                <tr>

                                    <td colspan="9"
                                        class="table-error">

                                        <i class="fas fa-exclamation-triangle"></i>

                                        Error loading items:

                                        <%= e.getMessage() %>

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


        </div>

    </div>


</div>


<!-- =====================================
     JAVASCRIPT
====================================== -->

<script>


    // Sidebar toggle

    document
        .getElementById("menu-toggle")
        .addEventListener("click", function(e) {

            e.preventDefault();

            document
                .getElementById("wrapper")
                .classList
                .toggle("toggled");

        });


    // Close alert

    function closeAlert(id) {

        var alert =
            document.getElementById(id);

        if (alert) {

            alert.style.display = "none";

        }

    }

</script>


</body>

</html>