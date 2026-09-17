/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;
import java.sql.*;
import java.util.*;

import model.Stock;
import util.DBConnection;
/**
 *
 * @author Sajiv.v
 */
public class ItemDAO {
    
    public List<Stock> getAllItems() {

        List<Stock> itemList = new ArrayList<>();

        String sql = "SELECT item_id, item_name FROM items ORDER BY item_name";

        try {

            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(sql);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Stock stock = new Stock();

                stock.setItemId(rs.getInt("item_id"));
                stock.setItemName(rs.getString("item_name"));

                itemList.add(stock);
            }
            rs.close();
            ps.close();
            con.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return itemList;
    }
}
