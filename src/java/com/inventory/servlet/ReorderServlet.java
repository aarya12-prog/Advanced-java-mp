/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.inventory.servlet;  // change this to your package name

import com.inventory.dao.InventoryDAO;
import com.inventory.model.inventory;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/ReorderServlet")
public class ReorderServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        InventoryDAO dao = new InventoryDAO();

        List<inventory> reorderList = dao.getLowStockItems();

        request.setAttribute("reorderList", reorderList);

        request.getRequestDispatcher("reorder.jsp")
                .forward(request, response);
    }
}