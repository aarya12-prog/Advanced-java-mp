package com.mycompany.inventorywebapp.servlet;

import com.mycompany.inventorywebapp.dao.StockDAO;
import com.mycompany.inventorywebapp.model.StockItem;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/stock-reports")
public class StockReportServlet extends HttpServlet {
    private StockDAO stockDAO;

    @Override
    public void init() {
        stockDAO = new StockDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<StockItem> reportData = stockDAO.getAllStock();
        
        double totalCostValue = 0;
        double totalSalesValue = 0;
        int totalQuantity = 0;

        for (StockItem item : reportData) {
            totalCostValue += (item.getQuantity() * item.getPurchasePrice());
            totalSalesValue += (item.getQuantity() * item.getSellingPrice());
            totalQuantity += item.getQuantity();
        }

        request.setAttribute("reportData", reportData);
        request.setAttribute("totalCostValue", totalCostValue);
        request.setAttribute("totalSalesValue", totalSalesValue);
        request.setAttribute("totalQuantity", totalQuantity);

        request.getRequestDispatcher("stock-reports.jsp").forward(request, response);
    }
}