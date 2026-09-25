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
