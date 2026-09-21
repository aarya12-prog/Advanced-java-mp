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
    <title>Add Item - Hardware Management</title>

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
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #10090b;
            color: #2b1a1d;
        }

        a {
            text-decoration: none;
        }

        /* =========================
           MAIN WRAPPER
        ========================= */
        #wrapper {
            display: flex;
            min-height: 100vh;
            width: 100%;
        }

        /* =========================
           SIDEBAR
        ========================= */
        #sidebar-wrapper {
            width: 250px;
            min-height: 100vh;
            flex-shrink: 0;
            background: linear-gradient(
                180deg,
                #160a0d 0%,
                #260d16 100%
            );
            border-right: 1px solid #b9954c;
            box-shadow: 5px 0 20px rgba(0, 0, 0, 0.35);
            transition: all 0.3s ease;
        }

        .sidebar-heading {
            padding: 27px 20px;
            text-align: center;
            border-bottom: 1px solid rgba(229, 195, 107, 0.35);
            color: #f8ebcb;
            font-size: 19px;
            letter-spacing: 0.5px;
        }

        .sidebar-heading i {
            color: #e5c36b;
            margin-right: 8px;
        }

        .sidebar-heading span {
            font-weight: 700;
        }

        .sidebar-menu {
            margin-top: 20px;
            padding: 0 12px;
        }

        .sidebar-link {
            display: flex;
            align-items: center;
            padding: 14px 16px;
            margin-bottom: 7px;
            border-radius: 8px;
            color: #f1eee7;
            font-size: 15px;
            transition: all 0.3s ease;
            border-left: 3px solid transparent;
        }

        .sidebar-link i {
            width: 25px;
            font-size: 16px;
            color: #d5ae55;
        }

        .sidebar-link:hover {
            background: rgba(124, 36, 68, 0.45);
            color: #ffffff;
            transform: translateX(3px);
        }

        .sidebar-link:hover i {
            color: #e5c36b;
        }

        .sidebar-link.active {
            background: #651b36;
            color: #fffdf8;
            border-left: 3px solid #e5c36b;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.25);
        }

        .sidebar-link.active i {
            color: #e5c36b;
        }

        .sidebar-link.logout {
            color: #d99a9a;
        }

        .sidebar-link.logout i {
            color: #d99a9a;
        }

        .sidebar-link.logout:hover {
            background: rgba(101, 27, 54, 0.55);
            color: #f5c6c6;
        }

        /* =========================
           PAGE CONTENT
        ========================= */
        #page-content-wrapper {
            width: 100%;
            min-width: 0;
            background: #10090b;
        }

        /* =========================
           NAVBAR
        ========================= */
        .top-navbar {
            height: 80px;
            background: #eee9df;
            border-bottom: 2px solid #b9954c;
            display: flex;
            align-items: center;
            padding: 0 30px;
            box-shadow: 0 3px 12px rgba(0, 0, 0, 0.2);
        }

        .menu-toggle {
            border: none;
            background: #651b36;
            color: #fffdf8;
            width: 43px;
            height: 43px;
            border-radius: 8px;
            cursor: pointer;
            font-size: 17px;
            transition: 0.3s;
        }

        .menu-toggle:hover {
            background: #7c2444;
            transform: translateY(-1px);
        }

        .admin-info {
            margin-left: auto;
            color: #3d252b;
            font-size: 15px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 7px;
        }

        .admin-info i {
            color: #651b36;
            font-size: 22px;
        }

        /* =========================
           MAIN CONTENT
        ========================= */
        .content-container {
            margin: 30px;
            padding: 30px;
            background: #f1eee7;
            border: 1px solid #c6a455;
            border-radius: 20px;
            min-height: calc(100vh - 140px);
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
        }

        .page-title {
            color: #3d1d27;
            font-size: 30px;
            font-weight: 700;
            margin-bottom: 25px;
            position: relative;
            padding-bottom: 12px;
        }

        .page-title::after {
            content: "";
            position: absolute;
            left: 0;
            bottom: 0;
            width: 65px;
            height: 3px;
            background: #651b36;
            border-radius: 3px;
        }

        /* =========================
           ALERT
        ========================= */
        .alert {
            padding: 14px 18px;
            border-radius: 10px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 14px;
        }

        .alert-danger {
            background: #f1d9d9;
            color: #6b2029;
            border: 1px solid #c98c8c;
        }

        /* =========================
           FORM CARD
        ========================= */
        .form-card {
            background: #fffdf8;
            border: 1px solid #d8c99f;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 6px 20px rgba(55, 31, 24, 0.12);
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px 25px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
        }

        .form-group.full-width {
            grid-column: 1 / -1;
        }

        .form-group label {
            font-size: 14px;
            font-weight: 600;
            color: #4b3035;
            margin-bottom: 8px;
        }

        .form-group label::first-letter {
            color: #651b36;
        }

        .form-control,
        .form-select,
        textarea {
            width: 100%;
            padding: 12px 14px;
            border: 1px solid #cbbd9b;
            border-radius: 8px;
            background: #fdfbf5;
            color: #342025;
            font-size: 14px;
            font-family: inherit;
            outline: none;
            transition: all 0.25s ease;
        }

        .form-control:focus,
        .form-select:focus,
        textarea:focus {
            border-color: #651b36;
            box-shadow: 0 0 0 3px rgba(101, 27, 54, 0.12);
            background: #fffdf8;
        }

        .form-control::placeholder,
        textarea::placeholder {
            color: #998b82;
        }

        textarea {
            resize: vertical;
            min-height: 95px;
        }

        select.form-select {
            cursor: pointer;
        }

        input[type="file"] {
            padding: 9px 12px;
        }

        .form-help {
            margin-top: 6px;
            font-size: 12px;
            color: #806d62;
        }

        /* =========================
           THREE COLUMN PRICE SECTION
        ========================= */
        .three-column {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
        }

        /* =========================
           FORM ACTIONS
        ========================= */
        .form-actions {
            margin-top: 28px;
            padding-top: 22px;
            border-top: 1px solid #dfd3b5;
            display: flex;
            gap: 12px;
        }

        .btn {
            border: none;
            border-radius: 8px;
            padding: 12px 22px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s ease;
            font-family: inherit;
        }

        .btn-primary {
            background: #651b36;
            color: #fffdf8;
            border: 1px solid #651b36;
        }

        .btn-primary:hover {
            background: #7c2444;
            border-color: #7c2444;
            transform: translateY(-2px);
            box-shadow: 0 5px 12px rgba(101, 27, 54, 0.3);
        }

        .btn-secondary {
            background: #ded6c7;
            color: #3f2d2d;
            border: 1px solid #c3b69f;
        }

        .btn-secondary:hover {
            background: #cfc4b2;
            transform: translateY(-2px);
        }

        .btn i {
            font-size: 14px;
        }

        /* =========================
           WRAPPER TOGGLE
        ========================= */
        #wrapper.toggled #sidebar-wrapper {
            margin-left: -250px;
        }

        /* =========================
           RESPONSIVE
        ========================= */
        @media (max-width: 900px) {

            .form-grid {
                grid-template-columns: 1fr;
            }

            .form-group.full-width {
                grid-column: auto;
            }

            .three-column {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 768px) {

            #sidebar-wrapper {
                margin-left: -250px;
                position: fixed;
                z-index: 1000;
                height: 100vh;
            }

            #wrapper.toggled #sidebar-wrapper {
                margin-left: 0;
            }

            .content-container {
                margin: 20px;
                padding: 20px;
            }

            .top-navbar {
                padding: 0 20px;
            }

            .page-title {
                font-size: 25px;
            }

            .form-card {
                padding: 20px;
            }

            .form-actions {
                flex-direction: column;
            }

            .btn {
                justify-content: center;
            }
        }

        @media (max-width: 480px) {

            .admin-info span {
                display: none;
            }

            .content-container {
                margin: 12px;
                padding: 15px;
            }

            .form-card {
                padding: 15px;
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
            <span>Hardware Admin</span>
        </div>

        <div class="sidebar-menu">

            <a href="${pageContext.request.contextPath}/admin/dashboard.jsp"
               class="sidebar-link">
                <i class="fas fa-chart-pie"></i>
                <span>Dashboard</span>
            </a>

            <a href="${pageContext.request.contextPath}/admin/add-item.jsp"
               class="sidebar-link active">
                <i class="fas fa-plus-circle"></i>
                <span>Add Item</span>
            </a>

            <a href="${pageContext.request.contextPath}/admin/view-items.jsp"
               class="sidebar-link">
                <i class="fas fa-list"></i>
                <span>View Items</span>
            </a>

            <a href="${pageContext.request.contextPath}/admin/profile.jsp"
               class="sidebar-link">
                <i class="fas fa-user"></i>
                <span>My Profile</span>
            </a>

            <a href="${pageContext.request.contextPath}/admin/logout"
               class="sidebar-link logout">
                <i class="fas fa-sign-out-alt"></i>
                <span>Logout</span>
            </a>

        </div>
    </div>


    <!-- =========================
         PAGE CONTENT
    ========================== -->
    <div id="page-content-wrapper">

        <!-- Navbar -->
        <nav class="top-navbar">

            <button class="menu-toggle" id="menu-toggle">
                <i class="fas fa-bars"></i>
            </button>

            <div class="admin-info">
                <i class="fas fa-user-circle"></i>
                <span><%= adminName %></span>
            </div>

        </nav>


        <!-- Main Content -->
        <div class="content-container">

            <h1 class="page-title">
                Add New Item
            </h1>


            <!-- Error Message -->
            <%
                String error = request.getParameter("error");

                if (error != null) {
            %>

            <div class="alert alert-danger">
                <i class="fas fa-exclamation-circle"></i>
                <span><%= error %></span>
            </div>

            <%
                }
            %>


            <!-- Form Card -->
            <div class="form-card">

                <form action="${pageContext.request.contextPath}/admin/add-item"
                      method="POST"
                      enctype="multipart/form-data">


                    <!-- Item Name + Category -->
                    <div class="form-grid">

                        <div class="form-group">

                            <label>
                                Item Name *
                            </label>

                            <input type="text"
                                   name="item_name"
                                   class="form-control"
                                   required>

                        </div>


                        <div class="form-group">

                            <label>
                                Category *
                            </label>

                            <select name="category"
                                    class="form-select"
                                    required>

                                <option value="">Select Category</option>
                                <option value="Computer">Computer</option>
                                <option value="Laptop">Laptop</option>
                                <option value="Printer">Printer</option>
                                <option value="Networking">Networking</option>
                                <option value="Monitor">Monitor</option>
                                <option value="Accessories">Accessories</option>
                                <option value="Computer Component">
                                    Computer Component
                                </option>

                            </select>

                        </div>


                        <!-- Brand -->
                        <div class="form-group">

                            <label>
                                Brand
                            </label>

                            <input type="text"
                                   name="brand"
                                   class="form-control">

                        </div>


                        <!-- Model Number -->
                        <div class="form-group">

                            <label>
                                Model Number
                            </label>

                            <input type="text"
                                   name="model_number"
                                   class="form-control">

                        </div>


                        <!-- Description -->
                        <div class="form-group full-width">

                            <label>
                                Description
                            </label>

                            <textarea name="description"
                                      class="form-control"
                                      rows="3"></textarea>

                        </div>


                        <!-- Supplier -->
                        <div class="form-group">

                            <label>
                                Supplier *
                            </label>

                            <select name="supplier_id"
                                    class="form-select"
                                    required>

                                <option value="">Select Supplier</option>

                                <%
                                    try (Connection conn = DBConnection.getConnection()) {

                                        PreparedStatement stmt = conn.prepareStatement(
                                            "SELECT supplier_id, supplier_name FROM suppliers WHERE status = 'Active'"
                                        );

                                        ResultSet rs = stmt.executeQuery();

                                        while (rs.next()) {
                                %>

                                <option value="<%= rs.getInt("supplier_id") %>">
                                    <%= rs.getString("supplier_name") %>
                                </option>

                                <%
                                        }

                                        rs.close();
                                        stmt.close();

                                    } catch (Exception e) {
                                        e.printStackTrace();
                                    }
                                %>

                            </select>

                        </div>


                        <!-- Status -->
                        <div class="form-group">

                            <label>
                                Status
                            </label>

                            <select name="status"
                                    class="form-select">

                                <option value="Active">Active</option>
                                <option value="Discontinued">Discontinued</option>

                            </select>

                        </div>

                    </div>


                    <!-- Price + Quantity -->
                    <div class="three-column"
                         style="margin-top: 20px;">

                        <div class="form-group">

                            <label>
                                Purchase Price (Rs.) *
                            </label>

                            <input type="number"
                                   name="purchase_price"
                                   class="form-control"
                                   step="0.01"
                                   required>

                        </div>


                        <div class="form-group">

                            <label>
                                Selling Price (Rs.) *
                            </label>

                            <input type="number"
                                   name="selling_price"
                                   class="form-control"
                                   step="0.01"
                                   required>

                        </div>


                        <div class="form-group">

                            <label>
                                Quantity *
                            </label>

                            <input type="number"
                                   name="quantity"
                                   class="form-control"
                                   required>

                        </div>

                    </div>


                    <!-- Location + Reorder -->
                    <div class="form-grid"
                         style="margin-top: 20px;">

                        <div class="form-group">

                            <label>
                                Location
                            </label>

                            <input type="text"
                                   name="location"
                                   class="form-control"
                                   placeholder="e.g., Warehouse A">

                        </div>


                        <div class="form-group">

                            <label>
                                Reorder Level
                            </label>

                            <input type="number"
                                   name="reorder_level"
                                   class="form-control"
                                   value="5">

                        </div>

                    </div>


                    <!-- Photo Upload -->
                    <div class="form-group"
                         style="margin-top: 20px;">

                        <label>
                            Product Photo
                        </label>

                        <input type="file"
                               name="product_photo"
                               class="form-control"
                               accept="image/*">

                        <div class="form-help">
                            Supported: JPG, PNG, GIF (Max 5MB)
                        </div>

                    </div>


                    <!-- Buttons -->
                    <div class="form-actions">

                        <button type="submit"
                                class="btn btn-primary">

                            <i class="fas fa-save"></i>
                            Add Item

                        </button>


                        <a href="${pageContext.request.contextPath}/admin/view-items.jsp"
                           class="btn btn-secondary">

                            <i class="fas fa-times"></i>
                            Cancel

                        </a>

                    </div>

                </form>

            </div>

        </div>

    </div>

</div>


<!-- Sidebar Toggle -->
<script>
    document.getElementById("menu-toggle").addEventListener("click", function(e) {
        e.preventDefault();

        document.getElementById("wrapper").classList.toggle("toggled");
    });
</script>

</body>
</html>