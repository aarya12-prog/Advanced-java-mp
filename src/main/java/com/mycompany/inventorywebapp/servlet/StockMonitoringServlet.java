package com.mycompany.inventorywebapp.servlet;

import com.mycompany.inventorywebapp.dao.StockDAO;
import com.mycompany.inventorywebapp.model.StockItem;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/stock-monitoring")
public class StockMonitoringServlet extends HttpServlet {
    private StockDAO stockDAO;

    @Override
    public void init() {
        stockDAO = new StockDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "search":
                String query = request.getParameter("query");
                List<StockItem> searchResults = stockDAO.searchStock(query != null ? query : "");
                request.setAttribute("items", searchResults);
                break;
            case "lowStock":
                List<StockItem> lowStock = stockDAO.getLowStockAlerts();
                request.setAttribute("items", lowStock);
                request.setAttribute("alertType", "Low Stock Items");
                break;
            case "outOfStock":
                List<StockItem> outOfStock = stockDAO.getOutOfStockAlerts();
                request.setAttribute("items", outOfStock);
                request.setAttribute("alertType", "Out of Stock Items");
                break;
            default:
                List<StockItem> allItems = stockDAO.getAllStock();
                request.setAttribute("items", allItems);
                break;
        }

        request.getRequestDispatcher("stock-monitoring.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("setReorderLevel".equals(action)) {
            int itemId = Integer.parseInt(request.getParameter("itemId"));
            int reorderLevel = Integer.parseInt(request.getParameter("reorderLevel"));
            stockDAO.updateReorderLevel(itemId, reorderLevel);
        }
        response.sendRedirect("stock-monitoring");
    }
}