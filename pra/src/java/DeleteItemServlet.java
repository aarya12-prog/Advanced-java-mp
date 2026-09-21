import com.hardware.utils.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/delete-item")
public class DeleteItemServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("isLoggedIn") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login.jsp");
            return;
        }
        
        try {
            int itemId = Integer.parseInt(request.getParameter("id"));
            
            Connection conn = DBConnection.getConnection();
            
            // ==============================================
            // IMPORTANT: Delete in correct order (child tables first)
            // ==============================================
            
            // 1. Delete from supplier_feedback (references purchase_orders and items)
            try {
                String sql1 = "DELETE FROM supplier_feedback WHERE item_id = ? OR purchase_order_id IN (SELECT purchase_order_id FROM purchase_orders WHERE item_id = ?)";
                PreparedStatement stmt1 = conn.prepareStatement("DELETE FROM supplier_feedback WHERE item_id = ?");
                stmt1.setInt(1, itemId);
                stmt1.executeUpdate();
                stmt1.close();
            } catch (Exception e) {
                // Table might not exist or no records
            }
            
            // 2. Delete from supplier_feedback via purchase_orders
            try {
                PreparedStatement stmt2 = conn.prepareStatement(
                    "DELETE FROM supplier_feedback WHERE purchase_order_id IN (SELECT purchase_order_id FROM purchase_orders WHERE item_id = ?)"
                );
                stmt2.setInt(1, itemId);
                stmt2.executeUpdate();
                stmt2.close();
            } catch (Exception e) {
                // Table might not exist or no records
            }
            
            // 3. Delete from purchase_orders
            try {
                PreparedStatement stmt3 = conn.prepareStatement("DELETE FROM purchase_orders WHERE item_id = ?");
                stmt3.setInt(1, itemId);
                stmt3.executeUpdate();
                stmt3.close();
            } catch (Exception e) {
                // Table might not exist or no records
            }
            
            // 4. Delete from sales
            try {
                PreparedStatement stmt4 = conn.prepareStatement("DELETE FROM sales WHERE item_id = ?");
                stmt4.setInt(1, itemId);
                stmt4.executeUpdate();
                stmt4.close();
            } catch (Exception e) {
                // Table might not exist or no records
            }
            
            // 5. Delete from stock_movements
            try {
                PreparedStatement stmt5 = conn.prepareStatement("DELETE FROM stock_movements WHERE item_id = ?");
                stmt5.setInt(1, itemId);
                stmt5.executeUpdate();
                stmt5.close();
            } catch (Exception e) {
                // Table might not exist or no records
            }
            
            // 6. Delete from assets
            try {
                PreparedStatement stmt6 = conn.prepareStatement("DELETE FROM assets WHERE item_id = ?");
                stmt6.setInt(1, itemId);
                stmt6.executeUpdate();
                stmt6.close();
            } catch (Exception e) {
                // Table might not exist or no records
            }
            
            // 7. Delete from inventory
            try {
                PreparedStatement stmt7 = conn.prepareStatement("DELETE FROM inventory WHERE item_id = ?");
                stmt7.setInt(1, itemId);
                stmt7.executeUpdate();
                stmt7.close();
            } catch (Exception e) {
                // Table might not exist or no records
            }
            
            // 8. Finally delete from items (parent table)
            PreparedStatement stmt8 = conn.prepareStatement("DELETE FROM items WHERE item_id = ?");
            stmt8.setInt(1, itemId);
            int result = stmt8.executeUpdate();
            stmt8.close();
            
            conn.close();
            
            if (result > 0) {
                response.sendRedirect(request.getContextPath() + "/admin/view-items.jsp?success=Item deleted successfully!");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/view-items.jsp?error=Item not found!");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            // URL encode the error message to avoid special character issues
            String errorMsg = java.net.URLEncoder.encode(e.getMessage(), "UTF-8");
            response.sendRedirect(request.getContextPath() + "/admin/view-items.jsp?error=" + errorMsg);
        }
    }
}