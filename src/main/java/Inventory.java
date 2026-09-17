import com.mycompany.inventorywebapp.Product;
import java.util.HashMap;
import java.util.Map;

public class Inventory {
    private final Map<String, Product> products = new HashMap<>();

    public void addProduct(Product product) {
        if (products.containsKey(product.getId())) {
            System.out.println("Error: Product with ID " + product.getId() + " already exists.");
        } else {
            products.put(product.getId(), product);
            System.out.println("Product added successfully!");
        }
    }

    public void updateStock(String id, int quantityChange) {
        Product p = products.get(id);
        if (p != null) {
            int newQty = p.getQuantity() + quantityChange;
            if (newQty < 0) {
                System.out.println("Error: Insufficient stock available.");
            } else {
                p.setQuantity(newQty);
                System.out.println("Stock updated. New quantity: " + newQty);
            }
        } else {
            System.out.println("Error: Product not found.");
        }
    }

    public void displayAllProducts() {
        if (products.isEmpty()) {
            System.out.println("Inventory is empty.");
            return;
        }
        System.out.println("\n--- Current Inventory ---");
        for (Product p : products.values()) {
            System.out.println(p);
        }
    }
}