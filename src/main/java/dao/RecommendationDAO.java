package dao;

import model.Item;
import model.Supplier;
import model.RecommendationResult;
import util.DBConnection;

import java.sql.*;
import java.util.*;

public class RecommendationDAO {

    public List<RecommendationResult> searchWithRecommendation(String keyword) {
        List<RecommendationResult> results = new ArrayList<>();

        String sql =
            "SELECT i.item_id, i.item_name, i.category, i.purchase_price, " +
            "s.supplier_id, s.supplier_name, s.contact_person, s.phone, s.email, " +
            "COALESCE(inv.quantity, 0) AS current_stock, " +
            "COALESCE(AVG(f.rating), 0) AS avg_rating, " +
            "COUNT(f.feedback_id) AS feedback_count " +
            "FROM items i " +
            "JOIN suppliers s ON i.supplier_id = s.supplier_id " +
            "LEFT JOIN inventory inv ON i.item_id = inv.item_id " +
            "LEFT JOIN supplier_feedback f ON s.supplier_id = f.supplier_id " +
            "WHERE i.status = 'Active' AND i.item_name LIKE ? " +
            "GROUP BY i.item_id, i.item_name, i.category, i.purchase_price, " +
            "s.supplier_id, s.supplier_name, s.contact_person, s.phone, s.email, inv.quantity " +
            "HAVING current_stock > 0 " +
            "ORDER BY current_stock DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, "%" + keyword + "%");

            try (ResultSet rs = stmt.executeQuery()) {

                while (rs.next()) {

                    Item item = new Item();
                    item.setItemId(rs.getInt("item_id"));
                    item.setItemName(rs.getString("item_name"));
                    item.setCategory(rs.getString("category"));
                    item.setPurchasePrice(rs.getBigDecimal("purchase_price"));

                    Supplier supplier = new Supplier();
                    supplier.setSupplierId(rs.getInt("supplier_id"));
                    supplier.setSupplierName(rs.getString("supplier_name"));
                    supplier.setContactPerson(rs.getString("contact_person"));
                    supplier.setPhone(rs.getString("phone"));
                    supplier.setEmail(rs.getString("email"));

                    RecommendationResult result = new RecommendationResult();
                    result.setItem(item);
                    result.setSupplier(supplier);
                    result.setCurrentStock(rs.getInt("current_stock"));
                    result.setAverageRating(rs.getDouble("avg_rating"));
                    result.setFeedbackCount(rs.getInt("feedback_count"));

                    results.add(result);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        results.sort(
            Comparator.comparingDouble(
                RecommendationResult::getAverageRating
            ).reversed()
            .thenComparingInt(
                RecommendationResult::getCurrentStock
            ).reversed()
        );

        return results;
    }
}