---
title: 'LAB 7 [EXERCISES]: SPRING BOOT & JPA CRUD'

---

---
title: 'LAB 7 EXERCISES: SPRING BOOT & JPA CRUD'

---

# LAB 7 EXERCISES: SPRING BOOT & JPA CRUD

**Course:** Web Application Development  
**Lab Duration:** 2.5 hours  
**Total Points:** 100 points (In-class: 60 points, Homework: 40 points)

---

## 📚 BEFORE YOU START

### Prerequisites:
- ✅ Completed JSP/Servlet labs (Lab 1-6)
- ✅ Read Lab 7 Setup Guide
- ✅ Java JDK 17+ installed
- ✅ VS Code with Java and Spring extensions
- ✅ MySQL running with `product_management` database
- ✅ Basic understanding of Spring Boot concepts

### Software Setup:
1. **Java:** JDK 17 or 21
2. **IDE:** VS Code with Extension Pack for Java + Spring Boot Extension Pack
3. **Build Tool:** Maven (bundled with Spring Boot)
4. **Database:** MySQL 8.0+
5. **Testing:** Browser + REST Client extension (optional)

### Lab Objectives:
By the end of this lab, you should be able to:
1. Create a Spring Boot project with Spring Initializr
2. Configure Spring Data JPA with MySQL
3. Create JPA entities with proper annotations
4. Implement Repository interfaces
5. Build Service layer with business logic
6. Create Controllers with GET and POST mappings
7. Use Thymeleaf for views

---

## PART A: IN-CLASS EXERCISES (60 points)

**Time Allocation:** 2.5 hours  
**Submission:** Demonstrate to instructor at end of class

---

### EXERCISE 1: PROJECT SETUP & CONFIGURATION (15 points)

**Estimated Time:** 25 minutes

#### Task 1.1: Create Spring Boot Project (5 points)

**Using Spring Initializr in VS Code:**

1. Press `Ctrl+Shift+P`
2. Type: "Spring Initializr: Create a Maven Project"
3. Select configurations:
   - Spring Boot: **3.3.x** (latest stable)
   - Language: **Java**
   - Group Id: **com.example**
   - Artifact Id: **product-management**
   - Packaging: **Jar**
   - Java version: **17** or **21**

4. Add dependencies:
   - ✅ Spring Web
   - ✅ Spring Data JPA
   - ✅ MySQL Driver
   - ✅ Thymeleaf
   - ✅ Spring Boot DevTools (optional)

5. Choose folder and open project

**Evaluation Criteria:**
| Criteria | Points |
|----------|--------|
| Project created with correct structure | 2 |
| All dependencies added | 2 |
| Project opens without errors | 1 |

---

#### Task 1.2: Database Setup (5 points)

**Create Database and Table:**

```sql
CREATE DATABASE product_management;
USE product_management;

CREATE TABLE products (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    product_code VARCHAR(20) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    quantity INT DEFAULT 0,
    category VARCHAR(50),
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample data
INSERT INTO products (product_code, name, price, quantity, category, description) VALUES
('P001', 'Laptop Dell XPS 13', 1299.99, 10, 'Electronics', 'High-performance laptop with Intel i7'),
('P002', 'iPhone 15 Pro', 999.99, 25, 'Electronics', 'Latest iPhone with A17 Pro chip'),
('P003', 'Samsung Galaxy S24', 899.99, 20, 'Electronics', 'Flagship Android smartphone'),
('P004', 'Office Chair Ergonomic', 199.99, 50, 'Furniture', 'Comfortable office chair with lumbar support'),
('P005', 'Standing Desk', 399.99, 15, 'Furniture', 'Adjustable height standing desk');
```

**Evaluation Criteria:**
| Criteria | Points |
|----------|--------|
| Database created | 2 |
| Table structure correct | 2 |
| Sample data inserted | 1 |

---

#### Task 1.3: Configure application.properties (5 points)

**File:** `src/main/resources/application.properties`

**Template to complete:**
```properties
# Application Name
spring.application.name=product-management

# Server Configuration
server.port=8080

# Database Configuration
# TODO: Add datasource URL (jdbc:mysql://localhost:3306/product_management?...)
spring.datasource.url=
# TODO: Add username
spring.datasource.username=
# TODO: Add password
spring.datasource.password=
# TODO: Add driver class name
spring.datasource.driver-class-name=

# JPA/Hibernate Configuration
# TODO: Set ddl-auto to 'update'
spring.jpa.hibernate.ddl-auto=
# TODO: Enable show-sql
spring.jpa.show-sql=
# TODO: Enable format-sql
spring.jpa.properties.hibernate.format_sql=
# TODO: Set MySQL dialect
spring.jpa.properties.hibernate.dialect=

# Thymeleaf Configuration
spring.thymeleaf.cache=false
spring.thymeleaf.prefix=classpath:/templates/
spring.thymeleaf.suffix=.html
```

**Solution:**
```properties
spring.datasource.url=jdbc:mysql://localhost:3306/product_management?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true
spring.datasource.username=root
spring.datasource.password=your_password
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver

spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.format_sql=true
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.MySQLDialect
```

**Evaluation Criteria:**
| Criteria | Points |
|----------|--------|
| Database connection configured | 2 |
| JPA properties set correctly | 2 |
| Application runs without errors | 1 |

**Checkpoint #1:** Run the application and verify no errors. Check console for successful connection.

---

### EXERCISE 2: ENTITY & REPOSITORY LAYERS (20 points)

**Estimated Time:** 40 minutes

#### Task 2.1: Create Product Entity (10 points)

**File:** `src/main/java/com/example/productmanagement/entity/Product.java`

**Requirements:**
- Add proper JPA annotations
- All fields with appropriate types
- Use BigDecimal for price
- Use LocalDateTime for timestamp
- Add lifecycle callback for createdAt
- Generate getters, setters, constructors

**Template to complete:**
```java
package com.example.productmanagement.entity;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;

// TODO: Add @Entity annotation
// TODO: Add @Table annotation with name "products"
public class Product {
    
    // TODO: Add @Id annotation
    // TODO: Add @GeneratedValue with IDENTITY strategy
    private Long id;
    
    // TODO: Add @Column with unique=true, nullable=false
    private String productCode;
    
    // TODO: Add @Column with nullable=false
    private String name;
    
    // TODO: Add @Column with precision and scale for decimal
    private BigDecimal price;
    
    // TODO: Add @Column for quantity
    private Integer quantity;
    
    // TODO: Add @Column for category
    private String category;
    
    // TODO: Add @Column with TEXT type
    private String description;
    
    // TODO: Add @Column for created_at with updatable=false
    private LocalDateTime createdAt;
    
    // TODO: Add no-arg constructor
    
    // TODO: Add parameterized constructor (without id and createdAt)
    
    // TODO: Add @PrePersist method to set createdAt
    
    // TODO: Generate all getters and setters
    
    // TODO: Add toString() method
}
```

**Evaluation Criteria:**
| Criteria | Points |
|----------|--------|
| All JPA annotations correct | 3 |
| Proper data types used | 2 |
| Constructors implemented | 2 |
| Getters/setters complete | 2 |
| @PrePersist lifecycle callback | 1 |

---

#### Task 2.2: Create Product Repository (5 points)

**File:** `src/main/java/com/example/productmanagement/repository/ProductRepository.java`

**Requirements:**
- Interface extends JpaRepository
- Add @Repository annotation
- Add custom query methods

**Template to complete:**
```java
package com.example.productmanagement.repository;

import com.example.productmanagement.entity.Product;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.util.List;

// TODO: Add @Repository annotation
// TODO: Extend JpaRepository<Product, Long>
public interface ProductRepository {
    
    // TODO: Add method to find products by category
    
    // TODO: Add method to find products by name containing keyword
    
    // TODO: Add method to check if product code exists
    
    // Note: Basic CRUD methods are inherited from JpaRepository
}
```

**Solution:**
```java
@Repository
public interface ProductRepository extends JpaRepository<Product, Long> {
    
    List<Product> findByCategory(String category);
    
    List<Product> findByNameContaining(String keyword);
    
    boolean existsByProductCode(String productCode);
}
```

**Evaluation Criteria:**
| Criteria | Points |
|----------|--------|
| Extends JpaRepository correctly | 2 |
| Custom query methods correct | 2 |
| Method naming conventions followed | 1 |

---

#### Task 2.3: Test Repository (5 points)

**Create a test in main application class (temporary):**

```java
@SpringBootApplication
public class ProductManagementApplication {

    public static void main(String[] args) {
        SpringApplication.run(ProductManagementApplication.class, args);
    }
    
    // Temporary test - remove after verification
    @Bean
    CommandLineRunner test(ProductRepository repository) {
        return args -> {
            System.out.println("=== Testing Repository ===");
            
            // Count all products
            long count = repository.count();
            System.out.println("Total products: " + count);
            
            // Find all products
            List<Product> products = repository.findAll();
            products.forEach(System.out::println);
            
            // Find by category
            List<Product> electronics = repository.findByCategory("Electronics");
            System.out.println("\nElectronics: " + electronics.size());
            
            System.out.println("=== Test Complete ===");
        };
    }
}
```

**Run application and verify output in console.**

**Evaluation Criteria:**
| Criteria | Points |
|----------|--------|
| Repository methods work correctly | 3 |
| Data retrieved from database | 2 |

**Checkpoint #2:** Show instructor that Entity and Repository work correctly.

---

### EXERCISE 3: SERVICE LAYER (10 points)

**Estimated Time:** 25 minutes

#### Task 3.1: Create Service Interface (3 points)

**File:** `src/main/java/com/example/productmanagement/service/ProductService.java`

```java
package com.example.productmanagement.service;

import com.example.productmanagement.entity.Product;

import java.util.List;
import java.util.Optional;

public interface ProductService {
    
    List<Product> getAllProducts();
    
    Optional<Product> getProductById(Long id);
    
    Product saveProduct(Product product);
    
    void deleteProduct(Long id);
    
    List<Product> searchProducts(String keyword);
    
    List<Product> getProductsByCategory(String category);
}
```

---

#### Task 3.2: Implement Service (7 points)

**File:** `src/main/java/com/example/productmanagement/service/ProductServiceImpl.java`

**Template to complete:**
```java
package com.example.productmanagement.service;

import com.example.productmanagement.entity.Product;
import com.example.productmanagement.repository.ProductRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

// TODO: Add @Service annotation
// TODO: Add @Transactional annotation
public class ProductServiceImpl implements ProductService {
    
    // TODO: Inject ProductRepository using constructor injection
    private final ProductRepository productRepository;
    
    // TODO: Create constructor with @Autowired
    
    @Override
    public List<Product> getAllProducts() {
        // TODO: Return all products from repository
        return null;
    }
    
    @Override
    public Optional<Product> getProductById(Long id) {
        // TODO: Return product by id from repository
        return null;
    }
    
    @Override
    public Product saveProduct(Product product) {
        // TODO: Save product to repository
        return null;
    }
    
    @Override
    public void deleteProduct(Long id) {
        // TODO: Delete product from repository
    }
    
    @Override
    public List<Product> searchProducts(String keyword) {
        // TODO: Search products using repository method
        return null;
    }
    
    @Override
    public List<Product> getProductsByCategory(String category) {
        // TODO: Get products by category from repository
        return null;
    }
}
```

**Evaluation Criteria:**
| Criteria | Points |
|----------|--------|
| @Service and @Transactional annotations | 2 |
| Constructor injection implemented | 2 |
| All methods implemented correctly | 3 |

**Checkpoint #3:** Verify service layer compiles and runs.

---

### EXERCISE 4: CONTROLLER & VIEWS (15 points)

**Estimated Time:** 50 minutes

#### Task 4.1: Create Product Controller (8 points)

**File:** `src/main/java/com/example/productmanagement/controller/ProductController.java`

**Template to complete:**
```java
package com.example.productmanagement.controller;

import com.example.productmanagement.entity.Product;
import com.example.productmanagement.service.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

// TODO: Add @Controller annotation
// TODO: Add @RequestMapping("/products")
public class ProductController {
    
    // TODO: Inject ProductService
    private final ProductService productService;
    
    // TODO: Create constructor with @Autowired
    
    // TODO: List all products - GET /products
    public String listProducts(Model model) {
        // 1. Get all products from service
        // 2. Add to model
        // 3. Return "product-list"
        return null;
    }
    
    // TODO: Show new product form - GET /products/new
    public String showNewForm(Model model) {
        // 1. Create empty Product object
        // 2. Add to model
        // 3. Return "product-form"
        return null;
    }
    
    // TODO: Show edit form - GET /products/edit/{id}
    public String showEditForm(@PathVariable Long id, Model model, RedirectAttributes redirectAttributes) {
        // 1. Get product by id from service
        // 2. If found, add to model and return "product-form"
        // 3. If not found, add error message and redirect to list
        return null;
    }
    
    // TODO: Save product - POST /products/save
    public String saveProduct(@ModelAttribute("product") Product product, RedirectAttributes redirectAttributes) {
        // 1. Save product using service
        // 2. Add success message
        // 3. Redirect to list
        return null;
    }
    
    // TODO: Delete product - GET /products/delete/{id}
    public String deleteProduct(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        // 1. Delete product using service
        // 2. Add success message
        // 3. Redirect to list
        return null;
    }
    
    // TODO: Search products - GET /products/search
    public String searchProducts(@RequestParam("keyword") String keyword, Model model) {
        // 1. Search products from service
        // 2. Add results and keyword to model
        // 3. Return "product-list"
        return null;
    }
}
```

**Hints:**
```java
// Example: List products
@GetMapping
public String listProducts(Model model) {
    List<Product> products = productService.getAllProducts();
    model.addAttribute("products", products);
    return "product-list";
}

// Example: Edit form with Optional handling
@GetMapping("/edit/{id}")
public String showEditForm(@PathVariable Long id, Model model, RedirectAttributes redirectAttributes) {
    return productService.getProductById(id)
            .map(product -> {
                model.addAttribute("product", product);
                return "product-form";
            })
            .orElseGet(() -> {
                redirectAttributes.addFlashAttribute("error", "Product not found");
                return "redirect:/products";
            });
}
```

**Evaluation Criteria:**
| Criteria | Points |
|----------|--------|
| All request mappings correct | 2 |
| Service injection works | 1 |
| List products implemented | 1 |
| New/Edit forms work | 2 |
| Save functionality works | 1 |
| Delete functionality works | 1 |

---

#### Task 4.2: Create Product List View (4 points)

**File:** `src/main/resources/templates/product-list.html`

**Requirements:**
- Display all products in a table
- Show success/error messages
- Add "New Product" button
- Search form
- Edit and Delete buttons for each product

**Basic template:**
```html
<!DOCTYPE html>
<html xmlns:th="http://www.thymeleaf.org">
<head>
    <meta charset="UTF-8">
    <title>Product List</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 10px; border: 1px solid #ddd; text-align: left; }
        th { background-color: #4CAF50; color: white; }
        .btn { padding: 5px 10px; text-decoration: none; color: white; border-radius: 3px; }
        .btn-primary { background-color: #4CAF50; }
        .btn-danger { background-color: #f44336; }
        .alert { padding: 10px; margin-bottom: 15px; border-radius: 5px; }
        .alert-success { background-color: #d4edda; color: #155724; }
        .alert-error { background-color: #f8d7da; color: #721c24; }
    </style>
</head>
<body>
    <h1>Product Management</h1>
    
    <!-- TODO: Display success message if exists -->
    
    <!-- TODO: Display error message if exists -->
    
    <!-- TODO: Add "New Product" button -->
    
    <!-- TODO: Add search form -->
    
    <!-- TODO: Create table with products -->
    <!-- Use th:each to loop through products -->
    <!-- Display: id, productCode, name, price, quantity, category -->
    <!-- Add Edit and Delete buttons -->
    
</body>
</html>
```

**Evaluation Criteria:**
| Criteria | Points |
|----------|--------|
| Table displays all products | 2 |
| Messages displayed correctly | 1 |
| Action buttons work | 1 |

---

#### Task 4.3: Create Product Form View (3 points)

**File:** `src/main/resources/templates/product-form.html`

**Requirements:**
- Form for adding/editing products
- All fields: productCode, name, price, quantity, category, description
- Save and Cancel buttons
- Title changes based on add/edit mode

**Basic template:**
```html
<!DOCTYPE html>
<html xmlns:th="http://www.thymeleaf.org">
<head>
    <meta charset="UTF-8">
    <title>Product Form</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .form-group { margin-bottom: 15px; }
        label { display: block; margin-bottom: 5px; }
        input, select, textarea { width: 100%; padding: 8px; }
        .btn { padding: 10px 20px; margin-right: 10px; cursor: pointer; }
    </style>
</head>
<body>
    <!-- TODO: Dynamic title (Add/Edit) -->
    <h1>Product Form</h1>
    
    <!-- TODO: Create form with th:action and th:object -->
    <!-- Hidden field for id -->
    <!-- Input fields for all product properties -->
    <!-- Save and Cancel buttons -->
    
</body>
</html>
```

**Evaluation Criteria:**
| Criteria | Points |
|----------|--------|
| Form binding works | 1 |
| All fields present | 1 |
| Save/Cancel buttons work | 1 |

**Checkpoint #4:** Demonstrate complete CRUD operations to instructor.

---

## PART B: HOMEWORK EXERCISES (40 points)

**Deadline:** 1 week  
**Submission:** ZIP file with complete project + README

---

### EXERCISE 5: ADVANCED SEARCH (12 points)

**Estimated Time:** 45 minutes

#### Task 5.1: Multi-Criteria Search (6 points)

Add search by multiple criteria:
- Name (contains)
- Category (exact match)
- Price range (min-max)

**Add to ProductRepository:**
```java
@Query("SELECT p FROM Product p WHERE " +
       "(:name IS NULL OR p.name LIKE %:name%) AND " +
       "(:category IS NULL OR p.category = :category) AND " +
       "(:minPrice IS NULL OR p.price >= :minPrice) AND " +
       "(:maxPrice IS NULL OR p.price <= :maxPrice)")
List<Product> searchProducts(@Param("name") String name,
                            @Param("category") String category,
                            @Param("minPrice") BigDecimal minPrice,
                            @Param("maxPrice") BigDecimal maxPrice);
```

**Add to Service interface and implementation.**

**Add to Controller:**
```java
@GetMapping("/advanced-search")
public String advancedSearch(
    @RequestParam(required = false) String name,
    @RequestParam(required = false) String category,
    @RequestParam(required = false) BigDecimal minPrice,
    @RequestParam(required = false) BigDecimal maxPrice,
    Model model) {
    // Implementation
}
```

**Add advanced search form to product-list.html.**

---

#### Task 5.2: Category Filter (3 points)

Add category filter dropdown that shows all unique categories.

**Add to ProductRepository:**
```java
@Query("SELECT DISTINCT p.category FROM Product p ORDER BY p.category")
List<String> findAllCategories();
```

**Add filter dropdown to view:**
```html
<select name="category" onchange="this.form.submit()">
    <option value="">All Categories</option>
    <option th:each="cat : ${categories}" 
            th:value="${cat}" 
            th:text="${cat}"
            th:selected="${cat == selectedCategory}">
    </option>
</select>
```

---

#### Task 5.3: Search with Pagination (3 points)

Implement pagination for search results.

**Modify repository method to use Pageable:**
```java
Page<Product> findByNameContaining(String keyword, Pageable pageable);
```

**Update controller to handle pagination:**
```java
@GetMapping("/search")
public String searchProducts(
    @RequestParam("keyword") String keyword,
    @RequestParam(defaultValue = "0") int page,
    @RequestParam(defaultValue = "10") int size,
    Model model) {
    
    Pageable pageable = PageRequest.of(page, size);
    Page<Product> productPage = productService.searchProducts(keyword, pageable);
    
    model.addAttribute("products", productPage.getContent());
    model.addAttribute("currentPage", page);
    model.addAttribute("totalPages", productPage.getTotalPages());
    
    return "product-list";
}
```

---

### EXERCISE 6: VALIDATION (10 points)

**Estimated Time:** 40 minutes

#### Task 6.1: Add Validation Annotations (5 points)

**Add to Product entity:**
```java
import jakarta.validation.constraints.*;

@Entity
public class Product {
    
    @NotBlank(message = "Product code is required")
    @Size(min = 3, max = 20, message = "Product code must be 3-20 characters")
    @Pattern(regexp = "^P\\d{3,}$", message = "Product code must start with P followed by numbers")
    private String productCode;
    
    @NotBlank(message = "Product name is required")
    @Size(min = 3, max = 100, message = "Name must be 3-100 characters")
    private String name;
    
    @NotNull(message = "Price is required")
    @DecimalMin(value = "0.01", message = "Price must be greater than 0")
    @DecimalMax(value = "999999.99", message = "Price is too high")
    private BigDecimal price;
    
    @NotNull(message = "Quantity is required")
    @Min(value = 0, message = "Quantity cannot be negative")
    private Integer quantity;
    
    @NotBlank(message = "Category is required")
    private String category;
}
```

---

#### Task 6.2: Add Validation in Controller (3 points)

**Update controller:**
```java
import jakarta.validation.Valid;
import org.springframework.validation.BindingResult;

@PostMapping("/save")
public String saveProduct(
    @Valid @ModelAttribute("product") Product product,
    BindingResult result,
    Model model,
    RedirectAttributes redirectAttributes) {
    
    if (result.hasErrors()) {
        return "product-form";
    }
    
    try {
        productService.saveProduct(product);
        redirectAttributes.addFlashAttribute("message", "Product saved successfully!");
    } catch (Exception e) {
        redirectAttributes.addFlashAttribute("error", "Error: " + e.getMessage());
    }
    
    return "redirect:/products";
}
```

---

#### Task 6.3: Display Validation Errors (2 points)

**Update product-form.html:**
```html
<div class="form-group">
    <label for="productCode">Product Code *</label>
    <input type="text" 
           id="productCode" 
           th:field="*{productCode}" 
           th:errorclass="error" />
    <span th:if="${#fields.hasErrors('productCode')}" 
          th:errors="*{productCode}" 
          class="error-message">Error</span>
</div>
```

**Add CSS for errors:**
```css
.error { border-color: red; }
.error-message { color: red; font-size: 12px; }
```

---

### EXERCISE 7: SORTING & FILTERING (10 points)

**Estimated Time:** 40 minutes

#### Task 7.1: Add Sorting (5 points)

**Update controller:**
```java
@GetMapping
public String listProducts(
    @RequestParam(required = false) String sortBy,
    @RequestParam(defaultValue = "asc") String sortDir,
    Model model) {
    
    List<Product> products;
    
    if (sortBy != null) {
        Sort sort = sortDir.equals("asc") ? 
            Sort.by(sortBy).ascending() : 
            Sort.by(sortBy).descending();
        products = productService.getAllProducts(sort);
    } else {
        products = productService.getAllProducts();
    }
    
    model.addAttribute("products", products);
    model.addAttribute("sortBy", sortBy);
    model.addAttribute("sortDir", sortDir);
    
    return "product-list";
}
```

**Update service to accept Sort parameter.**

**Add sorting links to view:**
```html
<th>
    <a th:href="@{/products(sortBy='name',sortDir=${sortDir=='asc'?'desc':'asc'})}">
        Name
        <span th:if="${sortBy=='name'}" th:text="${sortDir=='asc'?'↑':'↓'}"></span>
    </a>
</th>
```

---

#### Task 7.2: Filter by Category (3 points)

Add category filter buttons/dropdown that maintains sorting.

---

#### Task 7.3: Combined Sorting and Filtering (2 points)

Combine sorting and filtering in one interface.

---

### EXERCISE 8: STATISTICS DASHBOARD (8 points)

**Estimated Time:** 35 minutes

Create a dashboard showing statistics.

#### Task 8.1: Add Statistics Methods (4 points)

**Add to ProductRepository:**
```java
@Query("SELECT COUNT(p) FROM Product p WHERE p.category = :category")
long countByCategory(@Param("category") String category);

@Query("SELECT SUM(p.price * p.quantity) FROM Product p")
BigDecimal calculateTotalValue();

@Query("SELECT AVG(p.price) FROM Product p")
BigDecimal calculateAveragePrice();

@Query("SELECT p FROM Product p WHERE p.quantity < :threshold")
List<Product> findLowStockProducts(@Param("threshold") int threshold);
```

---

#### Task 8.2: Create Dashboard Controller (2 points)

```java
@Controller
@RequestMapping("/dashboard")
public class DashboardController {
    
    @Autowired
    private ProductService productService;
    
    @GetMapping
    public String showDashboard(Model model) {
        // Add statistics to model
        return "dashboard";
    }
}
```

---

#### Task 8.3: Create Dashboard View (2 points)

**Create:** `src/main/resources/templates/dashboard.html`

Display:
- Total products count
- Products by category (pie chart or list)
- Total inventory value
- Average product price
- Low stock alerts (quantity < 10)
- Recent products (last 5 added)

---

## BONUS EXERCISES (Optional - Extra Credit)

**Not required, earn up to 20 bonus points**

### BONUS 1: REST API Endpoints (8 points)

Create RESTful API for products.

**Create RestController:**
```java
@RestController
@RequestMapping("/api/products")
public class ProductRestController {
    
    @GetMapping
    public ResponseEntity<List<Product>> getAllProducts() {
        // Return JSON
    }
    
    @GetMapping("/{id}")
    public ResponseEntity<Product> getProduct(@PathVariable Long id) {
        // Return single product or 404
    }
    
    @PostMapping
    public ResponseEntity<Product> createProduct(@RequestBody Product product) {
        // Create and return 201
    }
    
    @PutMapping("/{id}")
    public ResponseEntity<Product> updateProduct(@PathVariable Long id, @RequestBody Product product) {
        // Update and return
    }
    
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteProduct(@PathVariable Long id) {
        // Delete and return 204
    }
}
```

Test with:
- Thunder Client (VS Code extension)
- Postman
- Or web browser for GET requests

---

### BONUS 2: Image Upload (6 points)

Add product image upload functionality.

**Requirements:**
- Add `imagePath` field to Product entity
- Handle file upload in controller using MultipartFile
- Store images in `uploads/` directory
- Display images in product list and details

---

### BONUS 3: Export to Excel (6 points)

Add Excel export functionality.

**Add dependency:**
```xml
<dependency>
    <groupId>org.apache.poi</groupId>
    <artifactId>poi-ooxml</artifactId>
    <version>5.2.3</version>
</dependency>
```

**Create ExportController:**
```java
@Controller
@RequestMapping("/export")
public class ExportController {
    
    @GetMapping("/excel")
    public void exportToExcel(HttpServletResponse response) throws IOException {
        // Create Excel workbook
        // Write data
        // Send to browser
    }
}
```

---

## HOMEWORK SUBMISSION GUIDELINES

### What to Submit:

**1. Complete Project ZIP:**
```
product-management.zip
├── src/
│   ├── main/
│   │   ├── java/com/example/productmanagement/
│   │   │   ├── ProductManagementApplication.java
│   │   │   ├── entity/Product.java
│   │   │   ├── repository/ProductRepository.java
│   │   │   ├── service/
│   │   │   │   ├── ProductService.java
│   │   │   │   └── ProductServiceImpl.java
│   │   │   └── controller/ProductController.java
│   │   └── resources/
│   │       ├── application.properties
│   │       └── templates/
│   │           ├── product-list.html
│   │           └── product-form.html
├── pom.xml
└── README.md
```

**2. README.md:**
```markdown
# Product Management System

## Student Information
- **Name:** [Your Name]
- **Student ID:** [Your ID]
- **Class:** [Your Class]

## Technologies Used
- Spring Boot 3.3.x
- Spring Data JPA
- MySQL 8.0
- Thymeleaf
- Maven

## Setup Instructions
1. Import project into VS Code
2. Create database: `product_management`
3. Update `application.properties` with your MySQL credentials
4. Run: `mvn spring-boot:run`
5. Open browser: http://localhost:8080/products

## Completed Features
- [x] CRUD operations
- [x] Search functionality
- [x] Advanced search with filters
- [x] Validation
- [x] Sorting
- [ ] Pagination
- [ ] REST API (Bonus)

## Project Structure
```
entity/       - JPA entities
repository/   - Data access layer
service/      - Business logic layer
controller/   - Web controllers
templates/    - Thymeleaf views
```

## Database Schema
See `schema.sql` for database structure.

## Known Issues
- [List any bugs or limitations]

## Time Spent
Approximately [X] hours

## Screenshots
See `screenshots/` folder.
```

**3. Screenshots:**
- Product list page
- Add product form
- Edit product form (with data)
- Search results
- Validation errors
- Sorted list
- Dashboard (if implemented)

**4. SQL Export:**
Export your database structure and sample data as `database.sql`

---

## EVALUATION RUBRIC

### In-Class (60 points):
| Component | Points |
|-----------|--------|
| Project Setup & Configuration | 15 |
| Entity & Repository | 20 |
| Service Layer | 10 |
| Controller & Views | 15 |

### Homework (40 points):
| Exercise | Points |
|----------|--------|
| Advanced Search | 12 |
| Validation | 10 |
| Sorting & Filtering | 10 |
| Statistics Dashboard | 8 |

### Bonus (20 points):
| Feature | Points |
|---------|--------|
| REST API | 8 |
| Image Upload | 6 |
| Excel Export | 6 |

### Code Quality (deductions):
- Poor naming conventions: -5
- No comments on complex logic: -3
- Not following Spring Boot conventions: -5
- Hardcoded values: -3

**Total Possible: 120 points (including bonus)**

---

## COMMON MISTAKES TO AVOID

### ❌ DON'T:

**1. Forget JPA annotations:**
```java
// DON'T forget @Entity, @Id, etc.
public class Product {
    private Long id;  // Missing annotations!
}
```

**2. Use wrong data types:**
```java
// DON'T use float/double for money
private double price;  // Use BigDecimal instead!
```

**3. Create repositories manually:**
```java
// DON'T implement repository
@Repository
public class ProductRepository implements JpaRepository {
    // Spring does this automatically!
}
```

**4. Forget to inject dependencies:**
```java
// DON'T use new keyword
private ProductService service = new ProductServiceImpl();
// Use @Autowired instead
```

### ✅ DO:

**1. Use proper annotations:**
```java
@Entity
@Table(name = "products")
public class Product {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
}
```

**2. Use correct types:**
```java
private BigDecimal price;          // For money
private LocalDateTime createdAt;   // For timestamps
```

**3. Let Spring generate repositories:**
```java
@Repository
public interface ProductRepository extends JpaRepository<Product, Long> {
    // Spring generates implementation
}
```

**4. Use dependency injection:**
```java
@Controller
public class ProductController {
    private final ProductService service;
    
    @Autowired
    public ProductController(ProductService service) {
        this.service = service;
    }
}
```

---

## TROUBLESHOOTING

### Issue 1: Application Won't Start

**Symptoms:**
- Port 8080 already in use
- Database connection errors

**Solutions:**
```properties
# Change port
server.port=8081

# Check database credentials
spring.datasource.username=root
spring.datasource.password=your_actual_password

# Verify database exists
# Run: CREATE DATABASE product_management;
```

---

### Issue 2: Entity Not Recognized

**Symptoms:**
- Table not created
- "Not a managed type" error

**Solutions:**
- Ensure @Entity annotation present
- Check @SpringBootApplication is in root package
- Verify entity package is scanned:
```java
@SpringBootApplication
@EntityScan("com.example.productmanagement.entity")
public class ProductManagementApplication {
    // ...
}
```

---

### Issue 3: Repository Methods Not Working

**Symptoms:**
- Method not found
- Unexpected query results

**Solutions:**
- Check method naming conventions
- Use correct parameter types
- Enable SQL logging:
```properties
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.format_sql=true
```

---

### Issue 4: Thymeleaf Template Not Found

**Symptoms:**
- TemplateInputException
- 404 error

**Solutions:**
- Verify template in `src/main/resources/templates/`
- Check file extension is `.html`
- Verify controller returns correct view name:
```java
return "product-list";  // Looks for product-list.html
```

---

### Issue 5: Form Binding Not Working

**Symptoms:**
- Null values in Product object
- Form data not saved

**Solutions:**
```html
<!-- Ensure form binding is correct -->
<form th:action="@{/products/save}" th:object="${product}" method="post">
    <!-- Use th:field -->
    <input type="text" th:field="*{name}" />
    <!-- NOT just name="" -->
</form>
```

---

## RESOURCES

### Official Documentation:
- **Spring Boot:** https://spring.io/projects/spring-boot
- **Spring Data JPA:** https://spring.io/projects/spring-data-jpa
- **Thymeleaf:** https://www.thymeleaf.org/
- **MySQL Connector:** https://dev.mysql.com/doc/connector-j/

### Tutorials:
- **Spring Boot Guides:** https://spring.io/guides
- **Baeldung Spring:** https://www.baeldung.com/spring-boot
- **Java Brains YouTube:** Spring Boot tutorials

### Tools:
- **Spring Initializr:** https://start.spring.io/
- **VS Code Spring:** https://code.visualstudio.com/docs/java/java-spring-boot
- **Maven Repository:** https://mvnrepository.com/

---

## SUMMARY

### In-Class Checklist:
✅ Created Spring Boot project  
✅ Configured application.properties  
✅ Created Product entity with JPA  
✅ Implemented ProductRepository  
✅ Built Service layer  
✅ Created Controller with CRUD  
✅ Built views with Thymeleaf  
✅ Tested all operations

### Homework Checklist:
✅ Advanced search functionality  
✅ Server-side validation  
✅ Sorting and filtering  
✅ Statistics dashboard  
✅ Code quality and documentation

### Key Takeaways:
1. **Spring Boot simplifies configuration** - Convention over configuration
2. **Spring Data JPA eliminates boilerplate** - No SQL for basic CRUD
3. **Dependency Injection promotes loose coupling** - Testable code
4. **Thymeleaf enables natural templates** - HTML-valid templates
5. **Annotations drive behavior** - Less XML, more productivity

### Next Lab Preview:

**Lab 8: REST API & DTO Pattern**
- Building RESTful APIs with @RestController
- JSON request/response handling
- DTO (Data Transfer Object) pattern
- Exception handling with @ControllerAdvice
- Testing APIs with Postman/Thunder Client
- HTTP status codes and ResponseEntity

---

**Good luck with Lab 7! 🚀**

*Remember: Spring Boot is all about productivity and convention over configuration. Let Spring do the heavy lifting!*