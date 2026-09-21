<%@ page import="java.sql.*, com.hardware.utils.DBConnection" %>

<%
    // Check if admin is logged in
    if (session == null || session.getAttribute("isLoggedIn") == null) {
        response.sendRedirect(request.getContextPath() + "/admin/login.jsp");
        return;
    }

    String adminName = (String) session.getAttribute("adminName");
    String adminUsername = (String) session.getAttribute("adminUsername");
    String adminEmail = "";

    try (Connection conn = DBConnection.getConnection()) {

        PreparedStatement stmt = conn.prepareStatement(
            "SELECT email FROM admins WHERE id = ?"
        );

        stmt.setInt(1, (Integer) session.getAttribute("adminId"));

        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            adminEmail = rs.getString("email");
        }

        rs.close();
        stmt.close();

    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <title>My Profile - Hardware Management</title>

    <!-- Font Awesome -->
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>

        /* =========================
           GLOBAL
        ========================= */

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


        /* =========================
           WRAPPER
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

            transition: 0.3s;
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

            background:
                rgba(151, 103, 28, 0.15);

            color: #ffffff !important;

            border-left:
                4px solid #d5ae55;
        }


        .list-group a.active {

            background: #651b36;

            color: #ffffff !important;

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


        /* =========================
           PAGE CONTENT
        ========================= */

        #page-content-wrapper {

            width: 100%;

            min-height: 100vh;
        }


        /* =========================
           NAVBAR
        ========================= */

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

            margin-right: 5px;
        }


        /* =========================
           MAIN CONTAINER
        ========================= */

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


        /* =========================
           ALERT MESSAGES
        ========================= */

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


        .alert-close {

            position: absolute;

            right: 15px;

            top: 9px;

            border: none;

            background: transparent;

            font-size: 18px;

            cursor: pointer;

            color: inherit;
        }


        /* =========================
           PROFILE LAYOUT
        ========================= */

        .profile-layout {

            display: grid;

            grid-template-columns: 35% 65%;

            gap: 25px;

            margin-top: 25px;
        }


        /* =========================
           CARDS
        ========================= */

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
        }


        .card-header {

            padding: 17px 22px;

            background: #651b36;

            color: #ffffff;

            font-size: 17px;

            font-weight: bold;

            border-bottom:
                3px solid #c6a455;
        }


        .card-header i {

            color: #e5c36b;

            margin-right: 8px;
        }


        .card-body {

            padding: 28px;
        }


        /* =========================
           PROFILE CARD
        ========================= */

        .profile-card {

            text-align: center;
        }


        .profile-card .card-body {

            padding: 30px 25px;
        }


        .profile-image {

            width: 120px;

            height: 120px;

            object-fit: cover;

            border-radius: 50%;

            border:
                4px solid #c6a455;

            padding: 3px;

            background: #651b36;

            margin-bottom: 15px;

            box-shadow:
                0 5px 15px rgba(
                    0,
                    0,
                    0,
                    0.18
                );
        }


        .profile-name {

            color: #651b36;

            font-size: 23px;

            font-weight: bold;

            margin-bottom: 7px;
        }


        .profile-role {

            color: #806d62;

            font-size: 14px;

            margin-bottom: 20px;
        }


        .profile-role i {

            color: #bd963b;

            margin-right: 5px;
        }


        .profile-divider {

            border: none;

            border-top:
                1px solid #d9cdb8;

            margin: 20px 0;
        }


        /* =========================
           PROFILE DETAILS
        ========================= */

        .profile-detail {

            text-align: left;

            padding: 13px 0;

            border-bottom:
                1px solid #eee3d1;

            color: #5d3841;

            font-size: 14px;
        }


        .profile-detail:last-child {

            border-bottom: none;
        }


        .profile-detail i {

            width: 25px;

            color: #9a762d;

            margin-right: 5px;
        }


        .profile-detail strong {

            color: #651b36;
        }


        /* =========================
           FORM
        ========================= */

        .form-group {

            margin-bottom: 20px;
        }


        .form-label {

            display: block;

            margin-bottom: 8px;

            color: #5d2c39;

            font-size: 14px;

            font-weight: bold;
        }


        .form-control {

            width: 100%;

            padding: 12px 14px;

            background: #fffaf0;

            color: #4d2630;

            border:
                1px solid #c9b27b;

            border-radius: 8px;

            font-size: 14px;

            outline: none;

            transition: 0.25s;
        }


        .form-control:focus {

            border-color: #8a2345;

            box-shadow:
                0 0 0 3px
                rgba(
                    101,
                    27,
                    54,
                    0.12
                );

            background: #fffdf8;
        }


        .form-control[readonly] {

            background: #eee8dc;

            color: #796961;

            cursor: not-allowed;
        }


        .help-text {

            display: block;

            margin-top: 6px;

            color: #806d62;

            font-size: 12px;
        }


        /* =========================
           BUTTONS
        ========================= */

        .button-row {

            display: flex;

            gap: 12px;

            margin-top: 25px;
        }


        .btn {

            display: inline-flex;

            align-items: center;

            justify-content: center;

            gap: 7px;

            padding: 11px 20px;

            border-radius: 8px;

            font-size: 14px;

            font-weight: bold;

            text-decoration: none;

            cursor: pointer;

            transition: 0.25s;

            border: none;
        }


        .btn-primary {

            background: #651b36;

            color: white;
        }


        .btn-primary:hover {

            background: #7c2344;

            transform: translateY(-1px);

            box-shadow:
                0 5px 15px
                rgba(
                    101,
                    27,
                    54,
                    0.25
                );
        }


        .btn-secondary {

            background: #e8dfd0;

            color: #5d3841;

            border:
                1px solid #bda982;
        }


        .btn-secondary:hover {

            background: #dcd0bc;

            color: #4b2630;
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

        @media (max-width: 900px) {

            .profile-layout {

                grid-template-columns: 1fr;
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


            .profile-layout {

                grid-template-columns: 1fr;
            }


            .button-row {

                flex-direction: column;
            }


            .btn {

                width: 100%;
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

            <a href="${pageContext.request.contextPath}/admin/dashboard.jsp">

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


            <a href="${pageContext.request.contextPath}/admin/profile.jsp"
               class="active">

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


        <!-- MAIN CONTAINER -->

        <div class="main-container">


            <!-- PAGE TITLE -->

            <div class="page-title">

                <i class="fas fa-user"></i>

                My Profile

            </div>


            <!-- =========================
                 SUCCESS MESSAGE
            ========================== -->

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


            <!-- =========================
                 PROFILE + UPDATE
            ========================== -->

            <div class="profile-layout">


                <!-- =========================
                     PROFILE INFORMATION
                ========================== -->

                <div class="card profile-card">

                    <div class="card-header">

                        <i class="fas fa-id-card"></i>

                        Admin Information

                    </div>


                    <div class="card-body">


                        <img
                            src="https://ui-avatars.com/api/?name=<%= adminName %>&background=651b36&color=f1cf72&size=120"
                            class="profile-image"
                            alt="Admin Profile">


                        <div class="profile-name">

                            <%= adminName %>

                        </div>


                        <div class="profile-role">

                            <i class="fas fa-user-tag"></i>

                            Administrator

                        </div>


                        <hr class="profile-divider">


                        <div class="profile-detail">

                            <i class="fas fa-user"></i>

                            <strong>Username:</strong>

                            <%= adminUsername %>

                        </div>


                        <div class="profile-detail">

                            <i class="fas fa-envelope"></i>

                            <strong>Email:</strong>

                            <%= adminEmail %>

                        </div>


                    </div>

                </div>


                <!-- =========================
                     UPDATE PROFILE
                ========================== -->

                <div class="card">

                    <div class="card-header">

                        <i class="fas fa-user-edit"></i>

                        Update Profile

                    </div>


                    <div class="card-body">


                        <form
                            action="${pageContext.request.contextPath}/admin/update-profile"
                            method="POST">


                            <!-- FULL NAME -->

                            <div class="form-group">

                                <label class="form-label">

                                    Full Name

                                </label>


                                <input
                                    type="text"
                                    name="full_name"
                                    class="form-control"
                                    value="<%= adminName %>"
                                    required>

                            </div>


                            <!-- EMAIL -->

                            <div class="form-group">

                                <label class="form-label">

                                    Email

                                </label>


                                <input
                                    type="email"
                                    name="email"
                                    class="form-control"
                                    value="<%= adminEmail %>"
                                    required>

                            </div>


                            <!-- USERNAME -->

                            <div class="form-group">

                                <label class="form-label">

                                    Username

                                </label>


                                <input
                                    type="text"
                                    name="username"
                                    class="form-control"
                                    value="<%= adminUsername %>"
                                    readonly>


                                <small class="help-text">

                                    <i class="fas fa-lock"></i>

                                    Username cannot be changed

                                </small>

                            </div>


                            <!-- PASSWORD -->

                            <div class="form-group">

                                <label class="form-label">

                                    New Password

                                </label>


                                <input
                                    type="password"
                                    name="password"
                                    class="form-control"
                                    placeholder="Leave blank to keep current">


                                <small class="help-text">

                                    Enter a new password only if you
                                    want to change it.

                                </small>

                            </div>


                            <!-- BUTTONS -->

                            <div class="button-row">


                                <button
                                    type="submit"
                                    class="btn btn-primary">

                                    <i class="fas fa-save"></i>

                                    Update Profile

                                </button>


                                <a
                                    href="${pageContext.request.contextPath}/admin/dashboard.jsp"
                                    class="btn btn-secondary">

                                    <i class="fas fa-arrow-left"></i>

                                    Back to Dashboard

                                </a>


                            </div>


                        </form>

                    </div>

                </div>

            </div>

        </div>

    </div>

</div>


<!-- =========================
     JAVASCRIPT
========================= -->

<script>

    /* Sidebar */

    document
        .getElementById("menu-toggle")
        .addEventListener("click", function(e) {

            e.preventDefault();

            document
                .getElementById("wrapper")
                .classList
                .toggle("toggled");

        });


    /* Close success/error message */

    function closeAlert(id) {

        var alert = document.getElementById(id);

        if (alert) {

            alert.style.display = "none";

        }

    }

</script>


</body>

</html>