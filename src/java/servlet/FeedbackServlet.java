// src/main/java/com/hardware/servlet/FeedbackServlet.java
package servlet;

import dao.FeedbackDAO;
import dao.SupplierDAO;
import model.SupplierFeedback;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/feedback")
public class FeedbackServlet extends HttpServlet {
    
    private SupplierDAO supplierDAO;
    private FeedbackDAO feedbackDAO;
    
    @Override
    public void init() throws ServletException {
        supplierDAO = new SupplierDAO();
        feedbackDAO = new FeedbackDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        handleRequest(request, response, false);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        handleRequest(request, response, true);
    }
    
    private void handleRequest(HttpServletRequest request, HttpServletResponse response, boolean isPost) 
            throws ServletException, IOException {
        
        try {
            if (isPost) {
                // Handle form submission
                submitFeedback(request, response);
            } else {
                // Handle GET request
                String action = request.getParameter("action");
                
                if ("view".equals(action)) {
                    showFeedbackList(request, response);
                } else {
                    showFeedbackForm(request, response);
                }
            }
        } catch (Exception e) {
            throw new ServletException("Error processing feedback request", e);
        }
    }
    
    private void showFeedbackForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Load suppliers for dropdown
        Map<Integer, String> suppliers = supplierDAO.getAllSuppliers();
        request.setAttribute("suppliers", suppliers);
        
        // If supplier selected, load related data
        String supplierId = request.getParameter("supplierId");
        if (supplierId != null && !supplierId.isEmpty()) {
            try {
                int sid = Integer.parseInt(supplierId);
                request.setAttribute("selectedSupplierId", sid);
                request.setAttribute("items", supplierDAO.getItemsBySupplier(sid));
                request.setAttribute("orders", supplierDAO.getPurchaseOrdersBySupplier(sid));
                request.setAttribute("stats", supplierDAO.getSupplierStats(sid));
            } catch (NumberFormatException e) {
                // Invalid supplier ID, ignore
            }
        }
        
        request.getRequestDispatcher("/supplier-feedback.jsp").forward(request, response);
    }
    
    private void showFeedbackList(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<SupplierFeedback> feedbackList = feedbackDAO.getAllFeedback();
        request.setAttribute("feedbackList", feedbackList);
        request.getRequestDispatcher("/feedback-list.jsp").forward(request, response);
    }
    
    private void submitFeedback(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        
        try {
            // Get form parameters
            String supplierIdStr = request.getParameter("supplierId");
            String itemIdStr = request.getParameter("itemId");
            String orderIdStr = request.getParameter("orderId");
            String ratingStr = request.getParameter("rating");
            String comments = request.getParameter("comments");
            
            // Validate required fields
            if (supplierIdStr == null || supplierIdStr.isBlank()
                    || ratingStr == null || ratingStr.isBlank()
                    || comments == null || comments.isBlank()) {
                session.setAttribute("message", "Please fill all required fields!");
                session.setAttribute("messageType", "error");
                response.sendRedirect(request.getContextPath() + "/feedback");
                return;
            }

            int supplierId = Integer.parseInt(supplierIdStr);
            int rating = Integer.parseInt(ratingStr);
            if (!supplierDAO.getAllSuppliers().containsKey(supplierId) || rating < 1 || rating > 5) {
                session.setAttribute("message", "Please select a valid active supplier and a rating from 1 to 5.");
                session.setAttribute("messageType", "error");
                response.sendRedirect(request.getContextPath() + "/feedback");
                return;
            }
            
            // Create feedback object
            SupplierFeedback feedback = new SupplierFeedback();
            feedback.setSupplierId(supplierId);
            feedback.setItemId(itemIdStr != null && !itemIdStr.isEmpty() ? Integer.parseInt(itemIdStr) : 0);
            feedback.setPurchaseOrderId(orderIdStr != null && !orderIdStr.isEmpty() ? Integer.parseInt(orderIdStr) : 0);
            feedback.setRating(rating);
            feedback.setComments(comments.trim());
            
            // Save feedback
            boolean success = feedbackDAO.submitFeedback(feedback);
            
            // Set response message
            if (success) {
                session.setAttribute("message", "Feedback submitted successfully!");
                session.setAttribute("messageType", "success");
            } else {
                session.setAttribute("message", "Error submitting feedback. Please try again.");
                session.setAttribute("messageType", "error");
            }
            
        } catch (Exception e) {
            session.setAttribute("message", " Error: " + e.getMessage());
            session.setAttribute("messageType", "error");
            e.printStackTrace();
        }
        
        // Redirect to view feedback
        response.sendRedirect(request.getContextPath() + "/feedback?action=view");
    }
}
