package com.inventory.servlet;

import com.inventory.dao.ReorderDAO;
import com.inventory.model.Reorder;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


@WebServlet("/ReorderHistoryServlet")
public class ReorderHistoryServlet extends HttpServlet {


    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {


        System.out.println("REORDER HISTORY SERVLET CALLED");


        ReorderDAO dao = new ReorderDAO();


        List<Reorder> reorderList =
                dao.getAllReorders();



        System.out.println(
                "Reorder History Count : "
                + reorderList.size()
        );



        request.setAttribute(
                "reorderList",
                reorderList
        );



        request.getRequestDispatcher(
                "reorder_history.jsp"
        )
        .forward(request, response);


    }


}