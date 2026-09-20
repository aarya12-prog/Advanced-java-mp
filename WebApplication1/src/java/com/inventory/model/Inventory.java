/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.inventory.model;

import java.sql.Timestamp;

public class Inventory {
    private int inventoryId;
    private int itemId;
    private int quantity;
    private String location;
    private int reorderLevel;
    private int safetyStock;
    private Timestamp lastUpdated;
    
    public Inventory() {}
    
    public Inventory(int itemId, int quantity, String location, int reorderLevel, int safetyStock) {
        this.itemId = itemId;
        this.quantity = quantity;
        this.location = location;
        this.reorderLevel = reorderLevel;
        this.safetyStock = safetyStock;
    }
    
    // Getters and Setters
    public int getInventoryId() { return inventoryId; }
    public void setInventoryId(int inventoryId) { this.inventoryId = inventoryId; }
    
    public int getItemId() { return itemId; }
    public void setItemId(int itemId) { this.itemId = itemId; }
    
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    
    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }
    
    public int getReorderLevel() { return reorderLevel; }
    public void setReorderLevel(int reorderLevel) { this.reorderLevel = reorderLevel; }
    
    public int getSafetyStock() { return safetyStock; }
    public void setSafetyStock(int safetyStock) { this.safetyStock = safetyStock; }
    
    public Timestamp getLastUpdated() { return lastUpdated; }
    public void setLastUpdated(Timestamp lastUpdated) { this.lastUpdated = lastUpdated; }
}