package com.inventory.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.inventory.model.inventory;
import com.inventory.util.DBconnection;

public class InventoryDAO {

    public List<inventory> getLowStockItems() {
        System.out.println("DAO METHOD CALLED");

        List<inventory> list = new ArrayList<>();
        

        String sql = "SELECT inventory.*, items.item_name "
                   + "FROM inventory "
                   + "JOIN items ON inventory.item_id = items.item_id "
                   + "WHERE inventory.quantity <= inventory.reorder_level";

        try (Connection con = DBconnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                inventory item = new inventory();

                item.setInventoryId(rs.getInt("inventory_id"));
                item.setItemId(rs.getInt("item_id"));
                item.setItemName(rs.getString("item_name"));
                item.setQuantity(rs.getInt("quantity"));
                item.setSafetyStock(rs.getInt("safety_stock"));
                item.setReorderLevel(rs.getInt("reorder_level"));

                list.add(item);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        System.out.println("Low Stock Items Found: " + list.size());

        for (inventory i : list) {
            System.out.println(i.getItemName() + " - " + i.getQuantity());
        }

        return list;
    }
}