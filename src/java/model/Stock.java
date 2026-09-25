/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Sajiv.v
 */
public class Stock {
    private int itemId;
    private String itemName;
    private String category;
    private String brand;
    private int quantity;
    private String location;
    private int reorderLevel;
    private int safetyStock;
    
    public Stock(){}
    
    public int getItemId(){
        return itemId;
    }
    
    public void setItemId(int itemId){
        this.itemId = itemId;
    }
    
    public String getItemName(){
        return itemName;
    }
    
    public void setItemName(String itemName){
        this.itemName = itemName;
    }
    
    public String getCategory(){
        return category;
    }
    
    public void setCategory(String category){
        this.category = category;
    }
    
    public String getBrand(){
        return brand;
    }
    
    public void setBrand(String brand){
        this.brand = brand;
    }
    
    public int getQuantity(){
        return quantity;
    }
    
    public void setQuantity(int quantity){
        this.quantity = quantity;
    }
    
    public String getLocation(){
        return location;
    }
    
    public void setLocation(String location){
        this.location = location;
    }
    
    public int getReorderLevel(){
        return reorderLevel;
    }
    
    public void setReorderLevel(int reorderLevel){
        this.reorderLevel = reorderLevel;
    }
    
    public int getSafetyStock(){
        return safetyStock;
    }
    
    public void setSafetyStock(int safetyStock){
        this.safetyStock = safetyStock;
    }    
}
