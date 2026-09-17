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

@WebServlet("/products")
public class InventoryServlet extends HttpServlet {

    // 1. DISPLAY INVENTORY & FORM (GET Request)
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");

        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html><html><head><title>Inventory Control</title></head><body>");
            out.println("<h2>Inventory Management System</h2>");

            // Web Form to Add New Product
            out.println("<h3>Add New Item</h3>");
            out.println("<form action='products' method='POST'>");
            out.println("  ID: <input type='text' name='id' required> ");
            out.println("  Name: <input type='text' name='name' required> ");
            out.println("  Qty: <input type='number' name='quantity' required> ");
            out.println("  Price ($): <input type='number' step='0.01' name='price' required> ");
            out.println("  <input type='submit' value='Add Item'>");
            out.println("</form><br><hr><br>");

            // Table Displaying MySQL Stock Items
            out.println("<h3>Current Inventory</h3>");
            out.println("<table border='1' cellpadding='8' cellspacing='0'>");
            out.println("<tr bgcolor='#f2f2f2'><th>ID</th><th>Name</th><th>Quantity</th><th>Price ($)</th></tr>");

            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement stmt = conn.prepareStatement("SELECT * FROM products");
                 ResultSet rs = stmt.executeQuery()) {

                while (rs.next()) {
                    out.println("<tr>");
                    out.println("<td>" + rs.getString("id") + "</td>");
                    out.println("<td>" + rs.getString("name") + "</td>");
                    out.println("<td>" + rs.getInt("quantity") + "</td>");
                    out.println("<td>$" + String.format("%.2f", rs.getDouble("price")) + "</td>");
                    out.println("</tr>");
                }

            } catch (SQLException e) {
                out.println("<tr><td colspan='4'>Database Error: " + e.getMessage() + "</td></tr>");
            }

            out.println("</table></body></html>");
        }
    }

    // 2. INSERT NEW PRODUCT INTO MYSQL (POST Request)
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String id = request.getParameter("id");
        String name = request.getParameter("name");
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        double price = Double.parseDouble(request.getParameter("price"));

        String sql = "INSERT INTO products (id, name, quantity, price) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, id);
            stmt.setString(2, name);
            stmt.setInt(3, quantity);
            stmt.setDouble(4, price);
            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }

        // Refresh page to view updated table
        response.sendRedirect("products");
    }
}