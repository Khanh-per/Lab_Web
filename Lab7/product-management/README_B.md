# title: 'LAB 6 [EXERCISE]: AUTHENTICATION & SESSION MANAGEMENT'


**Course:** Web Application Development  
**Lab Duration:** 2.5 hours  
**Total Points:** 100 points (In-class: 60 points, Homework: 40 points)

> Name: Le Hoang Khanh
> ID: ITCSIU23013
> Tutor: Nguyen Trung Nghia

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

    - Line: 120 - 128
}
```

**Add advanced search form to product-list.html.**
![screenshoot](/product-management/src/image/UpdateProduct_List_View.png)

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
- Result:
    ![screenshoot](/product-management/src/image/Validation_Annotation.png)

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

- Result: Filter by Name
    ![screenshot](/product-management/src/image/Fitter.png)

---

#### Task 7.2: Filter by Category (3 points)

Add category filter buttons/dropdown that maintains sorting.

- Result: 
    ![screenshot](/product-management/src/image/FilterByCategory.png)
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

Result:
    ![screenshot](/product-management/src/image/Dashboard.png)

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