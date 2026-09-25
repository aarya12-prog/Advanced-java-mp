<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="model.StockMovement" %>
<%@ page import="dao.StockDAO" %>

<%
    List<StockMovement> movementList = (List<StockMovement>) request.getAttribute("movementList");
    if (movementList == null) {
        try {
            StockDAO dao = new StockDAO();
            movementList = dao.viewStockMovement();
        } catch (Exception e) {
            movementList = new ArrayList<>();
        }
    }
    if (movementList == null) {
        movementList = new ArrayList<>();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Stock Movement History | Inventory Control System</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <style>
        :root {
            --teal-dark: #1f4657;
            --teal-main: #28586d;
            --teal-accent: #3f7f95;
            --teal-light: #eef6f8;
            --teal-soft: #eaf3f6;
            --text-dark: #243b44;
            --text-muted: #71858d;
            --border: #c9dce2;
            --white: #ffffff;
            --shadow-md: 0 6px 20px rgba(31, 70, 87, 0.08);
        }

        * { margin: 0; padding: 0; box-sizing: border-box; font-family: "Segoe UI", Arial, sans-serif; }
        body {
            background: linear-gradient(135deg, #eef6f8 0%, #e6f1f4 50%, #f5fafb 100%);
            color: var(--text-dark);
            min-height: 100vh;
            padding: 24px;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
        }

        .page-header {
            background: var(--white);
            border: 1px solid var(--border);
            border-radius: 16px;
            padding: 22px 28px;
            margin-bottom: 24px;
            box-shadow: var(--shadow-md);
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 16px;
        }

        .header-title-box {
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .header-icon {
            width: 52px;
            height: 52px;
            background: var(--teal-soft);
            color: var(--teal-main);
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 22px;
        }

        .header-title-box h1 {
            font-size: 22px;
            font-weight: 700;
            color: var(--teal-dark);
        }

        .header-title-box p {
            font-size: 13px;
            color: var(--text-muted);
            margin-top: 3px;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 18px;
            border-radius: 10px;
            font-size: 13px;
            font-weight: 600;
            text-decoration: none;
            cursor: pointer;
            transition: all 0.2s;
            border: none;
        }

        .btn-primary { background: var(--teal-main); color: var(--white); }
        .btn-primary:hover { background: #183745; transform: translateY(-1px); }
        .btn-secondary { background: var(--white); color: var(--teal-dark); border: 1px solid var(--border); }
        .btn-secondary:hover { background: var(--teal-soft); }

        .card {
            background: var(--white);
            border: 1px solid var(--border);
            border-radius: 16px;
            padding: 24px;
            box-shadow: var(--shadow-md);
        }

        .table-responsive {
            width: 100%;
            overflow-x: auto;
            border: 1px solid #e1edf0;
            border-radius: 12px;
            margin-top: 14px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            font-size: 13px;
            min-width: 700px;
        }

        thead {
            background: var(--teal-main);
            color: var(--white);
        }

        th, td {
            padding: 14px 16px;
            text-align: left;
            white-space: nowrap;
        }

        tbody tr {
            border-bottom: 1px solid #edf4f6;
            transition: background 0.15s;
        }
        tbody tr:hover { background: #f4f9fb; }
        tbody tr:last-child { border-bottom: none; }

        .type-badge {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 6px;
            font-size: 11px;
            font-weight: 700;
        }

        .type-in { background: #dcfce7; color: #15803d; }
        .type-out { background: #fee2e2; color: #b91c1c; }
        .type-adjustment { background: #e0e7ff; color: #4338ca; }
    </style>
</head>
<body>

<div class="container">

    <header class="page-header">
        <div class="header-title-box">
            <div class="header-icon">
                <i class="fa-solid fa-clock-rotate-left"></i>
            </div>
            <div>
                <h1>Stock Movement History</h1>
                <p>Complete chronological audit trail of all inventory transactions</p>
            </div>
        </div>

        <div style="display: flex; gap: 10px;">
            <a href="ViewStockServlet" class="btn btn-primary">
                <i class="fa-solid fa-boxes-stacked"></i> Stock Management
            </a>
            <a href="index.jsp" class="btn btn-secondary">
                <i class="fa-solid fa-house"></i> Dashboard
            </a>
        </div>
    </header>

    <div class="card">
        <div class="table-responsive">
            <table>
                <thead>
                    <tr>
                        <th style="width: 80px;">Log ID</th>
                        <th>Item ID</th>
                        <th>Item Name</th>
                        <th>Movement Type</th>
                        <th>Quantity</th>
                        <th>Reference Note</th>
                        <th>Movement Date & Time</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (movementList.isEmpty()) { %>
                        <tr>
                            <td colspan="7" style="text-align: center; color: var(--text-muted); padding: 30px;">
                                No stock movements found in history.
                            </td>
                        </tr>
                    <% } else {
                        for (StockMovement sm : movementList) {
                            String typeClass = "type-in";
                            if ("OUT".equalsIgnoreCase(sm.getMovementType())) typeClass = "type-out";
                            else if ("ADJUSTMENT".equalsIgnoreCase(sm.getMovementType())) typeClass = "type-adjustment";
                    %>
                        <tr>
                            <td><strong>#<%= sm.getMovementId() %></strong></td>
                            <td><%= sm.getItemId() %></td>
                            <td><strong><%= sm.getItemName() != null ? sm.getItemName() : ("Item #" + sm.getItemId()) %></strong></td>
                            <td><span class="type-badge <%= typeClass %>"><%= sm.getMovementType() %></span></td>
                            <td><strong><%= sm.getQuantity() %></strong></td>
                            <td><%= sm.getReferenceNote() != null ? sm.getReferenceNote() : "-" %></td>
                            <td style="color: var(--text-muted);"><%= sm.getMovementDate() %></td>
                        </tr>
                    <%  }
                    } %>
                </tbody>
            </table>
        </div>
    </div>

</div>

</body>
</html>