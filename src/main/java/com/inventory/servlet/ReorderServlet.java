package com.inventory.servlet;


import com.inventory.dao.InventoryDAO;
import com.inventory.dao.ReorderDAO;
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



    // Display Low Stock Items
    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {



        System.out.println("SERVLET CALLED");



        InventoryDAO dao = new InventoryDAO();



        List<inventory> lowStockItems =
                dao.getLowStockItems();



        System.out.println(
                "Sending to JSP : "
                + lowStockItems.size()
        );



        request.setAttribute(
                "lowStockItems",
                lowStockItems
        );



        request.getRequestDispatcher(
                "reorder.jsp"
        )
        .forward(request, response);


    }





    // Reorder Button Function
    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {



        System.out.println(
                "REORDER BUTTON CLICKED"
        );



        int itemId = Integer.parseInt(
                request.getParameter("itemId")
        );



        int quantity = Integer.parseInt(
                request.getParameter("quantity")
        );



        ReorderDAO dao =
                new ReorderDAO();



        boolean result =
                dao.addReorder(
                        itemId,
                        quantity
                );




        if(result){


            System.out.println(
                    "Reorder Added Successfully"
            );


        }
        else{


            System.out.println(
                    "Reorder Failed"
            );


        }



        response.sendRedirect(
                "ReorderHistoryServlet"
        );


    }



}