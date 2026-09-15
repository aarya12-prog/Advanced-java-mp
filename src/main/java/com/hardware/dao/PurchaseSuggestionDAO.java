package com.hardware.dao;

import model.PurchaseSuggestion;
import com.hardware.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PurchaseSuggestionDAO {

    public List<PurchaseSuggestion> getPurchaseSuggestions() {

        List<PurchaseSuggestion> list = new ArrayList<>();

        String sql =
        "SELECT i.item_id,i.item_name,s.supplier_name,i.purchase_price," +
        "i.reorder_level,i.desired_stock_level," +

        "COALESCE(SUM(CASE " +
        "WHEN sm.movement_type IN ('IN','RETURN') THEN sm.quantity " +
        "WHEN sm.movement_type='OUT' THEN -sm.quantity " +
        "ELSE 0 END),0) AS current_stock," +

        "(i.desired_stock_level-COALESCE(SUM(CASE " +
        "WHEN sm.movement_type IN ('IN','RETURN') THEN sm.quantity " +
        "WHEN sm.movement_type='OUT' THEN -sm.quantity " +
        "ELSE 0 END),0)) AS suggested_quantity," +

        "((i.desired_stock_level-COALESCE(SUM(CASE " +
        "WHEN sm.movement_type IN ('IN','RETURN') THEN sm.quantity " +
        "WHEN sm.movement_type='OUT' THEN -sm.quantity " +
        "ELSE 0 END),0))*i.purchase_price) AS estimated_cost " +

        "FROM items i " +
        "LEFT JOIN stock_movements sm ON sm.item_id=i.item_id " +
        "JOIN suppliers s ON s.supplier_id=i.supplier_id " +

        "GROUP BY i.item_id,i.item_name,s.supplier_name," +
        "i.purchase_price,i.reorder_level,i.desired_stock_level " +

        "HAVING current_stock<i.reorder_level " +

        "ORDER BY current_stock ASC";

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery()
        ) {

            while (rs.next()) {

                PurchaseSuggestion p = new PurchaseSuggestion();

                p.setItemId(rs.getInt("item_id"));
                p.setItemName(rs.getString("item_name"));
                p.setSupplierName(rs.getString("supplier_name"));

                p.setCurrentStock(rs.getInt("current_stock"));
                p.setReorderLevel(rs.getInt("reorder_level"));
                p.setDesiredStockLevel(rs.getInt("desired_stock_level"));

                p.setSuggestedQuantity(rs.getInt("suggested_quantity"));

                p.setPurchasePrice(rs.getDouble("purchase_price"));
                p.setEstimatedCost(rs.getDouble("estimated_cost"));

                list.add(p);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}