package com.inventory.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.inventory.model.Reorder;
import com.inventory.util.DBconnection;


public class ReorderDAO {


    public boolean addReorder(int itemId, int quantity) {

        boolean result = false;


        try(Connection con = DBconnection.getConnection()) {


            String sql =
            "INSERT INTO reorder_history(item_id, quantity) VALUES(?, ?)";


            PreparedStatement ps =
                    con.prepareStatement(sql);


            ps.setInt(1, itemId);

            ps.setInt(2, quantity);



            int row = ps.executeUpdate();



            if(row > 0) {

                result = true;

            }


        }
        catch(Exception e) {

            e.printStackTrace();

        }


        return result;

    }




    public List<Reorder> getAllReorders() {


        List<Reorder> list = new ArrayList<>();



        try(Connection con = DBconnection.getConnection()) {


            String sql =
            "SELECT r.*, i.item_name " +
            "FROM reorder_history r " +
            "JOIN items i " +
            "ON r.item_id = i.item_id " +
            "ORDER BY r.reorder_date DESC";



            PreparedStatement ps =
                    con.prepareStatement(sql);



            ResultSet rs =
                    ps.executeQuery();




            while(rs.next()) {


                Reorder r = new Reorder();



                r.setReorderId(
                        rs.getInt("reorder_id")
                );


                r.setItemId(
                        rs.getInt("item_id")
                );


                r.setItemName(
                        rs.getString("item_name")
                );


                r.setQuantity(
                        rs.getInt("quantity")
                );


                r.setReorderDate(
                        rs.getTimestamp("reorder_date")
                );


                r.setStatus(
                        rs.getString("status")
                );



                list.add(r);


            }



        }
        catch(Exception e) {

            e.printStackTrace();

        }



        return list;


    }


}