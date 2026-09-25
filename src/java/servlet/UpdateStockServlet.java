/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package servlet;

import dao.ItemDAO;
import dao.StockDAO;
import model.Stock;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/UpdateStockServlet")
public class UpdateStockServlet extends HttpServlet {

    // Display Update Stock Page
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        ItemDAO itemDAO = new ItemDAO();

        List<Stock> itemList = itemDAO.getAllItems();

        request.setAttribute("itemList", itemList);

        request.getRequestDispatcher("updateStock.jsp").forward(request, response);
    }

    // Process Update Stock
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int itemId = Integer.parseInt(request.getParameter("itemId"));

        int newQuantity = Integer.parseInt(request.getParameter("newQuantity"));

        String referenceNote = request.getParameter("referenceNote");

        StockDAO dao = new StockDAO();

        boolean success = dao.updateStock(itemId, newQuantity, referenceNote);

        if (success) {
            response.sendRedirect("ViewStockServlet");
        } else {
            response.getWriter().println("Failed to update stock.");
        }
    }
}