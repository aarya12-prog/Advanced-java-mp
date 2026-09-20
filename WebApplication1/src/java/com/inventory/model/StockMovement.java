/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.inventory.model;

import java.sql.Timestamp;

public class StockMovement {
    private int movementId;
    private int itemId;
    private String movementType;
    private int quantity;
    private String referenceNote;
    private Timestamp movementDate;
    
    public StockMovement() {}
    
    public StockMovement(int itemId, String movementType, int quantity, String referenceNote) {
        this.itemId = itemId;
        this.movementType = movementType;
        this.quantity = quantity;
        this.referenceNote = referenceNote;
    }
    
    // Getters and Setters
    public int getMovementId() { return movementId; }
    public void setMovementId(int movementId) { this.movementId = movementId; }
    
    public int getItemId() { return itemId; }
    public void setItemId(int itemId) { this.itemId = itemId; }
    
    public String getMovementType() { return movementType; }
    public void setMovementType(String movementType) { this.movementType = movementType; }
    
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    
    public String getReferenceNote() { return referenceNote; }
    public void setReferenceNote(String referenceNote) { this.referenceNote = referenceNote; }
    
    public Timestamp getMovementDate() { return movementDate; }
    public void setMovementDate(Timestamp movementDate) { this.movementDate = movementDate; }
}