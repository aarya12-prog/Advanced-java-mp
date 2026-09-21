<%@ page import="java.sql.*, com.hardware.utils.DBConnection" %>

<%
    // Check if admin is logged in
    if (session == null || session.getAttribute("isLoggedIn") == null) {
        response.sendRedirect(request.getContextPath() + "/admin/login.jsp");
        return;
    }

    String adminName = (String) session.getAttribute("adminName");

    // Get stats
    int totalItems = 0, totalSuppliers = 0, lowStock = 0, totalSales = 0;

    try (Connection conn = DBConnection.getConnection()) {

        PreparedStatement stmt1 = conn.prepareStatement(
            "SELECT COUNT(*) FROM items"
        );
        ResultSet rs1 = stmt1.executeQuery();

        if (rs1.next())
            totalItems = rs1.getInt(1);

        rs1.close();
        stmt1.close();


        PreparedStatement stmt2 = conn.prepareStatement(
            "SELECT COUNT(*) FROM suppliers"
        );
        ResultSet rs2 = stmt2.executeQuery();

        if (rs2.next())
            totalSuppliers = rs2.getInt(1);

        rs2.close();
        stmt2.close();


        PreparedStatement stmt3 = conn.prepareStatement(
            "SELECT COUNT(*) FROM inventory WHERE quantity < reorder_level"
        );
        ResultSet rs3 = stmt3.executeQuery();

        if (rs3.next())
            lowStock = rs3.getInt(1);

        rs3.close();
        stmt3.close();


        PreparedStatement stmt4 = conn.prepareStatement(
            "SELECT SUM(quantity_sold) FROM sales"
        );
        ResultSet rs4 = stmt4.executeQuery();

        if (rs4.next())
            totalSales = rs4.getInt(1);

        rs4.close();
        stmt4.close();

    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html>
<head>

    <meta charset="UTF-8">

    <title>Dashboard - Hardware Management</title>

    <!-- Font Awesome only for icons -->
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>

        /* =========================
           GLOBAL
        ========================= */

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: Arial, Helvetica, sans-serif;
            background:
                radial-gradient(circle at 20% 20%, rgba(150, 110, 30, 0.12), transparent 25%),
                radial-gradient(circle at 80% 70%, rgba(150, 110, 30, 0.10), transparent 25%),
                #10090b;

            color: #4d2630;
            min-height: 100vh;
        }


        /* =========================
           MAIN WRAPPER
        ========================= */

        #wrapper {
            display: flex;
            min-height: 100vh;
        }


        /* =========================
           SIDEBAR
        ========================= */

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

            color: #eadfca !important;

            text-decoration: none;

            border-left: 4px solid transparent;

            transition: 0.3s;
        }

        .list-group a i {
            width: 25px;
            color: #d5ae55;
        }

        .list-group a:hover {
            background: rgba(151, 103, 28, 0.15);

            color: #ffffff !important;

            border-left: 4px solid #d5ae55;
        }

        .list-group a.active {
            background: #651b36;

            color: #ffffff !important;

            border-left: 4px solid #e0b957;

            box-shadow:
                inset 0 0 15px rgba(0, 0, 0, 0.25);
        }

        .list-group a.active i {
            color: #f1cf72;
        }

        .logout {
            color: #d99b8e !important;
        }


        /* =========================
           PAGE CONTENT
        ========================= */

        #page-content-wrapper {
            width: 100%;
            min-height: 100vh;
        }


        /* =========================
           TOP NAVBAR
        ========================= */

        .navbar {
            height: 80px;

            background: #eee9df;

            border-bottom: 1px solid #c8a65b;

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
        }

        #menu-toggle:hover {
            background: #7c2443;
        }

        .admin-info {
            margin-left: auto;

            color: #5b2836;

            font-weight: bold;
        }

        .admin-info i {
            color: #7b1e3d;
        }


        /* =========================
           MAIN CONTAINER
        ========================= */

        .container-fluid {
            width: 100%;
        }

        .main-container {
            margin: 30px;

            background: #f1eee7;

            border: 2px solid #b9954c;

            border-radius: 20px;

            padding: 30px;

            box-shadow:
                0 15px 40px rgba(0, 0, 0, 0.45);
        }


        /* =========================
           PAGE TITLE
        ========================= */

        h1 {
            color: #651b36;

            font-size: 30px;

            margin-bottom: 5px;
        }

        .welcome {
            color: #806d62;

            margin-bottom: 25px;

            font-size: 15px;
        }


        /* =========================
           STAT CARDS
        ========================= */

        .stats-row {
            display: grid;

            grid-template-columns:
                repeat(4, 1fr);

            gap: 18px;

            margin-bottom: 30px;
        }

        .stat-card {
            padding: 22px;

            min-height: 130px;

            border-radius: 14px;

            border: 1px solid #c6a455;

            background: #fffaf0;

            box-shadow:
                0 5px 15px rgba(72, 38, 20, 0.15);

            transition: 0.3s;
        }

        .stat-card:hover {
            transform: translateY(-3px);

            box-shadow:
                0 8px 20px rgba(72, 38, 20, 0.25);
        }

        .stat-card .stat-content {
            display: flex;

            justify-content: space-between;

            align-items: center;
        }

        .stat-card h6 {
            color: #735b51;

            font-size: 14px;

            margin-bottom: 10px;
        }

        .stat-card h2 {
            color: #651b36;

            font-size: 30px;

            font-weight: bold;
        }

        .stat-card i {
            font-size: 40px;

            color: #bd963b;

            opacity: 0.7;
        }


        /* Individual cards */

        .items-card {
            border-top: 5px solid #651b36;
        }

        .suppliers-card {
            border-top: 5px solid #92732f;
        }

        .lowstock-card {
            border-top: 5px solid #b38a27;
        }

        .sales-card {
            border-top: 5px solid #7b1e3d;
        }


        /* =========================
           RECENT ITEMS
        ========================= */

        .card {
            background: #fffdf8;

            border: 1px solid #c6a455;

            border-radius: 15px;

            overflow: hidden;

            box-shadow:
                0 5px 18px rgba(71, 39, 23, 0.15);
        }

        .card-header {
            padding: 18px 22px;

            background: #651b36;

            color: #ffffff;

            font-size: 17px;

            font-weight: bold;

            border-bottom: 3px solid #c6a455;
        }

        .card-header i {
            color: #e5c36b;

            margin-right: 8px;
        }

        .card-body {
            padding: 0;

            overflow-x: auto;
        }


        /* =========================
           TABLE
        ========================= */

        .table {
            width: 100%;

            border-collapse: collapse;

            margin: 0;
        }

        .table thead {
            background: #741c3b;

            color: #f9e6ad;
        }

        .table th {
            padding: 15px 18px;

            text-align: left;

            font-size: 13px;

            text-transform: uppercase;

            letter-spacing: 0.5px;

            border-bottom: 2px solid #c6a455;
        }

        .table td {
            padding: 15px 18px;

            color: #56323b;

            font-size: 14px;

            border-bottom: 1px solid #e3d8c5;
        }

        .table tbody tr:nth-child(even) {
            background: #f6efe3;
        }

        .table tbody tr:nth-child(odd) {
            background: #fffdf8;
        }

        .table tbody tr:hover {
            background: #eee2cc;
        }


        /* =========================
           STATUS BADGES
        ========================= */

        .badge {
            display: inline-block;

            padding: 7px 13px;

            border-radius: 20px;

            font-size: 12px;

            font-weight: bold;
        }

        .badge-active {
            background: #f5e6b8;

            color: #765516;

            border: 1px solid #d8b65d;
        }

        .badge-inactive {
            background: #e7dddd;

            color: #6c4545;

            border: 1px solid #bfa4a4;
        }


        /* =========================
           SIDEBAR TOGGLE
        ========================= */

        #wrapper.toggled #sidebar-wrapper {
            margin-left: -250px;
        }


        /* =========================
           RESPONSIVE
        ========================= */

        @media (max-width: 1000px) {

            .stats-row {
                grid-template-columns: repeat(2, 1fr);
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
                padding: 20px;
            }

            .stats-row {
                grid-template-columns: 1fr;
            }

        }

    </style>

</head>

<body>

<div id="wrapper">

    <!-- =========================
         SIDEBAR
    ========================== -->

    <div id="sidebar-wrapper">

        <div class="sidebar-heading">

            <i class="fas fa-tools"></i>

            Hardware Admin

        </div>

        <div class="list-group">

            <a href="${pageContext.request.contextPath}/admin/dashboard.jsp"
               class="active">

                <i class="fas fa-chart-pie"></i>
                Dashboard

            </a>

            <a href="${pageContext.request.contextPath}/admin/add-item.jsp">

                <i class="fas fa-plus-circle"></i>
                Add Item

            </a>

            <a href="${pageContext.request.contextPath}/admin/view-items.jsp">

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


    <!-- =========================
         PAGE CONTENT
    ========================== -->

    <div id="page-content-wrapper">

        <!-- TOP NAVBAR -->

        <nav class="navbar">

            <button id="menu-toggle">

                <i class="fas fa-bars"></i>

            </button>

            <div class="admin-info">

                <span style="margin-right: 25px;">

                    <i class="fas fa-bell"></i>

                </span>

                <i class="fas fa-user-circle"></i>

                <%= adminName %>

            </div>

        </nav>


        <!-- MAIN CONTENT -->

        <div class="main-container">

            <h1>Dashboard</h1>

            <p class="welcome">
                Welcome back, <%= adminName %>!
            </p>


            <!-- =========================
                 STATISTICS
            ========================== -->

            <div class="stats-row">


                <!-- TOTAL ITEMS -->

                <div class="stat-card items-card">

                    <div class="stat-content">

                        <div>

                            <h6>Total Items</h6>

                            <h2>
                                <%= totalItems %>
                            </h2>

                        </div>

                        <i class="fas fa-cubes"></i>

                    </div>

                </div>


                <!-- SUPPLIERS -->

                <div class="stat-card suppliers-card">

                    <div class="stat-content">

                        <div>

                            <h6>Suppliers</h6>

                            <h2>
                                <%= totalSuppliers %>
                            </h2>

                        </div>

                        <i class="fas fa-truck"></i>

                    </div>

                </div>


                <!-- LOW STOCK -->

                <div class="stat-card lowstock-card">

                    <div class="stat-content">

                        <div>

                            <h6>Low Stock</h6>

                            <h2>
                                <%= lowStock %>
                            </h2>

                        </div>

                        <i class="fas fa-exclamation-triangle"></i>

                    </div>

                </div>


                <!-- TOTAL SALES -->

                <div class="stat-card sales-card">

                    <div class="stat-content">

                        <div>

                            <h6>Total Sales</h6>

                            <h2>
                                <%= totalSales %>
                            </h2>

                        </div>

                        <i class="fas fa-chart-line"></i>

                    </div>

                </div>

            </div>


            <!-- =========================
                 RECENT ITEMS
            ========================== -->

            <div class="card">

                <div class="card-header">

                    <i class="fas fa-clock"></i>

                    Recent Items

                </div>


                <div class="card-body">

                    <table class="table">

                        <thead>

                            <tr>

                                <th>Name</th>

                                <th>Category</th>

                                <th>Price</th>

                                <th>Status</th>

                            </tr>

                        </thead>


                        <tbody>

                            <%
                                try (Connection conn = DBConnection.getConnection()) {

                                    String sql =
                                        "SELECT item_name, category, selling_price, status " +
                                        "FROM items " +
                                        "ORDER BY created_at DESC LIMIT 5";

                                    PreparedStatement stmt =
                                        conn.prepareStatement(sql);

                                    ResultSet rs =
                                        stmt.executeQuery();

                                    while (rs.next()) {

                                        String status =
                                            rs.getString("status");

                                        String badgeClass =
                                            status.equals("Active")
                                            ? "badge-active"
                                            : "badge-inactive";
                            %>

                            <tr>

                                <td>
                                    <%= rs.getString("item_name") %>
                                </td>

                                <td>
                                    <%= rs.getString("category") %>
                                </td>

                                <td>
                                    Rs.<%= rs.getDouble("selling_price") %>
                                </td>

                                <td>

                                    <span class="badge <%= badgeClass %>">

                                        <%= status %>

                                    </span>

                                </td>

                            </tr>

                            <%
                                    }

                                    rs.close();
                                    stmt.close();

                                } catch (Exception e) {

                                    e.printStackTrace();

                                }
                            %>

                        </tbody>

                    </table>

                </div>

            </div>

        </div>

    </div>

</div>


<!-- =========================
     MENU SCRIPT
========================= -->

<script>

    document.getElementById("menu-toggle")
        .addEventListener("click", function(e) {

            e.preventDefault();

            document.getElementById("wrapper")
                .classList.toggle("toggled");

        });

</script>

</body>
</html>