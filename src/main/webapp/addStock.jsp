<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="model.Stock" %>
<%@ page import="dao.ItemDAO" %>

<%
    List<Stock> itemList = (List<Stock>) request.getAttribute("itemList");
    if (itemList == null) {
        try {
            ItemDAO itemDAO = new ItemDAO();
            itemList = itemDAO.getAllItems();
        } catch (Exception e) {
            itemList = new ArrayList<>();
        }
    }
    if (itemList == null) {
        itemList = new ArrayList<>();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Add Stock | Inventory Control System</title>
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
        }

        * { margin: 0; padding: 0; box-sizing: border-box; font-family: "Segoe UI", Arial, sans-serif; }
        body {
            background: linear-gradient(135deg, #eef6f8 0%, #e6f1f4 50%, #f5fafb 100%);
            color: var(--text-dark);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 24px;
        }

        .card {
            background: var(--white);
            border: 1px solid var(--border);
            border-radius: 16px;
            box-shadow: 0 10px 30px rgba(31, 70, 87, 0.10);
            width: 100%;
            max-width: 500px;
            overflow: hidden;
        }

        .card-header {
            background: var(--teal-main);
            color: var(--white);
            padding: 22px 28px;
            display: flex;
            align-items: center;
            gap: 14px;
        }

        .card-header i { font-size: 24px; }
        .card-header h1 { font-size: 20px; font-weight: 700; }
        .card-header p { font-size: 12px; opacity: 0.85; margin-top: 2px; }

        .card-body { padding: 28px; }

        .form-group { margin-bottom: 20px; }
        .form-group label {
            display: block;
            font-size: 13px;
            font-weight: 600;
            color: var(--teal-dark);
            margin-bottom: 8px;
        }

        .form-control {
            width: 100%;
            padding: 12px 14px;
            border: 1px solid var(--border);
            border-radius: 10px;
            font-size: 14px;
            outline: none;
            transition: all 0.2s;
            background: #fafcfd;
        }

        .form-control:focus {
            border-color: var(--teal-accent);
            background: var(--white);
            box-shadow: 0 0 0 3px rgba(63, 127, 149, 0.15);
        }

        .btn-submit {
            width: 100%;
            padding: 13px;
            background: var(--teal-main);
            color: var(--white);
            border: none;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 700;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            box-shadow: 0 4px 12px rgba(40, 88, 109, 0.25);
            transition: all 0.2s;
        }

        .btn-submit:hover {
            background: #183745;
            transform: translateY(-1px);
        }

        .card-footer {
            padding: 16px 28px;
            background: #f8fafb;
            border-top: 1px solid #edf4f6;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .back-link {
            color: var(--teal-accent);
            text-decoration: none;
            font-size: 13px;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }
        .back-link:hover { text-decoration: underline; color: var(--teal-dark); }
    </style>
</head>
<body>

<div class="card">
    <div class="card-header">
        <i class="fa-solid fa-boxes-packing"></i>
        <div>
            <h1>Add Stock</h1>
            <p>Replenish items and record incoming inventory</p>
        </div>
    </div>

    <form action="AddStockServlet" method="post">
        <div class="card-body">
            <div class="form-group">
                <label for="itemId"><i class="fa-solid fa-box"></i> Select Inventory Item</label>
                <select name="itemId" id="itemId" class="form-control" required>
                    <option value="" disabled selected>-- Select an Item --</option>
                    <% for (Stock stock : itemList) { %>
                        <option value="<%= stock.getItemId() %>">
                            #<%= stock.getItemId() %> - <%= stock.getItemName() %>
                        </option>
                    <% } %>
                </select>
            </div>

            <div class="form-group">
                <label for="quantity"><i class="fa-solid fa-arrow-up-right-dots"></i> Quantity to Add</label>
                <input type="number" id="quantity" name="quantity" min="1" class="form-control"
                       placeholder="e.g. 25" required>
            </div>

            <div class="form-group">
                <label for="referenceNote"><i class="fa-solid fa-note-sticky"></i> Reference Note (Optional)</label>
                <input type="text" id="referenceNote" name="referenceNote" class="form-control"
                       placeholder="e.g. Supplier invoice #892, PO restock">
            </div>

            <button type="submit" class="btn-submit">
                <i class="fa-solid fa-plus-circle"></i> Confirm & Add Stock
            </button>
        </div>

        <div class="card-footer">
            <a href="ViewStockServlet" class="back-link">
                <i class="fa-solid fa-arrow-left"></i> Stock Management
            </a>
            <a href="index.jsp" class="back-link">
                <i class="fa-solid fa-house"></i> Dashboard
            </a>
        </div>
    </form>
</div>

</body>
</html>