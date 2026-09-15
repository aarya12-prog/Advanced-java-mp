package com.hardware.servlet;

import com.hardware.dao.SearchDAO;
import com.hardware.model.SearchFilter;
import com.hardware.model.SearchResult;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet("/search")
public class SearchServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        SearchDAO searchDAO = new SearchDAO();
        
        // Always load dropdowns
        request.setAttribute("categories", searchDAO.getAllCategories());
        request.setAttribute("brands", searchDAO.getAllBrands());
        
        // Build filter
        SearchFilter filter = new SearchFilter();
        
        String action = request.getParameter("action");
        
        if ("search".equals(action)) {
            // Get search parameters
            String category = request.getParameter("category");
            if (category != null) filter.setCategory(category);
            
            String brand = request.getParameter("brand");
            if (brand != null) filter.setBrand(brand);
            
            String minPrice = request.getParameter("minPrice");
            if (minPrice != null && !minPrice.isEmpty()) {
                try {
                    filter.setMinPrice(new BigDecimal(minPrice));
                } catch (NumberFormatException e) {
                    request.setAttribute("searchError", "Minimum price must be a valid number.");
                }
            }
            
            String maxPrice = request.getParameter("maxPrice");
            if (maxPrice != null && !maxPrice.isEmpty()) {
                try {
                    filter.setMaxPrice(new BigDecimal(maxPrice));
                } catch (NumberFormatException e) {
                    request.setAttribute("searchError", "Maximum price must be a valid number.");
                }
            }
            
            String stockStatus = request.getParameter("stockStatus");
            if (stockStatus != null) filter.setStockStatus(stockStatus);
            
            String itemStatus = request.getParameter("itemStatus");
            if (itemStatus != null) filter.setItemStatus(itemStatus);
            
            String keyword = request.getParameter("keyword");
            if (keyword != null) filter.setKeyword(keyword);
            
            String sortBy = request.getParameter("sortBy");
            if (sortBy != null) filter.setSortBy(sortBy);

            if (filter.getMinPrice() != null && filter.getMaxPrice() != null
                    && filter.getMinPrice().compareTo(filter.getMaxPrice()) > 0) {
                request.setAttribute("searchError", "Minimum price cannot be greater than maximum price.");
                filter.setMinPrice(null);
                filter.setMaxPrice(null);
            }
        }
        
        // Perform search
        List<SearchResult> results = searchDAO.searchItems(filter);
        
        // Set attributes
        request.setAttribute("results", results);
        request.setAttribute("resultCount", results.size());
        request.setAttribute("filter", filter);
        
        // Forward to JSP
        request.getRequestDispatcher("/search.jsp").forward(request, response);
    }
}
