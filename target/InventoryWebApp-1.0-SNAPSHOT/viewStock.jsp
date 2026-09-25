<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="model.Stock" %>
<%@ page import="model.StockMovement" %>
<%@ page import="dao.StockDAO" %>
<%@ page import="dao.ItemDAO" %>

<%
    /* =====================================================
       DATA RETRIEVAL & FALLBACK LOGIC
       Ensures stock management always has data, whether
       accessed via ViewStockServlet or direct JSP link.
       ===================================================== */
    List<Stock> stockList = (List<Stock>) request.getAttribute("stockList");
    if (stockList == null) {
        try {
            StockDAO dao = new StockDAO();
            stockList = dao.viewStock();
        } catch (Exception e) {
            stockList = new ArrayList<>();
        }
    }
    if (stockList == null) {
        stockList = new ArrayList<>();
    }

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

    /* Calculate Key Inventory Performance Indicators & Alerts */
    int totalSKUs = stockList.size();
    int totalUnits = 0;
    int lowStockCount = 0;
    int outOfStockCount = 0;
    int healthyStockCount = 0;

    List<Stock> alertItems = new ArrayList<>();

    for (Stock s : stockList) {
        totalUnits += s.getQuantity();
        if (s.getQuantity() <= 0) {
            outOfStockCount++;
            alertItems.add(s);
        } else if (s.getQuantity() <= s.getReorderLevel()) {
            lowStockCount++;
            alertItems.add(s);
        } else {
            healthyStockCount++;
        }
    }

    int totalAlerts = lowStockCount + outOfStockCount;

    String msg = request.getParameter("msg");
    String err = request.getParameter("err");

    SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy, hh:mm a");
    String reportGeneratedTime = sdf.format(new Date());
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Stock Management & Alerts | Inventory Control System</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

    <style>
        :root {
            --teal-dark: #1f4657;
            --teal-main: #28586d;
            --teal-accent: #3f7f95;
            --teal-light: #eef6f8;
            --teal-soft: #eaf3f6;
            --teal-highlight: #72b9ca;
            --teal-hover: #183745;
            --text-dark: #243b44;
            --text-muted: #71858d;
            --border: #c9dce2;
            --white: #ffffff;
            --success: #10b981;
            --success-bg: #ecfdf5;
            --success-border: #a7f3d0;
            --warning: #f59e0b;
            --warning-bg: #fffbeb;
            --warning-border: #fde68a;
            --danger: #ef4444;
            --danger-bg: #fef2f2;
            --danger-border: #fecaca;
            --info: #0284c7;
            --info-bg: #f0f9ff;
            --purple: #7c3aed;
            --purple-bg: #f5f3ff;
            --shadow-sm: 0 2px 8px rgba(31, 70, 87, 0.06);
            --shadow-md: 0 6px 20px rgba(31, 70, 87, 0.08);
            --shadow-lg: 0 12px 35px rgba(31, 70, 87, 0.12);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: "Segoe UI", Arial, sans-serif;
        }

        body {
            background: linear-gradient(135deg, #eef6f8 0%, #e6f1f4 50%, #f5fafb 100%);
            color: var(--text-dark);
            min-height: 100vh;
            padding: 24px;
        }

        .container {
            max-width: 1440px;
            margin: 0 auto;
        }

        /* =========================================
           PRINT & PDF STYLES
           ========================================= */
        .print-only {
            display: none;
        }

        @media print {
            @page {
                size: landscape;
                margin: 10mm;
            }
            body {
                background: #ffffff !important;
                color: #000000 !important;
                padding: 0 !important;
            }
            .no-print, .alert-banner, .page-header, .toolbar, .action-group, 
            .modal-overlay, .header-actions, th.action-col, td.action-col,
            .quick-alert-box {
                display: none !important;
            }
            .print-only {
                display: block !important;
            }
            .content-card {
                border: none !important;
                box-shadow: none !important;
                padding: 0 !important;
                margin: 0 !important;
            }
            .metrics-grid {
                display: grid !important;
                grid-template-columns: repeat(4, 1fr) !important;
                gap: 10px !important;
                margin-bottom: 20px !important;
            }
            .metric-card {
                border: 1px solid #94a3b8 !important;
                box-shadow: none !important;
                padding: 10px !important;
            }
            .metric-icon { display: none !important; }
            .metric-info h3 { font-size: 18px !important; color: #000 !important; }
            .metric-info p { font-size: 11px !important; color: #475569 !important; }
            table {
                width: 100% !important;
                border-collapse: collapse !important;
            }
            th, td {
                border: 1px solid #cbd5e1 !important;
                padding: 8px 10px !important;
                font-size: 11px !important;
                color: #000000 !important;
            }
            thead {
                background-color: #28586d !important;
                color: #ffffff !important;
                -webkit-print-color-adjust: exact;
                print-color-adjust: exact;
            }
            .badge {
                border: 1px solid #94a3b8 !important;
                -webkit-print-color-adjust: exact;
                print-color-adjust: exact;
            }
            .print-report-header {
                border-bottom: 2px solid #28586d;
                padding-bottom: 12px;
                margin-bottom: 16px;
                display: flex;
                justify-content: space-between;
                align-items: flex-end;
            }
            .print-report-header h1 {
                font-size: 22px;
                color: #1f4657;
            }
            .print-report-header p {
                font-size: 12px;
                color: #475569;
            }
            .print-footer {
                margin-top: 25px;
                display: flex;
                justify-content: space-between;
                font-size: 11px;
                color: #64748b;
                border-top: 1px dashed #cbd5e1;
                padding-top: 12px;
            }
        }

        /* =========================================
           TOAST NOTIFICATIONS
           ========================================= */
        .alert-banner {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 14px 20px;
            border-radius: 12px;
            margin-bottom: 20px;
            font-size: 14px;
            font-weight: 500;
            box-shadow: var(--shadow-sm);
            animation: slideDown 0.3s ease-out;
        }

        .alert-banner.success {
            background-color: var(--success-bg);
            color: #065f46;
            border: 1px solid var(--success-border);
        }

        .alert-banner.error {
            background-color: var(--danger-bg);
            color: #991b1b;
            border: 1px solid var(--danger-border);
        }

        .alert-banner .alert-left {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .alert-banner .close-alert {
            background: none;
            border: none;
            cursor: pointer;
            color: inherit;
            font-size: 16px;
            opacity: 0.7;
        }
        .alert-banner .close-alert:hover { opacity: 1; }

        /* Persistent Stock Alerts Notification Bar */
        .quick-alert-box {
            display: flex;
            align-items: center;
            justify-content: space-between;
            background: #fff7ed;
            border: 1px solid #fdba74;
            color: #9a3412;
            padding: 14px 20px;
            border-radius: 12px;
            margin-bottom: 22px;
            font-size: 14px;
            box-shadow: var(--shadow-sm);
        }

        .quick-alert-box .qa-left {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .quick-alert-box .qa-actions {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .qa-btn {
            background: #ea580c;
            color: #ffffff;
            border: none;
            padding: 6px 14px;
            border-radius: 8px;
            font-size: 12px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
        }
        .qa-btn:hover { background: #c2410c; }

        @keyframes slideDown {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* =========================================
           TOP NAVIGATION HEADER
           ========================================= */
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
            gap: 20px;
        }

        .header-title-box {
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .header-icon {
            width: 54px;
            height: 54px;
            background: var(--teal-soft);
            color: var(--teal-main);
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            box-shadow: inset 0 0 0 1px rgba(40, 88, 109, 0.15);
        }

        .header-title-box h1 {
            font-size: 24px;
            font-weight: 700;
            color: var(--teal-dark);
            line-height: 1.2;
        }

        .header-title-box p {
            font-size: 13px;
            color: var(--text-muted);
            margin-top: 4px;
        }

        .header-actions {
            display: flex;
            align-items: center;
            gap: 10px;
            flex-wrap: wrap;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            padding: 10px 16px;
            border-radius: 10px;
            font-size: 13px;
            font-weight: 600;
            text-decoration: none;
            cursor: pointer;
            transition: all 0.2s ease;
            border: none;
        }

        .btn-primary {
            background: var(--teal-main);
            color: var(--white);
            box-shadow: 0 4px 14px rgba(40, 88, 109, 0.25);
        }
        .btn-primary:hover {
            background: var(--teal-hover);
            transform: translateY(-1px);
        }

        .btn-secondary {
            background: var(--white);
            color: var(--teal-dark);
            border: 1px solid var(--border);
        }
        .btn-secondary:hover {
            background: var(--teal-soft);
            border-color: var(--teal-accent);
        }

        .btn-pdf {
            background: #b91c1c;
            color: var(--white);
            box-shadow: 0 4px 12px rgba(185, 28, 28, 0.25);
        }
        .btn-pdf:hover {
            background: #991b1b;
            transform: translateY(-1px);
        }

        .btn-alerts {
            background: #f59e0b;
            color: var(--white);
            box-shadow: 0 4px 12px rgba(245, 158, 11, 0.25);
            position: relative;
        }
        .btn-alerts:hover {
            background: #d97706;
            transform: translateY(-1px);
        }

        .alert-pill {
            background: #ffffff;
            color: #b45309;
            font-size: 11px;
            padding: 1px 7px;
            border-radius: 10px;
            font-weight: 800;
        }

        /* =========================================
           METRIC KPI CARDS
           ========================================= */
        .metrics-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(230px, 1fr));
            gap: 18px;
            margin-bottom: 24px;
        }

        .metric-card {
            background: var(--white);
            border: 1px solid var(--border);
            border-radius: 14px;
            padding: 20px;
            box-shadow: var(--shadow-sm);
            display: flex;
            align-items: center;
            gap: 16px;
            cursor: pointer;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }

        .metric-card:hover {
            transform: translateY(-3px);
            box-shadow: var(--shadow-md);
        }

        .metric-icon {
            width: 50px;
            height: 50px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 22px;
            flex-shrink: 0;
        }

        .metric-info h3 {
            font-size: 26px;
            font-weight: 700;
            color: var(--teal-dark);
            line-height: 1;
        }

        .metric-info p {
            font-size: 13px;
            color: var(--text-muted);
            margin-top: 5px;
            font-weight: 500;
        }

        .icon-blue { background: #e0f2fe; color: #0284c7; }
        .icon-teal { background: #ccfbf1; color: #0f766e; }
        .icon-amber { background: #fef3c7; color: #d97706; }
        .icon-rose { background: #ffe4e6; color: #e11d48; }

        /* =========================================
           MAIN CONTENT CARD
           ========================================= */
        .content-card {
            background: var(--white);
            border: 1px solid var(--border);
            border-radius: 16px;
            padding: 24px;
            box-shadow: var(--shadow-md);
            margin-bottom: 24px;
        }

        /* Filter & Toolbar */
        .toolbar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 16px;
            margin-bottom: 20px;
            padding-bottom: 18px;
            border-bottom: 1px solid #edf4f6;
        }

        .search-wrapper {
            position: relative;
            flex: 1;
            min-width: 280px;
            max-width: 480px;
        }

        .search-wrapper i {
            position: absolute;
            left: 14px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-muted);
            font-size: 14px;
        }

        .search-input {
            width: 100%;
            padding: 10px 14px 10px 38px;
            border: 1px solid var(--border);
            border-radius: 10px;
            font-size: 13px;
            outline: none;
            transition: all 0.2s ease;
            background: #fafcfd;
        }

        .search-input:focus {
            border-color: var(--teal-accent);
            background: var(--white);
            box-shadow: 0 0 0 3px rgba(63, 127, 149, 0.12);
        }

        .filter-pills {
            display: flex;
            align-items: center;
            gap: 8px;
            flex-wrap: wrap;
        }

        .filter-btn {
            background: var(--teal-light);
            border: 1px solid var(--border);
            color: var(--text-dark);
            padding: 7px 14px;
            border-radius: 8px;
            font-size: 12px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s ease;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .filter-btn.active, .filter-btn:hover {
            background: var(--teal-main);
            color: var(--white);
            border-color: var(--teal-main);
        }

        .filter-btn.btn-filter-alert {
            background: #fef3c7;
            color: #92400e;
            border-color: #fde68a;
        }
        .filter-btn.btn-filter-alert.active, .filter-btn.btn-filter-alert:hover {
            background: #d97706;
            color: #ffffff;
            border-color: #d97706;
        }

        .filter-btn.btn-filter-out {
            background: #fee2e2;
            color: #991b1b;
            border-color: #fecaca;
        }
        .filter-btn.btn-filter-out.active, .filter-btn.btn-filter-out:hover {
            background: #dc2626;
            color: #ffffff;
            border-color: #dc2626;
        }

        /* =========================================
           DATA TABLE
           ========================================= */
        .table-responsive {
            width: 100%;
            overflow-x: auto;
            border: 1px solid #e1edf0;
            border-radius: 12px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            min-width: 950px;
            font-size: 13px;
        }

        thead {
            background: var(--teal-main);
            color: var(--white);
        }

        th {
            padding: 14px 16px;
            text-align: left;
            font-weight: 600;
            font-size: 12px;
            letter-spacing: 0.4px;
            white-space: nowrap;
        }

        td {
            padding: 14px 16px;
            border-bottom: 1px solid #edf4f6;
            color: #334d58;
            vertical-align: middle;
            white-space: nowrap;
        }

        tbody tr {
            transition: background 0.15s ease;
        }

        tbody tr:hover {
            background: #f4f9fb;
        }

        tbody tr.row-low-stock {
            background-color: #fffdf5;
        }
        tbody tr.row-out-of-stock {
            background-color: #fff8f8;
        }

        tbody tr:last-child td {
            border-bottom: none;
        }

        .item-cell {
            display: flex;
            flex-direction: column;
            gap: 2px;
        }

        .item-name {
            font-weight: 600;
            color: var(--teal-dark);
            font-size: 14px;
        }

        .item-sub {
            font-size: 11px;
            color: var(--text-muted);
            display: flex;
            gap: 8px;
        }

        .cat-tag {
            background: #eef6f8;
            padding: 1px 7px;
            border-radius: 4px;
            color: var(--teal-accent);
            font-weight: 500;
        }

        /* Quantity Badge & Progress */
        .qty-box {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .qty-num {
            font-weight: 700;
            font-size: 15px;
            min-width: 32px;
        }

        .stock-progress {
            width: 70px;
            height: 6px;
            background: #e2e8f0;
            border-radius: 3px;
            overflow: hidden;
        }

        .stock-progress-bar {
            height: 100%;
            border-radius: 3px;
        }

        .bar-healthy { background: var(--success); }
        .bar-low { background: var(--warning); }
        .bar-out { background: var(--danger); }

        /* Badges */
        .badge {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            padding: 5px 10px;
            border-radius: 6px;
            font-size: 11px;
            font-weight: 600;
        }

        .badge-healthy {
            background: var(--success-bg);
            color: #065f46;
            border: 1px solid var(--success-border);
        }

        .badge-low {
            background: var(--warning-bg);
            color: #92400e;
            border: 1px solid var(--warning-border);
        }

        .badge-out {
            background: var(--danger-bg);
            color: #991b1b;
            border: 1px solid var(--danger-border);
        }

        .loc-tag {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            color: #4a636e;
            font-size: 12px;
        }
        .loc-tag i { color: var(--teal-accent); }

        /* Row Action Buttons */
        .action-group {
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .btn-action-sm {
            padding: 6px 10px;
            border-radius: 6px;
            font-size: 11px;
            font-weight: 600;
            border: none;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 4px;
            transition: all 0.15s ease;
        }

        .btn-act-add {
            background: #e0f2fe;
            color: #0369a1;
        }
        .btn-act-add:hover {
            background: #0284c7;
            color: var(--white);
        }

        .btn-act-reduce {
            background: #fef2f2;
            color: #b91c1c;
        }
        .btn-act-reduce:hover {
            background: #ef4444;
            color: var(--white);
        }

        .btn-act-adjust {
            background: #f3f4f6;
            color: #374151;
        }
        .btn-act-adjust:hover {
            background: var(--teal-main);
            color: var(--white);
        }

        /* Empty State */
        .empty-state {
            padding: 50px 20px;
            text-align: center;
        }

        .empty-state i {
            font-size: 48px;
            color: #a0b6bf;
            margin-bottom: 14px;
        }

        .empty-state h3 {
            font-size: 18px;
            color: var(--teal-dark);
            margin-bottom: 6px;
        }

        .empty-state p {
            color: var(--text-muted);
            font-size: 13px;
            margin-bottom: 18px;
        }

        /* =========================================
           RECENT MOVEMENTS SECTION
           ========================================= */
        .section-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 16px;
        }

        .section-header h2 {
            font-size: 18px;
            font-weight: 700;
            color: var(--teal-dark);
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .type-badge {
            display: inline-block;
            padding: 3px 8px;
            border-radius: 4px;
            font-size: 11px;
            font-weight: 700;
        }

        .type-in { background: #dcfce7; color: #15803d; }
        .type-out { background: #fee2e2; color: #b91c1c; }
        .type-adjustment { background: #e0e7ff; color: #4338ca; }

        /* =========================================
           MODAL DIALOGS
           ========================================= */
        .modal-overlay {
            position: fixed;
            inset: 0;
            background: rgba(18, 42, 54, 0.5);
            backdrop-filter: blur(4px);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 1000;
            opacity: 0;
            visibility: hidden;
            transition: all 0.25s ease;
            padding: 20px;
        }

        .modal-overlay.active {
            opacity: 1;
            visibility: visible;
        }

        .modal-card {
            background: var(--white);
            border-radius: 16px;
            width: 100%;
            max-width: 540px;
            box-shadow: var(--shadow-lg);
            border: 1px solid var(--border);
            overflow: hidden;
            transform: scale(0.95);
            transition: transform 0.25s ease;
        }

        .modal-overlay.active .modal-card {
            transform: scale(1);
        }

        .modal-header {
            padding: 18px 24px;
            background: var(--teal-main);
            color: var(--white);
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .modal-header h3 {
            font-size: 17px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .modal-close {
            background: none;
            border: none;
            color: var(--white);
            font-size: 18px;
            cursor: pointer;
            opacity: 0.8;
        }
        .modal-close:hover { opacity: 1; }

        .modal-body {
            padding: 24px;
        }

        .form-group {
            margin-bottom: 18px;
        }

        .form-group label {
            display: block;
            font-size: 13px;
            font-weight: 600;
            color: var(--teal-dark);
            margin-bottom: 6px;
        }

        .form-control {
            width: 100%;
            padding: 10px 14px;
            border: 1px solid var(--border);
            border-radius: 8px;
            font-size: 13px;
            outline: none;
            transition: border-color 0.2s;
            background: #fdfefe;
        }

        .form-control:focus {
            border-color: var(--teal-accent);
            box-shadow: 0 0 0 3px rgba(63, 127, 149, 0.12);
        }

        .modal-footer {
            padding: 16px 24px;
            background: #f8fafb;
            border-top: 1px solid #edf4f6;
            display: flex;
            align-items: center;
            justify-content: flex-end;
            gap: 10px;
        }

        /* Large Modal */
        .modal-lg {
            max-width: 850px;
        }

        /* PDF Selection Card Options */
        .pdf-option-grid {
            display: grid;
            grid-template-columns: 1fr;
            gap: 14px;
        }

        .pdf-opt-card {
            border: 1px solid var(--border);
            border-radius: 12px;
            padding: 16px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            background: #fafcfd;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        .pdf-opt-card:hover {
            border-color: var(--teal-accent);
            background: var(--white);
            box-shadow: var(--shadow-sm);
        }

        .pdf-opt-info h4 {
            font-size: 15px;
            color: var(--teal-dark);
            margin-bottom: 4px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .pdf-opt-info p {
            font-size: 12px;
            color: var(--text-muted);
        }

        @media (max-width: 768px) {
            body { padding: 12px; }
            .page-header { padding: 16px; }
            .content-card { padding: 16px; }
            .header-actions { width: 100%; justify-content: stretch; }
            .header-actions .btn { flex: 1; }
        }
    </style>
</head>
<body>

<div class="container">

    <!-- PRINT-ONLY REPORT HEADER FOR PDF EXPORT -->
    <div class="print-only">
        <div class="print-report-header">
            <div>
                <h1 id="printReportTitle">Hardware Inventory Stock & Valuation Report</h1>
                <p>Official Inventory Control System - Generated on <%= reportGeneratedTime %></p>
            </div>
            <div style="text-align: right;">
                <p><strong>Status:</strong> Active Inventory Audit</p>
                <p><strong>Total SKUs Tracked:</strong> <%= totalSKUs %></p>
            </div>
        </div>
    </div>

    <!-- ALERT / TOAST NOTIFICATIONS -->
    <% if ("stock_added".equals(msg)) { %>
        <div class="alert-banner success no-print">
            <div class="alert-left">
                <i class="fa-solid fa-circle-check"></i>
                <span>Stock Added Successfully! Inventory records and movements updated.</span>
            </div>
            <button class="close-alert" onclick="this.parentElement.style.display='none'"><i class="fa-solid fa-xmark"></i></button>
        </div>
    <% } else if ("stock_reduced".equals(msg)) { %>
        <div class="alert-banner success no-print">
            <div class="alert-left">
                <i class="fa-solid fa-circle-check"></i>
                <span>Stock Reduced Successfully! Quantities adjusted and audit logged.</span>
            </div>
            <button class="close-alert" onclick="this.parentElement.style.display='none'"><i class="fa-solid fa-xmark"></i></button>
        </div>
    <% } else if ("stock_updated".equals(msg)) { %>
        <div class="alert-banner success no-print">
            <div class="alert-left">
                <i class="fa-solid fa-circle-check"></i>
                <span>Stock Quantity Adjusted Successfully! Balance verified.</span>
            </div>
            <button class="close-alert" onclick="this.parentElement.style.display='none'"><i class="fa-solid fa-xmark"></i></button>
        </div>
    <% } else if (err != null) { %>
        <div class="alert-banner error no-print">
            <div class="alert-left">
                <i class="fa-solid fa-triangle-exclamation"></i>
                <span>Stock operation could not be completed. Please check data and try again.</span>
            </div>
            <button class="close-alert" onclick="this.parentElement.style.display='none'"><i class="fa-solid fa-xmark"></i></button>
        </div>
    <% } %>

    <!-- PERSISTENT STOCK ALERTS BANNER -->
    <% if (totalAlerts > 0) { %>
        <div class="quick-alert-box no-print">
            <div class="qa-left">
                <i class="fa-solid fa-triangle-exclamation" style="font-size: 20px;"></i>
                <div>
                    <strong>Inventory Alert:</strong>
                    <span>
                        <%= outOfStockCount %> item(s) are completely out of stock, and <%= lowStockCount %> item(s) are below reorder threshold.
                    </span>
                </div>
            </div>
            <div class="qa-actions">
                <button class="qa-btn" onclick="openModal('alertsModal')">
                    <i class="fa-solid fa-bell"></i> View Stock Alerts (<%= totalAlerts %>)
                </button>
                <button class="qa-btn" style="background:#b91c1c;" onclick="generatePdfReport('alerts')">
                    <i class="fa-solid fa-file-pdf"></i> Export Alerts PDF
                </button>
            </div>
        </div>
    <% } %>

    <!-- PAGE HEADER -->
    <header class="page-header no-print">
        <div class="header-title-box">
            <div class="header-icon">
                <i class="fa-solid fa-boxes-stacked"></i>
            </div>
            <div>
                <h1>Stock Management & Alerts</h1>
                <p>Live inventory tracking, replenish/reduce operations, and PDF reporting</p>
            </div>
        </div>

        <div class="header-actions">
            <!-- PDF REPORT BUTTON -->
            <button class="btn btn-pdf" onclick="openModal('pdfReportModal')">
                <i class="fa-solid fa-file-pdf"></i> Stock Report (PDF)
            </button>

            <!-- STOCK ALERTS BUTTON -->
            <button class="btn btn-alerts" onclick="openModal('alertsModal')">
                <i class="fa-solid fa-bell"></i> Stock Alerts
                <% if (totalAlerts > 0) { %>
                    <span class="alert-pill"><%= totalAlerts %></span>
                <% } %>
            </button>

            <!-- QUICK ACTIONS -->
            <button class="btn btn-primary" onclick="openModal('addStockModal')">
                <i class="fa-solid fa-plus"></i> Add Stock
            </button>
            <button class="btn btn-secondary" onclick="openModal('reduceStockModal')">
                <i class="fa-solid fa-minus"></i> Reduce
            </button>
            <button class="btn btn-secondary" onclick="openModal('updateStockModal')">
                <i class="fa-solid fa-arrows-rotate"></i> Adjust
            </button>
            <button class="btn btn-secondary" onclick="openModal('movementsModal')">
                <i class="fa-solid fa-clock-rotate-left"></i> Movements
            </button>
            <a href="index.jsp" class="btn btn-secondary">
                <i class="fa-solid fa-house"></i> Dashboard
            </a>
        </div>
    </header>

    <!-- METRICS KPI STATS -->
    <div class="metrics-grid">
        <div class="metric-card" onclick="setFilter('all', document.getElementById('filterBtnAll'))">
            <div class="metric-icon icon-blue">
                <i class="fa-solid fa-layer-group"></i>
            </div>
            <div class="metric-info">
                <h3><%= totalSKUs %></h3>
                <p>Total Tracked Items</p>
            </div>
        </div>

        <div class="metric-card" onclick="setFilter('healthy', document.getElementById('filterBtnHealthy'))">
            <div class="metric-icon icon-teal">
                <i class="fa-solid fa-cubes"></i>
            </div>
            <div class="metric-info">
                <h3><%= totalUnits %></h3>
                <p>Total Units on Hand</p>
            </div>
        </div>

        <div class="metric-card" onclick="setFilter('low', document.getElementById('filterBtnLow'))">
            <div class="metric-icon icon-amber">
                <i class="fa-solid fa-triangle-exclamation"></i>
            </div>
            <div class="metric-info">
                <h3><%= lowStockCount %></h3>
                <p>Low Stock Alerts</p>
            </div>
        </div>

        <div class="metric-card" onclick="setFilter('out', document.getElementById('filterBtnOut'))">
            <div class="metric-icon icon-rose">
                <i class="fa-solid fa-circle-exclamation"></i>
            </div>
            <div class="metric-info">
                <h3><%= outOfStockCount %></h3>
                <p>Out of Stock Items</p>
            </div>
        </div>
    </div>

    <!-- MAIN STOCK TABLE CARD -->
    <div class="content-card">
        <div class="toolbar no-print">
            <div class="search-wrapper">
                <i class="fa-solid fa-magnifying-glass"></i>
                <input type="text" id="stockSearch" class="search-input"
                       placeholder="Search by item name, category, brand, or location..."
                       onkeyup="filterStockTable()">
            </div>

            <div class="filter-pills">
                <button id="filterBtnAll" class="filter-btn active" onclick="setFilter('all', this)">
                    All Items (<%= totalSKUs %>)
                </button>
                <button id="filterBtnHealthy" class="filter-btn" onclick="setFilter('healthy', this)">
                    In Stock (<%= healthyStockCount %>)
                </button>
                <button id="filterBtnLow" class="filter-btn btn-filter-alert" onclick="setFilter('low', this)">
                    <i class="fa-solid fa-triangle-exclamation"></i> Low Stock (<%= lowStockCount %>)
                </button>
                <button id="filterBtnOut" class="filter-btn btn-filter-out" onclick="setFilter('out', this)">
                    <i class="fa-solid fa-circle-exclamation"></i> Out of Stock (<%= outOfStockCount %>)
                </button>
                <button id="filterBtnAlerts" class="filter-btn" style="border-color: #f59e0b;" onclick="setFilter('alerts', this)">
                    <i class="fa-solid fa-bell"></i> All Alerts (<%= totalAlerts %>)
                </button>
            </div>
        </div>

        <div class="table-responsive">
            <table id="stockTable">
                <thead>
                    <tr>
                        <th style="width: 70px;">ID</th>
                        <th>Item & Category</th>
                        <th>Brand</th>
                        <th>Quantity on Hand</th>
                        <th>Location</th>
                        <th>Reorder Level</th>
                        <th>Safety Stock</th>
                        <th>Status</th>
                        <th class="action-col" style="text-align: center; width: 170px;">Quick Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (stockList.isEmpty()) { %>
                        <tr>
                            <td colspan="9">
                                <div class="empty-state">
                                    <i class="fa-solid fa-box-open"></i>
                                    <h3>No Stock Records Found</h3>
                                    <p>Your inventory database is ready. Add stock to begin tracking.</p>
                                    <button class="btn btn-primary no-print" onclick="openModal('addStockModal')">
                                        <i class="fa-solid fa-plus"></i> Add Initial Stock
                                    </button>
                                </div>
                            </td>
                        </tr>
                    <% } else {
                        for (Stock stock : stockList) {
                            String statusType;
                            String statusText;
                            String badgeClass;
                            String barClass;
                            String rowAlertClass = "";

                            if (stock.getQuantity() <= 0) {
                                statusType = "out";
                                statusText = "Out of Stock";
                                badgeClass = "badge-out";
                                barClass = "bar-out";
                                rowAlertClass = "row-out-of-stock";
                            } else if (stock.getQuantity() <= stock.getReorderLevel()) {
                                statusType = "low";
                                statusText = "Low Stock";
                                badgeClass = "badge-low";
                                barClass = "bar-low";
                                rowAlertClass = "row-low-stock";
                            } else {
                                statusType = "healthy";
                                statusText = "In Stock";
                                badgeClass = "badge-healthy";
                                barClass = "bar-healthy";
                            }

                            int pct = 0;
                            if (stock.getReorderLevel() > 0) {
                                pct = Math.min(100, (stock.getQuantity() * 100) / (stock.getReorderLevel() * 2));
                            } else {
                                pct = stock.getQuantity() > 0 ? 100 : 0;
                            }
                    %>
                        <tr class="<%= rowAlertClass %>"
                            data-status="<%= statusType %>"
                            data-name="<%= stock.getItemName() != null ? stock.getItemName().toLowerCase() : "" %>"
                            data-brand="<%= stock.getBrand() != null ? stock.getBrand().toLowerCase() : "" %>"
                            data-cat="<%= stock.getCategory() != null ? stock.getCategory().toLowerCase() : "" %>"
                            data-loc="<%= stock.getLocation() != null ? stock.getLocation().toLowerCase() : "" %>">
                            <td>
                                <strong>#<%= stock.getItemId() %></strong>
                            </td>
                            <td>
                                <div class="item-cell">
                                    <span class="item-name"><%= stock.getItemName() %></span>
                                    <span class="item-sub">
                                        <span class="cat-tag"><%= stock.getCategory() != null ? stock.getCategory() : "General" %></span>
                                    </span>
                                </div>
                            </td>
                            <td><%= stock.getBrand() != null ? stock.getBrand() : "-" %></td>
                            <td>
                                <div class="qty-box">
                                    <span class="qty-num"><%= stock.getQuantity() %></span>
                                    <div class="stock-progress no-print" title="Stock vs Reorder Ratio: <%= pct %>%">
                                        <div class="stock-progress-bar <%= barClass %>" style="width: <%= Math.max(8, pct) %>%;"></div>
                                    </div>
                                </div>
                            </td>
                            <td>
                                <span class="loc-tag">
                                    <i class="fa-solid fa-location-dot no-print"></i>
                                    <%= stock.getLocation() != null ? stock.getLocation() : "Warehouse" %>
                                </span>
                            </td>
                            <td><strong><%= stock.getReorderLevel() %></strong></td>
                            <td><%= stock.getSafetyStock() %></td>
                            <td>
                                <span class="badge <%= badgeClass %>">
                                    <% if ("healthy".equals(statusType)) { %>
                                        <i class="fa-solid fa-check no-print"></i>
                                    <% } else if ("low".equals(statusType)) { %>
                                        <i class="fa-solid fa-triangle-exclamation no-print"></i>
                                    <% } else { %>
                                        <i class="fa-solid fa-circle-xmark no-print"></i>
                                    <% } %>
                                    <%= statusText %>
                                </span>
                            </td>
                            <td class="action-col" style="text-align: center;">
                                <div class="action-group" style="justify-content: center;">
                                    <button class="btn-action-sm btn-act-add"
                                            title="Add stock to this item"
                                            onclick="quickAdd(<%= stock.getItemId() %>, '<%= stock.getItemName().replace("'", "\\'") %>')">
                                        <i class="fa-solid fa-plus"></i> Add
                                    </button>
                                    <button class="btn-action-sm btn-act-reduce"
                                            title="Reduce stock from this item"
                                            onclick="quickReduce(<%= stock.getItemId() %>, '<%= stock.getItemName().replace("'", "\\'") %>', <%= stock.getQuantity() %>)">
                                        <i class="fa-solid fa-minus"></i>
                                    </button>
                                    <button class="btn-action-sm btn-act-adjust"
                                            title="Adjust count"
                                            onclick="quickAdjust(<%= stock.getItemId() %>, '<%= stock.getItemName().replace("'", "\\'") %>', <%= stock.getQuantity() %>)">
                                        <i class="fa-solid fa-pen"></i>
                                    </button>
                                </div>
                            </td>
                        </tr>
                    <%  }
                    } %>
                </tbody>
            </table>
        </div>

        <!-- PRINT FOOTER FOR PDF -->
        <div class="print-only print-footer">
            <span>Hardware Inventory System | Official Audit Report</span>
            <span>Generated: <%= reportGeneratedTime %></span>
            <span>Authorized Signature: __________________________</span>
        </div>
    </div>

    <!-- RECENT MOVEMENTS SECTION -->
    <div class="content-card no-print">
        <div class="section-header">
            <h2>
                <i class="fa-solid fa-clock-rotate-left" style="color: var(--teal-accent);"></i>
                Recent Stock Movements
            </h2>
            <button class="btn btn-secondary" onclick="openModal('movementsModal')">
                View All Movements (<%= movementList.size() %>)
            </button>
        </div>

        <div class="table-responsive">
            <table>
                <thead>
                    <tr>
                        <th style="width: 80px;">Log ID</th>
                        <th>Item</th>
                        <th>Movement Type</th>
                        <th>Quantity</th>
                        <th>Reference Note</th>
                        <th>Timestamp</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (movementList.isEmpty()) { %>
                        <tr>
                            <td colspan="6" style="text-align: center; color: var(--text-muted); padding: 25px;">
                                No stock movements logged yet.
                            </td>
                        </tr>
                    <% } else {
                        int maxShow = Math.min(6, movementList.size());
                        for (int i = 0; i < maxShow; i++) {
                            StockMovement sm = movementList.get(i);
                            String typeClass = "type-in";
                            if ("OUT".equalsIgnoreCase(sm.getMovementType())) typeClass = "type-out";
                            else if ("ADJUSTMENT".equalsIgnoreCase(sm.getMovementType())) typeClass = "type-adjustment";
                    %>
                        <tr>
                            <td>#<%= sm.getMovementId() %></td>
                            <td><strong><%= sm.getItemName() != null ? sm.getItemName() : ("Item #" + sm.getItemId()) %></strong></td>
                            <td>
                                <span class="type-badge <%= typeClass %>">
                                    <%= sm.getMovementType() %>
                                </span>
                            </td>
                            <td><strong><%= sm.getQuantity() %></strong></td>
                            <td><%= sm.getReferenceNote() != null && !sm.getReferenceNote().trim().isEmpty() ? sm.getReferenceNote() : "-" %></td>
                            <td style="color: var(--text-muted); font-size: 12px;"><%= sm.getMovementDate() %></td>
                        </tr>
                    <%  }
                    } %>
                </tbody>
            </table>
        </div>
    </div>

</div>

<!-- =========================================
     MODAL: STOCK ALERTS (LOW & OUT OF STOCK)
     ========================================= -->
<div id="alertsModal" class="modal-overlay" onclick="handleOverlayClick(event, 'alertsModal')">
    <div class="modal-card modal-lg">
        <div class="modal-header" style="background: #ea580c;">
            <h3><i class="fa-solid fa-triangle-exclamation"></i> Stock Alerts Center</h3>
            <button class="modal-close" onclick="closeModal('alertsModal')"><i class="fa-solid fa-xmark"></i></button>
        </div>
        <div class="modal-body" style="max-height: 480px; overflow-y: auto;">
            <% if (alertItems.isEmpty()) { %>
                <div style="text-align: center; padding: 40px 20px;">
                    <i class="fa-solid fa-circle-check" style="font-size: 48px; color: #10b981; margin-bottom: 12px;"></i>
                    <h3 style="color: var(--teal-dark); margin-bottom: 6px;">All Stock Levels Healthy!</h3>
                    <p style="color: var(--text-muted); font-size: 13px;">No items currently below reorder thresholds or out of stock.</p>
                </div>
            <% } else { %>
                <p style="margin-bottom: 14px; font-size: 13px; color: var(--text-muted);">
                    The following items have reached critical stock or need immediate replenishment:
                </p>
                <div class="table-responsive">
                    <table>
                        <thead>
                            <tr>
                                <th>Item</th>
                                <th>Current Qty</th>
                                <th>Reorder Level</th>
                                <th>Deficit</th>
                                <th>Status</th>
                                <th style="text-align: center;">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Stock it : alertItems) {
                                int deficit = Math.max(0, it.getReorderLevel() - it.getQuantity() + it.getSafetyStock());
                                String alertBadge = it.getQuantity() <= 0 ? "badge-out" : "badge-low";
                                String alertLabel = it.getQuantity() <= 0 ? "Out of Stock" : "Low Stock";
                            %>
                                <tr>
                                    <td>
                                        <strong><%= it.getItemName() %></strong>
                                        <div style="font-size: 11px; color: var(--text-muted);"><%= it.getLocation() %></div>
                                    </td>
                                    <td><strong style="color: #b91c1c; font-size: 14px;"><%= it.getQuantity() %></strong></td>
                                    <td><%= it.getReorderLevel() %></td>
                                    <td>
                                        <span style="font-weight: 700; color: #ea580c;">+<%= deficit > 0 ? deficit : 10 %> units needed</span>
                                    </td>
                                    <td>
                                        <span class="badge <%= alertBadge %>"><%= alertLabel %></span>
                                    </td>
                                    <td style="text-align: center;">
                                        <button class="btn btn-primary" style="padding: 6px 12px; font-size: 11px;"
                                                onclick="closeModal('alertsModal'); quickAdd(<%= it.getItemId() %>, '<%= it.getItemName().replace("'", "\\'") %>')">
                                            <i class="fa-solid fa-plus"></i> Replenish
                                        </button>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            <% } %>
        </div>
        <div class="modal-footer">
            <% if (!alertItems.isEmpty()) { %>
                <button type="button" class="btn btn-pdf" onclick="closeModal('alertsModal'); generatePdfReport('alerts')">
                    <i class="fa-solid fa-file-pdf"></i> Download Alerts PDF
                </button>
            <% } %>
            <button type="button" class="btn btn-secondary" onclick="closeModal('alertsModal')">Close</button>
        </div>
    </div>
</div>

<!-- =========================================
     MODAL: PDF REPORT OPTIONS
     ========================================= -->
<div id="pdfReportModal" class="modal-overlay" onclick="handleOverlayClick(event, 'pdfReportModal')">
    <div class="modal-card">
        <div class="modal-header" style="background: #b91c1c;">
            <h3><i class="fa-solid fa-file-pdf"></i> Generate Stock Report (PDF)</h3>
            <button class="modal-close" onclick="closeModal('pdfReportModal')"><i class="fa-solid fa-xmark"></i></button>
        </div>
        <div class="modal-body">
            <p style="font-size: 13px; color: var(--text-muted); margin-bottom: 16px;">
                Choose the type of stock inventory report you want to generate in PDF format:
            </p>

            <div class="pdf-option-grid">
                <!-- Option 1: Full Stock Report -->
                <div class="pdf-opt-card" onclick="generatePdfReport('all')">
                    <div class="pdf-opt-info">
                        <h4><i class="fa-solid fa-boxes-stacked" style="color: var(--teal-main);"></i> Full Inventory Stock PDF</h4>
                        <p>Complete listing of all <%= totalSKUs %> tracked items, quantities, locations, and status.</p>
                    </div>
                    <button class="btn btn-pdf" style="padding: 7px 12px; font-size: 12px;">Generate</button>
                </div>

                <!-- Option 2: Alerts & Reorder PDF -->
                <div class="pdf-opt-card" onclick="generatePdfReport('alerts')">
                    <div class="pdf-opt-info">
                        <h4><i class="fa-solid fa-triangle-exclamation" style="color: #ea580c;"></i> Low Stock & Reorder PDF</h4>
                        <p>Focused report on <%= totalAlerts %> items that are out of stock or need immediate reordering.</p>
                    </div>
                    <button class="btn btn-warning" style="padding: 7px 12px; font-size: 12px;">Generate</button>
                </div>

                <!-- Option 3: Backend Valuation Report -->
                <div class="pdf-opt-card" onclick="window.open('stock-reports', '_blank')">
                    <div class="pdf-opt-info">
                        <h4><i class="fa-solid fa-chart-pie" style="color: #0284c7;"></i> Stock Valuation & Cost Report</h4>
                        <p>Comprehensive cost, sales value, and asset valuation breakdown (HTML/Print).</p>
                    </div>
                    <button class="btn btn-secondary" style="padding: 7px 12px; font-size: 12px;">Open</button>
                </div>
            </div>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-secondary" onclick="closeModal('pdfReportModal')">Cancel</button>
        </div>
    </div>
</div>

<!-- =========================================
     MODAL: ADD STOCK
     ========================================= -->
<div id="addStockModal" class="modal-overlay" onclick="handleOverlayClick(event, 'addStockModal')">
    <div class="modal-card">
        <div class="modal-header">
            <h3><i class="fa-solid fa-plus-circle"></i> Add Stock (Replenish)</h3>
            <button class="modal-close" onclick="closeModal('addStockModal')"><i class="fa-solid fa-xmark"></i></button>
        </div>
        <form action="AddStockServlet" method="post">
            <div class="modal-body">
                <div class="form-group">
                    <label for="addStockItemId">Select Item</label>
                    <select name="itemId" id="addStockItemId" class="form-control" required>
                        <% for (Stock it : itemList) { %>
                            <option value="<%= it.getItemId() %>">
                                #<%= it.getItemId() %> - <%= it.getItemName() %>
                            </option>
                        <% } %>
                    </select>
                </div>

                <div class="form-group">
                    <label for="addStockQuantity">Quantity to Add</label>
                    <input type="number" id="addStockQuantity" name="quantity" min="1" class="form-control"
                           placeholder="Enter units to add..." required>
                </div>

                <div class="form-group">
                    <label for="addStockNote">Reference Note (Optional)</label>
                    <input type="text" id="addStockNote" name="referenceNote" class="form-control"
                           placeholder="e.g. Supplier delivery, PO #1042">
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="closeModal('addStockModal')">Cancel</button>
                <button type="submit" class="btn btn-primary"><i class="fa-solid fa-plus"></i> Add Stock</button>
            </div>
        </form>
    </div>
</div>

<!-- =========================================
     MODAL: REDUCE STOCK
     ========================================= -->
<div id="reduceStockModal" class="modal-overlay" onclick="handleOverlayClick(event, 'reduceStockModal')">
    <div class="modal-card">
        <div class="modal-header" style="background: #b91c1c;">
            <h3><i class="fa-solid fa-minus-circle"></i> Reduce Stock (Dispatch/Issue)</h3>
            <button class="modal-close" onclick="closeModal('reduceStockModal')"><i class="fa-solid fa-xmark"></i></button>
        </div>
        <form action="ReduceStockServlet" method="post">
            <div class="modal-body">
                <div class="form-group">
                    <label for="reduceStockItemId">Select Item</label>
                    <select name="itemId" id="reduceStockItemId" class="form-control" required>
                        <% for (Stock it : itemList) { %>
                            <option value="<%= it.getItemId() %>">
                                #<%= it.getItemId() %> - <%= it.getItemName() %>
                            </option>
                        <% } %>
                    </select>
                </div>

                <div class="form-group">
                    <label for="reduceStockQuantity">Quantity to Reduce</label>
                    <input type="number" id="reduceStockQuantity" name="quantity" min="1" class="form-control"
                           placeholder="Enter units to dispatch..." required>
                </div>

                <div class="form-group">
                    <label for="reduceStockNote">Reference Note (Optional)</label>
                    <input type="text" id="reduceStockNote" name="referenceNote" class="form-control"
                           placeholder="e.g. Issued to Lab 3, Customer order #512">
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="closeModal('reduceStockModal')">Cancel</button>
                <button type="submit" class="btn btn-secondary" style="background:#b91c1c; color:#fff;">
                    <i class="fa-solid fa-minus"></i> Reduce Stock
                </button>
            </div>
        </form>
    </div>
</div>

<!-- =========================================
     MODAL: ADJUST / UPDATE STOCK
     ========================================= -->
<div id="updateStockModal" class="modal-overlay" onclick="handleOverlayClick(event, 'updateStockModal')">
    <div class="modal-card">
        <div class="modal-header" style="background: var(--teal-accent);">
            <h3><i class="fa-solid fa-arrows-rotate"></i> Adjust Stock Quantity</h3>
            <button class="modal-close" onclick="closeModal('updateStockModal')"><i class="fa-solid fa-xmark"></i></button>
        </div>
        <form action="UpdateStockServlet" method="post">
            <div class="modal-body">
                <div class="form-group">
                    <label for="updateStockItemId">Select Item</label>
                    <select name="itemId" id="updateStockItemId" class="form-control" required>
                        <% for (Stock it : itemList) { %>
                            <option value="<%= it.getItemId() %>">
                                #<%= it.getItemId() %> - <%= it.getItemName() %>
                            </option>
                        <% } %>
                    </select>
                </div>

                <div class="form-group">
                    <label for="updateStockQuantity">New Exact Total Quantity</label>
                    <input type="number" id="updateStockQuantity" name="newQuantity" min="0" class="form-control"
                           placeholder="Enter audited count..." required>
                </div>

                <div class="form-group">
                    <label for="updateStockNote">Audit Note</label>
                    <input type="text" id="updateStockNote" name="referenceNote" class="form-control"
                           placeholder="e.g. Physical inventory count reconciliation">
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="closeModal('updateStockModal')">Cancel</button>
                <button type="submit" class="btn btn-primary"><i class="fa-solid fa-check"></i> Save Adjustment</button>
            </div>
        </form>
    </div>
</div>

<!-- =========================================
     MODAL: ALL MOVEMENTS AUDIT LOG
     ========================================= -->
<div id="movementsModal" class="modal-overlay" onclick="handleOverlayClick(event, 'movementsModal')">
    <div class="modal-card modal-lg">
        <div class="modal-header">
            <h3><i class="fa-solid fa-clock-rotate-left"></i> Stock Movement Audit History</h3>
            <button class="modal-close" onclick="closeModal('movementsModal')"><i class="fa-solid fa-xmark"></i></button>
        </div>
        <div class="modal-body" style="max-height: 480px; overflow-y: auto;">
            <div class="table-responsive">
                <table>
                    <thead>
                        <tr>
                            <th>Log ID</th>
                            <th>Item Name</th>
                            <th>Type</th>
                            <th>Quantity</th>
                            <th>Note</th>
                            <th>Date</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (movementList.isEmpty()) { %>
                            <tr><td colspan="6" style="text-align: center; color: var(--text-muted); padding: 20px;">No movements logged.</td></tr>
                        <% } else {
                            for (StockMovement sm : movementList) {
                                String typeClass = "type-in";
                                if ("OUT".equalsIgnoreCase(sm.getMovementType())) typeClass = "type-out";
                                else if ("ADJUSTMENT".equalsIgnoreCase(sm.getMovementType())) typeClass = "type-adjustment";
                        %>
                            <tr>
                                <td>#<%= sm.getMovementId() %></td>
                                <td><strong><%= sm.getItemName() != null ? sm.getItemName() : ("Item #" + sm.getItemId()) %></strong></td>
                                <td><span class="type-badge <%= typeClass %>"><%= sm.getMovementType() %></span></td>
                                <td><%= sm.getQuantity() %></td>
                                <td><%= sm.getReferenceNote() != null ? sm.getReferenceNote() : "-" %></td>
                                <td style="font-size: 12px; color: var(--text-muted);"><%= sm.getMovementDate() %></td>
                            </tr>
                        <%  }
                        } %>
                    </tbody>
                </table>
            </div>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-secondary" onclick="closeModal('movementsModal')">Close</button>
        </div>
    </div>
</div>

<!-- JAVASCRIPT LOGIC -->
<script>
    let currentFilter = 'all';

    function openModal(id) {
        const modal = document.getElementById(id);
        if (modal) modal.classList.add('active');
    }

    function closeModal(id) {
        const modal = document.getElementById(id);
        if (modal) modal.classList.remove('active');
    }

    function handleOverlayClick(event, id) {
        if (event.target === document.getElementById(id)) {
            closeModal(id);
        }
    }

    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            document.querySelectorAll('.modal-overlay.active').forEach(m => m.classList.remove('active'));
        }
    });

    // Quick Action Fillers
    function quickAdd(itemId, itemName) {
        const sel = document.getElementById('addStockItemId');
        if (sel) sel.value = itemId;
        const qty = document.getElementById('addStockQuantity');
        if (qty) qty.value = '';
        openModal('addStockModal');
    }

    function quickReduce(itemId, itemName, currentQty) {
        const sel = document.getElementById('reduceStockItemId');
        if (sel) sel.value = itemId;
        const qty = document.getElementById('reduceStockQuantity');
        if (qty) {
            qty.value = '';
            qty.max = currentQty;
        }
        openModal('reduceStockModal');
    }

    function quickAdjust(itemId, itemName, currentQty) {
        const sel = document.getElementById('updateStockItemId');
        if (sel) sel.value = itemId;
        const qty = document.getElementById('updateStockQuantity');
        if (qty) qty.value = currentQty;
        openModal('updateStockModal');
    }

    // Filter by Tab
    function setFilter(status, btn) {
        currentFilter = status;
        document.querySelectorAll('.filter-pills .filter-btn').forEach(b => b.classList.remove('active'));
        if (btn) btn.classList.add('active');
        filterStockTable();
    }

    // Live Search & Filter
    function filterStockTable() {
        const query = document.getElementById('stockSearch').value.toLowerCase().trim();
        const rows = document.querySelectorAll('#stockTable tbody tr');

        rows.forEach(row => {
            const rowStatus = row.getAttribute('data-status');
            if (!rowStatus) return; // skip empty state row

            const name = row.getAttribute('data-name') || '';
            const brand = row.getAttribute('data-brand') || '';
            const cat = row.getAttribute('data-cat') || '';
            const loc = row.getAttribute('data-loc') || '';

            const matchesQuery = !query || name.includes(query) || brand.includes(query) || cat.includes(query) || loc.includes(query);
            
            let matchesStatus = false;
            if (currentFilter === 'all') {
                matchesStatus = true;
            } else if (currentFilter === 'alerts') {
                matchesStatus = (rowStatus === 'low' || rowStatus === 'out');
            } else {
                matchesStatus = (rowStatus === currentFilter);
            }

            if (matchesQuery && matchesStatus) {
                row.style.display = '';
            } else {
                row.style.display = 'none';
            }
        });
    }

    // PDF Report Generator
    function generatePdfReport(type) {
        closeModal('pdfReportModal');
        const titleEl = document.getElementById('printReportTitle');

        if (type === 'alerts') {
            setFilter('alerts', document.getElementById('filterBtnAlerts'));
            if (titleEl) titleEl.innerText = 'Hardware Inventory: Stock Alerts & Reorder Procurement Report';
        } else {
            setFilter('all', document.getElementById('filterBtnAll'));
            if (titleEl) titleEl.innerText = 'Hardware Inventory: Complete Stock Status & Valuation Report';
        }

        // Trigger browser print-to-PDF
        setTimeout(function() {
            window.print();
        }, 200);
    }
</script>

</body>
</html>
