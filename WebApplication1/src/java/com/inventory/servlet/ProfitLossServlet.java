package com.inventory.servlet;

import com.inventory.dao.ProfitLossDAO;
import com.inventory.model.ProfitLossReport;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

@WebServlet("/profitLoss")
public class ProfitLossServlet extends HttpServlet {
    
    private ProfitLossDAO profitLossDAO;
    
    @Override
    public void init() {
        profitLossDAO = new ProfitLossDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            // Get date range from request or use defaults
            String startDate = request.getParameter("startDate");
            String endDate = request.getParameter("endDate");
            
            // Default to current month if not specified
            if (startDate == null || startDate.isEmpty()) {
                LocalDate today = LocalDate.now();
                LocalDate firstDay = today.withDayOfMonth(1);
                startDate = firstDay.format(DateTimeFormatter.ISO_LOCAL_DATE);
                endDate = today.format(DateTimeFormatter.ISO_LOCAL_DATE);
            }
            
            // Get profit/loss report
            ProfitLossReport report = profitLossDAO.getProfitLossReport(startDate, endDate);
            
            // Set attributes for JSP
            request.setAttribute("report", report);
            request.setAttribute("startDate", startDate);
            request.setAttribute("endDate", endDate);
            
            // Calculate profit margin
            double profitMargin = 0;
            if (report.getTotalSales().compareTo(java.math.BigDecimal.ZERO) > 0) {
                profitMargin = report.getNetProfit().divide(report.getTotalSales(), 4, java.math.RoundingMode.HALF_UP)
                                    .multiply(new java.math.BigDecimal(100))
                                    .doubleValue();
            }
            request.setAttribute("profitMargin", profitMargin);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading report: " + e.getMessage());
        }
        
        request.getRequestDispatcher("/jsp/profitLossReport.jsp").forward(request, response);
    }
}