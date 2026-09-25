/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package servlet;

import dao.StockDAO;
import model.StockMovement;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/ViewStockMovementServlet")
public class ViewStockMovementServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        StockDAO dao = new StockDAO();

        List<StockMovement> movementList = dao.viewStockMovement();

        request.setAttribute("movementList", movementList);

        request.getRequestDispatcher("viewStockMovement.jsp").forward(request, response);
    }
}
