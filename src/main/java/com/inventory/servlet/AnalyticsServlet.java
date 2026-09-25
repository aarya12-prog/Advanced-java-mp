/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.inventory.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/AnalyticsServlet")
public class AnalyticsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // =========================================================
    // DATABASE CONFIGURATION
    // =========================================================

    private static final String DB_URL = "jdbc:mysql://localhost:3306/hardware_inventory";

    private static final String DB_USER = "root";

    private static final String DB_PASSWORD = "root";

    // =========================================================
    // DATABASE CONNECTION
    // =========================================================

    private Connection getConnection() throws Exception {

        Class.forName("com.mysql.cj.jdbc.Driver");

        return DriverManager.getConnection(
                DB_URL,
                DB_USER,
                DB_PASSWORD
        );
    }

    // =========================================================
    // GET
    // =========================================================

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        Connection con = null;

        try {

            con = getConnection();

            // -------------------------------------------------
            // 1. TOTAL PRODUCTS
            // -------------------------------------------------

            int totalProducts = 0;

            String sqlTotalProducts =
                    "SELECT COUNT(*) FROM items WHERE status = 'Active'";

            try (PreparedStatement ps =
                         con.prepareStatement(sqlTotalProducts);
                 ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    totalProducts = rs.getInt(1);
                }
            }

            // -------------------------------------------------
            // 2. TOTAL STOCK
            // -------------------------------------------------

            int totalStock = 0;

            String sqlTotalStock =
                    "SELECT COALESCE(SUM(i.quantity), 0) " +
                    "FROM inventory i " +
                    "JOIN items it ON i.item_id = it.item_id " +
                    "WHERE it.status = 'Active'";

            try (PreparedStatement ps =
                         con.prepareStatement(sqlTotalStock);
                 ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    totalStock = rs.getInt(1);
                }
            }

            // -------------------------------------------------
            // 3. LOW STOCK PRODUCTS
            // -------------------------------------------------
            // quantity <= safety_stock
            // -------------------------------------------------

            int lowStockProducts = 0;

            String sqlLowStock =
                    "SELECT COUNT(*) " +
                    "FROM inventory i " +
                    "JOIN items it ON i.item_id = it.item_id " +
                    "WHERE it.status = 'Active' " +
                    "AND i.quantity <= i.safety_stock";

            try (PreparedStatement ps =
                         con.prepareStatement(sqlLowStock);
                 ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    lowStockProducts = rs.getInt(1);
                }
            }

            // -------------------------------------------------
            // 4. CRITICAL STOCK PRODUCTS
            // -------------------------------------------------
            // quantity <= 2
            // -------------------------------------------------

            int criticalStockProducts = 0;

            String sqlCriticalStock =
                    "SELECT COUNT(*) " +
                    "FROM inventory i " +
                    "JOIN items it ON i.item_id = it.item_id " +
                    "WHERE it.status = 'Active' " +
                    "AND i.quantity <= 2";

            try (PreparedStatement ps =
                         con.prepareStatement(sqlCriticalStock);
                 ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    criticalStockProducts = rs.getInt(1);
                }
            }

            // -------------------------------------------------
            // 5. INVENTORY VALUE
            // -------------------------------------------------
            // quantity × purchase price
            // -------------------------------------------------

            double inventoryValue = 0;

            String sqlInventoryValue =
                    "SELECT COALESCE(SUM(i.quantity * it.purchase_price), 0) " +
                    "FROM inventory i " +
                    "JOIN items it ON i.item_id = it.item_id " +
                    "WHERE it.status = 'Active'";

            try (PreparedStatement ps =
                         con.prepareStatement(sqlInventoryValue);
                 ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    inventoryValue = rs.getDouble(1);
                }
            }

            // -------------------------------------------------
            // 6. STOCK STATUS COUNTS
            // -------------------------------------------------

            int healthyStock = 0;
            int lowStock = 0;
            int criticalStock = 0;

            String sqlStockStatus =
                    "SELECT " +
                    "SUM(CASE WHEN i.quantity <= 2 THEN 1 ELSE 0 END) AS critical_stock, " +
                    "SUM(CASE WHEN i.quantity > 2 AND i.quantity <= i.safety_stock THEN 1 ELSE 0 END) AS low_stock, " +
                    "SUM(CASE WHEN i.quantity > i.safety_stock THEN 1 ELSE 0 END) AS healthy_stock " +
                    "FROM inventory i " +
                    "JOIN items it ON i.item_id = it.item_id " +
                    "WHERE it.status = 'Active'";

            try (PreparedStatement ps =
                         con.prepareStatement(sqlStockStatus);
                 ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    criticalStock = rs.getInt("critical_stock");

                    lowStock = rs.getInt("low_stock");

                    healthyStock = rs.getInt("healthy_stock");
                }
            }

            // -------------------------------------------------
            // 7. CATEGORY-WISE STOCK
            // -------------------------------------------------

            List<Map<String, Object>> categoryList =
                    new ArrayList<>();

            String sqlCategory =
                    "SELECT it.category, " +
                    "COUNT(it.item_id) AS product_count, " +
                    "COALESCE(SUM(i.quantity), 0) AS stock_count " +
                    "FROM items it " +
                    "LEFT JOIN inventory i ON it.item_id = i.item_id " +
                    "WHERE it.status = 'Active' " +
                    "GROUP BY it.category " +
                    "ORDER BY stock_count DESC";

            try (PreparedStatement ps =
                         con.prepareStatement(sqlCategory);
                 ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    Map<String, Object> row =
                            new HashMap<>();

                    row.put(
                            "category",
                            rs.getString("category")
                    );

                    row.put(
                            "productCount",
                            rs.getInt("product_count")
                    );

                    row.put(
                            "stockCount",
                            rs.getInt("stock_count")
                    );

                    categoryList.add(row);
                }
            }

            // -------------------------------------------------
            // 8. LOW / CRITICAL PRODUCTS
            // -------------------------------------------------

            List<Map<String, Object>> alertList =
                    new ArrayList<>();

            String sqlAlerts =
                    "SELECT it.item_id, " +
                    "it.item_name, " +
                    "it.category, " +
                    "i.quantity, " +
                    "i.safety_stock, " +
                    "i.reorder_level " +
                    "FROM inventory i " +
                    "JOIN items it ON i.item_id = it.item_id " +
                    "WHERE it.status = 'Active' " +
                    "AND i.quantity <= i.safety_stock " +
                    "ORDER BY i.quantity ASC, it.item_name ASC";

            try (PreparedStatement ps =
                         con.prepareStatement(sqlAlerts);
                 ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    Map<String, Object> row =
                            new HashMap<>();

                    int quantity =
                            rs.getInt("quantity");

                    row.put(
                            "itemId",
                            rs.getInt("item_id")
                    );

                    row.put(
                            "itemName",
                            rs.getString("item_name")
                    );

                    row.put(
                            "category",
                            rs.getString("category")
                    );

                    row.put(
                            "quantity",
                            quantity
                    );

                    row.put(
                            "safetyStock",
                            rs.getInt("safety_stock")
                    );

                    row.put(
                            "reorderLevel",
                            rs.getInt("reorder_level")
                    );

                    if (quantity <= 2) {

                        row.put("status", "Critical");

                    } else {

                        row.put("status", "Low Stock");
                    }

                    alertList.add(row);
                }
            }

            // -------------------------------------------------
            // SEND DATA TO JSP
            // -------------------------------------------------

            request.setAttribute(
                    "totalProducts",
                    totalProducts
            );

            request.setAttribute(
                    "totalStock",
                    totalStock
            );

            request.setAttribute(
                    "lowStockProducts",
                    lowStockProducts
            );

            request.setAttribute(
                    "criticalStockProducts",
                    criticalStockProducts
            );

            request.setAttribute(
                    "inventoryValue",
                    inventoryValue
            );

            request.setAttribute(
                    "healthyStock",
                    healthyStock
            );

            request.setAttribute(
                    "lowStock",
                    lowStock
            );

            request.setAttribute(
                    "criticalStock",
                    criticalStock
            );

            request.setAttribute(
                    "categoryList",
                    categoryList
            );

            request.setAttribute(
                    "alertList",
                    alertList
            );

            request.getRequestDispatcher(
                    "analytics.jsp"
            ).forward(request, response);

        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute(
                    "errorMessage",
                    e.getMessage()
            );

            request.getRequestDispatcher(
                    "analytics.jsp"
            ).forward(request, response);

        } finally {

            try {

                if (con != null) {
                    con.close();
                }

            } catch (Exception e) {

                e.printStackTrace();
            }
        }
    }

    // =========================================================
    // POST
    // =========================================================

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        doGet(request, response);
    }
}