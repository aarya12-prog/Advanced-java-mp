<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.mycompany.inventorywebapp.model.StockItem" %>
<!DOCTYPE html>
<html>
<head>
    <title>Hardware Inventory - Stock Monitoring</title>
    <style>
        :root {
            --burgundy: #800020;
            --burgundy-dark: #5c0017;
            --burgundy-light: #9c1532;
            --burgundy-border: #66001a;
            --alert-low-bg: #4a2810;
            --alert-out-bg: #4a1010;
        }

        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
            margin: 20px; 
            background-color: #121212; 
            color: #ffffff; 
        }

        h2, h3 { 
            color: #ffffff; 
            border-bottom: 2px solid var(--burgundy); 
            padding-bottom: 8px; 
        }

        /* Nav Buttons & Action Styling */
        .nav-btns { margin-bottom: 20px; }
        .nav-btns a, .btn-action { 
            text-decoration: none; 
            padding: 9px 16px; 
            background-color: var(--burgundy); 
            color: #ffffff; 
            border: 1px solid var(--burgundy-border); 
            border-radius: 4px; 
            margin-right: 8px; 
            font-weight: bold;
            display: inline-block;
            transition: background 0.2s;
        }
        .nav-btns a:hover, .btn-action:hover { 
            background-color: var(--burgundy-light); 
        }

        /* Search Bar */
        .search-box { margin-bottom: 20px; }
        .search-box input[type="text"] { 
            padding: 8px 12px; 
            width: 280px; 
            background-color: #1e1e1e; 
            border: 1px solid var(--burgundy); 
            color: #ffffff; 
            border-radius: 4px;
        }
        .search-box button { 
            padding: 8px 15px; 
            background-color: var(--burgundy); 
            color: white; 
            border: 1px solid var(--burgundy-border); 
            border-radius: 4px; 
            cursor: pointer;
            font-weight: bold;
        }

        /* Burgundy Table Styling */
        table { 
            width: 100%; 
            border-collapse: collapse; 
            margin-top: 15px; 
            background-color: #1a1a1a; 
            border: 2px solid var(--burgundy); 
            color: #ffffff;
        }
        th, td { 
            border: 1px solid var(--burgundy-border); 
            padding: 12px; 
            text-align: left; 
        }
        th { 
            background-color: var(--burgundy); 
            color: #ffffff; 
            font-size: 15px;
            letter-spacing: 0.5px;
        }
        tr:nth-child(even) { background-color: #222222; }
        tr:hover { background-color: #2c1a20; }

        /* Custom Alert Rows */
        .alert-low { background-color: var(--alert-low-bg) !important; color: #ffcc99; }
        .alert-out { background-color: var(--alert-out-bg) !important; color: #ff9999; }

        /* Inline Input Fields */
        input[type="number"] {
            background-color: #121212;
            color: #ffffff;
            border: 1px solid var(--burgundy);
            padding: 4px;
            border-radius: 3px;
        }
    </style>
</head>
<body>

    <h2>Hardware Inventory Management System</h2>

    <div class="nav-btns">
        <a href="stock-monitoring">All Stock</a>
        <a href="stock-monitoring?action=lowStock">Low Stock Alerts</a>
        <a href="stock-monitoring?action=outOfStock">Out of Stock Alerts</a>
        <a href="stock-reports">Generate Stock Report</a>
    </div>

    <!-- Search Box -->
    <div class="search-box">
        <form action="stock-monitoring" method="get">
            <input type="hidden" name="action" value="search">
            <input type="text" name="query" placeholder="Search by Item, Category, or Brand..." required>
            <button type="submit">Search Stock</button>
        </form>
    </div>

    <h3>${alertType != null ? alertType : "Stock Inventory Overview"}</h3>

    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Item Name</th>
                <th>Brand & Model</th>
                <th>Category</th>
                <th>Supplier</th>
                <th>Location</th>
                <th>Qty</th>
                <th>Reorder Level</th>
                <th>Update Reorder Level</th>
            </tr>
        </thead>
        <tbody>
            <% 
                List<StockItem> items = (List<StockItem>) request.getAttribute("items");
                if (items != null && !items.isEmpty()) {
                    for (StockItem item : items) {
                        String rowClass = "";
                        if (item.getQuantity() == 0) rowClass = "alert-out";
                        else if (item.getQuantity() <= item.getReorderLevel()) rowClass = "alert-low";
            %>
            <tr class="<%= rowClass %>">
                <td><%= item.getItemId() %></td>
                <td><strong><%= item.getItemName() %></strong></td>
                <td><%= item.getBrand() %> (<%= item.getModelNumber() %>)</td>
                <td><%= item.getCategory() %></td>
                <td><%= item.getSupplierName() %></td>
                <td><%= item.getLocation() %></td>
                <td><strong><%= item.getQuantity() %></strong></td>
                <td><%= item.getReorderLevel() %></td>
                <td>
                    <form action="stock-monitoring" method="post" style="display:inline;">
                        <input type="hidden" name="action" value="setReorderLevel">
                        <input type="hidden" name="itemId" value="<%= item.getItemId() %>">
                        <input type="number" name="reorderLevel" value="<%= item.getReorderLevel() %>" style="width:50px;" required>
                        <button type="submit" class="btn-action" style="padding: 4px 8px; font-size: 12px;">Save</button>
                    </form>
                </td>
            </tr>
            <% 
                    }
                } else { 
            %>
            <tr><td colspan="9" style="text-align: center;">No items found matching criteria.</td></tr>
            <% } %>
        </tbody>
    </table>

</body>
</html>