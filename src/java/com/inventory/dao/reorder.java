/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.inventory.dao;

import com.inventory.model.inventory;
import com.inventory.util.DBconnection;

import java.util.List;
import java.util.ArrayList;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;


public class reorder {

    public List<inventory> getReorderItems() throws SQLException {

        List<inventory> list = new ArrayList<>();

        String sql =
            "SELECT i.item_id, i.item_name, i.category, i.brand, " +
            "COALESCE(SUM(CASE " +
            "WHEN sm.movement_type IN ('IN','RETURN') THEN sm.quantity " +
            "WHEN sm.movement_type='OUT' THEN -sm.quantity " +
            "ELSE 0 END),0) AS current_stock " +
            "FROM items i " +
            "LEFT JOIN stock_movements sm " +
            "ON i.item_id = sm.item_id " +
            "GROUP BY i.item_id " +
            "HAVING SUM(CASE " +
            "WHEN sm.movement_type IN ('IN','RETURN') THEN sm.quantity " +
            "WHEN sm.movement_type='OUT' THEN -sm.quantity " +
            "ELSE 0 END) <= 10";


        Connection con = DBconnection.getConnection();

        PreparedStatement ps = con.prepareStatement(sql);

        ResultSet rs = ps.executeQuery();


        while(rs.next()) {

            inventory item = new inventory();

            item.setItem_id(rs.getInt("item_id"));
            item.setItem_name(rs.getString("item_name"));
            item.setCategory(rs.getString("category"));
            item.setBrand(rs.getString("brand"));

            item.setQuantity(rs.getInt("current_stock"));

            list.add(item);
        }

        return list;
    }
}