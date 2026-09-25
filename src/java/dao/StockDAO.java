/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;
import java.sql.*;
import java.util.*;

import model.Stock;
import model.StockMovement;
import util.DBConnection;

/**
 *
 * @author Sajiv.v
 */
public class StockDAO {
    public StockDAO(){
        
    }
    
    public boolean addStock(int itemId, int quantity, String referenceNote){
        Connection con = null;
        PreparedStatement psInventory = null;
        PreparedStatement psMovement = null;
        
        try{
            con = DBConnection.getConnection();
            con.setAutoCommit(false);
            
            String UpdateInventory = "UPDATE iventory SET quantity = quantity + ? WHERE item_id = ?";
            psInventory = con.prepareStatement(UpdateInventory);
            psInventory.setInt(1, quantity);
            psInventory.setInt(2, itemId);
            
            int invent_updated = psInventory.executeUpdate();
            
            String insertMovement = "INSERT INTO stock_movements (item_id, movement_type, quantity, reference_note) " + "VALUES (?, 'IN', ?, ?)";

            psMovement = con.prepareStatement(insertMovement);

            psMovement.setInt(1, itemId);
            psMovement.setInt(2, quantity);
            psMovement.setString(3, referenceNote);

            int move_inserted = psMovement.executeUpdate();
            
            if(invent_updated > 0 && move_inserted > 0){
                con.commit();
                return true;
            }
            else{
                con.rollback();
                return false;
            }
        }
        catch (SQLException e){
            try {
                if(con != null){
                    con.rollback();
                }
            }
            catch (SQLException ex){
                ex.printStackTrace();
            }
            
            e.printStackTrace();
            return false;
        }
        
        finally{
            try {

            if (psInventory != null)
                psInventory.close();

            if (psMovement != null)
                psMovement.close();

            if (con != null)
                con.close();

            } 
            catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    
    public boolean reduceStock(int itemId, int quantity, String referenceNote) {

        Connection con = null;
        PreparedStatement psInventory = null;
        PreparedStatement psMovement = null;

        try {

            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            String updateInventory = "UPDATE inventory SET quantity = quantity - ? WHERE item_id = ?";

            psInventory = con.prepareStatement(updateInventory);

            psInventory.setInt(1, quantity);
            psInventory.setInt(2, itemId);

            int inventoryUpdated = psInventory.executeUpdate();

            String insertMovement = "INSERT INTO stock_movements (item_id, movement_type, quantity, reference_note) " + "VALUES (?, 'OUT', ?, ?)";

            psMovement = con.prepareStatement(insertMovement);

            psMovement.setInt(1, itemId);
            psMovement.setInt(2, quantity);
            psMovement.setString(3, referenceNote);

            int movementInserted = psMovement.executeUpdate();

            if (inventoryUpdated > 0 && movementInserted > 0) {

                con.commit();
                return true;

            } else {

                con.rollback();
                return false;

            }

        } catch (SQLException e) {

            try {
                if (con != null)
                    con.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }

            e.printStackTrace();
            return false;

        } finally {

            try {

                if (psInventory != null)
                    psInventory.close();

                if (psMovement != null)
                    psMovement.close();

                if (con != null)
                    con.close();

            } catch (SQLException e) {
                e.printStackTrace();
            }

        }

    }
    
    
    public boolean updateStock(int itemId, int newQuantity, String referenceNote) {

        Connection con = null;
        PreparedStatement psInventory = null;
        PreparedStatement psMovement = null;

        try {

            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            String updateInventory = "UPDATE inventory SET quantity = ? WHERE item_id = ?";

            psInventory = con.prepareStatement(updateInventory);

            psInventory.setInt(1, newQuantity);
            psInventory.setInt(2, itemId);

            int inventoryUpdated = psInventory.executeUpdate();

            String insertMovement = "INSERT INTO stock_movements (item_id, movement_type, quantity, reference_note) "
                        + "VALUES (?, 'ADJUSTMENT', ?, ?)";

            psMovement = con.prepareStatement(insertMovement);

            psMovement.setInt(1, itemId);
            psMovement.setInt(2, newQuantity);
            psMovement.setString(3, referenceNote);

            int movementInserted = psMovement.executeUpdate();

            if (inventoryUpdated > 0 && movementInserted > 0) {
                con.commit();
                return true;
            } 
            else {
                con.rollback();
                return false;
            }
        } 
        catch (SQLException e) {
            try {
                if (con != null)
                    con.rollback();
            } 
            catch (SQLException ex) {
                ex.printStackTrace();
            }

            e.printStackTrace();
            return false;
        } 
        finally {

            try {

                if (psInventory != null)
                    psInventory.close();

                if (psMovement != null)
                    psMovement.close();

                if (con != null)
                    con.close();

            } 
            catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    
    //View Stock
    public List<Stock> viewStock() {

        List<Stock> stockList = new ArrayList<>();

        String sql =
                "SELECT i.item_id, i.item_name, i.category, i.brand, "
                + "inv.quantity, inv.location, inv.reorder_level, inv.safety_stock "
                + "FROM items i "
                + "JOIN inventory inv ON i.item_id = inv.item_id";

        try {

            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(sql);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Stock stock = new Stock();

                stock.setItemId(rs.getInt("item_id"));
                stock.setItemName(rs.getString("item_name"));
                stock.setCategory(rs.getString("category"));
                stock.setBrand(rs.getString("brand"));
                stock.setQuantity(rs.getInt("quantity"));
                stock.setLocation(rs.getString("location"));
                stock.setReorderLevel(rs.getInt("reorder_level"));
                stock.setSafetyStock(rs.getInt("safety_stock"));

                stockList.add(stock);
            }
            rs.close();
            ps.close();
            con.close();
        } 
        catch (SQLException e) {
            e.printStackTrace();
        }
        return stockList;
    }
    
    
    //View Stock Movement
    public List<StockMovement> viewStockMovement() {

        List<StockMovement> movementList = new ArrayList<>();

        String sql =
                "SELECT sm.movement_id, i.item_name, sm.item_id, "
                + "sm.movement_type, sm.quantity, "
                + "sm.reference_note, sm.movement_date "
                + "FROM stock_movements sm "
                + "JOIN items i ON sm.item_id = i.item_id "
                + "ORDER BY sm.movement_date DESC";

        try {

            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(sql);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                StockMovement movement = new StockMovement();

                movement.setMovementId(rs.getInt("movement_id"));
                movement.setItemId(rs.getInt("item_id"));
                movement.setItemName(rs.getString("item_name"));
                movement.setMovementType(rs.getString("movement_type"));
                movement.setQuantity(rs.getInt("quantity"));
                movement.setReferenceNote(rs.getString("reference_note"));
                movement.setMovementDate(rs.getTimestamp("movement_date"));

                movementList.add(movement);
            }
            rs.close();
            ps.close();
            con.close();
        } 
        catch (SQLException e) {
            e.printStackTrace();
        }
        return movementList;
    }

}
