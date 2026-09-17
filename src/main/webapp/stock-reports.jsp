<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.mycompany.inventorywebapp.model.StockItem" %>
<!DOCTYPE html>
<html>
<head>
    <title>Hardware Inventory - Stock Report</title>
    <style>
        :root {
            --burgundy: #800020;
            --burgundy-border: #66001a;
        }

        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
            margin: 20px; 
            background-color: #121212; 
            color: #ffffff; 
        }

        h2, h3 { color: #ffffff; }

        a.back-btn, button.print-btn {
            text-decoration: none; 
            padding: 8px 15px; 
            background-color: var(--burgundy); 
            color: #ffffff; 
            border: 1px solid var(--burgundy-border); 
            border-radius: 4px; 
            font-weight: bold;
            display: inline-block;
            cursor: pointer;
        }

        .summary-box { 
            background-color: #1a1a1a; 
            padding: 15px; 
            border: 2px solid var(--burgundy); 
            border-radius: 5px; 
            margin: 20px 0; 
        }

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
            padding: 10px; 
            text-align: left; 
        }
        th { 
            background-color: var(--burgundy); 
            color: #ffffff; 
        }

        @media print { 
            .no-print { display: none; } 
            body { background-color: white; color: black; }
            table, th, td { border: 1px solid black; }
            th { background-color: #800020; color: white; }
        }
    </style>
</head>
<body>

    <a href="stock-monitoring" class="back-btn no-print">&larr; Back to Monitoring</a>
    <h2>Hardware Stock Inventory Valuation Report</h2>

    <div class="summary-box">
        <h3>Inventory Valuation Summary</h3>
        <p><strong>Total Stock Quantity:</strong> ${totalQuantity} units</p>
        <p><strong>Total Inventory Cost Value:</strong> ₹${totalCostValue}</p>
        <p><strong>Total Estimated Sales Value:</strong> ₹${totalSalesValue}</p>
    </div>

    <button onclick="window.print()" class="print-btn no-print">Print / Download PDF</button>

    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Item Name</th>
                <th>Category</th>
                <th>Supplier</th>
                <th>Quantity</th>
                <th>Purchase Price</th>
                <th>Selling Price</th>
                <th>Total Asset Value</th>
            </tr>
        </thead>
        <tbody>
            <% 
                List<StockItem> reportData = (List<StockItem>) request.getAttribute("reportData");
                if (reportData != null) {
                    for (StockItem item : reportData) {
            %>
            <tr>
                <td><%= item.getItemId() %></td>
                <td><%= item.getItemName() %> (<%= item.getBrand() %>)</td>
                <td><%= item.getCategory() %></td>
                <td><%= item.getSupplierName() %></td>
                <td><%= item.getQuantity() %></td>
                <td>₹<%= item.getPurchasePrice() %></td>
                <td>₹<%= item.getSellingPrice() %></td>
                <td>₹<%= (item.getQuantity() * item.getPurchasePrice()) %></td>
            </tr>
            <% 
                    }
                } 
            %>
        </tbody>
    </table>

</body>
</html>