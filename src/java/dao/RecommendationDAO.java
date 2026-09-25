package dao;

import model.Item;
import model.Supplier;
import model.RecommendationResult;
import util.DBConnection;

import java.sql.*;
import java.util.*;

public class RecommendationDAO {

    public List<RecommendationResult> searchWithRecommendation(String keyword) {
        List<RecommendationResult> results = new ArrayList<>();

        String sql =
            "SELECT i.item_id, i.item_name, i.category, i.purchase_price, " +
            "s.supplier_id, s.supplier_name, s.contact_person, s.phone, s.email, " +
            "COALESCE(inv.quantity, 0) AS current_stock, " +
            "COALESCE(AVG(f.rating), 0) AS avg_rating, " +
            "COUNT(f.feedback_id) AS feedback_count " +
            "FROM items i " +
            "JOIN suppliers s ON i.supplier_id = s.supplier_id " +

cat > src/java/servlet/RecommendationServlet.java <<'EOF'
package servlet;

import dao.RecommendationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/recommend")
public class RecommendationServlet extends HttpServlet {

    private final RecommendationDAO recommendationDAO = new RecommendationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("q");

        if (keyword != null && !keyword.trim().isEmpty()) {
            request.setAttribute(
                    "results",
                    recommendationDAO.searchWithRecommendation(keyword.trim())
            );
        }

        request.getRequestDispatcher("/recommend.jsp").forward(request, response);
    }
}
