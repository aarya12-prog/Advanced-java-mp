package com.hardware.dao;

import com.hardware.model.SearchFilter;
import com.hardware.model.SearchResult;
import com.hardware.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SearchDAO {
    
    public List<String> getAllCategories() {
        List<String> categories = new ArrayList<>();
        String sql = "SELECT DISTINCT category FROM items ORDER BY category";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                categories.add(rs.getString("category"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return categories;
    }
    
    public List<String> getAllBrands() {
        List<String> brands = new ArrayList<>();
        String sql = "SELECT DISTINCT brand FROM items WHERE brand IS NOT NULL ORDER BY brand";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                brands.add(rs.getString("brand"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return brands;
    }
    
    public List<SearchResult> searchItems(SearchFilter filter) {
        List<SearchResult> results = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        List<Object> params = new ArrayList<>();
        
        sql.append("SELECT i.item_id, i.item_name, i.category, i.brand, ");
        sql.append("i.model_number, i.description, s.supplier_name, ");
        sql.append("i.purchase_price, i.selling_price, i.status, ");
        sql.append("COALESCE(inv.quantity, 0) as quantity, ");
        sql.append("COALESCE(inv.location, 'N/A') as location, ");
        sql.append("COALESCE(inv.reorder_level, 0) as reorder_level ");
        sql.append("FROM items i ");
        sql.append("JOIN suppliers s ON i.supplier_id = s.supplier_id ");
        sql.append("LEFT JOIN inventory inv ON i.item_id = inv.item_id ");
        sql.append("WHERE 1=1 ");
        
        if (filter.getCategory() != null && !filter.getCategory().equals("All")) {
            sql.append("AND i.category = ? ");
            params.add(filter.getCategory());
        }
        
        if (filter.getBrand() != null && !filter.getBrand().equals("All")) {
            sql.append("AND i.brand = ? ");
            params.add(filter.getBrand());
        }
        
        if (filter.getMinPrice() != null) {
            sql.append("AND i.selling_price >= ? ");
            params.add(filter.getMinPrice());
        }
        
        if (filter.getMaxPrice() != null) {
            sql.append("AND i.selling_price <= ? ");
            params.add(filter.getMaxPrice());
        }
        
        if (filter.getStockStatus() != null && !filter.getStockStatus().equals("All")) {
            if (filter.getStockStatus().equals("In Stock")) {
                sql.append("AND COALESCE(inv.quantity, 0) > COALESCE(inv.reorder_level, 0) ");
            } else if (filter.getStockStatus().equals("Low Stock")) {
                sql.append("AND COALESCE(inv.quantity, 0) > 0 AND COALESCE(inv.quantity, 0) <= COALESCE(inv.reorder_level, 0) ");
            } else if (filter.getStockStatus().equals("Out of Stock")) {
                sql.append("AND COALESCE(inv.quantity, 0) = 0 ");
            }
        }
        
        if (filter.getItemStatus() != null && !filter.getItemStatus().equals("All")) {
            sql.append("AND i.status = ? ");
            params.add(filter.getItemStatus());
        }
        
        if (filter.getKeyword() != null && !filter.getKeyword().trim().isEmpty()) {
            sql.append("AND (i.item_name LIKE ? OR i.model_number LIKE ? OR i.description LIKE ? OR s.supplier_name LIKE ?) ");
            String keyword = "%" + filter.getKeyword().trim() + "%";
            params.add(keyword);
            params.add(keyword);
            params.add(keyword);
            params.add(keyword);
        }
        
        if (filter.getSortBy() != null) {
            if (filter.getSortBy().equals("price_low")) {
                sql.append("ORDER BY i.selling_price ASC");
            } else if (filter.getSortBy().equals("price_high")) {
                sql.append("ORDER BY i.selling_price DESC");
            } else if (filter.getSortBy().equals("quantity")) {
                sql.append("ORDER BY quantity DESC");
            } else {
                sql.append("ORDER BY i.item_name ASC");
            }
        } else {
            sql.append("ORDER BY i.item_name ASC");
        }
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {
            
            for (int i = 0; i < params.size(); i++) {
                pstmt.setObject(i + 1, params.get(i));
            }
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    SearchResult item = new SearchResult();
                    item.setItemId(rs.getInt("item_id"));
                    item.setItemName(rs.getString("item_name"));
                    item.setCategory(rs.getString("category"));
                    item.setBrand(rs.getString("brand"));
                    item.setModelNumber(rs.getString("model_number"));
                    item.setDescription(rs.getString("description"));
                    item.setSupplierName(rs.getString("supplier_name"));
                    item.setPurchasePrice(rs.getBigDecimal("purchase_price"));
                    item.setSellingPrice(rs.getBigDecimal("selling_price"));
                    item.setStatus(rs.getString("status"));
                    item.setQuantity(rs.getInt("quantity"));
                    item.setLocation(rs.getString("location"));
                    item.setReorderLevel(rs.getInt("reorder_level"));
                    
                    results.add(item);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return results;
    }
}