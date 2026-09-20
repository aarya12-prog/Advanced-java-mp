/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.inventory.model;

/**
 *
 * @author dines
 */

import java.math.BigDecimal;
import java.util.Map;

public class ProfitLossReport {
    private BigDecimal totalSales;
    private BigDecimal totalPurchaseCost;
    private BigDecimal totalExpenses;
    private BigDecimal grossProfit;
    private BigDecimal netProfit;
    private Map<String, BigDecimal> salesByCategory;
    private Map<String, BigDecimal> expensesByCategory;
    private Map<String, BigDecimal> monthlyProfit;
    
    // Getters and Setters
    public BigDecimal getTotalSales() { return totalSales; }
    public void setTotalSales(BigDecimal totalSales) { this.totalSales = totalSales; }
    
    public BigDecimal getTotalPurchaseCost() { return totalPurchaseCost; }
    public void setTotalPurchaseCost(BigDecimal totalPurchaseCost) { this.totalPurchaseCost = totalPurchaseCost; }
    
    public BigDecimal getTotalExpenses() { return totalExpenses; }
    public void setTotalExpenses(BigDecimal totalExpenses) { this.totalExpenses = totalExpenses; }
    
    public BigDecimal getGrossProfit() { return grossProfit; }
    public void setGrossProfit(BigDecimal grossProfit) { this.grossProfit = grossProfit; }
    
    public BigDecimal getNetProfit() { return netProfit; }
    public void setNetProfit(BigDecimal netProfit) { this.netProfit = netProfit; }
    
    public Map<String, BigDecimal> getSalesByCategory() { return salesByCategory; }
    public void setSalesByCategory(Map<String, BigDecimal> salesByCategory) { this.salesByCategory = salesByCategory; }
    
    public Map<String, BigDecimal> getExpensesByCategory() { return expensesByCategory; }
    public void setExpensesByCategory(Map<String, BigDecimal> expensesByCategory) { this.expensesByCategory = expensesByCategory; }
    
    public Map<String, BigDecimal> getMonthlyProfit() { return monthlyProfit; }
    public void setMonthlyProfit(Map<String, BigDecimal> monthlyProfit) { this.monthlyProfit = monthlyProfit; }
}