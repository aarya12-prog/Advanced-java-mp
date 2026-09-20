/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.inventory.servlet;

import com.inventory.dao.ItemDAO;
import com.inventory.model.Item;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/addItem")
public class AddItemServlet extends HttpServlet {
    
    private ItemDAO itemDAO;
    
    @Override
    public void init() {
        itemDAO = new ItemDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/jsp/addItem.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            String itemName = request.getParameter("itemName");
            String category = request.getParameter("category");
            String brand = request.getParameter("brand");
            String modelNumber = request.getParameter("modelNumber");
            String description = request.getParameter("description");
            int supplierId = Integer.parseInt(request.getParameter("supplierId"));
            BigDecimal purchasePrice = new BigDecimal(request.getParameter("purchasePrice"));
            BigDecimal sellingPrice = new BigDecimal(request.getParameter("sellingPrice"));
            String status = request.getParameter("status");
            
            Item item = new Item();
            item.setItemName(itemName);
            item.setCategory(category);
            item.setBrand(brand);
            item.setModelNumber(modelNumber);
            item.setDescription(description);
            item.setSupplierId(supplierId);
            item.setPurchasePrice(purchasePrice);
            item.setSellingPrice(sellingPrice);
            item.setStatus(status);
            
            boolean success = itemDAO.addItem(item);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/itemList?message=Item added successfully");
            } else {
                request.setAttribute("error", "Failed to add item");
                request.getRequestDispatcher("/jsp/addItem.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: " + e.getMessage());
            request.getRequestDispatcher("/jsp/addItem.jsp").forward(request, response);
        }
    }
}
