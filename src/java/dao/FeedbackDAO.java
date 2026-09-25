/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import model.SupplierFeedback;
import util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
/**
 *
 * @author mruna
 */
public class FeedbackDAO {
    // Submit new feedback
    public boolean submitFeedback(SupplierFeedback feedback) {
        String sql = "INSERT INTO supplier_feedback (supplier_id, item_id, purchase_order_id, rating, comments) " +
                     "VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, feedback.getSupplierId());
            
            if (feedback.getItemId() > 0) {
                pstmt.setInt(2, feedback.getItemId());
            } else {
                pstmt.setNull(2, Types.INTEGER);
            }
            
            if (feedback.getPurchaseOrderId() > 0) {
                pstmt.setInt(3, feedback.getPurchaseOrderId());
            } else {
                pstmt.setNull(3, Types.INTEGER);
            }
            
            pstmt.setInt(4, feedback.getRating());
            pstmt.setString(5, feedback.getComments());
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Get average rating for a supplier
    public double getAverageRating(int supplierId) {
        String sql = "SELECT ROUND(AVG(rating), 1) as avg_rating FROM supplier_feedback WHERE supplier_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, supplierId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getDouble("avg_rating");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    public List<SupplierFeedback> getAllFeedback() {
        List<SupplierFeedback> feedbackList = new ArrayList<>();
        String sql = "SELECT sf.*, s.supplier_name, i.item_name "
                + "FROM supplier_feedback sf "
                + "JOIN suppliers s ON sf.supplier_id = s.supplier_id "
                + "LEFT JOIN items i ON sf.item_id = i.item_id "
                + "ORDER BY sf.feedback_date DESC LIMIT 50";

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                SupplierFeedback feedback = new SupplierFeedback();
                feedback.setFeedbackId(rs.getInt("feedback_id"));
                feedback.setSupplierId(rs.getInt("supplier_id"));
                feedback.setSupplierName(rs.getString("supplier_name"));
                feedback.setItemId(rs.getInt("item_id"));
                feedback.setItemName(rs.getString("item_name"));
                feedback.setPurchaseOrderId(rs.getInt("purchase_order_id"));
                feedback.setRating(rs.getInt("rating"));
                feedback.setComments(rs.getString("comments"));
                feedback.setFeedbackDate(rs.getTimestamp("feedback_date"));
                feedbackList.add(feedback);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return feedbackList;
    }
}
