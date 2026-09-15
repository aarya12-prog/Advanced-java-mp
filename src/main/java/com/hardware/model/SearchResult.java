package com.hardware.model;

import java.math.BigDecimal;

public class SearchResult {
    private int itemId;
    private String itemName;
    private String category;
    private String brand;
    private String modelNumber;
    private String description;
    private String supplierName;
    private BigDecimal purchasePrice;
    private BigDecimal sellingPrice;
    private String status;
    private int quantity;
    private String location;
    private int reorderLevel;
    
    public int getItemId() { return itemId; }
    public void setItemId(int itemId) { this.itemId = itemId; }
    
    public String getItemName() { return itemName; }
    public void setItemName(String itemName) { this.itemName = itemName; }
    
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
    
    public String getBrand() { return brand; }
    public void setBrand(String brand) { this.brand = brand; }
    
    public String getModelNumber() { return modelNumber; }
    public void setModelNumber(String modelNumber) { this.modelNumber = modelNumber; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public String getSupplierName() { return supplierName; }
    public void setSupplierName(String supplierName) { this.supplierName = supplierName; }
    
    public BigDecimal getPurchasePrice() { return purchasePrice; }
    public void setPurchasePrice(BigDecimal purchasePrice) { this.purchasePrice = purchasePrice; }
    
    public BigDecimal getSellingPrice() { return sellingPrice; }
    public void setSellingPrice(BigDecimal sellingPrice) { this.sellingPrice = sellingPrice; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    
    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }
    
    public int getReorderLevel() { return reorderLevel; }
    public void setReorderLevel(int reorderLevel) { this.reorderLevel = reorderLevel; }
    
    // Stock status helper
    public String getStockStatusText() {
        if (quantity == 0) return "Out of Stock";
        if (quantity <= reorderLevel) return "Low Stock";
        return "In Stock";
    }
    
    // Stock status CSS class
    public String getStockStatusClass() {
        if (quantity == 0) return "outofstock";
        if (quantity <= reorderLevel) return "lowstock";
        return "instock";
    }
}