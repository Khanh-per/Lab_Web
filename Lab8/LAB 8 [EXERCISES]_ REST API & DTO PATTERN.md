---
title: 'LAB 8 [EXERCISES]: REST API & DTO PATTERN'

---

---
title: 'LAB 8 EXERCISES: REST API & DTO PATTERN'

---

# LAB 8 EXERCISES: REST API & DTO PATTERN

**Course:** Web Application Development  
**Lab Duration:** 2.5 hours  
**Total Points:** 100 points (In-class: 60 points, Homework: 40 points)

---

## 📚 BEFORE YOU START

### Prerequisites:
- ✅ Completed Lab 7 (Spring Boot + JPA CRUD)
- ✅ Read Lab 8 Setup Guide
- ✅ Understanding of HTTP methods and status codes
- ✅ Thunder Client or Postman installed (for testing)
- ✅ MySQL running with database ready

### Software Setup:
1. **Java:** JDK 17+
2. **IDE:** VS Code with Spring extensions
3. **API Testing:** Thunder Client (VS Code extension) or Postman
4. **Database:** MySQL 8.0+

### Lab Objectives:
By the end of this lab, you should be able to:
1. Build RESTful APIs with @RestController
2. Implement DTO pattern for request/response
3. Use HTTP methods correctly (GET, POST, PUT, DELETE)
4. Handle exceptions with @RestControllerAdvice
5. Validate inputs with @Valid
6. Test APIs with REST clients
7. Return proper HTTP status codes

---

## PART A: IN-CLASS EXERCISES (60 points)

**Time Allocation:** 2.5 hours  
**Submission:** Demonstrate API endpoints to instructor

---

### EXERCISE 1: PROJECT SETUP & ENTITY (15 points)

**Estimated Time:** 25 minutes

#### Task 1.1: Create Spring Boot Project (5 points)

**Using Spring Initializr:**

1. Press `Ctrl+Shift+P` → "Spring Initializr: Create a Maven Project"
2. Configure:
   - Spring Boot: **3.3.x**
   - Group: **com.example**
   - Artifact: **customer-api**
   - Java: **17**
   
3. Dependencies:
   - ✅ Spring Web
   - ✅ Spring Data JPA
   - ✅ MySQL Driver
   - ✅ Validation

**Evaluation Criteria:**
| Criteria | Points |
|----------|--------|
| Project created successfully | 2 |
| All dependencies added | 2 |
| Project structure correct | 1 |

---

#### Task 1.2: Database Setup (5 points)

**Create database and table:**

```sql
CREATE DATABASE customer_management;
USE customer_management;

CREATE TABLE customers (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    customer_code VARCHAR(20) UNIQUE NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    status ENUM('ACTIVE', 'INACTIVE') DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Sample data
INSERT INTO customers (customer_code, full_name, email, phone, address, status) VALUES
('C001', 'John Doe', 'john.doe@example.com', '+1-555-0101', '123 Main St, New York', 'ACTIVE'),
('C002', 'Jane Smith', 'jane.smith@example.com', '+1-555-0102', '456 Oak Ave, Los Angeles', 'ACTIVE'),
('C003', 'Bob Johnson', 'bob.johnson@example.com', '+1-555-0103', '789 Pine Rd, Chicago', 'ACTIVE');
```

**Configure application.properties:**
```properties
spring.application.name=customer-api
server.port=8080

spring.datasource.url=jdbc:mysql://localhost:3306/customer_management?useSSL=false&serverTimezone=UTC
spring.datasource.username=root
spring.datasource.password=your_password

spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.format_sql=true
```

**Evaluation Criteria:**
| Criteria | Points |
|----------|--------|
| Database created with data | 2 |
| application.properties configured | 2 |
| Application connects successfully | 1 |

---

#### Task 1.3: Create Customer Entity (5 points)

**File:** `src/main/java/com/example/customerapi/entity/Customer.java`

**Template to complete:**
```java
package com.example.customerapi.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

// TODO: Add @Entity annotation
// TODO: Add @Table annotation
public class Customer {
    
    // TODO: Add @Id and @GeneratedValue annotations
    private Long id;
    
    // TODO: Add @Column annotations with constraints
    private String customerCode;
    private String fullName;
    private String email;
    private String phone;
    private String address;
    
    // TODO: Add @Enumerated annotation
    private CustomerStatus status;
    
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    
    // TODO: Add @PrePersist method
    
    // TODO: Add @PreUpdate method
    
    // TODO: Add constructors, getters, setters
}

// TODO: Create CustomerStatus enum (ACTIVE, INACTIVE)
```

**Evaluation Criteria:**
| Criteria | Points |
|----------|--------|
| JPA annotations correct | 2 |
| Lifecycle callbacks implemented | 1 |
| Getters/setters complete | 1 |
| Enum created | 1 |

**Checkpoint #1:** Verify entity mapping by running the application.

---

### EXERCISE 2: DTO LAYER (15 points)

**Estimated Time:** 30 minutes

#### Task 2.1: Create Request DTO (5 points)

**File:** `src/main/java/com/example/customerapi/dto/CustomerRequestDTO.java`

**Requirements:**
- Validation annotations on all fields
- No ID field (auto-generated)
- Proper constraints

**Template:**
```java
package com.example.customerapi.dto;

import jakarta.validation.constraints.*;

public class CustomerRequestDTO {
    
    // TODO: Add validation annotations
    // @NotBlank, @Size, @Pattern
    private String customerCode;
    
    // TODO: Add validation
    // @NotBlank, @Size
    private String fullName;
    
    // TODO: Add validation
    // @NotBlank, @Email
    private String email;
    
    // TODO: Add validation
    // @Pattern for phone format
    private String phone;
    
    // TODO: Add validation
    // @Size
    private String address;
    
    private String status;
    
    // TODO: Add constructors, getters, setters
}
```

**Validation Requirements:**
- customerCode: Not blank, 3-20 chars, pattern `^C\\d{3,}$`
- fullName: Not blank, 2-100 chars
- email: Not blank, valid email format
- phone: Pattern `^\\+?[0-9]{10,20}$`
- address: Max 500 chars

**Evaluation Criteria:**
| Criteria | Points |
|----------|--------|
| All validation annotations correct | 3 |
| Constructors and getters/setters | 1 |
| No ID field (correct design) | 1 |

---

#### Task 2.2: Create Response DTO (5 points)

**File:** `src/main/java/com/example/customerapi/dto/CustomerResponseDTO.java`

**Requirements:**
- Include ID field
- Include all safe fields
- No sensitive data
- No internal fields

**Template:**
```java
package com.example.customerapi.dto;

import java.time.LocalDateTime;

public class CustomerResponseDTO {
    
    private Long id;
    private String customerCode;
    private String fullName;
    private String email;
    private String phone;
    private String address;
    private String status;
    private LocalDateTime createdAt;
    
    // TODO: Add constructors, getters, setters
}
```

**Evaluation Criteria:**
| Criteria | Points |
|----------|--------|
| All response fields present | 2 |
| Proper data types used | 2 |
| Constructors and getters/setters | 1 |

---

#### Task 2.3: Create Error Response DTO (5 points)

**File:** `src/main/java/com/example/customerapi/dto/ErrorResponseDTO.java`

**Template:**
```java
package com.example.customerapi.dto;

import java.time.LocalDateTime;
import java.util.List;

public class ErrorResponseDTO {
    
    private LocalDateTime timestamp;
    private int status;
    private String error;
    private String message;
    private String path;
    private List<String> details;
    
    // TODO: Add constructor that sets timestamp automatically
    
    // TODO: Add parameterized constructor
    
    // TODO: Add getters and setters
}
```

**Evaluation Criteria:**
| Criteria | Points |
|----------|--------|
| All error fields present | 2 |
| Timestamp auto-generated | 2 |
| Getters and setters | 1 |

**Checkpoint #2:** Verify all DTO classes compile without errors.

---

### EXERCISE 3: REPOSITORY & SERVICE (10 points)

**Estimated Time:** 20 minutes

#### Task 3.1: Create Repository (3 points)

**File:** `src/main/java/com/example/customerapi/repository/CustomerRepository.java`

```java
package com.example.customerapi.repository;

import com.example.customerapi.entity.Customer;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;

@Repository
public interface CustomerRepository extends JpaRepository<Customer, Long> {
    
    // TODO: Add method to find by customer code
    
    // TODO: Add method to find by email
    
    // TODO: Add method to check if customer code exists
    
    // TODO: Add method to check if email exists
    
    // TODO: Add method to find by status
}
```

**Evaluation Criteria:**
| Criteria | Points |
|----------|--------|
| Repository extends JpaRepository | 1 |
| Custom methods defined | 2 |

---

#### Task 3.2: Create Service Interface (2 points)

**File:** `src/main/java/com/example/customerapi/service/CustomerService.java`

```java
package com.example.customerapi.service;

import com.example.customerapi.dto.CustomerRequestDTO;
import com.example.customerapi.dto.CustomerResponseDTO;
import java.util.List;

public interface CustomerService {
    
    List<CustomerResponseDTO> getAllCustomers();
    CustomerResponseDTO getCustomerById(Long id);
    CustomerResponseDTO createCustomer(CustomerRequestDTO requestDTO);
    CustomerResponseDTO updateCustomer(Long id, CustomerRequestDTO requestDTO);
    void deleteCustomer(Long id);
}
```

---

#### Task 3.3: Implement Service (5 points)

**File:** `src/main/java/com/example/customerapi/service/CustomerServiceImpl.java`

**Template:**
```java
package com.example.customerapi.service;

import com.example.customerapi.dto.*;
import com.example.customerapi.entity.Customer;
import com.example.customerapi.repository.CustomerRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@Transactional
public class CustomerServiceImpl implements CustomerService {
    
    private final CustomerRepository customerRepository;
    
    @Autowired
    public CustomerServiceImpl(CustomerRepository customerRepository) {
        this.customerRepository = customerRepository;
    }
    
    @Override
    public List<CustomerResponseDTO> getAllCustomers() {
        // TODO: Get all customers from repository
        // TODO: Convert to DTO and return
        return null;
    }
    
    @Override
    public CustomerResponseDTO getCustomerById(Long id) {
        // TODO: Find customer by ID
        // TODO: Throw ResourceNotFoundException if not found
        // TODO: Convert to DTO and return
        return null;
    }
    
    @Override
    public CustomerResponseDTO createCustomer(CustomerRequestDTO requestDTO) {
        // TODO: Check for duplicate customer code
        // TODO: Check for duplicate email
        // TODO: Convert DTO to Entity
        // TODO: Save to repository
        // TODO: Convert saved entity to Response DTO
        return null;
    }
    
    @Override
    public CustomerResponseDTO updateCustomer(Long id, CustomerRequestDTO requestDTO) {
        // TODO: Find existing customer
        // TODO: Check for duplicate email (if changed)
        // TODO: Update fields
        // TODO: Save and return DTO
        return null;
    }
    
    @Override
    public void deleteCustomer(Long id) {
        // TODO: Check if customer exists
        // TODO: Delete from repository
    }
    
    // TODO: Add helper method to convert Entity to ResponseDTO
    private CustomerResponseDTO convertToResponseDTO(Customer customer) {
        return null;
    }
    
    // TODO: Add helper method to convert RequestDTO to Entity
    private Customer convertToEntity(CustomerRequestDTO dto) {
        return null;
    }
}
```

**Evaluation Criteria:**
| Criteria | Points |
|----------|--------|
| All CRUD methods implemented | 3 |
| DTO conversion methods work | 1 |
| Proper exception handling | 1 |

**Checkpoint #3:** Test service methods with a temporary test in main class.

---

### EXERCISE 4: REST CONTROLLER (20 points)

**Estimated Time:** 50 minutes

#### Task 4.1: Create Basic REST Controller (10 points)

**File:** `src/main/java/com/example/customerapi/controller/CustomerRestController.java`

**Template:**
```java
package com.example.customerapi.controller;

import com.example.customerapi.dto.CustomerRequestDTO;
import com.example.customerapi.dto.CustomerResponseDTO;
import com.example.customerapi.service.CustomerService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

// TODO: Add @RestController annotation
// TODO: Add @RequestMapping("/api/customers")
// TODO: Add @CrossOrigin(origins = "*")
public class CustomerRestController {
    
    // TODO: Inject CustomerService
    private final CustomerService customerService;
    
    // TODO: Add @Autowired constructor
    
    // TODO: GET /api/customers - Get all customers
    // Return: ResponseEntity<List<CustomerResponseDTO>>
    public ResponseEntity<List<CustomerResponseDTO>> getAllCustomers() {
        return null;
    }
    
    // TODO: GET /api/customers/{id} - Get customer by ID
    // Return: ResponseEntity<CustomerResponseDTO>
    public ResponseEntity<CustomerResponseDTO> getCustomerById(Long id) {
        return null;
    }
    
    // TODO: POST /api/customers - Create new customer
    // Parameter: @Valid @RequestBody CustomerRequestDTO
    // Return: ResponseEntity<CustomerResponseDTO> with status 201
    public ResponseEntity<CustomerResponseDTO> createCustomer(CustomerRequestDTO requestDTO) {
        return null;
    }
    
    // TODO: PUT /api/customers/{id} - Update customer
    // Parameters: @PathVariable Long id, @Valid @RequestBody CustomerRequestDTO
    // Return: ResponseEntity<CustomerResponseDTO>
    public ResponseEntity<CustomerResponseDTO> updateCustomer(Long id, CustomerRequestDTO requestDTO) {
        return null;
    }
    
    // TODO: DELETE /api/customers/{id} - Delete customer
    // Return: ResponseEntity with success message
    public ResponseEntity<?> deleteCustomer(Long id) {
        return null;
    }
}
```

**Hints:**
```java
// Example: GET all
@GetMapping
public ResponseEntity<List<CustomerResponseDTO>> getAllCustomers() {
    List<CustomerResponseDTO> customers = customerService.getAllCustomers();
    return ResponseEntity.ok(customers);
}

// Example: POST create (status 201)
@PostMapping
public ResponseEntity<CustomerResponseDTO> createCustomer(@Valid @RequestBody CustomerRequestDTO dto) {
    CustomerResponseDTO created = customerService.createCustomer(dto);
    return ResponseEntity.status(HttpStatus.CREATED).body(created);
}

// Example: DELETE (with message)
@DeleteMapping("/{id}")
public ResponseEntity<Map<String, String>> deleteCustomer(@PathVariable Long id) {
    customerService.deleteCustomer(id);
    Map<String, String> response = new HashMap<>();
    response.put("message", "Customer deleted successfully");
    return ResponseEntity.ok(response);
}
```

**Evaluation Criteria:**
| Criteria | Points |
|----------|--------|
| @RestController configured | 2 |
| GET all endpoint works | 2 |
| GET by ID endpoint works | 1 |
| POST create endpoint works | 2 |
| PUT update endpoint works | 2 |
| DELETE endpoint works | 1 |

---

#### Task 4.2: Add Exception Handling (10 points)

**Create Custom Exceptions:**

**File:** `src/main/java/com/example/customerapi/exception/ResourceNotFoundException.java`
```java
package com.example.customerapi.exception;

public class ResourceNotFoundException extends RuntimeException {
    public ResourceNotFoundException(String message) {
        super(message);
    }
}
```

**File:** `src/main/java/com/example/customerapi/exception/DuplicateResourceException.java`
```java
package com.example.customerapi.exception;

public class DuplicateResourceException extends RuntimeException {
    public DuplicateResourceException(String message) {
        super(message);
    }
}
```

**File:** `src/main/java/com/example/customerapi/exception/GlobalExceptionHandler.java`

**Template:**
```java
package com.example.customerapi.exception;

import com.example.customerapi.dto.ErrorResponseDTO;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.context.request.WebRequest;

import java.util.ArrayList;
import java.util.List;

// TODO: Add @RestControllerAdvice annotation
public class GlobalExceptionHandler {
    
    // TODO: Handle ResourceNotFoundException (404)
    // @ExceptionHandler(ResourceNotFoundException.class)
    public ResponseEntity<ErrorResponseDTO> handleResourceNotFoundException(
            ResourceNotFoundException ex, WebRequest request) {
        // TODO: Create ErrorResponseDTO with 404 status
        // TODO: Return ResponseEntity with NOT_FOUND status
        return null;
    }
    
    // TODO: Handle DuplicateResourceException (409)
    // @ExceptionHandler(DuplicateResourceException.class)
    public ResponseEntity<ErrorResponseDTO> handleDuplicateResourceException(
            DuplicateResourceException ex, WebRequest request) {
        // TODO: Create ErrorResponseDTO with 409 status
        // TODO: Return ResponseEntity with CONFLICT status
        return null;
    }
    
    // TODO: Handle Validation Errors (400)
    // @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ErrorResponseDTO> handleValidationException(
            MethodArgumentNotValidException ex, WebRequest request) {
        // TODO: Extract validation errors from FieldErrors
        // TODO: Create ErrorResponseDTO with details list
        // TODO: Return ResponseEntity with BAD_REQUEST status
        return null;
    }
    
    // TODO: Handle general exceptions (500)
    // @ExceptionHandler(Exception.class)
    public ResponseEntity<ErrorResponseDTO> handleGlobalException(
            Exception ex, WebRequest request) {
        // TODO: Create ErrorResponseDTO with 500 status
        // TODO: Return ResponseEntity with INTERNAL_SERVER_ERROR status
        return null;
    }
}
```

**Evaluation Criteria:**
| Criteria | Points |
|----------|--------|
| Custom exceptions created | 2 |
| @RestControllerAdvice configured | 2 |
| ResourceNotFoundException handler | 2 |
| DuplicateResourceException handler | 2 |
| Validation exception handler | 2 |

**Checkpoint #4:** Test all endpoints using Thunder Client.

---

## PART B: HOMEWORK EXERCISES (40 points)

**Deadline:** 1 week  
**Submission:** Project ZIP + Postman collection

---

### EXERCISE 5: SEARCH & FILTER ENDPOINTS (12 points)

**Estimated Time:** 45 minutes

#### Task 5.1: Search Customers (6 points)

Add search functionality to find customers by keyword.

**Update CustomerRepository:**
```java
@Query("SELECT c FROM Customer c WHERE " +
       "LOWER(c.fullName) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
       "LOWER(c.email) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
       "LOWER(c.customerCode) LIKE LOWER(CONCAT('%', :keyword, '%'))")
List<Customer> searchCustomers(@Param("keyword") String keyword);
```

**Update Service:**
```java
List<CustomerResponseDTO> searchCustomers(String keyword);
```

**Add to Controller:**
```java
@GetMapping("/search")
public ResponseEntity<List<CustomerResponseDTO>> searchCustomers(
        @RequestParam String keyword) {
    List<CustomerResponseDTO> customers = customerService.searchCustomers(keyword);
    return ResponseEntity.ok(customers);
}
```

**Test:**
```
GET /api/customers/search?keyword=john
```

---

#### Task 5.2: Filter by Status (3 points)

Add endpoint to filter customers by status.

**Add to Controller:**
```java
@GetMapping("/status/{status}")
public ResponseEntity<List<CustomerResponseDTO>> getCustomersByStatus(
        @PathVariable String status) {
    List<CustomerResponseDTO> customers = customerService.getCustomersByStatus(status);
    return ResponseEntity.ok(customers);
}
```

**Test:**
```
GET /api/customers/status/ACTIVE
GET /api/customers/status/INACTIVE
```

---

#### Task 5.3: Advanced Search with Multiple Criteria (3 points)

Create endpoint for searching with multiple optional parameters.

**Add to Controller:**
```java
@GetMapping("/advanced-search")
public ResponseEntity<List<CustomerResponseDTO>> advancedSearch(
        @RequestParam(required = false) String name,
        @RequestParam(required = false) String email,
        @RequestParam(required = false) String status) {
    // Implementation
}
```

---

### EXERCISE 6: PAGINATION & SORTING (10 points)

**Estimated Time:** 40 minutes

#### Task 6.1: Add Pagination (5 points)

Implement pagination for customer list.

**Update Service to use Pageable:**
```java
Page<CustomerResponseDTO> getAllCustomers(int page, int size);
```

**Update Controller:**
```java
@GetMapping
public ResponseEntity<Map<String, Object>> getAllCustomers(
        @RequestParam(defaultValue = "0") int page,
        @RequestParam(defaultValue = "10") int size) {
    
    Page<CustomerResponseDTO> customerPage = customerService.getAllCustomers(page, size);
    
    Map<String, Object> response = new HashMap<>();
    response.put("customers", customerPage.getContent());
    response.put("currentPage", customerPage.getNumber());
    response.put("totalItems", customerPage.getTotalElements());
    response.put("totalPages", customerPage.getTotalPages());
    
    return ResponseEntity.ok(response);
}
```

**Test:**
```
GET /api/customers?page=0&size=5
GET /api/customers?page=1&size=10
```

---

#### Task 6.2: Add Sorting (3 points)

Add sorting capability to customer list.

**Update Controller:**
```java
@GetMapping
public ResponseEntity<List<CustomerResponseDTO>> getAllCustomers(
        @RequestParam(required = false) String sortBy,
        @RequestParam(defaultValue = "asc") String sortDir) {
    
    Sort sort = sortDir.equalsIgnoreCase("asc") 
        ? Sort.by(sortBy).ascending() 
        : Sort.by(sortBy).descending();
    
    List<CustomerResponseDTO> customers = customerService.getAllCustomers(sort);
    return ResponseEntity.ok(customers);
}
```

**Test:**
```
GET /api/customers?sortBy=fullName&sortDir=asc
GET /api/customers?sortBy=createdAt&sortDir=desc
```

---

#### Task 6.3: Combine Pagination and Sorting (2 points)

Combine both features in one endpoint.

**Test:**
```
GET /api/customers?page=0&size=5&sortBy=fullName&sortDir=asc
```

---

### EXERCISE 7: PARTIAL UPDATE WITH PATCH (10 points)

**Estimated Time:** 35 minutes

#### Task 7.1: Create Update DTO (3 points)

**File:** `CustomerUpdateDTO.java`
```java
public class CustomerUpdateDTO {
    private String fullName;
    private String email;
    private String phone;
    private String address;
    // All fields optional for partial update
}
```

---

#### Task 7.2: Implement PATCH Endpoint (5 points)

**Add to Controller:**
```java
@PatchMapping("/{id}")
public ResponseEntity<CustomerResponseDTO> partialUpdateCustomer(
        @PathVariable Long id,
        @RequestBody CustomerUpdateDTO updateDTO) {
    
    CustomerResponseDTO updated = customerService.partialUpdateCustomer(id, updateDTO);
    return ResponseEntity.ok(updated);
}
```

**Add to Service:**
```java
public CustomerResponseDTO partialUpdateCustomer(Long id, CustomerUpdateDTO updateDTO) {
    Customer customer = customerRepository.findById(id)
        .orElseThrow(() -> new ResourceNotFoundException("Customer not found"));
    
    // Only update non-null fields
    if (updateDTO.getFullName() != null) {
        customer.setFullName(updateDTO.getFullName());
    }
    if (updateDTO.getEmail() != null) {
        customer.setEmail(updateDTO.getEmail());
    }
    // ... other fields
    
    return convertToResponseDTO(customerRepository.save(customer));
}
```

---

#### Task 7.3: Test PATCH vs PUT (2 points)

**Test cases:**
```
PUT /api/customers/1
{
    "customerCode": "C001",
    "fullName": "John Updated",
    "email": "john.updated@example.com",
    "phone": "+1-555-9999",
    "address": "New Address"
}

PATCH /api/customers/1
{
    "fullName": "John Partially Updated"
}
```

---

### EXERCISE 8: API DOCUMENTATION (8 points)

**Estimated Time:** 30 minutes

#### Task 8.1: Create Postman Collection (4 points)

Create a Postman collection with all endpoints:
1. GET all customers
2. GET customer by ID
3. POST create customer
4. PUT update customer
5. PATCH partial update
6. DELETE customer
7. Search customers
8. Filter by status

**Save as:** `Customer_API.postman_collection.json`

---

#### Task 8.2: Document API Responses (2 points)

Create `API_DOCUMENTATION.md` file:

```markdown
# Customer API Documentation

## Base URL
`http://localhost:8080/api/customers`

## Endpoints

### 1. Get All Customers
**GET** `/api/customers`

**Response:** 200 OK
```json
[
    {
        "id": 1,
        "customerCode": "C001",
        ...
    }
]
```

### 2. Get Customer by ID
**GET** `/api/customers/{id}`

**Response:** 200 OK
...

### Error Responses

**404 Not Found**
```json
{
    "timestamp": "2024-11-03T10:00:00",
    "status": 404,
    ...
}
```

---

#### Task 8.3: Add Examples for Each Status Code (2 points)

Document examples for:
- 200 OK
- 201 Created
- 400 Bad Request (validation)
- 404 Not Found
- 409 Conflict (duplicate)
- 500 Internal Server Error

---

## BONUS EXERCISES (Optional - Extra Credit)

**Not required, earn up to 20 bonus points**

### BONUS 1: API Versioning (6 points)

Implement API versioning.

**Create v1 and v2 controllers:**
```java
@RestController
@RequestMapping("/api/v1/customers")
public class CustomerRestControllerV1 {
    // Original implementation
}

@RestController
@RequestMapping("/api/v2/customers")
public class CustomerRestControllerV2 {
    // Enhanced version with new fields
}
```

---

### BONUS 2: HATEOAS Links (7 points)

Add hypermedia links to responses.

**Add dependency:**
```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-hateoas</artifactId>
</dependency>
```

**Update Response DTO:**
```java
import org.springframework.hateoas.RepresentationModel;

public class CustomerResponseDTO extends RepresentationModel<CustomerResponseDTO> {
    // ... fields
}
```

**Add links in controller:**
```java
@GetMapping("/{id}")
public ResponseEntity<CustomerResponseDTO> getCustomerById(@PathVariable Long id) {
    CustomerResponseDTO customer = customerService.getCustomerById(id);
    
    customer.add(linkTo(methodOn(CustomerRestController.class).getCustomerById(id)).withSelfRel());
    customer.add(linkTo(methodOn(CustomerRestController.class).getAllCustomers()).withRel("all-customers"));
    
    return ResponseEntity.ok(customer);
}
```

**Response with links:**
```json
{
    "id": 1,
    "customerCode": "C001",
    "fullName": "John Doe",
    "_links": {
        "self": {
            "href": "http://localhost:8080/api/customers/1"
        },
        "all-customers": {
            "href": "http://localhost:8080/api/customers"
        }
    }
}
```

---

### BONUS 3: Rate Limiting (7 points)

Implement rate limiting for API endpoints.

**Add Bucket4j dependency:**
```xml
<dependency>
    <groupId>com.github.vladimir-bukhtoyarov</groupId>
    <artifactId>bucket4j-core</artifactId>
    <version>8.1.0</version>
</dependency>
```

**Create rate limiting interceptor:**
```java
@Component
public class RateLimitInterceptor implements HandlerInterceptor {
    
    private final Map<String, Bucket> cache = new ConcurrentHashMap<>();
    
    @Override
    public boolean preHandle(HttpServletRequest request, 
                            HttpServletResponse response, 
                            Object handler) throws Exception {
        
        String key = request.getRemoteAddr();
        Bucket bucket = cache.computeIfAbsent(key, k -> createNewBucket());
        
        if (bucket.tryConsume(1)) {
            return true;
        }
        
        response.setStatus(429);
        response.getWriter().write("Too many requests");
        return false;
    }
    
    private Bucket createNewBucket() {
        return Bucket.builder()
            .addLimit(Bandwidth.simple(100, Duration.ofMinutes(1)))
            .build();
    }
}
```

---

## HOMEWORK SUBMISSION GUIDELINES

### What to Submit:

**1. Complete Project ZIP:**
```
customer-api.zip
├── src/main/java/com/example/customerapi/
│   ├── entity/Customer.java
│   ├── dto/
│   │   ├── CustomerRequestDTO.java
│   │   ├── CustomerResponseDTO.java
│   │   └── ErrorResponseDTO.java
│   ├── repository/CustomerRepository.java
│   ├── service/
│   │   ├── CustomerService.java
│   │   └── CustomerServiceImpl.java
│   ├── controller/CustomerRestController.java
│   └── exception/
│       ├── ResourceNotFoundException.java
│       ├── DuplicateResourceException.java
│       └── GlobalExceptionHandler.java
├── pom.xml
└── README.md
```

---

**2. README.md:**
```markdown
# Customer API

## Student Information
- **Name:** [Your Name]
- **Student ID:** [Your ID]
- **Class:** [Your Class]

## API Endpoints

### Base URL
`http://localhost:8080/api/customers`

### Endpoints Implemented
- ✅ GET /api/customers - Get all customers
- ✅ GET /api/customers/{id} - Get by ID
- ✅ POST /api/customers - Create customer
- ✅ PUT /api/customers/{id} - Update customer
- ✅ DELETE /api/customers/{id} - Delete customer
- ✅ GET /api/customers/search?keyword={keyword} - Search
- ✅ GET /api/customers/status/{status} - Filter by status
- ✅ Pagination and sorting
- ✅ PATCH for partial update
- [ ] Bonus features

## How to Run
1. Create database: `customer_management`
2. Update `application.properties` with your MySQL credentials
3. Run: `mvn spring-boot:run`
4. Test: Open Thunder Client or Postman
5. Import collection: `Customer_API.postman_collection.json`

## Testing
All endpoints tested with Thunder Client.
See `screenshots/` folder for test results.

## Features Implemented
- DTO pattern for request/response
- Validation with @Valid
- Exception handling with @RestControllerAdvice
- Custom exceptions (404, 409)
- Proper HTTP status codes
- Search and filter
- Pagination
- Sorting

## Known Issues
- [List any bugs]

## Time Spent
Approximately [X] hours
```

---

**3. API Testing Collection:**
- Postman collection JSON file
- OR Thunder Client collection export

---

**4. Screenshots:**
- GET all customers - 200 OK
- GET by ID - 200 OK
- POST create - 201 Created
- PUT update - 200 OK
- DELETE - 200 OK
- Validation error - 400 Bad Request
- Not found error - 404
- Duplicate error - 409 Conflict
- Search results
- Paginated results

---

**5. Database Export:**
- `database.sql` with structure and sample data

---

## EVALUATION RUBRIC

### In-Class (60 points):
| Component | Points |
|-----------|--------|
| Project Setup & Entity | 15 |
| DTO Layer | 15 |
| Repository & Service | 10 |
| REST Controller | 10 |
| Exception Handling | 10 |

### Homework (40 points):
| Exercise | Points |
|----------|--------|
| Search & Filter | 12 |
| Pagination & Sorting | 10 |
| Partial Update (PATCH) | 10 |
| API Documentation | 8 |

### Bonus (20 points):
| Feature | Points |
|---------|--------|
| API Versioning | 6 |
| HATEOAS | 7 |
| Rate Limiting | 7 |

### Code Quality:
- Poor exception handling: -5
- Missing validation: -5
- Improper HTTP status codes: -5
- No DTO conversion: -10
- Exposing entity directly: -10

**Total Possible: 120 points (including bonus)**

---

## COMMON MISTAKES TO AVOID

### ❌ DON'T:

**1. Return Entity directly:**
```java
// DON'T
@GetMapping
public List<Customer> getAll() {
    return customerRepository.findAll();
}
```

**2. Use wrong HTTP methods:**
```java
// DON'T use GET for creating data
@GetMapping("/create")
public Customer create(@RequestParam String name) { }
```

**3. Ignore validation:**
```java
// DON'T forget @Valid
@PostMapping
public Customer create(@RequestBody CustomerRequestDTO dto) { }
```

**4. Use wrong status codes:**
```java
// DON'T return 200 for creation
@PostMapping
public ResponseEntity<Customer> create(...) {
    return ResponseEntity.ok(created);  // Should be 201!
}
```

### ✅ DO:

**1. Use DTOs:**
```java
@GetMapping
public List<CustomerResponseDTO> getAll() {
    return customerService.getAllCustomers();
}
```

**2. Use correct HTTP methods:**
```java
@PostMapping  // For create
@PutMapping   // For full update
@PatchMapping // For partial update
@DeleteMapping // For delete
```

**3. Validate inputs:**
```java
@PostMapping
public ResponseEntity<CustomerResponseDTO> create(
    @Valid @RequestBody CustomerRequestDTO dto) {
    // ...
}
```

**4. Return proper status codes:**
```java
@PostMapping
public ResponseEntity<CustomerResponseDTO> create(...) {
    CustomerResponseDTO created = service.create(dto);
    return ResponseEntity.status(HttpStatus.CREATED).body(created);
}
```

---

## TROUBLESHOOTING

### Issue 1: 404 on API endpoints

**Solution:**
- Verify @RestController annotation
- Check @RequestMapping path
- Ensure application is running
- Test URL: http://localhost:8080/api/customers

---

### Issue 2: Validation not working

**Solution:**
- Add @Valid annotation
- Ensure validation dependency in pom.xml
- Check MethodArgumentNotValidException handler

---

### Issue 3: JSON parsing errors

**Solution:**
- Verify Content-Type: application/json header
- Check JSON syntax
- Ensure DTOs have proper getters/setters

---

### Issue 4: Circular reference in JSON

**Solution:**
```java
// Add to entity if needed
@JsonIgnoreProperties({"hibernateLazyInitializer", "handler"})
```

---

### Issue 5: CORS errors from frontend

**Solution:**
```java
@CrossOrigin(origins = "http://localhost:3000")
// Or in config class:
@Configuration
public class WebConfig implements WebMvcConfigurer {
    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/api/**")
                .allowedOrigins("*")
                .allowedMethods("*");
    }
}
```

---

## TESTING CHECKLIST

### Thunder Client / Postman Tests:

✅ **GET /api/customers** - Returns list (200)  
✅ **GET /api/customers/1** - Returns single customer (200)  
✅ **GET /api/customers/999** - Returns 404  
✅ **POST /api/customers** - Creates customer (201)  
✅ **POST /api/customers** - Validation error (400)  
✅ **POST /api/customers** - Duplicate error (409)  
✅ **PUT /api/customers/1** - Updates customer (200)  
✅ **DELETE /api/customers/1** - Deletes customer (200)  
✅ **GET /api/customers/search?keyword=john** - Search works  
✅ **GET /api/customers?page=0&size=5** - Pagination works

---

## RESOURCES

### REST API Design:
- **REST API Tutorial:** https://restfulapi.net/
- **HTTP Status Codes:** https://httpstatuses.com/
- **Richardson Maturity Model:** https://martinfowler.com/articles/richardsonMaturityModel.html

### Spring Boot REST:
- **Spring REST Guide:** https://spring.io/guides/gs/rest-service/
- **Spring Data REST:** https://spring.io/projects/spring-data-rest
- **Spring HATEOAS:** https://spring.io/projects/spring-hateoas

### Testing Tools:
- **Postman:** https://www.postman.com/
- **Thunder Client:** VS Code extension
- **RESTClient:** VS Code extension

---

## SUMMARY

### In-Class Checklist:
✅ Created REST API project  
✅ Implemented Entity and DTOs  
✅ Built Repository and Service layers  
✅ Created REST Controller  
✅ Handled exceptions globally  
✅ Tested all endpoints

### Homework Checklist:
✅ Search and filter endpoints  
✅ Pagination and sorting  
✅ Partial update with PATCH  
✅ API documentation  
✅ Postman collection

### Key Takeaways:
1. **REST API uses HTTP methods** - GET, POST, PUT, DELETE
2. **DTO pattern protects data** - Don't expose entities
3. **Validation is critical** - Always use @Valid
4. **Exception handling is centralized** - @RestControllerAdvice
5. **HTTP status codes matter** - Use correct codes (200, 201, 404, 409)
6. **Testing is essential** - Use Thunder Client or Postman

### Next Lab Preview:

**Lab 9: Spring Security & JWT Authentication**
- Securing REST APIs
- User registration and login
- JWT token generation and validation
- Role-based authorization
- Protecting endpoints with @PreAuthorize
- Authentication filters

---

**Good luck with Lab 8! 🚀**

*Remember: A good API is consistent, well-documented, and properly secured!*