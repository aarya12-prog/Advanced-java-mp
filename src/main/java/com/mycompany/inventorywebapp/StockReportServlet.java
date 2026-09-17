package com.mycompany.inventorywebapp;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author Tanishka Vaity
 */
@WebServlet(name = "StockReportServlet", urlPatterns = {"/StockReportServlet"})
public class StockReportServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        String query = "SELECT i.inventory_id, it.item_name, it.category, it.brand, it.model_number, " +
                       "i.quantity, i.reorder_level, i.safety_stock, i.location, " +
                       "s.supplier_name, i.last_updated " +
                       "FROM inventory i " +
                       "JOIN items it ON i.item_id = it.item_id " +
                       "JOIN suppliers s ON it.supplier_id = s.supplier_id " +
                       "ORDER BY i.quantity ASC";

        try (PrintWriter out = response.getWriter();
             Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {

            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Stock Report - Hardware Inventory</title>");
            out.println("<style>");
            out.println("body { font-family: Arial, sans-serif; margin: 20px; background-color: #f4f6f9; }");
            out.println("h2 { color: #333; }");
            out.println("table { width: 100%; border-collapse: collapse; margin-top: 15px; background: #fff; }");
            out.println("th, td { padding: 10px 12px; text-align: left; border: 1px solid #ddd; }");
            out.println("th { background-color: #007bff; color: white; }");
            out.println("tr:nth-child(even) { background-color: #f9f9f9; }");
            out.println(".status-ok { background-color: #28a745; color: white; padding: 4px 8px; border-radius: 4px; }");
            out.println(".status-low { background-color: #dc3545; color: white; padding: 4px 8px; border-radius: 4px; font-weight: bold; }");
            out.println(".btn { display: inline-block; padding: 8px 16px; background-color: #28a745; color: white; text-decoration: none; border-radius: 4px; margin-bottom: 15px; }");
            out.println("</style>");
            out.println("</head>");
            out.println("<body>");

            out.println("<h2>Hardware Inventory Stock Report</h2>");
            out.println("<a href='javascript:window.print()' class='btn'>Print / Export Report</a>");

            out.println("<table>");
            out.println("<thead>");
            out.println("<tr>");
            out.println("<th>ID</th>");
            out.println("<th>Item Name</th>");
            out.println("<th>Category</th>");
            out.println("<th>Brand / Model</th>");
            out.println("<th>Location</th>");
            out.println("<th>Quantity</th>");
            out.println("<th>Reorder Level</th>");
            out.println("<th>Supplier</th>");
            out.println("<th>Stock Status</th>");
            out.println("<th>Last Updated</th>");
            out.println("</tr>");
            out.println("</thead>");
            out.println("<tbody>");

            while (rs.next()) {
                int inventoryId = rs.getInt("inventory_id");
                String itemName = rs.getString("item_name");
                String category = rs.getString("category");
                String brandModel = rs.getString("brand") + " " + rs.getString("model_number");
                String location = rs.getString("location");
                int quantity = rs.getInt("quantity");
                int reorderLevel = rs.getInt("reorder_level");
                String supplierName = rs.getString("supplier_name");
                String lastUpdated = rs.getTimestamp("last_updated").toString();

                boolean isLowStock = quantity <= reorderLevel;

                out.println("<tr>");
                out.println("<td>" + inventoryId + "</td>");
                out.println("<td>" + itemName + "</td>");
                out.println("<td>" + category + "</td>");
                out.println("<td>" + brandModel + "</td>");
                out.println("<td>" + location + "</td>");
                out.println("<td><strong>" + quantity + "</strong></td>");
                out.println("<td>" + reorderLevel + "</td>");
                out.println("<td>" + supplierName + "</td>");

                if (isLowStock) {
                    out.println("<td><span class='status-low'>REORDER NEEDED</span></td>");
                } else {
                    out.println("<td><span class='status-ok'>IN STOCK</span></td>");
                }

                out.println("<td>" + lastUpdated + "</td>");
                out.println("</tr>");
            }

            out.println("</tbody>");
            out.println("</table>");
            out.println("</body>");
            out.println("</html>");

        } catch (SQLException e) {
            response.getWriter().println("<h3>Error loading stock report: " + e.getMessage() + "</h3>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Stock Report Generator Servlet";
    }
}