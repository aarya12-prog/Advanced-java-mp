/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.inventory.dao;

import java.util.ArrayList;
import java.util.List;
import java.sql.*;
import java.sql.SQLException;


import com.inventory.model.inventory;
import com.inventory.util.DBconnection;

public class InventoryDAO {

    public List<inventory> getLowStockItems() {

        List<inventory> list = new ArrayList<>();

        try {

            Connection con = DBconnection.getConnection();

            String sql = 
            "SELECT * FROM inventory WHERE quantity <= safety_stock";

            PreparedStatement ps = con.prepareStatement(sql);

            ResultSet rs = ps.executeQuery();


            while(rs.next()) {
                item.setItem_name(rs.getString("item_name"));

    inventory item = new inventory();

    item.setInventoryId(rs.getInt("inventory_id"));
    item.setItemId(rs.getInt("item_id"));
    item.setQuantity(rs.getInt("quantity"));
    item.setSafetyStock(rs.getInt("safety_stock"));
    item.setReorderLevel(rs.getInt("reorder_level"));

    list.add(item);
}

        } catch(SQLException e) {

            e.printStackTrace();
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        

        return list;
    }
}