<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    /* =====================================================
       LOGGED-IN USER
       ===================================================== */

    String username = (String) session.getAttribute("username");

    if (username == null || username.trim().isEmpty()) {
        username = "Administrator";
    }


    /* =====================================================
       RECENT INVENTORY ACTIVITY
       These values are set by the stock/reorder Servlet.
       ===================================================== */

    String activityType =
            (String) session.getAttribute("activityType");

    String activityProduct =
            (String) session.getAttribute("activityProduct");

    String activityQuantity =
            (String) session.getAttribute("activityQuantity");

    String activityTime =
            (String) session.getAttribute("activityTime");


    /*
     * Default activity shown when there is no new
     * stock activity in the current session.
     */
    if (activityType == null ||
        activityProduct == null ||
        activityProduct.trim().isEmpty()) {

        activityType = "Stock Updated";
        activityProduct = "Ultrasonic Sensor";
        activityQuantity = "6";
        activityTime = "2 hrs ago";
    }
%>


<!DOCTYPE html>

<html>

<head>

    <meta charset="UTF-8">

    <title>Inventory Management Dashboard</title>


    <style>

        /* =====================================================
           GLOBAL
           ===================================================== */

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: "Segoe UI", Arial, sans-serif;
        }

        html,
        body {
            width: 100%;
            height: 100%;
        }

        body {
            background: #edf5f9;
            color: #26343b;
            overflow: hidden;
        }


        /* =====================================================
           MAIN DASHBOARD
           ===================================================== */

        .dashboard {
            width: 100%;
            height: 100vh;
        }


        /* =====================================================
           APPLICATION
           ===================================================== */

        .application {
            width: 100%;
            height: 100vh;

            display: flex;

            background: #eaf4f8;

            overflow: hidden;
        }


        /* =====================================================
           SIDEBAR
           ===================================================== */

        .sidebar {
            width: 220px;
            min-width: 220px;

            height: 100%;

            background: #28586d;
            color: white;

            display: flex;
            flex-direction: column;
        }


        /* =====================================================
           PROFILE
           ===================================================== */

        .profile {
            padding: 28px 15px 22px;

            text-align: center;

            background: #28586d;
        }

        .profile-icon {
            width: 65px;
            height: 65px;

            margin: 0 auto 10px;

            border-radius: 50%;

            background: #d9eef5;

            border: 3px solid #9bc8d7;

            display: flex;
            align-items: center;
            justify-content: center;

            color: #28586d;
        }

        .profile-icon svg {
            width: 30px;
            height: 30px;

            fill: none;
            stroke: currentColor;
            stroke-width: 2;
            stroke-linecap: round;
            stroke-linejoin: round;
        }

        .profile h3 {
            font-size: 14px;
            font-weight: 600;
        }

        .profile p {
            font-size: 10px;

            opacity: 0.8;

            margin-top: 4px;
        }


        /* =====================================================
           MENU
           ===================================================== */

        .menu {
            padding: 10px 12px;
        }

        .menu a {
            display: flex;
            align-items: center;

            gap: 13px;

            padding: 13px 14px;

            margin-bottom: 6px;

            border-radius: 10px;

            color: white;

            text-decoration: none;

            font-size: 13px;
            font-weight: 500;

            transition: 0.2s;
        }

        .menu a:hover {
            background: rgba(255,255,255,0.12);
        }

        .menu a.active {
            background: #d8edf5;
            color: #28586d;
        }

        .menu-icon {
            width: 21px;
            height: 21px;

            display: flex;
            align-items: center;
            justify-content: center;

            flex-shrink: 0;
        }

        .menu-icon svg {
            width: 19px;
            height: 19px;

            fill: none;
            stroke: currentColor;
            stroke-width: 2;
            stroke-linecap: round;
            stroke-linejoin: round;
        }

        .menu-divider {
            height: 1px;

            background: rgba(255,255,255,0.22);

            margin: 15px 5px;
        }


        /* =====================================================
           LOGOUT
           ===================================================== */

        .logout {
            margin-top: auto;

            padding: 18px 12px;
        }

        .logout a {
            display: flex;
            align-items: center;

            gap: 13px;

            padding: 12px 14px;

            color: white;

            text-decoration: none;

            font-size: 13px;

            border-radius: 10px;
        }

        .logout a:hover {
            background: rgba(255,255,255,0.12);
        }


        /* =====================================================
           MAIN CONTENT
           ===================================================== */

        .content {
            flex: 1;

            min-width: 0;

            height: 100%;

            background: #eaf4f8;

            overflow-y: auto;
        }


        /* =====================================================
           TOP BAR
           ===================================================== */

        .topbar {
            height: 72px;

            background: white;

            display: flex;
            align-items: center;

            padding: 0 30px;

            border-bottom: 1px solid #d6e4e9;

            flex-shrink: 0;
        }

        .welcome {
            flex: 1;

            font-size: 18px;

            font-weight: 500;

            color: #26343b;
        }

        .welcome strong {
            color: #28586d;
            font-weight: 700;
        }


        /* =====================================================
           ADVANCED SEARCH BUTTON
           ===================================================== */

        .advanced-search {
            height: 38px;

            padding: 0 17px;

            display: flex;
            align-items: center;
            justify-content: center;

            gap: 9px;

            border-radius: 20px;

            background: #28586d;

            color: white;

            text-decoration: none;

            font-size: 11px;
            font-weight: 600;

            transition: 0.2s;
        }

        .advanced-search:hover {
            background: #1f4759;

            transform: translateY(-1px);
        }

        .advanced-search svg {
            width: 17px;
            height: 17px;

            fill: none;
            stroke: currentColor;
            stroke-width: 2;
            stroke-linecap: round;
            stroke-linejoin: round;
        }


        /* =====================================================
           ACTIVE USER
           ===================================================== */

        .active-user {
            display: flex;
            align-items: center;

            gap: 9px;

            margin-left: 18px;

            padding-left: 18px;

            border-left: 1px solid #d6e4e9;
        }

        .active-user-icon {
            width: 36px;
            height: 36px;

            border-radius: 50%;

            background: #d9eef5;

            color: #28586d;

            display: flex;
            align-items: center;
            justify-content: center;
        }

        .active-user-icon svg {
            width: 18px;
            height: 18px;

            fill: none;
            stroke: currentColor;
            stroke-width: 2;
            stroke-linecap: round;
            stroke-linejoin: round;
        }

        .active-user-text strong {
            display: block;

            font-size: 11px;

            color: #26343b;
        }

        .active-user-text span {
            display: block;

            font-size: 9px;

            color: #718087;

            margin-top: 2px;
        }


        /* =====================================================
           CONTENT BODY
           ===================================================== */

        .content-body {
            padding: 25px 30px 22px;

            min-height: calc(100vh - 72px);

            display: flex;
            flex-direction: column;
        }


        /* =====================================================
           SECTION HEADER
           ===================================================== */

        .section-header {
            display: flex;

            align-items: center;

            justify-content: space-between;

            margin-bottom: 12px;
        }

        .section-title {
            font-size: 17px;

            font-weight: 600;

            color: #26343b;
        }

        .section-subtitle {
            font-size: 11px;

            color: #718087;
        }


        /* =====================================================
           KPI CARDS
           ===================================================== */

        .stats-grid {
            display: grid;

            grid-template-columns: repeat(4, 1fr);

            gap: 14px;

            margin-bottom: 18px;
        }

        .stat-card {
            background: #ffffff;

            border: 1px solid #d1e0e5;

            border-radius: 12px;

            padding: 16px 17px;

            min-height: 105px;

            display: flex;

            align-items: center;

            gap: 14px;

            transition: 0.2s;
        }

        .stat-card:hover {
            transform: translateY(-2px);

            box-shadow:
                0 7px 18px rgba(40,88,109,0.10);
        }

        .stat-icon {
            width: 48px;
            height: 48px;

            border-radius: 12px;

            display: flex;
            align-items: center;
            justify-content: center;

            background: #d8f1ec;

            color: #28586d;

            flex-shrink: 0;
        }

        .stat-icon svg {
            width: 23px;
            height: 23px;

            fill: none;
            stroke: currentColor;
            stroke-width: 2;
            stroke-linecap: round;
            stroke-linejoin: round;
        }

        .stat-card.warning .stat-icon {
            background: #f4e5d8;
            color: #925b36;
        }

        .stat-card.danger .stat-icon {
            background: #f3dfe3;
            color: #7e1737;
        }

        .stat-card.gold .stat-icon {
            background: #f5e6b3;
            color: #7e1737;
        }

        .stat-label {
            font-size: 11px;

            color: #687980;

            margin-bottom: 3px;
        }

        .stat-value {
            font-size: 25px;

            font-weight: 700;

            color: #26343b;
        }

        .stat-description {
            font-size: 9px;

            color: #87949a;

            margin-top: 2px;
        }


        /* =====================================================
           MAIN TWO COLUMN AREA
           ===================================================== */

        .main-grid {
            display: grid;

            grid-template-columns: 1.35fr 1fr;

            gap: 18px;

            margin-bottom: 18px;

            flex: 1;

            min-height: 250px;
        }


        /* =====================================================
           PANEL
           ===================================================== */

        .panel {
            background: #ffffff;

            border: 1px solid #d1e0e5;

            border-radius: 12px;

            padding: 18px;

            min-height: 255px;
        }


        /* =====================================================
           LOW STOCK TABLE
           ===================================================== */

        .alert-title {
            display: flex;

            align-items: center;

            justify-content: space-between;

            margin-bottom: 14px;
        }

        .alert-title h2 {
            font-size: 16px;

            color: #711832;
        }

        .alert-count {
            background: #f3dfe3;

            color: #7e1737;

            padding: 5px 9px;

            border-radius: 15px;

            font-size: 10px;

            font-weight: 600;
        }

        .stock-table {
            width: 100%;

            border-collapse: collapse;
        }

        .stock-table th {
            text-align: left;

            font-size: 10px;

            font-weight: 600;

            color: #718087;

            padding: 8px 7px;

            border-bottom: 1px solid #dfe8eb;
        }

        .stock-table td {
            padding: 10px 7px;

            font-size: 11px;

            border-bottom: 1px solid #edf2f4;
        }

        .stock-table tr:last-child td {
            border-bottom: none;
        }

        .product-name {
            font-weight: 600;

            color: #35464d;
        }

        .stock-number {
            font-weight: 600;

            color: #7e1737;
        }

        .status {
            display: inline-block;

            padding: 4px 8px;

            border-radius: 12px;

            font-size: 9px;

            font-weight: 600;
        }

        .status.low {
            background: #f8eadc;

            color: #925b36;
        }

        .status.critical {
            background: #f3dfe3;

            color: #7e1737;
        }

        .status.out {
            background: #e5e8ea;

            color: #39484e;
        }

        .reorder-link {
            display: inline-block;

            margin-top: 12px;

            color: #7e1737;

            text-decoration: none;

            font-size: 11px;

            font-weight: 600;
        }

        .reorder-link:hover {
            text-decoration: underline;
        }


        /* =====================================================
           INVENTORY OVERVIEW
           ===================================================== */

        .inventory-overview h2 {
            font-size: 16px;

            color: #711832;

            margin-bottom: 15px;
        }

        .distribution {
            display: flex;

            align-items: center;

            justify-content: center;

            gap: 25px;

            height: calc(100% - 35px);
        }

        .donut {
            width: 145px;
            height: 145px;

            border-radius: 50%;

            background:
                conic-gradient(
                    #28586d 0deg 245deg,
                    #d4a72c 245deg 320deg,
                    #7e1737 320deg 360deg
                );

            display: flex;

            align-items: center;
            justify-content: center;

            flex-shrink: 0;
        }

        .donut-inner {
            width: 94px;
            height: 94px;

            border-radius: 50%;

            background: white;

            display: flex;

            flex-direction: column;

            align-items: center;
            justify-content: center;
        }

        .donut-inner strong {
            font-size: 20px;

            color: #26343b;
        }

        .donut-inner span {
            font-size: 9px;

            color: #718087;
        }

        .legend {
            flex: 1;

            max-width: 170px;
        }

        .legend-item {
            display: flex;

            align-items: center;

            justify-content: space-between;

            padding: 9px 0;

            border-bottom: 1px solid #edf2f4;
        }

        .legend-item:last-child {
            border-bottom: none;
        }

        .legend-left {
            display: flex;

            align-items: center;

            gap: 8px;

            font-size: 11px;

            color: #526168;
        }

        .legend-dot {
            width: 9px;
            height: 9px;

            border-radius: 50%;
        }

        .dot-stock {
            background: #28586d;
        }

        .dot-low {
            background: #d4a72c;
        }

        .dot-out {
            background: #7e1737;
        }

        .legend-value {
            font-size: 11px;

            font-weight: 600;

            color: #26343b;
        }


        /* =====================================================
           BOTTOM GRID
           ===================================================== */

        .bottom-grid {
            display: grid;

            grid-template-columns: 1.35fr 1fr;

            gap: 18px;

            height: 185px;

            flex-shrink: 0;
        }

        .bottom-grid .panel {
            min-height: 0;
        }


        /* =====================================================
           RECENT ACTIVITY
           ===================================================== */

        .activity-panel h2,
        .quick-panel h2 {
            font-size: 16px;

            color: #711832;

            margin-bottom: 10px;
        }

        .activity {
            display: flex;

            flex-direction: column;
        }

        .activity-item {
            display: flex;

            align-items: center;

            gap: 11px;

            padding: 7px 0;

            border-bottom: 1px solid #edf2f4;
        }

        .activity-item:last-child {
            border-bottom: none;
        }

        .activity-icon {
            width: 30px;
            height: 30px;

            border-radius: 8px;

            display: flex;

            align-items: center;
            justify-content: center;

            background: #d8f1ec;

            color: #28586d;

            flex-shrink: 0;
        }

        .activity-icon svg {
            width: 16px;
            height: 16px;

            fill: none;

            stroke: currentColor;

            stroke-width: 2;

            stroke-linecap: round;

            stroke-linejoin: round;
        }

        .activity-icon.reorder {
            background: #f5e6b3;

            color: #7e1737;
        }

        .activity-icon.remove {
            background: #f3dfe3;

            color: #7e1737;
        }

        .activity-text {
            flex: 1;

            font-size: 10px;

            color: #526168;

            line-height: 1.35;
        }

        .activity-text strong {
            color: #35464d;
        }

        .activity-stock {
            display: block;

            margin-top: 2px;

            font-size: 9px;

            color: #87949a;
        }

        .activity-time {
            font-size: 9px;

            color: #8a979d;

            white-space: nowrap;
        }


        /* =====================================================
           QUICK ACTIONS
           ===================================================== */

        .quick-actions {
            display: grid;

            grid-template-columns: 1fr 1fr;

            gap: 9px;
        }

        .quick-action {
            min-height: 55px;

            background: #f8fcfd;

            border: 1px solid #d1e0e5;

            border-radius: 9px;

            padding: 9px;

            display: flex;

            align-items: center;

            gap: 9px;

            text-decoration: none;

            color: #35464d;

            transition: 0.2s;
        }

        .quick-action:hover {
            border-color: #9bb5bf;

            background: #f2f9fb;

            transform: translateY(-2px);
        }

        .quick-icon {
            width: 32px;
            height: 32px;

            border-radius: 8px;

            background: #f5e6b3;

            color: #7e1737;

            display: flex;

            align-items: center;
            justify-content: center;

            flex-shrink: 0;
        }

        .quick-icon svg {
            width: 16px;
            height: 16px;

            fill: none;

            stroke: currentColor;

            stroke-width: 2;

            stroke-linecap: round;

            stroke-linejoin: round;
        }

        .quick-action span {
            font-size: 10px;

            font-weight: 600;

            line-height: 1.3;
        }


        /* =====================================================
           FOOTER
           ===================================================== */

        .bottom-label {
            text-align: right;

            margin-top: 10px;

            font-size: 9px;

            color: #718087;
        }


        /* =====================================================
           SCROLLBAR
           ===================================================== */

        .content::-webkit-scrollbar {
            width: 7px;
        }

        .content::-webkit-scrollbar-track {
            background: #eaf4f8;
        }

        .content::-webkit-scrollbar-thumb {
            background: #9bb5bf;

            border-radius: 10px;
        }


        /* =====================================================
           TABLET
           ===================================================== */

        @media (max-width: 1100px) {

            .sidebar {
                width: 200px;
                min-width: 200px;
            }

            .stats-grid {
                grid-template-columns: repeat(2, 1fr);
            }

            .main-grid,
            .bottom-grid {
                grid-template-columns: 1fr;
            }

            .bottom-grid {
                height: auto;
            }
        }


        /* =====================================================
           MOBILE
           ===================================================== */

        @media (max-width: 700px) {

            body {
                overflow: auto;
            }

            .application {
                height: auto;

                min-height: 100vh;

                flex-direction: column;
            }

            .sidebar {
                width: 100%;

                min-width: 100%;

                height: auto;
            }

            .profile {
                display: none;
            }

            .menu {
                display: flex;

                overflow-x: auto;

                padding: 8px;
            }

            .menu a {
                white-space: nowrap;

                margin: 0 5px 0 0;
            }

            .menu-divider {
                display: none;
            }

            .logout {
                display: none;
            }

            .topbar {
                flex-wrap: wrap;

                height: auto;

                min-height: 65px;

                gap: 10px;

                padding: 12px 15px;
            }

            .welcome {
                width: 100%;

                flex: none;

                font-size: 16px;
            }

            .advanced-search {
                flex: 1;
            }

            .active-user {
                margin-left: 5px;

                padding-left: 10px;
            }

            .content-body {
                padding: 15px;
            }

            .stats-grid {
                grid-template-columns: 1fr;
            }

            .main-grid,
            .bottom-grid {
                grid-template-columns: 1fr;
            }

            .distribution {
                flex-direction: column;
            }
        }

    </style>

</head>


<body>


<div class="dashboard">


    <div class="application">


        <!-- =================================================
             SIDEBAR
             ================================================= -->

        <aside class="sidebar">


            <!-- PROFILE -->

            <div class="profile">

                <div class="profile-icon">

                    <svg viewBox="0 0 24 24">

                        <circle cx="12" cy="8" r="4"></circle>

                        <path d="M4 21c1.5-4.2 4.2-6 8-6s6.5 1.8 8 6"></path>

                    </svg>

                </div>

                <h3>
                    <%= username %>
                </h3>

                <p>
                    Active User
                </p>

            </div>


            <!-- =================================================
                 MENU
                 ================================================= -->

            <nav class="menu">


                <!-- DASHBOARD -->

                <a href="index.jsp" class="active">

                    <span class="menu-icon">

                        <svg viewBox="0 0 24 24">

                            <rect x="3" y="3" width="7" height="7"></rect>

                            <rect x="14" y="3" width="7" height="7"></rect>

                            <rect x="3" y="14" width="7" height="7"></rect>

                            <rect x="14" y="14" width="7" height="7"></rect>

                        </svg>

                    </span>

                    Dashboard

                </a>


                <!-- STOCK MANAGEMENT -->

                <a href="ViewStockServlet">

                    <span class="menu-icon">

                        <svg viewBox="0 0 24 24">

                            <path d="M21 16V8a2 2 0 0 0-1-1.7l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.7l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"></path>

                            <polyline points="3.3 7 12 12 20.7 7"></polyline>

                            <line x1="12" y1="22" x2="12" y2="12"></line>

                        </svg>

                    </span>

                    Stock Management

                </a>


              

                   


                <!-- RECOMMENDATIONS -->

                <a href="recommend.jsp">

                    <span class="menu-icon">

                        <svg viewBox="0 0 24 24">

                            <path d="M9 18h6"></path>

                            <path d="M10 22h4"></path>

                            <path d="M8.5 14.5C7.5 13.7 7 12.5 7 11a5 5 0 0 1 10 0c0 1.5-.5 2.7-1.5 3.5-.7.6-1 1.2-1.2 2.5h-4.6c-.2-1.3-.5-1.9-1.2-2.5z"></path>

                        </svg>

                    </span>

                    Recommendations

                </a>


                <!-- SUPPLIER FEEDBACK -->

                <a href="supplier-feedback.jsp">

                    <span class="menu-icon">

                        <svg viewBox="0 0 24 24">

                            <path d="M21 11.5a8.4 8.4 0 0 1-9 8.5 9.2 9.2 0 0 1-4-.9L3 21l1.9-4.6A8.1 8.1 0 0 1 3 11.5a8.5 8.5 0 0 1 18 0z"></path>

                            <line x1="8" y1="11" x2="16" y2="11"></line>

                            <line x1="8" y1="14" x2="13" y2="14"></line>

                        </svg>

                    </span>

                    Supplier Feedback

                </a>


                <!-- ANALYTICS -->

                <a href="analytics.jsp">

                    <span class="menu-icon">

                        <svg viewBox="0 0 24 24">

                            <line x1="4" y1="20" x2="4" y2="10"></line>

                            <line x1="10" y1="20" x2="10" y2="5"></line>

                            <line x1="16" y1="20" x2="16" y2="13"></line>

                            <line x1="22" y1="20" x2="22" y2="7"></line>

                        </svg>

                    </span>

                    Analytics

                </a>


                <div class="menu-divider"></div>


                <!-- REORDER -->

                <a href="reorder.jsp">

                    <span class="menu-icon">

                        <svg viewBox="0 0 24 24">

                            <path d="M20 11a8 8 0 0 0-15.5-3"></path>

                            <polyline points="4 4 4 8 8 8"></polyline>

                            <path d="M4 13a8 8 0 0 0 15.5 3"></path>

                            <polyline points="20 20 20 16 16 16"></polyline>

                        </svg>

                    </span>

                    Reorder Management

                </a>


            </nav>


            <!-- LOGOUT -->

            <div class="logout">

                <a href="login.html">

                    <span class="menu-icon">

                        <svg viewBox="0 0 24 24">

                            <path d="M10 17l5-5-5-5"></path>

                            <line x1="15" y1="12" x2="3" y2="12"></line>

                            <path d="M21 19V5a2 2 0 0 0-2-2h-6"></path>

                        </svg>

                    </span>

                    Logout

                </a>

            </div>


        </aside>


        <!-- =================================================
             MAIN CONTENT
             ================================================= -->

        <main class="content">


            <!-- =================================================
                 TOP BAR
                 ================================================= -->

            <div class="topbar">


                <div class="welcome">

                    Welcome,

                    <strong>
                        <%= username %>
                    </strong>

                </div>


                <!-- ADVANCED HARDWARE SEARCH -->

                <a href="search.jsp"
                   class="advanced-search">

                    <svg viewBox="0 0 24 24">

                        <circle cx="11" cy="11" r="7"></circle>

                        <line x1="16.5"
                              y1="16.5"
                              x2="21"
                              y2="21"></line>

                    </svg>

                    Advanced Hardware Search

                </a>


                <!-- ACTIVE USER -->

                <div class="active-user">

                    <div class="active-user-icon">

                        <svg viewBox="0 0 24 24">

                            <circle cx="12" cy="8" r="4"></circle>

                            <path d="M4 21c1.5-4.2 4.2-6 8-6s6.5 1.8 8 6"></path>

                        </svg>

                    </div>


                    <div class="active-user-text">

                        <strong>
                            <%= username %>
                        </strong>

                        <span>
                            Active User
                        </span>

                    </div>

                </div>


            </div>


            <!-- =================================================
                 CONTENT BODY
                 ================================================= -->

            <div class="content-body">


                <!-- SECTION HEADER -->

                <div class="section-header">

                    <div>

                        <div class="section-title">
                            Inventory Overview
                        </div>

                        <div class="section-subtitle">
                            Current status of your hardware and electronics inventory
                        </div>

                    </div>

                </div>


                <!-- =================================================
                     STAT CARDS
                     ================================================= -->

                <div class="stats-grid">


                    <!-- TOTAL PRODUCTS -->

                    <div class="stat-card">

                        <div class="stat-icon">

                            <svg viewBox="0 0 24 24">

                                <path d="M21 16V8a2 2 0 0 0-1-1.7l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.7l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"></path>

                                <polyline points="3.3 7 12 12 20.7 7"></polyline>

                                <line x1="12"
                                      y1="22"
                                      x2="12"
                                      y2="12"></line>

                            </svg>

                        </div>

                        <div>

                            <div class="stat-label">
                                Total Products
                            </div>

                            <div class="stat-value">
                                150
                            </div>

                            <div class="stat-description">
                                Registered items
                            </div>

                        </div>

                    </div>


                    <!-- TOTAL STOCK -->

                    <div class="stat-card gold">

                        <div class="stat-icon">

                            <svg viewBox="0 0 24 24">

                                <rect x="3"
                                      y="3"
                                      width="7"
                                      height="7"></rect>

                                <rect x="14"
                                      y="3"
                                      width="7"
                                      height="7"></rect>

                                <rect x="3"
                                      y="14"
                                      width="7"
                                      height="7"></rect>

                                <rect x="14"
                                      y="14"
                                      width="7"
                                      height="7"></rect>

                            </svg>

                        </div>

                        <div>

                            <div class="stat-label">
                                Total Stock Units
                            </div>

                            <div class="stat-value">
                                2,480
                            </div>

                            <div class="stat-description">
                                Units currently available
                            </div>

                        </div>

                    </div>


                    <!-- LOW STOCK -->

                    <div class="stat-card warning">

                        <div class="stat-icon">

                            <svg viewBox="0 0 24 24">

                                <path d="M10.3 3.3L2.4 17a2 2 0 0 0 1.7 3h15.8a2 2 0 0 0 1.7-3L13.7 3.3a2 2 0 0 0-3.4 0z"></path>

                                <line x1="12"
                                      y1="9"
                                      x2="12"
                                      y2="13"></line>

                                <circle cx="12"
                                        cy="16.5"
                                        r=".7"></circle>

                            </svg>

                        </div>

                        <div>

                            <div class="stat-label">
                                Low Stock Items
                            </div>

                            <div class="stat-value">
                                12
                            </div>

                            <div class="stat-description">
                                Need attention
                            </div>

                        </div>

                    </div>


                    <!-- OUT OF STOCK -->

                    <div class="stat-card danger">

                        <div class="stat-icon">

                            <svg viewBox="0 0 24 24">

                                <circle cx="12"
                                        cy="12"
                                        r="9"></circle>

                                <line x1="8"
                                      y1="8"
                                      x2="16"
                                      y2="16"></line>

                                <line x1="16"
                                      y1="8"
                                      x2="8"
                                      y2="16"></line>

                            </svg>

                        </div>

                        <div>

                            <div class="stat-label">
                                Out of Stock
                            </div>

                            <div class="stat-value">
                                4
                            </div>

                            <div class="stat-description">
                                Immediate action required
                            </div>

                        </div>

                    </div>


                </div>


                <!-- =================================================
                     MAIN GRID
                     ================================================= -->

                <div class="main-grid">


                    <!-- LOW STOCK & REORDER -->

                    <section class="panel">


                        <div class="alert-title">

                            <h2>
                                Low Stock &amp; Reorder Alerts
                            </h2>

                            <span class="alert-count">
                                12 items
                            </span>

                        </div>


                        <table class="stock-table">

                            <thead>

                                <tr>

                                    <th>
                                        Product
                                    </th>

                                    <th>
                                        Current
                                    </th>

                                    <th>
                                        Reorder Level
                                    </th>

                                    <th>
                                        Status
                                    </th>

                                </tr>

                            </thead>


                            <tbody>


                                <!-- ARDUINO -->

                                <tr>

                                    <td class="product-name">
                                        Arduino Uno
                                    </td>

                                    <td class="stock-number">
                                        4
                                    </td>

                                    <td>
                                        10
                                    </td>

                                    <td>

                                        <span class="status low">
                                            Low Stock
                                        </span>

                                    </td>

                                </tr>


                                <!-- HDMI -->

                                <tr>

                                    <td class="product-name">
                                        HDMI Cable
                                    </td>

                                    <td class="stock-number">
                                        2
                                    </td>

                                    <td>
                                        15
                                    </td>

                                    <td>

                                        <span class="status critical">
                                            Critical
                                        </span>

                                    </td>

                                </tr>


                                <!-- RASPBERRY PI -->

                                <tr>

                                    <td class="product-name">
                                        Raspberry Pi
                                    </td>

                                    <td class="stock-number">
                                        0
                                    </td>

                                    <td>
                                        5
                                    </td>

                                    <td>

                                        <span class="status out">
                                            Out of Stock
                                        </span>

                                    </td>

                                </tr>


                                <!-- ULTRASONIC SENSOR -->

                                <tr>

                                    <td class="product-name">
                                        Ultrasonic Sensor
                                    </td>

                                    <td class="stock-number">
                                        6
                                    </td>

                                    <td>
                                        12
                                    </td>

                                    <td>

                                        <span class="status low">
                                            Low Stock
                                        </span>

                                    </td>

                                </tr>


                            </tbody>

                        </table>


                        <a href="reorder.jsp"
                           class="reorder-link">

                            Manage Reorders →

                        </a>


                    </section>


                    <!-- =================================================
                         INVENTORY DISTRIBUTION
                         ================================================= -->

                    <section class="panel inventory-overview">


                        <h2>
                            Inventory Distribution
                        </h2>


                        <div class="distribution">


                            <div class="donut">

                                <div class="donut-inner">

                                    <strong>
                                        150
                                    </strong>

                                    <span>
                                        Products
                                    </span>

                                </div>

                            </div>


                            <div class="legend">


                                <div class="legend-item">

                                    <div class="legend-left">

                                        <span class="legend-dot dot-stock"></span>

                                        In Stock

                                    </div>

                                    <span class="legend-value">
                                        102
                                    </span>

                                </div>


                                <div class="legend-item">

                                    <div class="legend-left">

                                        <span class="legend-dot dot-low"></span>

                                        Low Stock

                                    </div>

                                    <span class="legend-value">
                                        44
                                    </span>

                                </div>


                                <div class="legend-item">

                                    <div class="legend-left">

                                        <span class="legend-dot dot-out"></span>

                                        Out of Stock

                                    </div>

                                    <span class="legend-value">
                                        4
                                    </span>

                                </div>


                            </div>


                        </div>


                    </section>


                </div>


                <!-- =================================================
                     BOTTOM GRID
                     ================================================= -->

                <div class="bottom-grid">


                    <!-- =================================================
                         RECENT INVENTORY ACTIVITY
                         ================================================= -->

                    <section class="panel activity-panel">


                        <h2>
                            Recent Inventory Activity
                        </h2>


                        <div class="activity">


                            <!-- DYNAMIC LATEST ACTIVITY -->

                            <div class="activity-item">


                                <div class="activity-icon">


                                    <% if ("Stock Added".equals(activityType)) { %>

                                        <!-- PLUS -->

                                        <svg viewBox="0 0 24 24">

                                            <line x1="12"
                                                  y1="5"
                                                  x2="12"
                                                  y2="19"></line>

                                            <line x1="5"
                                                  y1="12"
                                                  x2="19"
                                                  y2="12"></line>

                                        </svg>


                                    <% } else if ("Stock Removed".equals(activityType)) { %>

                                        <!-- MINUS -->

                                        <svg viewBox="0 0 24 24">

                                            <line x1="5"
                                                  y1="12"
                                                  x2="19"
                                                  y2="12"></line>

                                        </svg>


                                    <% } else if ("Reorder Created".equals(activityType)) { %>

                                        <!-- REORDER -->

                                        <svg viewBox="0 0 24 24">

                                            <path d="M20 11a8 8 0 0 0-15.5-3"></path>

                                            <polyline points="4 4 4 8 8 8"></polyline>

                                            <path d="M4 13a8 8 0 0 0 15.5 3"></path>

                                            <polyline points="20 20 20 16 16 16"></polyline>

                                        </svg>


                                    <% } else { %>

                                        <!-- STOCK UPDATED -->

                                        <svg viewBox="0 0 24 24">

                                            <circle cx="12"
                                                    cy="12"
                                                    r="9"></circle>

                                            <polyline points="8 12 11 15 16 9"></polyline>

                                        </svg>

                                    <% } %>


                                </div>


                                <div class="activity-text">


                                    <strong>
                                        <%= activityType %>
                                    </strong>

                                    for

                                    <%= activityProduct %>


                                    <% if (activityQuantity != null &&
                                           !activityQuantity.trim().isEmpty()) { %>

                                        <span class="activity-stock">

                                            Current stock:
                                            <%= activityQuantity %>
                                            units

                                        </span>

                                    <% } %>


                                </div>


                                <div class="activity-time">

                                    <%= activityTime %>

                                </div>


                            </div>


                        </div>


                    </section>


                    <!-- =================================================
                         QUICK ACTIONS
                         ================================================= -->

                    <section class="panel quick-panel">


                        <h2>
                            Quick Actions
                        </h2>


                        <div class="quick-actions">


                            <!-- ADD / UPDATE STOCK -->

                            <a href="ViewStockServlet"
                               class="quick-action">


                                <div class="quick-icon">

                                    <svg viewBox="0 0 24 24">

                                        <line x1="12"
                                              y1="5"
                                              x2="12"
                                              y2="19"></line>

                                        <line x1="5"
                                              y1="12"
                                              x2="19"
                                              y2="12"></line>

                                    </svg>

                                </div>


                                <span>
                                    Add / Update Stock
                                </span>


                            </a>


                            <!-- SEARCH -->

                            <a href="search.jsp"
                               class="quick-action">


                                <div class="quick-icon">

                                    <svg viewBox="0 0 24 24">

                                        <circle cx="11"
                                                cy="11"
                                                r="7"></circle>

                                        <line x1="16.5"
                                              y1="16.5"
                                              x2="21"
                                              y2="21"></line>

                                    </svg>

                                </div>


                                <span>
                                    Search Item
                                </span>


                            </a>


                            <!-- REORDER -->

                            <a href="reorder.jsp"
                               class="quick-action">


                                <div class="quick-icon">

                                    <svg viewBox="0 0 24 24">

                                        <path d="M20 11a8 8 0 0 0-15.5-3"></path>

                                        <polyline points="4 4 4 8 8 8"></polyline>

                                        <path d="M4 13a8 8 0 0 0 15.5 3"></path>

                                        <polyline points="20 20 20 16 16 16"></polyline>

                                    </svg>

                                </div>


                                <span>
                                    Create Reorder
                                </span>


                            </a>


                            <!-- ANALYTICS -->

                            <a href="analytics.jsp"
                               class="quick-action">


                                <div class="quick-icon">

                                    <svg viewBox="0 0 24 24">

                                        <line x1="4"
                                              y1="20"
                                              x2="4"
                                              y2="10"></line>

                                        <line x1="10"
                                              y1="20"
                                              x2="10"
                                              y2="5"></line>

                                        <line x1="16"
                                              y1="20"
                                              x2="16"
                                              y2="13"></line>

                                        <line x1="22"
                                              y1="20"
                                              x2="22"
                                              y2="7"></line>

                                    </svg>

                                </div>


                                <span>
                                    View Analytics
                                </span>


                            </a>


                        </div>


                    </section>


                </div>


                <!-- FOOTER -->

                <div class="bottom-label">

                    Hardware &amp; Electronics Inventory System

                </div>


            </div>


        </main>


    </div>


</div>


</body>

</html>