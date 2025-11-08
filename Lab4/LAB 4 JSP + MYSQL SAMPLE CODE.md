---
title: LAB 4 JSP + MYSQL SAMPLE CODE

---

# LAB 4: JSP + MYSQL - CRUD OPERATIONS
## Setup Guide & Sample Code

**Course:** Web Application Development  
**Duration:** 2.5 hours  
**Prerequisites:** Basic Java, HTML/CSS, SQL

> **Note:** This guide provides complete working code samples. Code explanations are provided BELOW each code block for better readability.

---

## 📋 TABLE OF CONTENTS

1. [Environment Setup](#1-environment-setup)
2. [Database Setup](#2-database-setup)
3. [Project Structure](#3-project-structure)
4. [Understanding JDBC](#4-understanding-jdbc)
5. [Sample Code](#5-sample-code)
6. [Running the Demo](#6-running-the-demo)
7. [Best Practices](#7-best-practices)

---

## 1. ENVIRONMENT SETUP

### Required Software

| Software | Version | Download Link |
|----------|---------|---------------|
| JDK | 17+ | https://www.oracle.com/java/technologies/downloads/ |
| NetBeans | 12+ | https://netbeans.apache.org/download/ |
| Tomcat | 9.x/10.x | https://tomcat.apache.org/download-90.cgi |
| MySQL & Workbench | 8.0+ | https://dev.mysql.com/downloads/installer/ |


### Installation Steps

**A. Install JDK and verify:**
```bash
java -version
javac -version
```

**B. Install NetBeans**
- Download Java EE version
- Run installer and follow wizard

**C. Install MySQL**
- Choose "Developer Default" setup
- **Remember your root password!**

**D. Configure Tomcat in NetBeans**
1. Tools → Servers → Add Server
2. Select Apache Tomcat
3. Browse to Tomcat folder
4. Finish

---

## 2. DATABASE SETUP

### Create Database and Table

Open MySQL Workbench and run:

```sql
CREATE DATABASE student_management;
USE student_management;

CREATE TABLE students (
    id INT PRIMARY KEY AUTO_INCREMENT,
    student_code VARCHAR(10) UNIQUE NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    major VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO students (student_code, full_name, email, major) VALUES
('SV001', 'John Smith', 'john.smith@email.com', 'Computer Science'),
('SV002', 'Emily Johnson', 'emily.j@email.com', 'Information Technology'),
('SV003', 'Michael Brown', 'michael.b@email.com', 'Software Engineering'),
('SV004', 'Sarah Davis', 'sarah.d@email.com', 'Data Science'),
('SV005', 'David Wilson', 'david.w@email.com', 'Computer Science');
```

### Verify Data
```sql
SELECT * FROM students;
```
You should see 5 students.

---

## 3. PROJECT STRUCTURE

### Create Project in NetBeans

1. File → New Project
2. Java maven → Web Application
3. Name: `StudentManagement`
4. Server: Apache Tomcat
5. Finish

### Add MySQL Connector

1. Open projects files → pom.xml
2. add mysql-connector by add following code to the `dependencies` tab
``` xml
<dependency>    
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
    <version>8.0.33</version>
</dependency>
```
4. Select `mysql-connector-java-8.0.33.jar`

### Directory Structure

```
StudentManagement/
├── Web Pages/
│   ├── list_students.jsp
│   ├── add_student.jsp
│   ├── process_add.jsp
│   ├── edit_student.jsp
│   ├── process_edit.jsp
│   └── delete_student.jsp
└── Libraries/
    └── MySQL Connector/J
```

---

## 4. UNDERSTANDING JDBC

### What is JDBC?

JDBC (Java Database Connectivity) is the standard Java API for connecting to databases.

### Connection String Format

```
jdbc:mysql://[host]:[port]/[database]
```

Example:
```
jdbc:mysql://localhost:3306/student_management
```

### Key JDBC Classes

- `DriverManager` - Creates connections
- `Connection` - Represents database connection
- `Statement` - Executes SQL (⚠️ SQL injection risk)
- `PreparedStatement` - Executes parameterized SQL (✅ safe)
- `ResultSet` - Contains query results

### JDBC Workflow

```
1. Load Driver → Class.forName()
2. Connect → DriverManager.getConnection()
3. Create Statement → prepareStatement()
4. Execute Query → executeQuery() / executeUpdate()
5. Process Results → ResultSet
6. Close Resources → close()
```

### Why PreparedStatement?

**❌ Statement (UNSAFE):**
```java
String sql = "SELECT * FROM users WHERE username = '" + username + "'";
```
If username = `'; DROP TABLE users; --` → SQL Injection attack!

**✅ PreparedStatement (SAFE):**
```java
String sql = "SELECT * FROM users WHERE username = ?";
pstmt.setString(1, username);
```
User input is treated as DATA, not CODE.

---

## 5. SAMPLE CODE

### 5.1 LIST STUDENTS (SELECT)

**File:** `list_students.jsp`

#### Complete Code

```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Student List</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f5f5f5;
        }
        h1 { color: #333; }
        .message {
            padding: 10px;
            margin-bottom: 20px;
            border-radius: 5px;
        }
        .success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .btn {
            display: inline-block;
            padding: 10px 20px;
            margin-bottom: 20px;
            background-color: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 5px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            background-color: white;
        }
        th {
            background-color: #007bff;
            color: white;
            padding: 12px;
            text-align: left;
        }
        td {
            padding: 10px;
            border-bottom: 1px solid #ddd;
        }
        tr:hover { background-color: #f8f9fa; }
        .action-link {
            color: #007bff;
            text-decoration: none;
            margin-right: 10px;
        }
        .delete-link { color: #dc3545; }
    </style>
</head>
<body>
    <h1>📚 Student Management System</h1>
    
    <% if (request.getParameter("message") != null) { %>
        <div class="message success">
            <%= request.getParameter("message") %>
        </div>
    <% } %>
    
    <% if (request.getParameter("error") != null) { %>
        <div class="message error">
            <%= request.getParameter("error") %>
        </div>
    <% } %>
    
    <a href="add_student.jsp" class="btn">➕ Add New Student</a>
    
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Student Code</th>
                <th>Full Name</th>
                <th>Email</th>
                <th>Major</th>
                <th>Created At</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
<%
    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        
        conn = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/student_management",
            "root",
            "your_password"
        );
        
        stmt = conn.createStatement();
        String sql = "SELECT * FROM students ORDER BY id DESC";
        rs = stmt.executeQuery(sql);
        
        while (rs.next()) {
            int id = rs.getInt("id");
            String studentCode = rs.getString("student_code");
            String fullName = rs.getString("full_name");
            String email = rs.getString("email");
            String major = rs.getString("major");
            Timestamp createdAt = rs.getTimestamp("created_at");
%>
            <tr>
                <td><%= id %></td>
                <td><%= studentCode %></td>
                <td><%= fullName %></td>
                <td><%= email != null ? email : "N/A" %></td>
                <td><%= major != null ? major : "N/A" %></td>
                <td><%= createdAt %></td>
                <td>
                    <a href="edit_student.jsp?id=<%= id %>" class="action-link">✏️ Edit</a>
                    <a href="delete_student.jsp?id=<%= id %>" 
                       class="action-link delete-link"
                       onclick="return confirm('Are you sure?')">🗑️ Delete</a>
                </td>
            </tr>
<%
        }
    } catch (ClassNotFoundException e) {
        out.println("<tr><td colspan='7'>Error: JDBC Driver not found!</td></tr>");
        e.printStackTrace();
    } catch (SQLException e) {
        out.println("<tr><td colspan='7'>Database Error: " + e.getMessage() + "</td></tr>");
        e.printStackTrace();
    } finally {
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>
        </tbody>
    </table>
</body>
</html>
```

#### Code Explanation

**Message Display:**
- `request.getParameter("message")` retrieves URL parameter
- Example: `list_students.jsp?message=Student added successfully`
- Green box for success, red box for errors

**Database Connection Steps:**

1. **Declare Variables**: Initialize as `null` for null-checking in finally block

2. **Load Driver**: `Class.forName()` loads MySQL JDBC driver into memory

3. **Establish Connection**: 
   - URL format: `jdbc:mysql://localhost:3306/database_name`
   - Provide username and password
   - ⚠️ **Change `"your_password"` to your actual MySQL password!**

4. **Create Statement**: Used for executing SQL queries

5. **Execute Query**:
   - `executeQuery()` for SELECT statements
   - Returns `ResultSet` with results
   - `ORDER BY id DESC` shows newest first

6. **Process Results**:
   - `rs.next()` moves to next row, returns `true` if row exists
   - `rs.getInt()`, `rs.getString()`, `rs.getTimestamp()` extract column values
   - Column names must match database exactly

7. **NULL Handling**:
   - `email != null ? email : "N/A"` - ternary operator
   - If email is NULL, display "N/A" instead

**Action Links:**
- Pass ID as URL parameter: `edit_student.jsp?id=5`
- JavaScript `onclick="return confirm()"` shows confirmation
- If user clicks "Cancel", returns `false` to prevent navigation

**Exception Handling:**

- **ClassNotFoundException**: JDBC driver not found
  - **Solution**: Add MySQL Connector/J to project libraries

- **SQLException**: Database errors (wrong credentials, server not running, etc.)
  - `e.getMessage()` provides error details
  - `e.printStackTrace()` prints full stack trace to console

**Resource Cleanup:**
- `finally` block ALWAYS executes
- Close in reverse order: ResultSet → Statement → Connection
- Check `!= null` before closing to prevent NullPointerException
- Prevents memory leaks and connection exhaustion

---

### 5.2 ADD STUDENT (INSERT)

Two pages needed:
1. `add_student.jsp` - Display form
2. `process_add.jsp` - Process submission

#### Part A: Display Form

**File:** `add_student.jsp`

```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add New Student</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f5f5f5;
        }
        .container {
            max-width: 600px;
            margin: 50px auto;
            background-color: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        h2 { color: #333; margin-bottom: 30px; }
        .form-group { margin-bottom: 20px; }
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #555;
        }
        input[type="text"], input[type="email"] {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            box-sizing: border-box;
        }
        input:focus {
            outline: none;
            border-color: #007bff;
        }
        .btn-submit {
            background-color: #28a745;
            color: white;
            padding: 12px 30px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            margin-right: 10px;
        }
        .btn-cancel {
            background-color: #6c757d;
            color: white;
            padding: 12px 30px;
            text-decoration: none;
            display: inline-block;
            border-radius: 5px;
        }
        .error {
            background-color: #f8d7da;
            color: #721c24;
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        .required { color: red; }
    </style>
</head>
<body>
    <div class="container">
        <h2>➕ Add New Student</h2>
        
        <% if (request.getParameter("error") != null) { %>
            <div class="error">
                <%= request.getParameter("error") %>
            </div>
        <% } %>
        
        <form action="process_add.jsp" method="POST">
            <div class="form-group">
                <label for="student_code">Student Code <span class="required">*</span></label>
                <input type="text" id="student_code" name="student_code" 
                       placeholder="e.g., SV001" required 
                       pattern="[A-Z]{2}[0-9]{3,}"
                       title="Format: 2 uppercase letters + 3+ digits">
            </div>
            
            <div class="form-group">
                <label for="full_name">Full Name <span class="required">*</span></label>
                <input type="text" id="full_name" name="full_name" 
                       placeholder="Enter full name" required>
            </div>
            
            <div class="form-group">
                <label for="email">Email</label>
                <input type="email" id="email" name="email" 
                       placeholder="student@email.com">
            </div>
            
            <div class="form-group">
                <label for="major">Major</label>
                <input type="text" id="major" name="major" 
                       placeholder="e.g., Computer Science">
            </div>
            
            <button type="submit" class="btn-submit">💾 Save Student</button>
            <a href="list_students.jsp" class="btn-cancel">Cancel</a>
        </form>
    </div>
</body>
</html>
```

#### Explanation - Add Form

**Form Attributes:**
- `action="process_add.jsp"` - where data is sent
- `method="POST"` - HTTP method
  - POST: Data in request body (secure, not in URL)
  - GET: Data in URL (visible, bookmarkable)
  - **Use POST for create/update!**

**Input Attributes:**
- `name` - key for retrieving value: `request.getParameter("name")`
- `placeholder` - hint text
- `required` - HTML5 validation (cannot submit if empty)
- `pattern` - regex validation
  - `[A-Z]{2}` = exactly 2 uppercase letters
  - `[0-9]{3,}` = 3 or more digits
  - Valid: SV001, IT123
  - Invalid: sv001, S01
- `type="email"` - browser validates email format

**⚠️ Important:**
- Client validation can be bypassed!
- **Always validate on server too!**

#### Part B: Process Form

**File:** `process_add.jsp`

```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String studentCode = request.getParameter("student_code");
    String fullName = request.getParameter("full_name");
    String email = request.getParameter("email");
    String major = request.getParameter("major");
    
    if (studentCode == null || studentCode.trim().isEmpty() ||
        fullName == null || fullName.trim().isEmpty()) {
        response.sendRedirect("add_student.jsp?error=Required fields are missing");
        return;
    }
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/student_management",
            "root",
            "your_password"
        );
        
        String sql = "INSERT INTO students (student_code, full_name, email, major) VALUES (?, ?, ?, ?)";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, studentCode);
        pstmt.setString(2, fullName);
        pstmt.setString(3, email);
        pstmt.setString(4, major);
        
        int rowsAffected = pstmt.executeUpdate();
        
        if (rowsAffected > 0) {
            response.sendRedirect("list_students.jsp?message=Student added successfully");
        } else {
            response.sendRedirect("add_student.jsp?error=Failed to add student");
        }
        
    } catch (ClassNotFoundException e) {
        response.sendRedirect("add_student.jsp?error=Driver not found");
        e.printStackTrace();
    } catch (SQLException e) {
        String errorMsg = e.getMessage();
        if (errorMsg.contains("Duplicate entry")) {
            response.sendRedirect("add_student.jsp?error=Student code already exists");
        } else {
            response.sendRedirect("add_student.jsp?error=Database error");
        }
        e.printStackTrace();
    } finally {
        try {
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>
```

#### Explanation - Process Add

**Retrieve Form Data:**
- `request.getParameter("field_name")` gets value
- Returns `String` or `null` if missing
- `name` in HTML must match parameter name

**Server-Side Validation:**
- Check for `null` or empty
- `.trim()` removes whitespace
- **Never trust client validation!**
- User can bypass HTML5 validation

**PreparedStatement vs Statement:**

Why PreparedStatement is safer:

```java
// ❌ Statement - SQL Injection vulnerability:
String sql = "INSERT INTO students VALUES ('" + code + "')";
// If code = "'); DROP TABLE students; --"
// Result: Students table deleted!

// ✅ PreparedStatement - Safe:
pstmt.setString(1, "'); DROP TABLE students; --");
// Treated as DATA, safely escaped
```

**PreparedStatement Syntax:**
- `?` = placeholder
- Parameters are 1-indexed (first ? is 1)
- `setString(index, value)` for VARCHAR
- `setInt(index, value)` for INT
- Must set all parameters before execute

**Execute and Check Results:**
- `executeUpdate()` for INSERT/UPDATE/DELETE
- Returns number of rows affected
- `> 0` means success

**Redirect Pattern (Post-Redirect-Get):**
- Success: redirect to list with message
- Failure: redirect back to form with error
- Prevents duplicate submission on refresh

**Error Handling:**
- SQLException: Check message for "Duplicate entry"
- Show user-friendly error message
- Log details with printStackTrace()

---

### 5.3 EDIT STUDENT (UPDATE)

Two pages:
1. `edit_student.jsp` - Display form with current data
2. `process_edit.jsp` - Update database

#### Part A: Edit Form

**File:** `edit_student.jsp`

```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Student</title>
    <style>
        /* Same CSS as add_student.jsp */
        body { font-family: Arial, sans-serif; margin: 20px; background: #f5f5f5; }
        .container {
            max-width: 600px; margin: 50px auto; background: white;
            padding: 30px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .form-group { margin-bottom: 20px; }
        label { display: block; margin-bottom: 5px; font-weight: bold; }
        input[type="text"], input[type="email"] {
            width: 100%; padding: 10px; border: 1px solid #ddd;
            border-radius: 5px; box-sizing: border-box;
        }
        .btn-submit {
            background: #ffc107; color: #333; padding: 12px 30px;
            border: none; border-radius: 5px; cursor: pointer;
        }
        .btn-cancel {
            background: #6c757d; color: white; padding: 12px 30px;
            text-decoration: none; display: inline-block; border-radius: 5px;
        }
        .error { background: #f8d7da; color: #721c24; padding: 10px; border-radius: 5px; margin-bottom: 20px; }
    </style>
</head>
<body>
<%
    String idParam = request.getParameter("id");
    
    if (idParam == null || idParam.trim().isEmpty()) {
        response.sendRedirect("list_students.jsp?error=Invalid student ID");
        return;
    }
    
    int studentId = 0;
    try {
        studentId = Integer.parseInt(idParam);
    } catch (NumberFormatException e) {
        response.sendRedirect("list_students.jsp?error=Invalid ID format");
        return;
    }
    
    String studentCode = "";
    String fullName = "";
    String email = "";
    String major = "";
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/student_management",
            "root",
            "your_password"
        );
        
        String sql = "SELECT * FROM students WHERE id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, studentId);
        rs = pstmt.executeQuery();
        
        if (rs.next()) {
            studentCode = rs.getString("student_code");
            fullName = rs.getString("full_name");
            email = rs.getString("email");
            major = rs.getString("major");
            
            if (email == null) email = "";
            if (major == null) major = "";
        } else {
            response.sendRedirect("list_students.jsp?error=Student not found");
            return;
        }
        
    } catch (Exception e) {
        out.println("<div class='error'>Error: " + e.getMessage() + "</div>");
        return;
    } finally {
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>
    <div class="container">
        <h2>✏️ Edit Student Information</h2>
        
        <% if (request.getParameter("error") != null) { %>
            <div class="error"><%= request.getParameter("error") %></div>
        <% } %>
        
        <form action="process_edit.jsp" method="POST">
            <input type="hidden" name="id" value="<%= studentId %>">
            
            <div class="form-group">
                <label>Student Code</label>
                <input type="text" name="student_code" value="<%= studentCode %>" readonly>
                <small style="color: #666;">Cannot be changed</small>
            </div>
            
            <div class="form-group">
                <label>Full Name *</label>
                <input type="text" name="full_name" value="<%= fullName %>" required>
            </div>
            
            <div class="form-group">
                <label>Email</label>
                <input type="email" name="email" value="<%= email %>">
            </div>
            
            <div class="form-group">
                <label>Major</label>
                <input type="text" name="major" value="<%= major %>">
            </div>
            
            <button type="submit" class="btn-submit">💾 Update</button>
            <a href="list_students.jsp" class="btn-cancel">Cancel</a>
        </form>
    </div>
</body>
</html>
```

#### Explanation - Edit Form

**Get ID from URL:**
- URL: `edit_student.jsp?id=5`
- `request.getParameter("id")` returns `"5"` (String)

**Validate ID:**
1. Check not null/empty
2. Convert String to int with `Integer.parseInt()`
3. Catch `NumberFormatException` if invalid

**Query Student:**
```sql
SELECT * FROM students WHERE id = ?
```
- Filters to one student
- Use PreparedStatement even for integers

**ResultSet Navigation:**
- `rs.next()` returns true if found, false if not
- Extract values with `rs.getString()`, etc.
- Convert NULL to empty string for form fields

**Hidden Input:**
```html
<input type="hidden" name="id" value="5">
```
- Not visible to user
- Included in form submission
- Needed for UPDATE query

**Readonly vs Disabled:**
- `readonly`: Cannot edit, but value IS submitted
- `disabled`: Cannot edit, value NOT submitted
- Use readonly for student code (need value but prevent changes)

**Pre-filled Values:**
```html
<input value="<%= fullName %>">
```
- Shows current data
- User can modify it

#### Part B: Process Update

**File:** `process_edit.jsp`

```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String idParam = request.getParameter("id");
    String fullName = request.getParameter("full_name");
    String email = request.getParameter("email");
    String major = request.getParameter("major");
    
    if (idParam == null || fullName == null || fullName.trim().isEmpty()) {
        response.sendRedirect("list_students.jsp?error=Invalid data");
        return;
    }
    
    int studentId = Integer.parseInt(idParam);
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/student_management",
            "root",
            "your_password"
        );
        
        String sql = "UPDATE students SET full_name = ?, email = ?, major = ? WHERE id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, fullName);
        pstmt.setString(2, email);
        pstmt.setString(3, major);
        pstmt.setInt(4, studentId);
        
        int rowsAffected = pstmt.executeUpdate();
        
        if (rowsAffected > 0) {
            response.sendRedirect("list_students.jsp?message=Student updated successfully");
        } else {
            response.sendRedirect("edit_student.jsp?id=" + studentId + "&error=Update failed");
        }
        
    } catch (Exception e) {
        response.sendRedirect("edit_student.jsp?id=" + studentId + "&error=Error occurred");
        e.printStackTrace();
    } finally {
        try {
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>
```

#### Explanation - Process Update

**UPDATE SQL:**
```sql
UPDATE students SET col1 = ?, col2 = ? WHERE id = ?
```

**⚠️ CRITICAL: Always include WHERE!**

Without WHERE:
```sql
UPDATE students SET name = 'John';
```
Result: ALL students named 'John'!

**Parameter Order:**
- Positions 1-3: SET clause (what to update)
- Position 4: WHERE clause (which row)

**Check Results:**
- `rowsAffected = 0`: ID doesn't exist
- `rowsAffected = 1`: Success
- `rowsAffected > 1`: Shouldn't happen with unique ID

**Error Handling:**
- Redirect back to edit form with error
- Include ID so form can reload
- Format: `?id=5&error=message`

---

### 5.4 DELETE STUDENT (DELETE)

Single page that processes deletion.

**File:** `delete_student.jsp`

```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String idParam = request.getParameter("id");
    
    if (idParam == null || idParam.trim().isEmpty()) {
        response.sendRedirect("list_students.jsp?error=Invalid ID");
        return;
    }
    
    int studentId = Integer.parseInt(idParam);
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/student_management",
            "root",
            "your_password"
        );
        
        String sql = "DELETE FROM students WHERE id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, studentId);
        
        int rowsAffected = pstmt.executeUpdate();
        
        if (rowsAffected > 0) {
            response.sendRedirect("list_students.jsp?message=Student deleted successfully");
        } else {
            response.sendRedirect("list_students.jsp?error=Student not found");
        }
        
    } catch (SQLException e) {
        if (e.getMessage().contains("foreign key constraint")) {
            response.sendRedirect("list_students.jsp?error=Cannot delete: has related records");
        } else {
            response.sendRedirect("list_students.jsp?error=Database error");
        }
        e.printStackTrace();
    } catch (Exception e) {
        response.sendRedirect("list_students.jsp?error=Error occurred");
        e.printStackTrace();
    } finally {
        try {
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>
```

#### Explanation - Delete

**DELETE SQL:**
```sql
DELETE FROM students WHERE id = ?
```

**⚠️ DANGER: Without WHERE**
```sql
DELETE FROM students;
```
Result: ALL students deleted!

**Return Value:**
- `rowsAffected = 0`: ID not found
- `rowsAffected = 1`: Success
- `rowsAffected > 1`: Multiple deleted (shouldn't happen)

**Foreign Key Constraints:**

If student referenced in other tables:
```sql
CREATE TABLE enrollments (
    student_id INT,
    FOREIGN KEY (student_id) REFERENCES students(id)
);
```

DELETE fails with error: "foreign key constraint"

**Solutions:**
1. Cascade delete (database level)
2. Check dependencies first
3. Soft delete (set is_deleted = true)

**Soft Delete Alternative:**
```sql
UPDATE students SET is_deleted = TRUE WHERE id = ?;
SELECT * FROM students WHERE is_deleted = FALSE;
```
Benefits: Can restore, maintain history, no constraint issues

---

## 6. RUNNING THE DEMO

### Build and Deploy

1. Right-click project → **Clean and Build**
2. Right-click project → **Run**
3. NetBeans will start Tomcat and open browser

### Test CRUD Operations

**URL:** `http://localhost:8080/StudentManagement/list_students.jsp`

**Test Sequence:**

1. **View List** - See 5 sample students
2. **Add Student** - Code: SV006, Name: Test Student
3. **Edit Student** - Modify SV006 name
4. **Delete Student** - Remove SV006

### Common Issues

| Issue | Solution |
|-------|----------|
| 404 Error | Check file names, verify deployment |
| ClassNotFoundException | Add MySQL Connector/J to libraries |
| SQLException | Check MySQL running, verify credentials |
| Blank page | Check Tomcat logs for errors |

### Where to See Errors

- **NetBeans Output** - Build messages
- **Tomcat tab** - Server logs, stack traces
- **Browser F12** - Console for JavaScript errors

---

## 7. BEST PRACTICES

### Security

✅ **Always use PreparedStatement**
```java
String sql = "SELECT * FROM users WHERE username = ?";
pstmt.setString(1, username);
```

✅ **Validate on server**
```java
if (name == null || name.trim().isEmpty()) {
    return error;
}
```

✅ **Handle exceptions properly**
```java
} catch (SQLException e) {
    // Don't expose details to user
    response.sendRedirect("error.jsp?msg=Error occurred");
    // Log for debugging
    e.printStackTrace();
}
```

✅ **Always close resources**
```java
} finally {
    if (rs != null) rs.close();
    if (stmt != null) stmt.close();
    if (conn != null) conn.close();
}
```

### Code Quality

✅ **Meaningful variable names**
```java
String fullName = request.getParameter("full_name");
```

✅ **Handle NULL values**
```java
String email = rs.getString("email");
if (email == null) email = "";
```

✅ **Use constants for repeated values**
```java
private static final String DB_URL = "jdbc:mysql://localhost:3306/student_management";
```

### Database

✅ **Always use WHERE in UPDATE/DELETE**
```sql
UPDATE students SET name = ? WHERE id = ?;
DELETE FROM students WHERE id = ?;
```

✅ **Check affected rows**
```java
int rows = pstmt.executeUpdate();
if (rows > 0) { /* success */ }
```

---

## 8. SUMMARY

### What You Learned

✅ JDBC basics - Connect JSP to MySQL  
✅ CRUD operations - Create, Read, Update, Delete  
✅ PreparedStatement - Prevent SQL injection  
✅ Form handling - GET vs POST  
✅ Exception handling - Try-catch-finally  
✅ Resource management - Always close connections

### Key Comparisons

**Statement vs PreparedStatement:**
- Statement: ❌ SQL injection risk
- PreparedStatement: ✅ Safe, faster, readable

**GET vs POST:**
- GET: Data in URL, for viewing
- POST: Data in body, for modifications

**readonly vs disabled:**
- readonly: Value submitted
- disabled: Value NOT submitted

### Next Lab Preview

Lab 5: Refactor to MVC Pattern
- Model (JavaBeans)
- View (JSP - display only)
- Controller (Servlet - logic)

Better code organization and maintainability!

---

**End of Setup Guide**

*Review this before lab. Come prepared with questions!*