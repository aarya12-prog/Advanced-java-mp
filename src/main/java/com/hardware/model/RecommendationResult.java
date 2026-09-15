package com.hardware.model;
import com.hardware.model.Item;
import com.hardware.model.Supplier;

public class RecommendationResult {
    private Item item;
    private Supplier supplier;
    private int currentStock;
    private double averageRating;
    private int feedbackCount;

    public Item getItem() { return item; }
    public void setItem(Item item) { this.item = item; }
    public Supplier getSupplier() { return supplier; }
    public void setSupplier(Supplier supplier) { this.supplier = supplier; }
    public int getCurrentStock() { return currentStock; }
    public void setCurrentStock(int currentStock) { this.currentStock = currentStock; }
    public double getAverageRating() { return averageRating; }
    public void setAverageRating(double averageRating) { this.averageRating = averageRating; }
    public int getFeedbackCount() { return feedbackCount; }
    public void setFeedbackCount(int feedbackCount) { this.feedbackCount = feedbackCount; }
}