// src/main/java/com/hardware/dao/SupplierDAO.java
package com.hardware.dao;

import com.hardware.model.SupplierFeedback;
import com.hardware.util.DBConnection;
import java.sql.*;
import java.util.*;

public class SupplierDAO {
    
    // Get all active suppliers
    public Map<Integer, String> getAllSuppliers() {
        Map<Integer, String> suppliers = new LinkedHashMap<>();
        String sql = "SELECT supplier_id, supplier_name FROM suppliers WHERE status = 'Active' ORDER BY supplier_name";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                suppliers.put(rs.getInt("supplier_id"), rs.getString("supplier_name"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return suppliers;
    }
    
    // Get items for a specific supplier
    public Map<Integer, String> getItemsBySupplier(int supplierId) {
        Map<Integer, String> items = new LinkedHashMap<>();
        String sql = "SELECT item_id, item_name FROM items WHERE supplier_id = ? AND status = 'Active' ORDER BY item_name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, supplierId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                items.put(rs.getInt("item_id"), rs.getString("item_name"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return items;
    }
    
    // Get purchase orders for a supplier
    public Map<Integer, String> getPurchaseOrdersBySupplier(int supplierId) {
        Map<Integer, String> orders = new LinkedHashMap<>();
        String sql = "SELECT po.purchase_order_id, " +
                     "CONCAT('PO #', po.purchase_order_id, ' - ', i.item_name, ' (', po.order_status, ')') as order_info " +
                     "FROM purchase_orders po " +
                     "JOIN items i ON po.item_id = i.item_id " +
                     "WHERE po.supplier_id = ? " +
                     "ORDER BY po.order_date DESC LIMIT 10";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, supplierId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                orders.put(rs.getInt("purchase_order_id"), rs.getString("order_info"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }
    
    // Get supplier rating statistics
    public Map<String, Object> getSupplierStats(int supplierId) {
        Map<String, Object> stats = new HashMap<>();
        String sql = "SELECT COUNT(*) as total_feedback, " +
                     "ROUND(AVG(rating), 1) as avg_rating " +
                     "FROM supplier_feedback WHERE supplier_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, supplierId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                stats.put("totalFeedback", rs.getInt("total_feedback"));
                stats.put("avgRating", rs.getDouble("avg_rating"));
            } else {
                stats.put("totalFeedback", 0);
                stats.put("avgRating", 0.0);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stats;
    }
    
}
