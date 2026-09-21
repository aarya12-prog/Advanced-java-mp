import com.hardware.utils.DBConnection;
import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

@WebServlet("/admin/add-item")
@MultipartConfig(
    maxFileSize = 5 * 1024 * 1024,
    maxRequestSize = 10 * 1024 * 1024,
    fileSizeThreshold = 1024 * 1024
)
public class AddItemServlet extends HttpServlet {
    
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
            // 1. Get form data
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
            
            // 2. Handle photo upload
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
            
            // 3. Insert into database
            Connection conn = DBConnection.getConnection();
            
            String sql = "INSERT INTO items (item_name, category, brand, model_number, description, supplier_id, purchase_price, selling_price, photo_path, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
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
            
            int result = stmt.executeUpdate();
            
            int itemId = 0;
            if (result > 0) {
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    itemId = rs.getInt(1);
                }
                rs.close();
            }
            stmt.close();
            
            // Insert into inventory
            if (itemId > 0) {
                String invSql = "INSERT INTO inventory (item_id, quantity, location, reorder_level) VALUES (?, ?, ?, ?)";
                PreparedStatement invStmt = conn.prepareStatement(invSql);
                invStmt.setInt(1, itemId);
                invStmt.setInt(2, quantity);
                invStmt.setString(3, location);
                invStmt.setInt(4, reorderLevel);
                invStmt.executeUpdate();
                invStmt.close();
            }
            
            conn.close();
            
            response.sendRedirect(request.getContextPath() + "/admin/view-items.jsp?success=Item added successfully!");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/add-item.jsp?error=" + e.getMessage());
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