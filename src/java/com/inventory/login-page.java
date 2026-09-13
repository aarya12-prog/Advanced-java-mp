package com.inventory;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Demo username and password
        if (username.equals("admin") && password.equals("mini@123")) {

            response.sendRedirect("success.html");

        } else {
            response.sendRedirect("invalid.html");
            response.setContentType("text/html");

            response.getWriter().println(
                "<h2>Invalid Username or Password</h2>"           
            );
        }
    }
}