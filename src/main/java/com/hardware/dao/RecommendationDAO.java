/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.hardware.dao;

import com.hardware.model.Item;
import com.hardware.model.RecommendationResult;
import com.hardware.model.Supplier;
import com.hardware.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

public class RecommendationDAO {

    /**
     * Search items by keyword, fetch current stock and supplier feedback.
     * Applies the ±10 rule: items with stock within 10 of the max are
     * sorted by feedback rating descending; others by stock descending.
     */
    public List<RecommendationResult> searchWithRecommendation(String keyword) {
        List<RecommendationResult> results = new ArrayList<>();

        // Query: join items, stock, suppliers, and average feedback
        String sql =
            "SELECT i.item_id, i.item_name, i.category, i.brand, i.model_number, " +
            "i.description, i.purchase_price, i.selling_price, " +
            "s.supplier_id, s.supplier_name, s.contact_person, s.phone, s.email, " +
            "COALESCE(st.current_quantity, 0) AS current_stock, " +
            "COALESCE(AVG(f.rating), 0) AS avg_rating, " +
            "COUNT(f.feedback_id) AS feedback_count " +
            "FROM items i " +
            "JOIN suppliers s ON i.supplier_id = s.supplier_id " +
            "LEFT JOIN stock st ON i.item_id = st.item_id " +
            "LEFT JOIN supplier_feedback f ON s.supplier_id = f.supplier_id " +
            "WHERE i.status = 'Active' AND i.item_name LIKE ? " +
            "GROUP BY i.item_id, s.supplier_id, st.current_quantity " +
            "HAVING current_stock > 0 " +
            "ORDER BY current_stock DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, "%" + keyword + "%");
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    RecommendationResult result = new RecommendationResult();

                    // Item
                    Item item = new Item();
                    item.setItemId(rs.getInt("item_id"));
                    item.setItemName(rs.getString("item_name"));
                    item.setCategory(rs.getString("category"));
                    item.setBrand(rs.getString("brand"));
                    item.setModelNumber(rs.getString("model_number"));
                    item.setDescription(rs.getString("description"));
                    item.setPurchasePrice(rs.getBigDecimal("purchase_price"));
                    item.setSellingPrice(rs.getBigDecimal("selling_price"));
                    result.setItem(item);

                    // Supplier
                    Supplier supplier = new Supplier();
                    supplier.setSupplierId(rs.getInt("supplier_id"));
                    supplier.setSupplierName(rs.getString("supplier_name"));
                    supplier.setContactPerson(rs.getString("contact_person"));
                    supplier.setPhone(rs.getString("phone"));
                    supplier.setEmail(rs.getString("email"));
                    result.setSupplier(supplier);

                    // Stock and feedback
                    result.setCurrentStock(rs.getInt("current_stock"));
                    result.setAverageRating(rs.getDouble("avg_rating"));
                    result.setFeedbackCount(rs.getInt("feedback_count"));

                    results.add(result);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // --- Apply ±10 rule ---
        if (results.size() > 1) {
            int maxStock = results.stream()
                    .mapToInt(RecommendationResult::getCurrentStock)
                    .max()
                    .orElse(0);

            List<RecommendationResult> nearMax = new ArrayList<>();
            List<RecommendationResult> others = new ArrayList<>();

            for (RecommendationResult r : results) {
                if (r.getCurrentStock() >= maxStock - 10) {
                    nearMax.add(r);
                } else {
                    others.add(r);
                }
            }

            // Sort nearMax by average rating (descending), then by stock (descending) as tiebreaker
            nearMax.sort(Comparator
                    .comparingDouble(RecommendationResult::getAverageRating).reversed()
                    .thenComparingInt(RecommendationResult::getCurrentStock).reversed());

            // Sort others by stock descending
            others.sort(Comparator.comparingInt(RecommendationResult::getCurrentStock).reversed());

            // Combine: nearMax first, then others
            List<RecommendationResult> sorted = new ArrayList<>();
            sorted.addAll(nearMax);
            sorted.addAll(others);
            results = sorted;
        }

        return results;
    }
}
