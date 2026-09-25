/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.inventory.servlet;

import com.inventory.util.DBconnection;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/testConnection")
public class TestConnectionServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");

        try (PrintWriter out = response.getWriter()) {

            Connection con = DBconnection.getConnection();

            if (con != null) {
                out.println("<h2 style='color:green;'>Database Connected Successfully!</h2>");
                con.close();
            } else {
                out.println("<h2 style='color:red;'>Database Connection Failed!</h2>");
            }
        } catch (Exception e) {
            e.printStackTrace(response.getWriter());
        }
    }
}