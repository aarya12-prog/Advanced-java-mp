<%@ page import="java.sql.*, com.hardware.utils.DBConnection" %>
<%
    // Check if admin is logged in
    if (session == null || session.getAttribute("isLoggedIn") == null) {
        response.sendRedirect(request.getContextPath() + "/admin/login.jsp");
        return;
    }
    String adminName = (String) session.getAttribute("adminName");
    
    // Get item details
    int itemId = Integer.parseInt(request.getParameter("id"));
    String itemName = "", category = "", brand = "", modelNumber = "", description = "";
    int supplierId = 0, quantity = 0, reorderLevel = 0;
    double purchasePrice = 0, sellingPrice = 0;
    String status = "", location = "", photoPath = "";
    
    try (Connection conn = DBConnection.getConnection()) {
        String sql = "SELECT i.*, inv.quantity, inv.location, inv.reorder_level FROM items i LEFT JOIN inventory inv ON i.item_id = inv.item_id WHERE i.item_id = ?";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setInt(1, itemId);
        ResultSet rs = stmt.executeQuery();
        if (rs.next()) {
            itemName = rs.getString("item_name");
            category = rs.getString("category");
            brand = rs.getString("brand");
            modelNumber = rs.getString("model_number");
            description = rs.getString("description");
            supplierId = rs.getInt("supplier_id");
            purchasePrice = rs.getDouble("purchase_price");
            sellingPrice = rs.getDouble("selling_price");
            status = rs.getString("status");
            photoPath = rs.getString("photo_path");
            quantity = rs.getInt("quantity");
            location = rs.getString("location");
            reorderLevel = rs.getInt("reorder_level");
        }
        rs.close(); stmt.close();
    } catch (Exception e) { e.printStackTrace(); }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Item - Hardware Management</title>
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
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
            radial-gradient(circle at 20% 20%,
                rgba(150, 110, 30, 0.12),
                transparent 25%),

            radial-gradient(circle at 80% 70%,
                rgba(150, 110, 30, 0.10),
                transparent 25%),

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
       FORM CARD
    ========================= */

    .form-card {
        background: #fffdf8;

        border: 1px solid #c6a455;

        border-radius: 15px;

        overflow: hidden;

        box-shadow:
            0 5px 18px rgba(71, 39, 23, 0.15);
    }

    .form-card-header {
        background: #651b36;

        color: #ffffff;

        padding: 18px 25px;

        font-size: 18px;

        font-weight: bold;

        border-bottom: 3px solid #c6a455;
    }

    .form-card-header i {
        color: #e5c36b;

        margin-right: 8px;
    }

    .form-card-body {
        padding: 30px;
    }


    /* =========================
       FORM ROW
    ========================= */

    .form-row {
        display: grid;

        grid-template-columns: 1fr 1fr;

        gap: 25px;

        margin-bottom: 20px;
    }

    .form-row.three-columns {
        grid-template-columns:
            repeat(3, 1fr);
    }


    /* =========================
       FORM GROUP
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

    .required {
        color: #8a1e3f;
    }


    /* =========================
       INPUTS
    ========================= */

    .form-control,
    .form-select,
    textarea {
        width: 100%;

        padding: 12px 14px;

        background: #fffaf0;

        color: #4d2630;

        border: 1px solid #c9b27b;

        border-radius: 8px;

        font-size: 14px;

        outline: none;

        transition: 0.25s;
    }

    .form-control:focus,
    .form-select:focus,
    textarea:focus {
        border-color: #8a2345;

        box-shadow:
            0 0 0 3px rgba(101, 27, 54, 0.12);

        background: #fffdf8;
    }

    textarea {
        resize: vertical;

        min-height: 100px;
    }

    .form-select {
        cursor: pointer;
    }


    /* =========================
       DESCRIPTION
    ========================= */

    .full-width {
        margin-bottom: 22px;
    }


    /* =========================
       PHOTO SECTION
    ========================= */

    .photo-section {
        background: #f7f0e3;

        border: 1px solid #d3bc85;

        border-radius: 10px;

        padding: 18px;

        margin-top: 5px;

        margin-bottom: 25px;
    }

    .current-photo {
        width: 110px;

        height: 110px;

        object-fit: cover;

        border-radius: 10px;

        border: 2px solid #c6a455;

        display: block;

        margin-bottom: 12px;

        box-shadow:
            0 4px 10px rgba(0, 0, 0, 0.15);
    }

    .no-photo {
        color: #806d62;

        font-size: 13px;

        margin-bottom: 12px;
    }

    .photo-help {
        display: block;

        margin-top: 7px;

        color: #806d62;

        font-size: 12px;
    }


    /* =========================
       BUTTONS
    ========================= */

    .button-row {
        display: flex;

        gap: 12px;

        margin-top: 10px;
    }

    .btn {
        display: inline-flex;

        align-items: center;

        justify-content: center;

        gap: 8px;

        padding: 11px 22px;

        border-radius: 8px;

        font-size: 14px;

        font-weight: bold;

        text-decoration: none;

        cursor: pointer;

        border: none;

        transition: 0.25s;
    }

    .btn-primary {
        background: #651b36;

        color: white;
    }

    .btn-primary:hover {
        background: #7d2344;

        transform: translateY(-1px);

        box-shadow:
            0 5px 12px rgba(101, 27, 54, 0.25);
    }

    .btn-secondary {
        background: #e8dfd0;

        color: #5d3841;

        border: 1px solid #bda982;
    }

    .btn-secondary:hover {
        background: #dcd0bc;

        color: #4b2630;
    }


    /* =========================
       TOGGLE
    ========================= */

    #wrapper.toggled #sidebar-wrapper {
        margin-left: -250px;
    }


    /* =========================
       RESPONSIVE
    ========================= */

    @media (max-width: 900px) {

        .form-row,
        .form-row.three-columns {
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

        .form-card-body {
            padding: 20px;
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


        <!-- MAIN CONTENT -->

        <div class="main-container">

            <div class="page-title">

                <i class="fas fa-pen-to-square"></i>

                Edit Item

            </div>


            <!-- FORM CARD -->

            <div class="form-card">

                <div class="form-card-header">

                    <i class="fas fa-box-open"></i>

                    Item Information

                </div>


                <div class="form-card-body">

                    <form action="${pageContext.request.contextPath}/admin/edit-item"
                          method="POST"
                          enctype="multipart/form-data">

                        <input type="hidden"
                               name="item_id"
                               value="<%= itemId %>">


                        <!-- ITEM NAME + CATEGORY -->

                        <div class="form-row">

                            <div class="form-group">

                                <label class="form-label">
                                    Item Name <span class="required">*</span>
                                </label>

                                <input type="text"
                                       name="item_name"
                                       class="form-control"
                                       value="<%= itemName %>"
                                       required>

                            </div>


                            <div class="form-group">

                                <label class="form-label">
                                    Category <span class="required">*</span>
                                </label>

                                <select name="category"
                                        class="form-select"
                                        required>

                                    <option value="Computer"
                                        <%= category.equals("Computer") ? "selected" : "" %>>
                                        Computer
                                    </option>

                                    <option value="Laptop"
                                        <%= category.equals("Laptop") ? "selected" : "" %>>
                                        Laptop
                                    </option>

                                    <option value="Printer"
                                        <%= category.equals("Printer") ? "selected" : "" %>>
                                        Printer
                                    </option>

                                    <option value="Networking"
                                        <%= category.equals("Networking") ? "selected" : "" %>>
                                        Networking
                                    </option>

                                    <option value="Monitor"
                                        <%= category.equals("Monitor") ? "selected" : "" %>>
                                        Monitor
                                    </option>

                                    <option value="Accessories"
                                        <%= category.equals("Accessories") ? "selected" : "" %>>
                                        Accessories
                                    </option>

                                    <option value="Computer Component"
                                        <%= category.equals("Computer Component") ? "selected" : "" %>>
                                        Computer Component
                                    </option>

                                </select>

                            </div>

                        </div>


                        <!-- BRAND + MODEL -->

                        <div class="form-row">

                            <div class="form-group">

                                <label class="form-label">
                                    Brand
                                </label>

                                <input type="text"
                                       name="brand"
                                       class="form-control"
                                       value="<%= brand %>">

                            </div>


                            <div class="form-group">

                                <label class="form-label">
                                    Model Number
                                </label>

                                <input type="text"
                                       name="model_number"
                                       class="form-control"
                                       value="<%= modelNumber %>">

                            </div>

                        </div>


                        <!-- DESCRIPTION -->

                        <div class="form-group full-width">

                            <label class="form-label">
                                Description
                            </label>

                            <textarea name="description"
                                      class="form-control"
                                      rows="3"><%= description %></textarea>

                        </div>


                        <!-- SUPPLIER + STATUS -->

                        <div class="form-row">

                            <div class="form-group">

                                <label class="form-label">

                                    Supplier
                                    <span class="required">*</span>

                                </label>

                                <select name="supplier_id"
                                        class="form-select"
                                        required>

                                    <%
                                        try (Connection conn =
                                                DBConnection.getConnection()) {

                                            PreparedStatement stmt =
                                                conn.prepareStatement(
                                                    "SELECT supplier_id, supplier_name " +
                                                    "FROM suppliers " +
                                                    "WHERE status = 'Active'"
                                                );

                                            ResultSet rs =
                                                stmt.executeQuery();

                                            while (rs.next()) {
                                    %>

                                    <option
                                        value="<%= rs.getInt("supplier_id") %>"
                                        <%= rs.getInt("supplier_id") == supplierId
                                            ? "selected"
                                            : "" %>>

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


                            <div class="form-group">

                                <label class="form-label">
                                    Status
                                </label>

                                <select name="status"
                                        class="form-select">

                                    <option value="Active"
                                        <%= status.equals("Active")
                                            ? "selected"
                                            : "" %>>
                                        Active
                                    </option>

                                    <option value="Discontinued"
                                        <%= status.equals("Discontinued")
                                            ? "selected"
                                            : "" %>>
                                        Discontinued
                                    </option>

                                </select>

                            </div>

                        </div>


                        <!-- PRICE + QUANTITY -->

                        <div class="form-row three-columns">

                            <div class="form-group">

                                <label class="form-label">

                                    Purchase Price (Rs.)
                                    <span class="required">*</span>

                                </label>

                                <input type="number"
                                       name="purchase_price"
                                       class="form-control"
                                       step="0.01"
                                       value="<%= purchasePrice %>"
                                       required>

                            </div>


                            <div class="form-group">

                                <label class="form-label">

                                    Selling Price (Rs.)
                                    <span class="required">*</span>

                                </label>

                                <input type="number"
                                       name="selling_price"
                                       class="form-control"
                                       step="0.01"
                                       value="<%= sellingPrice %>"
                                       required>

                            </div>


                            <div class="form-group">

                                <label class="form-label">

                                    Quantity
                                    <span class="required">*</span>

                                </label>

                                <input type="number"
                                       name="quantity"
                                       class="form-control"
                                       value="<%= quantity %>"
                                       required>

                            </div>

                        </div>


                        <!-- LOCATION + REORDER -->

                        <div class="form-row">

                            <div class="form-group">

                                <label class="form-label">
                                    Location
                                </label>

                                <input type="text"
                                       name="location"
                                       class="form-control"
                                       value="<%= location %>"
                                       placeholder="e.g., Warehouse A">

                            </div>


                            <div class="form-group">

                                <label class="form-label">
                                    Reorder Level
                                </label>

                                <input type="number"
                                       name="reorder_level"
                                       class="form-control"
                                       value="<%= reorderLevel %>">

                            </div>

                        </div>


                        <!-- PHOTO -->

                        <div class="photo-section">

                            <label class="form-label">
                                Current Photo
                            </label>

                            <%
                                if (photoPath != null &&
                                    !photoPath.isEmpty()) {
                            %>

                                <img
                                    src="${pageContext.request.contextPath}/<%= photoPath %>"
                                    alt="Current Photo"
                                    class="current-photo">

                            <%
                                } else {
                            %>

                                <p class="no-photo">
                                    No photo uploaded
                                </p>

                            <%
                                }
                            %>


                            <input type="file"
                                   name="product_photo"
                                   class="form-control"
                                   accept="image/*">

                            <small class="photo-help">

                                Leave empty to keep current photo.
                                Supported: JPG, PNG, GIF
                                (Max 5MB)

                            </small>

                        </div>


                        <!-- BUTTONS -->

                        <div class="button-row">

                            <button type="submit"
                                    class="btn btn-primary">

                                <i class="fas fa-save"></i>

                                Update Item

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

</div>


<!-- MENU SCRIPT -->

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