---
title: 'LAB 8 [GUIDE]: REST API & DTO PATTERN'

---

---
title: LAB 8 REST API & DTO PATTERN

---

# LAB 8: REST API & DTO PATTERN
## Setup Guide & Sample Code

**Course:** Web Application Development  
**Duration:** 2.5 hours  
**Prerequisites:** Lab 7 completed (Spring Boot + JPA CRUD)

> **Note:** This lab focuses on building RESTful APIs with JSON responses. Read this BEFORE the lab session.

---

## 📋 TABLE OF CONTENTS

1. [Why REST API?](#1-why-rest-api)
2. [REST Architecture Overview](#2-rest-architecture-overview)
3. [Understanding DTO Pattern](#3-understanding-dto-pattern)
4. [Project Setup](#4-project-setup)
5. [Sample Code - REST API Implementation](#5-sample-code-rest-api-implementation)
6. [Exception Handling](#6-exception-handling)
7. [Testing with REST Client](#7-testing-with-rest-client)
8. [Comparison: Traditional vs REST API](#8-comparison-traditional-vs-rest-api)

---

## 1. WHY REST API?

### Problems with Traditional Web Applications

**From Lab 7 (Thymeleaf Views):**
```java
@Controller
public class ProductController {
    
    @GetMapping("/products")
    public String listProducts(Model model) {
        List<Product> products = productService.getAllProducts();
        model.addAttribute("products", products);
        return "product-list";  // Returns HTML page
    }
}
```

**Issues:**

1. ❌ **Tight Coupling** - Frontend (HTML) and backend are together
2. ❌ **Not Mobile Friendly** - Can't easily build mobile apps
3. ❌ **Limited Reusability** - Can't use same backend for web, mobile, desktop
4. ❌ **Difficult Integration** - Other systems can't consume your data
5. ❌ **Not Modern** - Modern apps use separate frontend frameworks (React, Vue, Angular)

### Benefits of REST API

✅ **Separation of Concerns** - Backend provides data, frontend handles presentation  
✅ **Platform Independent** - Any client (web, mobile, desktop) can consume API  
✅ **Reusability** - One API serves multiple applications  
✅ **Scalability** - Frontend and backend can scale independently  
✅ **Modern Architecture** - Industry standard for web services  
✅ **Easy Integration** - Other systems can integrate with your API

### Real-World Examples

**REST APIs you use daily:**
- Facebook API - Social media integration
- Google Maps API - Location services
- PayPal API - Payment processing
- Twitter API - Tweet automation
- Weather API - Weather data
- YouTube API - Video embedding

---

## 2. REST ARCHITECTURE OVERVIEW

### What is REST?

**REST (Representational State Transfer)** - An architectural style for designing networked applications.

**Key Principles:**

1. **Stateless** - Each request contains all information needed
2. **Client-Server** - Separation of concerns
3. **Cacheable** - Responses can be cached
4. **Uniform Interface** - Consistent API design
5. **Layered System** - Client doesn't know if connected directly to server

---

### HTTP Methods (CRUD Operations)

| HTTP Method | CRUD Operation | Purpose | Example |
|-------------|----------------|---------|---------|
| **GET** | Read | Retrieve data | GET /api/customers → Get all customers |
| **POST** | Create | Add new data | POST /api/customers → Create customer |
| **PUT** | Update | Replace data | PUT /api/customers/1 → Update customer 1 |
| **PATCH** | Update | Partial update | PATCH /api/customers/1 → Update some fields |
| **DELETE** | Delete | Remove data | DELETE /api/customers/1 → Delete customer 1 |

---

### REST API Request/Response Flow

```
┌─────────────┐                                    ┌─────────────┐
│   CLIENT    │                                    │   SERVER    │
│ (Browser/   │                                    │  (Spring    │
│  Mobile)    │                                    │   Boot)     │
└──────┬──────┘                                    └──────┬──────┘
       │                                                  │
       │ 1. HTTP Request                                 │
       │    GET /api/customers                           │
       │    Accept: application/json                     │
       ├────────────────────────────────────────────────>│
       │                                                  │
       │                              2. Process Request │
       │                                 - Call Service  │
       │                                 - Get from DB   │
       │                                 - Convert to DTO│
       │                                                  │
       │ 3. HTTP Response                                │
       │    Status: 200 OK                               │
       │    Content-Type: application/json               │
       │    Body: [{"id":1,"name":"John"}]               │
       │<────────────────────────────────────────────────┤
       │                                                  │
```

---

### HTTP Status Codes

**Success (2xx):**
- `200 OK` - Request succeeded
- `201 Created` - Resource created successfully
- `204 No Content` - Success but no data to return

**Client Errors (4xx):**
- `400 Bad Request` - Invalid request data
- `401 Unauthorized` - Authentication required
- `403 Forbidden` - No permission
- `404 Not Found` - Resource doesn't exist
- `409 Conflict` - Duplicate or conflicting data

**Server Errors (5xx):**
- `500 Internal Server Error` - Server-side error
- `503 Service Unavailable` - Server temporarily unavailable

---

### RESTful API Design Best Practices

**URL Structure:**
```
✅ Good:
GET    /api/customers              - Get all customers
GET    /api/customers/1            - Get customer with ID 1
POST   /api/customers              - Create new customer
PUT    /api/customers/1            - Update customer 1
DELETE /api/customers/1            - Delete customer 1

❌ Bad:
GET    /api/getCustomers
POST   /api/createCustomer
GET    /api/customer?action=get&id=1
```

**Use Nouns, Not Verbs:**
- ✅ `/api/customers`
- ❌ `/api/getCustomers`
- ❌ `/api/getAllCustomers`

**Use Plural Nouns:**
- ✅ `/api/customers`
- ❌ `/api/customer`

**Use Sub-resources for Relationships:**
```
GET /api/customers/1/orders        - Get orders for customer 1
GET /api/orders/5/items            - Get items for order 5
```

---

## 3. UNDERSTANDING DTO PATTERN

### What is DTO?

**DTO (Data Transfer Object)** - An object that carries data between processes.

### Why Use DTOs?

**Problem - Exposing Entity Directly:**
```java
@RestController
public class CustomerController {
    
    @GetMapping("/api/customers")
    public List<Customer> getAll() {
        return customerService.findAll();  // ❌ Exposing entity!
    }
}

// Response includes everything:
{
    "id": 1,
    "customerCode": "C001",
    "fullName": "John Doe",
    "email": "john@example.com",
    "password": "hashed_password",      // ❌ Security issue!
    "createdAt": "2024-11-03T10:00:00",
    "orders": [...]                     // ❌ Performance issue (lazy loading)
}
```

**Issues:**
1. ❌ **Security** - Exposes sensitive data (passwords, internal IDs)
2. ❌ **Over-fetching** - Sends unnecessary data
3. ❌ **Coupling** - Frontend depends on database structure
4. ❌ **Performance** - May trigger lazy loading
5. ❌ **Versioning** - Hard to maintain API versions

---

### DTO Pattern Solution

**Using DTOs:**
```java
// Entity (Database)
@Entity
public class Customer {
    private Long id;
    private String customerCode;
    private String fullName;
    private String email;
    private String password;          // Sensitive!
    private String internalNotes;     // Internal only
    private LocalDateTime createdAt;
}

// DTO (API Response)
public class CustomerResponseDTO {
    private Long id;
    private String customerCode;
    private String fullName;
    private String email;
    // No password!
    // No internal fields!
}

// DTO (API Request)
public class CustomerRequestDTO {
    private String customerCode;
    private String fullName;
    private String email;
    private String password;
    // No ID (auto-generated)
}

@RestController
public class CustomerController {
    
    @GetMapping("/api/customers")
    public List<CustomerResponseDTO> getAll() {
        return customerService.findAll()
            .stream()
            .map(this::convertToDTO)
            .collect(Collectors.toList());
    }
}
```

**Response is clean and safe:**
```json
{
    "id": 1,
    "customerCode": "C001",
    "fullName": "John Doe",
    "email": "john@example.com"
}
```

---

### DTO Types

**1. Request DTO** - Data coming from client
```java
public class CustomerRequestDTO {
    private String fullName;
    private String email;
    // Validation annotations
}
```

**2. Response DTO** - Data going to client
```java
public class CustomerResponseDTO {
    private Long id;
    private String fullName;
    private String email;
    // Only safe fields
}
```

**3. Update DTO** - Data for updating (may differ from create)
```java
public class CustomerUpdateDTO {
    private String fullName;
    private String email;
    // No password update here
}
```

---

## 4. PROJECT SETUP

### 4.1 Create New Spring Boot Project

**Option 1: Continue from Lab 7**
- Add REST endpoints to existing project
- Keep Thymeleaf for admin panel
- Add REST API for external consumption

**Option 2: Create New Project (Recommended for this lab)**

**Using Spring Initializr (VS Code):**

1. Press `Ctrl+Shift+P`
2. Type: "Spring Initializr: Create a Maven Project"
3. Configure:
   - Spring Boot: **3.3.x**
   - Group Id: **com.example**
   - Artifact Id: **customer-api**
   - Java: **17** or **21**

4. Dependencies:
   - ✅ Spring Web
   - ✅ Spring Data JPA
   - ✅ MySQL Driver
   - ✅ Validation
   - ✅ Lombok (optional, but recommended)
   - ✅ Spring Boot DevTools

---

### 4.2 Project Structure

```
customer-api/
│
├── src/main/java/com/example/customerapi/
│   ├── CustomerApiApplication.java
│   │
│   ├── entity/
│   │   └── Customer.java
│   │
│   ├── dto/
│   │   ├── CustomerRequestDTO.java
│   │   ├── CustomerResponseDTO.java
│   │   └── ErrorResponseDTO.java
│   │
│   ├── repository/
│   │   └── CustomerRepository.java
│   │
│   ├── service/
│   │   ├── CustomerService.java
│   │   └── CustomerServiceImpl.java
│   │
│   ├── controller/
│   │   └── CustomerRestController.java
│   │
│   └── exception/
│       ├── ResourceNotFoundException.java
│       ├── DuplicateResourceException.java
│       └── GlobalExceptionHandler.java
│
├── src/main/resources/
│   └── application.properties
│
└── pom.xml
```

---

### 4.3 Database Setup

**Create Database:**
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
('C001', 'John Doe', 'john.doe@example.com', '+1-555-0101', '123 Main St, New York, NY 10001', 'ACTIVE'),
('C002', 'Jane Smith', 'jane.smith@example.com', '+1-555-0102', '456 Oak Ave, Los Angeles, CA 90001', 'ACTIVE'),
('C003', 'Bob Johnson', 'bob.johnson@example.com', '+1-555-0103', '789 Pine Rd, Chicago, IL 60601', 'ACTIVE'),
('C004', 'Alice Brown', 'alice.brown@example.com', '+1-555-0104', '321 Elm St, Houston, TX 77001', 'INACTIVE'),
('C005', 'Charlie Wilson', 'charlie.wilson@example.com', '+1-555-0105', '654 Maple Dr, Phoenix, AZ 85001', 'ACTIVE');
```

---

### 4.4 Configuration

**File:** `src/main/resources/application.properties`

```properties
# Application
spring.application.name=customer-api
server.port=8080

# Database
spring.datasource.url=jdbc:mysql://localhost:3306/customer_management?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true
spring.datasource.username=root
spring.datasource.password=your_password
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver

# JPA
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.format_sql=true
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.MySQLDialect

# JSON formatting
spring.jackson.serialization.indent_output=true
spring.jackson.serialization.write-dates-as-timestamps=false

# Logging
logging.level.com.example.customerapi=DEBUG
```

---

## 5. SAMPLE CODE - REST API IMPLEMENTATION

### 5.1 ENTITY Layer

**File:** `src/main/java/com/example/customerapi/entity/Customer.java`

```java
package com.example.customerapi.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "customers")
public class Customer {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(name = "customer_code", unique = true, nullable = false, length = 20)
    private String customerCode;
    
    @Column(name = "full_name", nullable = false, length = 100)
    private String fullName;
    
    @Column(unique = true, nullable = false, length = 100)
    private String email;
    
    @Column(length = 20)
    private String phone;
    
    @Column(columnDefinition = "TEXT")
    private String address;
    
    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private CustomerStatus status = CustomerStatus.ACTIVE;
    
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;
    
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
    
    @PrePersist
    protected void onCreate() {
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }
    
    @PreUpdate
    protected void onUpdate() {
        this.updatedAt = LocalDateTime.now();
    }
    
    // Constructors
    public Customer() {
    }
    
    public Customer(String customerCode, String fullName, String email, String phone, String address) {
        this.customerCode = customerCode;
        this.fullName = fullName;
        this.email = email;
        this.phone = phone;
        this.address = address;
    }
    
    // Getters and Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public String getCustomerCode() {
        return customerCode;
    }
    
    public void setCustomerCode(String customerCode) {
        this.customerCode = customerCode;
    }
    
    public String getFullName() {
        return fullName;
    }
    
    public void setFullName(String fullName) {
        this.fullName = fullName;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public String getPhone() {
        return phone;
    }
    
    public void setPhone(String phone) {
        this.phone = phone;
    }
    
    public String getAddress() {
        return address;
    }
    
    public void setAddress(String address) {
        this.address = address;
    }
    
    public CustomerStatus getStatus() {
        return status;
    }
    
    public void setStatus(CustomerStatus status) {
        this.status = status;
    }
    
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    
    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }
    
    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }
}

// Enum for status
enum CustomerStatus {
    ACTIVE,
    INACTIVE
}
```

---

### 5.2 DTO Layer

**File:** `src/main/java/com/example/customerapi/dto/CustomerRequestDTO.java`

```java
package com.example.customerapi.dto;

import jakarta.validation.constraints.*;

public class CustomerRequestDTO {
    
    @NotBlank(message = "Customer code is required")
    @Size(min = 3, max = 20, message = "Customer code must be 3-20 characters")
    @Pattern(regexp = "^C\\d{3,}$", message = "Customer code must start with C followed by numbers")
    private String customerCode;
    
    @NotBlank(message = "Full name is required")
    @Size(min = 2, max = 100, message = "Name must be 2-100 characters")
    private String fullName;
    
    @NotBlank(message = "Email is required")
    @Email(message = "Invalid email format")
    private String email;
    
    @Pattern(regexp = "^\\+?[0-9]{10,20}$", message = "Invalid phone number format")
    private String phone;
    
    @Size(max = 500, message = "Address too long")
    private String address;
    
    private String status;
    
    // Constructors
    public CustomerRequestDTO() {
    }
    
    public CustomerRequestDTO(String customerCode, String fullName, String email, String phone, String address) {
        this.customerCode = customerCode;
        this.fullName = fullName;
        this.email = email;
        this.phone = phone;
        this.address = address;
    }
    
    // Getters and Setters
    public String getCustomerCode() {
        return customerCode;
    }
    
    public void setCustomerCode(String customerCode) {
        this.customerCode = customerCode;
    }
    
    public String getFullName() {
        return fullName;
    }
    
    public void setFullName(String fullName) {
        this.fullName = fullName;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public String getPhone() {
        return phone;
    }
    
    public void setPhone(String phone) {
        this.phone = phone;
    }
    
    public String getAddress() {
        return address;
    }
    
    public void setAddress(String address) {
        this.address = address;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
}
```

---

**File:** `src/main/java/com/example/customerapi/dto/CustomerResponseDTO.java`

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
    
    // Constructors
    public CustomerResponseDTO() {
    }
    
    public CustomerResponseDTO(Long id, String customerCode, String fullName, String email, 
                              String phone, String address, String status, LocalDateTime createdAt) {
        this.id = id;
        this.customerCode = customerCode;
        this.fullName = fullName;
        this.email = email;
        this.phone = phone;
        this.address = address;
        this.status = status;
        this.createdAt = createdAt;
    }
    
    // Getters and Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public String getCustomerCode() {
        return customerCode;
    }
    
    public void setCustomerCode(String customerCode) {
        this.customerCode = customerCode;
    }
    
    public String getFullName() {
        return fullName;
    }
    
    public void setFullName(String fullName) {
        this.fullName = fullName;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public String getPhone() {
        return phone;
    }
    
    public void setPhone(String phone) {
        this.phone = phone;
    }
    
    public String getAddress() {
        return address;
    }
    
    public void setAddress(String address) {
        this.address = address;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}
```

---

**File:** `src/main/java/com/example/customerapi/dto/ErrorResponseDTO.java`

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
    
    public ErrorResponseDTO() {
        this.timestamp = LocalDateTime.now();
    }
    
    public ErrorResponseDTO(int status, String error, String message, String path) {
        this.timestamp = LocalDateTime.now();
        this.status = status;
        this.error = error;
        this.message = message;
        this.path = path;
    }
    
    // Getters and Setters
    public LocalDateTime getTimestamp() {
        return timestamp;
    }
    
    public void setTimestamp(LocalDateTime timestamp) {
        this.timestamp = timestamp;
    }
    
    public int getStatus() {
        return status;
    }
    
    public void setStatus(int status) {
        this.status = status;
    }
    
    public String getError() {
        return error;
    }
    
    public void setError(String error) {
        this.error = error;
    }
    
    public String getMessage() {
        return message;
    }
    
    public void setMessage(String message) {
        this.message = message;
    }
    
    public String getPath() {
        return path;
    }
    
    public void setPath(String path) {
        this.path = path;
    }
    
    public List<String> getDetails() {
        return details;
    }
    
    public void setDetails(List<String> details) {
        this.details = details;
    }
}
```

---

### 5.3 REPOSITORY Layer

**File:** `src/main/java/com/example/customerapi/repository/CustomerRepository.java`

```java
package com.example.customerapi.repository;

import com.example.customerapi.entity.Customer;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface CustomerRepository extends JpaRepository<Customer, Long> {
    
    Optional<Customer> findByCustomerCode(String customerCode);
    
    Optional<Customer> findByEmail(String email);
    
    boolean existsByCustomerCode(String customerCode);
    
    boolean existsByEmail(String email);
    
    List<Customer> findByStatus(String status);
    
    @Query("SELECT c FROM Customer c WHERE " +
           "LOWER(c.fullName) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
           "LOWER(c.email) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
           "LOWER(c.customerCode) LIKE LOWER(CONCAT('%', :keyword, '%'))")
    List<Customer> searchCustomers(@Param("keyword") String keyword);
}
```

---

### 5.4 SERVICE Layer

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
    
    List<CustomerResponseDTO> searchCustomers(String keyword);
    
    List<CustomerResponseDTO> getCustomersByStatus(String status);
}
```

---

**File:** `src/main/java/com/example/customerapi/service/CustomerServiceImpl.java`

```java
package com.example.customerapi.service;

import com.example.customerapi.dto.CustomerRequestDTO;
import com.example.customerapi.dto.CustomerResponseDTO;
import com.example.customerapi.entity.Customer;
import com.example.customerapi.exception.DuplicateResourceException;
import com.example.customerapi.exception.ResourceNotFoundException;
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
        return customerRepository.findAll()
                .stream()
                .map(this::convertToResponseDTO)
                .collect(Collectors.toList());
    }
    
    @Override
    public CustomerResponseDTO getCustomerById(Long id) {
        Customer customer = customerRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Customer not found with id: " + id));
        return convertToResponseDTO(customer);
    }
    
    @Override
    public CustomerResponseDTO createCustomer(CustomerRequestDTO requestDTO) {
        // Check for duplicates
        if (customerRepository.existsByCustomerCode(requestDTO.getCustomerCode())) {
            throw new DuplicateResourceException("Customer code already exists: " + requestDTO.getCustomerCode());
        }
        
        if (customerRepository.existsByEmail(requestDTO.getEmail())) {
            throw new DuplicateResourceException("Email already exists: " + requestDTO.getEmail());
        }
        
        // Convert DTO to Entity
        Customer customer = convertToEntity(requestDTO);
        
        // Save to database
        Customer savedCustomer = customerRepository.save(customer);
        
        // Convert Entity to Response DTO
        return convertToResponseDTO(savedCustomer);
    }
    
    @Override
    public CustomerResponseDTO updateCustomer(Long id, CustomerRequestDTO requestDTO) {
        Customer existingCustomer = customerRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Customer not found with id: " + id));
        
        // Check if email is being changed to an existing one
        if (!existingCustomer.getEmail().equals(requestDTO.getEmail()) 
            && customerRepository.existsByEmail(requestDTO.getEmail())) {
            throw new DuplicateResourceException("Email already exists: " + requestDTO.getEmail());
        }
        
        // Update fields
        existingCustomer.setFullName(requestDTO.getFullName());
        existingCustomer.setEmail(requestDTO.getEmail());
        existingCustomer.setPhone(requestDTO.getPhone());
        existingCustomer.setAddress(requestDTO.getAddress());
        
        // Don't update customerCode (immutable)
        
        Customer updatedCustomer = customerRepository.save(existingCustomer);
        return convertToResponseDTO(updatedCustomer);
    }
    
    @Override
    public void deleteCustomer(Long id) {
        if (!customerRepository.existsById(id)) {
            throw new ResourceNotFoundException("Customer not found with id: " + id);
        }
        customerRepository.deleteById(id);
    }
    
    @Override
    public List<CustomerResponseDTO> searchCustomers(String keyword) {
        return customerRepository.searchCustomers(keyword)
                .stream()
                .map(this::convertToResponseDTO)
                .collect(Collectors.toList());
    }
    
    @Override
    public List<CustomerResponseDTO> getCustomersByStatus(String status) {
        return customerRepository.findByStatus(status)
                .stream()
                .map(this::convertToResponseDTO)
                .collect(Collectors.toList());
    }
    
    // Helper Methods for DTO Conversion
    
    private CustomerResponseDTO convertToResponseDTO(Customer customer) {
        CustomerResponseDTO dto = new CustomerResponseDTO();
        dto.setId(customer.getId());
        dto.setCustomerCode(customer.getCustomerCode());
        dto.setFullName(customer.getFullName());
        dto.setEmail(customer.getEmail());
        dto.setPhone(customer.getPhone());
        dto.setAddress(customer.getAddress());
        dto.setStatus(customer.getStatus().toString());
        dto.setCreatedAt(customer.getCreatedAt());
        return dto;
    }
    
    private Customer convertToEntity(CustomerRequestDTO dto) {
        Customer customer = new Customer();
        customer.setCustomerCode(dto.getCustomerCode());
        customer.setFullName(dto.getFullName());
        customer.setEmail(dto.getEmail());
        customer.setPhone(dto.getPhone());
        customer.setAddress(dto.getAddress());
        return customer;
    }
}
```

---

### 5.5 CONTROLLER Layer (REST API)

**File:** `src/main/java/com/example/customerapi/controller/CustomerRestController.java`

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

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/customers")
@CrossOrigin(origins = "*")  // Allow CORS for frontend
public class CustomerRestController {
    
    private final CustomerService customerService;
    
    @Autowired
    public CustomerRestController(CustomerService customerService) {
        this.customerService = customerService;
    }
    
    // GET all customers
    @GetMapping
    public ResponseEntity<List<CustomerResponseDTO>> getAllCustomers() {
        List<CustomerResponseDTO> customers = customerService.getAllCustomers();
        return ResponseEntity.ok(customers);
    }
    
    // GET customer by ID
    @GetMapping("/{id}")
    public ResponseEntity<CustomerResponseDTO> getCustomerById(@PathVariable Long id) {
        CustomerResponseDTO customer = customerService.getCustomerById(id);
        return ResponseEntity.ok(customer);
    }
    
    // POST create new customer
    @PostMapping
    public ResponseEntity<CustomerResponseDTO> createCustomer(@Valid @RequestBody CustomerRequestDTO requestDTO) {
        CustomerResponseDTO createdCustomer = customerService.createCustomer(requestDTO);
        return ResponseEntity.status(HttpStatus.CREATED).body(createdCustomer);
    }
    
    // PUT update customer
    @PutMapping("/{id}")
    public ResponseEntity<CustomerResponseDTO> updateCustomer(
            @PathVariable Long id,
            @Valid @RequestBody CustomerRequestDTO requestDTO) {
        CustomerResponseDTO updatedCustomer = customerService.updateCustomer(id, requestDTO);
        return ResponseEntity.ok(updatedCustomer);
    }
    
    // DELETE customer
    @DeleteMapping("/{id}")
    public ResponseEntity<Map<String, String>> deleteCustomer(@PathVariable Long id) {
        customerService.deleteCustomer(id);
        Map<String, String> response = new HashMap<>();
        response.put("message", "Customer deleted successfully");
        return ResponseEntity.ok(response);
    }
    
    // GET search customers
    @GetMapping("/search")
    public ResponseEntity<List<CustomerResponseDTO>> searchCustomers(@RequestParam String keyword) {
        List<CustomerResponseDTO> customers = customerService.searchCustomers(keyword);
        return ResponseEntity.ok(customers);
    }
    
    // GET customers by status
    @GetMapping("/status/{status}")
    public ResponseEntity<List<CustomerResponseDTO>> getCustomersByStatus(@PathVariable String status) {
        List<CustomerResponseDTO> customers = customerService.getCustomersByStatus(status);
        return ResponseEntity.ok(customers);
    }
}
```

**Controller Annotations Explained:**

```java
@RestController              // = @Controller + @ResponseBody (returns JSON)
@RequestMapping("/api/customers")  // Base URL for all endpoints
@CrossOrigin(origins = "*")  // Allow requests from any origin (for frontend)

@GetMapping                  // Handle GET requests
@PostMapping                 // Handle POST requests
@PutMapping                  // Handle PUT requests
@DeleteMapping               // Handle DELETE requests

@PathVariable Long id        // Extract from URL: /api/customers/{id}
@RequestParam String keyword // Extract from query: ?keyword=john
@RequestBody                 // Parse JSON from request body
@Valid                       // Trigger validation

ResponseEntity<T>            // Wrapper for HTTP response with status code
```

---

## 6. EXCEPTION HANDLING

### 6.1 Custom Exceptions

**File:** `src/main/java/com/example/customerapi/exception/ResourceNotFoundException.java`

```java
package com.example.customerapi.exception;

public class ResourceNotFoundException extends RuntimeException {
    
    public ResourceNotFoundException(String message) {
        super(message);
    }
    
    public ResourceNotFoundException(String message, Throwable cause) {
        super(message, cause);
    }
}
```

---

**File:** `src/main/java/com/example/customerapi/exception/DuplicateResourceException.java`

```java
package com.example.customerapi.exception;

public class DuplicateResourceException extends RuntimeException {
    
    public DuplicateResourceException(String message) {
        super(message);
    }
    
    public DuplicateResourceException(String message, Throwable cause) {
        super(message, cause);
    }
}
```

---

### 6.2 Global Exception Handler

**File:** `src/main/java/com/example/customerapi/exception/GlobalExceptionHandler.java`

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

@RestControllerAdvice
public class GlobalExceptionHandler {
    
    // Handle ResourceNotFoundException (404)
    @ExceptionHandler(ResourceNotFoundException.class)
    public ResponseEntity<ErrorResponseDTO> handleResourceNotFoundException(
            ResourceNotFoundException ex, 
            WebRequest request) {
        
        ErrorResponseDTO error = new ErrorResponseDTO(
            HttpStatus.NOT_FOUND.value(),
            "Not Found",
            ex.getMessage(),
            request.getDescription(false).replace("uri=", "")
        );
        
        return new ResponseEntity<>(error, HttpStatus.NOT_FOUND);
    }
    
    // Handle DuplicateResourceException (409)
    @ExceptionHandler(DuplicateResourceException.class)
    public ResponseEntity<ErrorResponseDTO> handleDuplicateResourceException(
            DuplicateResourceException ex,
            WebRequest request) {
        
        ErrorResponseDTO error = new ErrorResponseDTO(
            HttpStatus.CONFLICT.value(),
            "Conflict",
            ex.getMessage(),
            request.getDescription(false).replace("uri=", "")
        );
        
        return new ResponseEntity<>(error, HttpStatus.CONFLICT);
    }
    
    // Handle Validation Errors (400)
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ErrorResponseDTO> handleValidationException(
            MethodArgumentNotValidException ex,
            WebRequest request) {
        
        List<String> details = new ArrayList<>();
        for (FieldError error : ex.getBindingResult().getFieldErrors()) {
            details.add(error.getField() + ": " + error.getDefaultMessage());
        }
        
        ErrorResponseDTO error = new ErrorResponseDTO(
            HttpStatus.BAD_REQUEST.value(),
            "Validation Failed",
            "Invalid input data",
            request.getDescription(false).replace("uri=", "")
        );
        error.setDetails(details);
        
        return new ResponseEntity<>(error, HttpStatus.BAD_REQUEST);
    }
    
    // Handle all other exceptions (500)
    @ExceptionHandler(Exception.class)
    public ResponseEntity<ErrorResponseDTO> handleGlobalException(
            Exception ex,
            WebRequest request) {
        
        ErrorResponseDTO error = new ErrorResponseDTO(
            HttpStatus.INTERNAL_SERVER_ERROR.value(),
            "Internal Server Error",
            ex.getMessage(),
            request.getDescription(false).replace("uri=", "")
        );
        
        return new ResponseEntity<>(error, HttpStatus.INTERNAL_SERVER_ERROR);
    }
}
```

**How It Works:**

1. **@RestControllerAdvice** - Applies exception handling globally to all REST controllers
2. **@ExceptionHandler** - Catches specific exception types
3. Returns consistent **ErrorResponseDTO** structure
4. Sets appropriate **HTTP status codes**

---

## 7. TESTING WITH REST CLIENT

### 7.1 Using Thunder Client (VS Code Extension)

**Install Thunder Client:**
1. Open VS Code Extensions (Ctrl+Shift+X)
2. Search "Thunder Client"
3. Install

**Create Collection:**
1. Click Thunder Client icon in sidebar
2. New Collection → "Customer API"
3. Add requests

---

### 7.2 Sample API Tests

**Test 1: GET All Customers**
```
Method: GET
URL: http://localhost:8080/api/customers

Expected Response (200 OK):
[
    {
        "id": 1,
        "customerCode": "C001",
        "fullName": "John Doe",
        "email": "john.doe@example.com",
        "phone": "+1-555-0101",
        "address": "123 Main St, New York, NY 10001",
        "status": "ACTIVE",
        "createdAt": "2024-11-03T10:00:00"
    },
    ...
]
```

---

**Test 2: GET Customer by ID**
```
Method: GET
URL: http://localhost:8080/api/customers/1

Expected Response (200 OK):
{
    "id": 1,
    "customerCode": "C001",
    "fullName": "John Doe",
    ...
}
```

---

**Test 3: POST Create Customer**
```
Method: POST
URL: http://localhost:8080/api/customers
Headers: Content-Type: application/json

Body (JSON):
{
    "customerCode": "C006",
    "fullName": "David Miller",
    "email": "david.miller@example.com",
    "phone": "+15550106",
    "address": "999 Broadway, Seattle, WA 98101"
}

Expected Response (201 Created):
{
    "id": 6,
    "customerCode": "C006",
    "fullName": "David Miller",
    ...
}
```

---

**Test 4: PUT Update Customer**
```
Method: PUT
URL: http://localhost:8080/api/customers/6
Headers: Content-Type: application/json

Body (JSON):
{
    "customerCode": "C006",
    "fullName": "David Miller Jr.",
    "email": "david.miller.jr@example.com",
    "phone": "+15550107",
    "address": "1000 Broadway, Seattle, WA 98101"
}

Expected Response (200 OK):
{
    "id": 6,
    "customerCode": "C006",
    "fullName": "David Miller Jr.",
    ...
}
```

---

**Test 5: DELETE Customer**
```
Method: DELETE
URL: http://localhost:8080/api/customers/6

Expected Response (200 OK):
{
    "message": "Customer deleted successfully"
}
```

---

**Test 6: Search Customers**
```
Method: GET
URL: http://localhost:8080/api/customers/search?keyword=john

Expected Response (200 OK):
[
    {
        "id": 1,
        "customerCode": "C001",
        "fullName": "John Doe",
        ...
    },
    {
        "id": 3,
        "customerCode": "C003",
        "fullName": "Bob Johnson",
        ...
    }
]
```

---

**Test 7: Validation Error**
```
Method: POST
URL: http://localhost:8080/api/customers
Headers: Content-Type: application/json

Body (Invalid - missing required fields):
{
    "customerCode": "C",
    "email": "invalid-email"
}

Expected Response (400 Bad Request):
{
    "timestamp": "2024-11-03T10:30:00",
    "status": 400,
    "error": "Validation Failed",
    "message": "Invalid input data",
    "path": "/api/customers",
    "details": [
        "customerCode: Customer code must be 3-20 characters",
        "fullName: Full name is required",
        "email: Invalid email format"
    ]
}
```

---

**Test 8: Resource Not Found**
```
Method: GET
URL: http://localhost:8080/api/customers/999

Expected Response (404 Not Found):
{
    "timestamp": "2024-11-03T10:35:00",
    "status": 404,
    "error": "Not Found",
    "message": "Customer not found with id: 999",
    "path": "/api/customers/999"
}
```

---

**Test 9: Duplicate Resource**
```
Method: POST
URL: http://localhost:8080/api/customers
Headers: Content-Type: application/json

Body (Duplicate email):
{
    "customerCode": "C007",
    "fullName": "Test User",
    "email": "john.doe@example.com"
}

Expected Response (409 Conflict):
{
    "timestamp": "2024-11-03T10:40:00",
    "status": 409,
    "error": "Conflict",
    "message": "Email already exists: john.doe@example.com",
    "path": "/api/customers"
}
```

---

### 7.3 Using cURL (Command Line)

```bash
# GET all customers
curl http://localhost:8080/api/customers

# GET customer by ID
curl http://localhost:8080/api/customers/1

# POST create customer
curl -X POST http://localhost:8080/api/customers \
  -H "Content-Type: application/json" \
  -d '{
    "customerCode": "C006",
    "fullName": "David Miller",
    "email": "david.miller@example.com",
    "phone": "+1-555-0106",
    "address": "999 Broadway, Seattle, WA 98101"
  }'

# PUT update customer
curl -X PUT http://localhost:8080/api/customers/6 \
  -H "Content-Type: application/json" \
  -d '{
    "customerCode": "C006",
    "fullName": "David Miller Jr.",
    "email": "david.miller.jr@example.com",
    "phone": "+1-555-0107",
    "address": "1000 Broadway, Seattle, WA 98101"
  }'

# DELETE customer
curl -X DELETE http://localhost:8080/api/customers/6

# Search customers
curl "http://localhost:8080/api/customers/search?keyword=john"
```

---

## 8. COMPARISON: TRADITIONAL VS REST API

### 8.1 Architecture

**Traditional Web App (Lab 7):**
```
Browser → Controller → Service → Repository → Database
           ↓
        Model + View (Thymeleaf)
           ↓
        HTML Response
```

**REST API (Lab 8):**
```
Client → REST Controller → Service → Repository → Database
(Any)        ↓
          DTO Conversion
             ↓
        JSON Response
```

---

### 8.2 Controller Comparison

**Traditional Controller (Lab 7):**
```java
@Controller
public class ProductController {
    
    @GetMapping("/products")
    public String listProducts(Model model) {
        List<Product> products = productService.getAllProducts();
        model.addAttribute("products", products);
        return "product-list";  // Returns HTML view
    }
    
    @PostMapping("/products/save")
    public String saveProduct(@ModelAttribute Product product) {
        productService.save(product);
        return "redirect:/products";
    }
}
```

**REST Controller (Lab 8):**
```java
@RestController
@RequestMapping("/api/customers")
public class CustomerRestController {
    
    @GetMapping
    public ResponseEntity<List<CustomerResponseDTO>> getAllCustomers() {
        List<CustomerResponseDTO> customers = customerService.getAllCustomers();
        return ResponseEntity.ok(customers);  // Returns JSON
    }
    
    @PostMapping
    public ResponseEntity<CustomerResponseDTO> createCustomer(
            @RequestBody CustomerRequestDTO dto) {
        CustomerResponseDTO created = customerService.createCustomer(dto);
        return ResponseEntity.status(HttpStatus.CREATED).body(created);
    }
}
```

---

### 8.3 Response Comparison

**Traditional HTML Response:**
```html
<!DOCTYPE html>
<html>
<head><title>Products</title></head>
<body>
    <table>
        <tr>
            <td>Laptop</td>
            <td>$1299.99</td>
        </tr>
    </table>
</body>
</html>
```

**REST JSON Response:**
```json
[
    {
        "id": 1,
        "customerCode": "C001",
        "fullName": "John Doe",
        "email": "john.doe@example.com",
        "phone": "+1-555-0101",
        "status": "ACTIVE"
    }
]
```

---

### 8.4 When to Use Each

**Use Traditional Web App (Lab 7) when:**
- Building server-side rendered applications
- SEO is critical
- Simple CRUD applications
- Team doesn't know frontend frameworks
- Admin panels

**Use REST API (Lab 8) when:**
- Building mobile apps
- Using modern frontend frameworks (React, Vue, Angular)
- Need to support multiple clients (web, mobile, desktop)
- Microservices architecture
- Third-party integrations
- Modern web applications

**Best Practice: Use Both!**
- REST API for data operations
- Admin panel with Thymeleaf for management

---

## 9. BEST PRACTICES

### API Design

✅ **Use nouns, not verbs**
```
✅ GET /api/customers
❌ GET /api/getCustomers
```

✅ **Use HTTP methods correctly**
```
GET    - Retrieve data (safe, idempotent)
POST   - Create new resource
PUT    - Update entire resource
PATCH  - Update partial resource
DELETE - Remove resource
```

✅ **Use proper status codes**
```
200 OK - Success
201 Created - Resource created
204 No Content - Success, no response body
400 Bad Request - Invalid input
404 Not Found - Resource doesn't exist
409 Conflict - Duplicate resource
500 Internal Server Error - Server error
```

✅ **Version your API**
```
/api/v1/customers
/api/v2/customers
```

✅ **Use pagination for large datasets**
```
GET /api/customers?page=0&size=10
```

---

### Security

✅ **Never expose sensitive data**
```java
// DON'T include in Response DTO:
- Passwords
- Internal IDs
- System information
- Audit fields
```

✅ **Validate all inputs**
```java
@Valid @RequestBody CustomerRequestDTO dto
```

✅ **Use HTTPS in production**

✅ **Implement authentication** (next lab)

---

### DTO Conversion

✅ **Use helper methods**
```java
private CustomerResponseDTO convertToDTO(Customer entity) {
    // Manual mapping
}
```

✅ **Consider ModelMapper for complex mappings**
```xml
<dependency>
    <groupId>org.modelmapper</groupId>
    <artifactId>modelmapper</artifactId>
    <version>3.1.1</version>
</dependency>
```

---

## 10. SUMMARY

### What You Learned

✅ **REST API Principles** - RESTful architecture and HTTP methods  
✅ **@RestController** - Building JSON APIs  
✅ **DTO Pattern** - Data Transfer Objects for API  
✅ **ResponseEntity** - Controlling HTTP responses  
✅ **Exception Handling** - Global error handling with @RestControllerAdvice  
✅ **Validation** - Input validation with @Valid  
✅ **API Testing** - Using Thunder Client and cURL

---

### Key Concepts

**REST API:**
- Uses HTTP methods (GET, POST, PUT, DELETE)
- Returns JSON instead of HTML
- Stateless communication
- Resource-based URLs

**DTO Pattern:**
- Separates API structure from database
- Improves security
- Enables versioning
- Controls data exposure

**Exception Handling:**
- Centralized with @RestControllerAdvice
- Consistent error responses
- Proper HTTP status codes
- Detailed error messages

---

### Next Lab Preview

**Lab 9: Spring Security & JWT Authentication**
- Securing REST APIs
- User authentication
- JWT (JSON Web Token) implementation
- Role-based authorization
- Protecting endpoints

---

**End of Setup Guide**

*Review this before Lab 8. Understand REST API and DTO concepts thoroughly!*