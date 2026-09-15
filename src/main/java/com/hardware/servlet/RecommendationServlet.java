/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.hardware.servlet;

import com.hardware.dao.RecommendationDAO;
import com.hardware.model.RecommendationResult;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/recommend")
public class RecommendationServlet extends HttpServlet {
    private RecommendationDAO dao;

    @Override
    public void init() {
        dao = new RecommendationDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("q");
        if (keyword != null && !keyword.trim().isEmpty()) {
            List<RecommendationResult> results = dao.searchWithRecommendation(keyword.trim());
            request.setAttribute("results", results);
            request.setAttribute("keyword", keyword);
        }
        request.getRequestDispatcher("/recommend.jsp").forward(request, response);
    }
}
