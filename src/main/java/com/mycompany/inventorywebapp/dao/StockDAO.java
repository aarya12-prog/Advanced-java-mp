package com.mycompany.inventorywebapp.dao;

import com.mycompany.inventorywebapp.model.StockItem;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class StockDAO {
    private String jdbcURL = "jdbc:mysql://localhost:3306/hardware_inventory";
    private String jdbcUsername = "root";
    private String jdbcPassword = "root"; // Update if your MySQL password is different

    protected Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
        return DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
    }

    private String getBaseQuery() {
        return "SELECT i.item_id, i.item_name, i.category, i.brand, i.model_number, " +
               "s.supplier_name, inv.quantity, inv.location, inv.reorder_level, " +
               "inv.safety_stock, i.purchase_price, i.selling_price " +
               "FROM items i " +
               "JOIN inventory inv ON i.item_id = inv.item_id " +
               "JOIN suppliers s ON i.supplier_id = s.supplier_id ";
    }

    // Search Stock & Check Availability
    public List<StockItem> searchStock(String query) {
        List<StockItem> items = new ArrayList<>();
        String sql = getBaseQuery() + "WHERE i.item_name LIKE ? OR i.category LIKE ? OR i.brand LIKE ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, "%" + query + "%");
            stmt.setString(2, "%" + query + "%");
            stmt.setString(3, "%" + query + "%");
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                items.add(extractItem(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return items;
    }

    // Set Reorder Level
    public boolean updateReorderLevel(int itemId, int newReorderLevel) {
        String sql = "UPDATE inventory SET reorder_level = ? WHERE item_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, newReorderLevel);
            stmt.setInt(2, itemId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // View Low Stock Alerts (quantity <= reorder_level AND quantity > 0)
    public List<StockItem> getLowStockAlerts() {
        List<StockItem> items = new ArrayList<>();
        String sql = getBaseQuery() + "WHERE inv.quantity <= inv.reorder_level AND inv.quantity > 0";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                items.add(extractItem(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return items;
    }

    // View Out of Stock Alerts (quantity = 0)
    public List<StockItem> getOutOfStockAlerts() {
        List<StockItem> items = new ArrayList<>();
        String sql = getBaseQuery() + "WHERE inv.quantity = 0";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                items.add(extractItem(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return items;
    }

    // Get All Items for Reports and Default View
    public List<StockItem> getAllStock() {
        List<StockItem> items = new ArrayList<>();
        String sql = getBaseQuery();
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                items.add(extractItem(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return items;
    }

    private StockItem extractItem(ResultSet rs) throws SQLException {
        return new StockItem(
            rs.getInt("item_id"),
            rs.getString("item_name"),
            rs.getString("category"),
            rs.getString("brand"),
            rs.getString("model_number"),
            rs.getString("supplier_name"),
            rs.getInt("quantity"),
            rs.getString("location"),
            rs.getInt("reorder_level"),
            rs.getInt("safety_stock"),
            rs.getDouble("purchase_price"),
            rs.getDouble("selling_price")
        );
    }
}