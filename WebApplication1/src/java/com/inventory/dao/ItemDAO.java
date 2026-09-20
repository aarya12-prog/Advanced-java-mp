/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.inventory.dao;

import com.inventory.config.DatabaseConfig;
import com.inventory.model.Item;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ItemDAO {
    
    public boolean addItem(Item item) throws SQLException {
        String sql = "INSERT INTO items (item_name, category, brand, model_number, description, supplier_id, purchase_price, selling_price, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, item.getItemName());
            pstmt.setString(2, item.getCategory());
            pstmt.setString(3, item.getBrand());
            pstmt.setString(4, item.getModelNumber());
            pstmt.setString(5, item.getDescription());
            pstmt.setInt(6, item.getSupplierId());
            pstmt.setBigDecimal(7, item.getPurchasePrice());
            pstmt.setBigDecimal(8, item.getSellingPrice());
            pstmt.setString(9, item.getStatus());
            
            return pstmt.executeUpdate() > 0;
        }
    }
    
    public List<Item> getAllItems() throws SQLException {
        List<Item> items = new ArrayList<>();
        String sql = "SELECT * FROM items";
        
        try (Connection conn = DatabaseConfig.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Item item = new Item();
                item.setItemId(rs.getInt("item_id"));
                item.setItemName(rs.getString("item_name"));
                item.setCategory(rs.getString("category"));
                item.setBrand(rs.getString("brand"));
                item.setModelNumber(rs.getString("model_number"));
                item.setDescription(rs.getString("description"));
                item.setSupplierId(rs.getInt("supplier_id"));
                item.setPurchasePrice(rs.getBigDecimal("purchase_price"));
                item.setSellingPrice(rs.getBigDecimal("selling_price"));
                item.setStatus(rs.getString("status"));
                item.setCreatedAt(rs.getTimestamp("created_at"));
                item.setUpdatedAt(rs.getTimestamp("updated_at"));
                items.add(item);
            }
        }
        return items;
    }
}