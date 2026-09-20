/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.inventory.servlet;

import com.inventory.dao.ItemDAO;
import com.inventory.dao.InventoryDAO;
import com.inventory.model.Item;
import com.inventory.model.Inventory;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/itemList")
public class ItemListServlet extends HttpServlet {
    
    private ItemDAO itemDAO;
    private InventoryDAO inventoryDAO;
    
    @Override
    public void init() {
        itemDAO = new ItemDAO();
        inventoryDAO = new InventoryDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            List<Item> items = itemDAO.getAllItems();
            request.setAttribute("items", items);
            
            request.getRequestDispatcher("/jsp/itemList.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading items: " + e.getMessage());
            request.getRequestDispatcher("/jsp/error.jsp").forward(request, response);
        }
    }
}
