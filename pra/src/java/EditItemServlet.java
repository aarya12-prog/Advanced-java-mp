import com.hardware.utils.DBConnection;
import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

@WebServlet("/admin/edit-item")
@MultipartConfig(
    maxFileSize = 5 * 1024 * 1024,
    maxRequestSize = 10 * 1024 * 1024,
    fileSizeThreshold = 1024 * 1024
)
public class EditItemServlet extends HttpServlet {
    
    private static final String UPLOAD_DIR = "product_photos";
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("isLoggedIn") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login.jsp");
            return;
        }
        
        try {
            int itemId = Integer.parseInt(request.getParameter("item_id"));
            String itemName = request.getParameter("item_name");
            String category = request.getParameter("category");
            String brand = request.getParameter("brand");
            String modelNumber = request.getParameter("model_number");
            String description = request.getParameter("description");
            int supplierId = Integer.parseInt(request.getParameter("supplier_id"));
            double purchasePrice = Double.parseDouble(request.getParameter("purchase_price"));
            double sellingPrice = Double.parseDouble(request.getParameter("selling_price"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            String location = request.getParameter("location");
            int reorderLevel = Integer.parseInt(request.getParameter("reorder_level"));
            String status = request.getParameter("status");
            
            Connection conn = DBConnection.getConnection();
            
            // Handle photo upload
            String photoPath = null;
            Part filePart = request.getPart("product_photo");
            
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = extractFileName(filePart);
                String uniqueFileName = System.currentTimeMillis() + "_" + fileName;
                
                String applicationPath = getServletContext().getRealPath("");
                String uploadFolderPath = applicationPath + File.separator + UPLOAD_DIR;
                
                File uploadFolder = new File(uploadFolderPath);
                if (!uploadFolder.exists()) {
                    uploadFolder.mkdirs();
                }
                
                String filePath = uploadFolderPath + File.separator + uniqueFileName;
                filePart.write(filePath);
                photoPath = UPLOAD_DIR + "/" + uniqueFileName;
            }
            
            // Update items table
            String sql;
            PreparedStatement stmt;
            
            if (photoPath != null) {
                sql = "UPDATE items SET item_name = ?, category = ?, brand = ?, model_number = ?, description = ?, supplier_id = ?, purchase_price = ?, selling_price = ?, photo_path = ?, status = ? WHERE item_id = ?";
                stmt = conn.prepareStatement(sql);
                stmt.setString(1, itemName);
                stmt.setString(2, category);
                stmt.setString(3, brand);
                stmt.setString(4, modelNumber);
                stmt.setString(5, description);
                stmt.setInt(6, supplierId);
                stmt.setDouble(7, purchasePrice);
                stmt.setDouble(8, sellingPrice);
                stmt.setString(9, photoPath);
                stmt.setString(10, status);
                stmt.setInt(11, itemId);
            } else {
                sql = "UPDATE items SET item_name = ?, category = ?, brand = ?, model_number = ?, description = ?, supplier_id = ?, purchase_price = ?, selling_price = ?, status = ? WHERE item_id = ?";
                stmt = conn.prepareStatement(sql);
                stmt.setString(1, itemName);
                stmt.setString(2, category);
                stmt.setString(3, brand);
                stmt.setString(4, modelNumber);
                stmt.setString(5, description);
                stmt.setInt(6, supplierId);
                stmt.setDouble(7, purchasePrice);
                stmt.setDouble(8, sellingPrice);
                stmt.setString(9, status);
                stmt.setInt(10, itemId);
            }
            
            stmt.executeUpdate();
            stmt.close();
            
            // Update inventory
            String invSql = "UPDATE inventory SET quantity = ?, location = ?, reorder_level = ? WHERE item_id = ?";
            PreparedStatement invStmt = conn.prepareStatement(invSql);
            invStmt.setInt(1, quantity);
            invStmt.setString(2, location);
            invStmt.setInt(3, reorderLevel);
            invStmt.setInt(4, itemId);
            invStmt.executeUpdate();
            invStmt.close();
            
            conn.close();
            
            response.sendRedirect(request.getContextPath() + "/admin/view-items.jsp?success=Item updated successfully!");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/view-items.jsp?error=" + e.getMessage());
        }
    }
    
    private String extractFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        String[] tokens = contentDisposition.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return "unknown.jpg";
    }
}