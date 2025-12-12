# Customer API Documentation

## Overview
RESTful API for client management, full support for CRUD, advanced search, pagination, sorting, and partial updates.

- **Base URL:** `http://localhost:8080`
- **Content-Type:** `application/json`

---

## 1. Get All Customers
Get a customer list with pagination and sorting support..

- **URL:** `/api/customers`
- **Method:** `GET`
- **Query Params:**
    - `page` (int): Page number (default 0)
    - `size` (int): Number of records (default 10)
    - `sortBy` (String): Sorting field (default "id")
    - `sortDir` (String): Sorting direction "asc" or "desc" (default "asc")
**Success Response (200 OK):**
```json
{
    "customers": [
        {
            "id": 1,
            "customerCode": "C001",
            "fullName": "John Doe",
            "email": "john.doe@example.com",
            "phone": "+1-555-0101",
            "address": "123 Main St, New York",
            "status": "ACTIVE",
            "createdAt": "2024-12-12T10:00:00"
        }
    ],
    "currentPage": 0,
    "totalItems": 50,
    "totalPages": 5,
    "sortBy": "id"
}
```

## 2. Create Customer
Create a new customer.

- **URL:** `/api/customers`
- **Method:** `POST`
- **Request body**:
```JSON
{
    "customerCode": "C099",
    "fullName": "David Beckham",
    "email": "david@example.com",
    "phone": "+1-555-9999",
    "address": "London, UK"
}
```

- **Success response** (201 Created)
```JSON
{
    "id": 99,
    "customerCode": "C099",
    "fullName": "David Beckham",
    "email": "david@example.com",
    "status": "ACTIVE",
    "createdAt": "2024-12-12T12:00:00"
}
```

- **Error Response** (400 Bad Request - Validation):
```JSON
{
    "timestamp": "2024-12-12T10:30:00",
    "status": 400,
    "error": "Validation Failed",
    "message": "Invalid input data",
    "path": "/api/customers",
    "details": [
        "email: Invalid email format",
        "fullName: Full name is required"
    ]
}
```

- **Error Response** (409 Conflict - Duplicate):
```JSON
{
    "timestamp": "2024-12-12T10:40:00",
    "status": 409,
    "error": "Conflict",
    "message": "Email already exists: david@example.com",
    "path": "/api/customers",
    "details": null
}
```