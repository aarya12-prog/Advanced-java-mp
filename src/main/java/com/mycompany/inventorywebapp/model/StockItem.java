package com.mycompany.inventorywebapp.model;

public class StockItem {
    private int itemId;
    private String itemName;
    private String category;
    private String brand;
    private String modelNumber;
    private String supplierName;
    private int quantity;
    private String location;
    private int reorderLevel;
    private int safetyStock;
    private double purchasePrice;
    private double sellingPrice;

    public StockItem() {}

    public StockItem(int itemId, String itemName, String category, String brand, String modelNumber, 
                     String supplierName, int quantity, String location, int reorderLevel, 
                     int safetyStock, double purchasePrice, double sellingPrice) {
        this.itemId = itemId;
        this.itemName = itemName;
        this.category = category;
        this.brand = brand;
        this.modelNumber = modelNumber;
        this.supplierName = supplierName;
        this.quantity = quantity;
        this.location = location;
        this.reorderLevel = reorderLevel;
        this.safetyStock = safetyStock;
        this.purchasePrice = purchasePrice;
        this.sellingPrice = sellingPrice;
    }

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

    public String getSupplierName() { return supplierName; }
    public void setSupplierName(String supplierName) { this.supplierName = supplierName; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }

    public int getReorderLevel() { return reorderLevel; }
    public void setReorderLevel(int reorderLevel) { this.reorderLevel = reorderLevel; }

    public int getSafetyStock() { return safetyStock; }
    public void setSafetyStock(int safetyStock) { this.safetyStock = safetyStock; }

    public double getPurchasePrice() { return purchasePrice; }
    public void setPurchasePrice(double purchasePrice) { this.purchasePrice = purchasePrice; }

    public double getSellingPrice() { return sellingPrice; }
    public void setSellingPrice(double sellingPrice) { this.sellingPrice = sellingPrice; }
}