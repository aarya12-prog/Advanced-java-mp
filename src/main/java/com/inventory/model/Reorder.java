/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.inventory.model;
import java.sql.Timestamp;

/**
 *
 * @author aarya Thorat
 */
public class Reorder {
    private int reorderId;
    private int itemId;
    private String itemName;
    private int quantity;
    private Timestamp reorderDate;
    private String status;


    public int getReorderId() {
        return reorderId;
    }

    public void setReorderId(int reorderId) {
        this.reorderId = reorderId;
    }


    public int getItemId() {
        return itemId;
    }

    /**
     *
     * @param itemId
     */
    public void setItemId(int itemId) {
        this.itemId = itemId;
    }


    public String getItemName() {
        return itemName;
    }

    public void setItemName(String itemName) {
        this.itemName = itemName;
    }


    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }


    public Timestamp getReorderDate() {
        return reorderDate;
    }

    public void setReorderDate(Timestamp reorderDate) {
        this.reorderDate = reorderDate;
    }


    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    


    
}
