/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.inventory.dao;

import com.inventory.config.DatabaseConfig;
import com.inventory.model.Inventory;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class InventoryDAO {
    
    public Inventory getInventoryByItemId(int itemId) throws SQLException {
        String sql = "SELECT * FROM inventory WHERE item_id = ?";
        
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, itemId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                Inventory inventory = new Inventory();
                inventory.setInventoryId(rs.getInt("inventory_id"));
                inventory.setItemId(rs.getInt("item_id"));
                inventory.setQuantity(rs.getInt("quantity"));
                inventory.setLocation(rs.getString("location"));
                inventory.setReorderLevel(rs.getInt("reorder_level"));
                inventory.setSafetyStock(rs.getInt("safety_stock"));
                inventory.setLastUpdated(rs.getTimestamp("last_updated"));
                return inventory;
            }
        }
        return null;
    }
    
    public boolean updateInventoryQuantity(int itemId, int newQuantity) throws SQLException {
        String sql = "UPDATE inventory SET quantity = ? WHERE item_id = ?";
        
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, newQuantity);
            pstmt.setInt(2, itemId);
            return pstmt.executeUpdate() > 0;
        }
    }
}
