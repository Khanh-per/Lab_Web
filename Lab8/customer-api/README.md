
title: 'LAB 8 [Exercise]: REST API & DTO PATTERN'
> Name: Le Hoang Khanh
> ID: ITCSIU23013
> Tutor: Nguyen Trung Nghia
---

---
title: LAB 8 REST API & DTO PATTERN

---

# LAB 8: REST API & DTO PATTERN
## Setup Guide & Sample Code

**Course:** Web Application Development  
**Duration:** 2.5 hours  
**Prerequisites:** Lab 7 completed (Spring Boot + JPA CRUD)

> **Note:** This lab focuses on building RESTful APIs with JSON responses. Read this BEFORE the lab session.---

## 7. TESTING WITH REST CLIENT

### 7.1 Using Thunder Client (VS Code Extension)

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
Result: 
    ![screenshoot](/customer-api/image/TestCase1.png)

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
Result:
    ![screenshoot](/customer-api/image/TestCase2.png)

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
Result:
    ![screenshoot](/customer-api/image/TestCase3.png)

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
Result:
    ![screenshoot](/customer-api/image/TestCase4.png)

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
Result:
    ![screenshoot](/customer-api/image/TestCase5.png)

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
Result:
    ![screenshoot](/customer-api/image/TestCase6.png)

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
Result:
    ![screenshoot](/customer-api/image/TestCase7.png)

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
Result:
    ![screenshoot](/customer-api/image/TestCase8.png)

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
Result:
    ![screenshoot](/customer-api/image/TestCase9.png)

---