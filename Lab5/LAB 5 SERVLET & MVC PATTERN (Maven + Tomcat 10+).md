---
title: LAB 5 SERVLET & MVC PATTERN (Maven + Tomcat 10+)

---

---
title: LAB 5 SERVLET & MVC PATTERN (Maven + Tomcat 10+)

---

# LAB 5: SERVLET & MVC PATTERN
## Setup Guide & Sample Code (Maven + Tomcat 10+)

**Course:** Web Application Development  
**Duration:** 2.5 hours  
**Prerequisites:** Lab 4 completed (JSP + MySQL CRUD)

> **Note:** This lab refactors Lab 4 code into MVC architecture using Maven and Jakarta EE (Tomcat 10+). Read this BEFORE the lab session.

---

## 📋 TABLE OF CONTENTS

1. [Why MVC?](#1-why-mvc)
2. [MVC Architecture Overview](#2-mvc-architecture-overview)
3. [Understanding Servlets](#3-understanding-servlets)
4. [Project Setup with Maven](#4-project-setup-with-maven)
5. [Sample Code - MVC Implementation](#5-sample-code-mvc-implementation)
6. [JSTL with Jakarta EE](#6-jstl-with-jakarta-ee)
7. [Running the Demo](#7-running-the-demo)
8. [Comparison: Before vs After](#8-comparison-before-vs-after)

---

## 1. WHY MVC?

### Problems with JSP-Only Approach (Lab 4)

**Example from Lab 4:**
```jsp
<%@ page import="java.sql.*" %>
<%
    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(...);
        stmt = conn.createStatement();
        rs = stmt.executeQuery("SELECT * FROM students");
        
        while (rs.next()) {
            // Display logic mixed with database logic
%>
    <tr>
        <td><%= rs.getString("name") %></td>
    </tr>
<%
        }
    } catch (SQLException e) {
        // Error handling
    } finally {
        // Close connections
    }
%>
```

**Issues:**

1. ❌ **Mixing Concerns** - Database code + HTML in same file
2. ❌ **Code Duplication** - Connection code repeated everywhere
3. ❌ **Hard to Maintain** - Changes require editing multiple JSP files
4. ❌ **No Reusability** - Can't reuse logic for different interfaces (web, mobile API)
5. ❌ **Hard to Test** - Can't unit test JSP pages
6. ❌ **Team Conflicts** - Designers and developers work on same files

### Benefits of MVC

✅ **Separation of Concerns** - Each layer has single responsibility  
✅ **Reusability** - Business logic can serve web, mobile, API  
✅ **Maintainability** - Changes isolated to specific layers  
✅ **Testability** - Can unit test models and controllers  
✅ **Team Collaboration** - Designers work on views, developers on logic  
✅ **Industry Standard** - Used in all modern frameworks

---

## 2. MVC ARCHITECTURE OVERVIEW

### MVC Diagram

```
┌─────────┐
│ Browser │
└────┬────┘
     │ 1. HTTP Request
     ▼
┌──────────────┐
│ CONTROLLER   │ ◄── Servlet (Java Class)
│ (Servlet)    │     - Receives requests
└──────┬───────┘     - Calls Model
       │ 2. Process  - Selects View
       ▼
┌──────────────┐
│   MODEL      │ ◄── JavaBean + DAO
│   (DAO)      │     - Business logic
└──────┬───────┘     - Database operations
       │ 3. Data     - Return data objects
       ▼
┌──────────────┐
│   VIEW       │ ◄── JSP with JSTL
│   (JSP)      │     - Display only
└──────┬───────┘     - No business logic
       │ 4. HTML     - Use JSTL tags
       ▼
┌─────────┐
│ Browser │
└─────────┘
```

### Layer Responsibilities

| Layer | Responsibility | Technology | Example |
|-------|---------------|------------|---------|
| **Model** | Data & Business Logic | JavaBean, DAO | `Student.java`, `StudentDAO.java` |
| **View** | Presentation | JSP, JSTL, HTML | `student-list.jsp` |
| **Controller** | Request Handling | Servlet | `StudentController.java` |

### Request Flow Example

**Scenario:** User clicks "View All Students"

1. **Browser** → `GET /student?action=list`
2. **Controller** (StudentController) receives request
   - Extracts `action=list` parameter
   - Calls `StudentDAO.getAllStudents()`
3. **Model** (StudentDAO) executes SQL
   - Returns `List<Student>`
4. **Controller** sets data as request attribute
   - Forwards to `student-list.jsp`
5. **View** (JSP) displays using JSTL
   - `<c:forEach items="${students}">`
6. **Browser** receives HTML response

---

## 3. UNDERSTANDING SERVLETS

### What is a Servlet?

A **Servlet** is a Java class that:
- Runs on the server (Tomcat)
- Handles HTTP requests and responses
- Acts as the **Controller** in MVC
- Extends `HttpServlet` (Jakarta Servlet API)

### Basic Servlet Example

```java
package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/hello")
public class HelloServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        
        String name = request.getParameter("name");
        out.println("<h1>Hello, " + name + "!</h1>");
    }
}
```

**Explanation:**

- `@WebServlet("/hello")` - Maps URL `/hello` to this servlet
- Extends `HttpServlet` - Inherits servlet functionality
- `doGet()` - Handles HTTP GET requests
- `request` - Contains request data (parameters, headers)
- `response` - Used to send response back to client

**Important:** Note the use of `jakarta.servlet` instead of `javax.servlet` (for Tomcat 10+)

**URL Mapping:**
```
http://localhost:8080/YourApp/hello
                                ↑
                         Servlet URL pattern
```

### Servlet Annotations

```java
// Simple URL mapping
@WebServlet("/student")

// Multiple URL patterns
@WebServlet({"/student", "/students"})

// With name and parameters
@WebServlet(
    name = "StudentServlet",
    urlPatterns = {"/student"},
    loadOnStartup = 1
)
```

### doGet vs doPost

```java
@WebServlet("/demo")
public class DemoServlet extends HttpServlet {
    
    // Handles: GET /demo
    protected void doGet(HttpServletRequest request, HttpServletResponse response) {
        // Use for: viewing data, search, filter
        // Parameters visible in URL
    }
    
    // Handles: POST /demo
    protected void doPost(HttpServletRequest request, HttpServletResponse response) {
        // Use for: create, update, delete
        // Parameters in request body
    }
}
```

**When to use:**
- **GET:** Retrieve/display data, idempotent operations
- **POST:** Modify data, non-idempotent operations

---

## 4. PROJECT SETUP WITH MAVEN

### 4.1 Create Maven Web Project

**Option A: Using IntelliJ IDEA**

1. **New Project** → **Maven Archetype**
2. Select: `maven-archetype-webapp`
3. **GroupId:** `com.student`
4. **ArtifactId:** `student-management-mvc`
5. **Version:** `1.0-SNAPSHOT`

**Option B: Using NetBeans**

1. **New Project** → **Maven** → **Web Application**
2. Fill in project details
3. Click **Finish**

**Option C: Using Command Line**

```bash
mvn archetype:generate \
  -DgroupId=com.student \
  -DartifactId=student-management-mvc \
  -DarchetypeArtifactId=maven-archetype-webapp \
  -DinteractiveMode=false
```

### 4.2 Project Structure

```
student-management-mvc/
│
├── pom.xml                          ← Maven configuration
│
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/student/
│   │   │       ├── model/
│   │   │       │   └── Student.java
│   │   │       ├── dao/
│   │   │       │   └── StudentDAO.java
│   │   │       └── controller/
│   │   │           └── StudentController.java
│   │   │
│   │   ├── resources/
│   │   │   └── (configuration files)
│   │   │
│   │   └── webapp/
│   │       ├── WEB-INF/
│   │       │   └── web.xml
│   │       └── views/
│   │           ├── student-list.jsp
│   │           └── student-form.jsp
│   │
│   └── test/
│       └── java/
│           └── (test files)
│
└── target/                          ← Compiled output
```

### 4.3 Configure pom.xml

**Complete pom.xml for Tomcat 10+ with Jakarta EE:**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 
         http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>com.student</groupId>
    <artifactId>student-management-mvc</artifactId>
    <version>1.0-SNAPSHOT</version>
    <packaging>war</packaging>

    <name>Student Management MVC</name>

    <properties>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <maven.compiler.source>17</maven.compiler.source>
        <maven.compiler.target>17</maven.compiler.target>
        <jakarta.servlet.version>6.0.0</jakarta.servlet.version>
        <jakarta.servlet.jsp.version>3.1.1</jakarta.servlet.jsp.version>
        <jakarta.servlet.jsp.jstl.version>3.0.1</jakarta.servlet.jsp.jstl.version>
        <mysql.connector.version>8.0.33</mysql.connector.version>
    </properties>

    <dependencies>
        <!-- Jakarta Servlet API (for Tomcat 10+) -->
        <dependency>
            <groupId>jakarta.servlet</groupId>
            <artifactId>jakarta.servlet-api</artifactId>
            <version>${jakarta.servlet.version}</version>
            <scope>provided</scope>
        </dependency>

        <!-- Jakarta JSP API (for Tomcat 10+) -->
        <dependency>
            <groupId>jakarta.servlet.jsp</groupId>
            <artifactId>jakarta.servlet.jsp-api</artifactId>
            <version>${jakarta.servlet.jsp.version}</version>
            <scope>provided</scope>
        </dependency>

        <!-- Jakarta JSTL API (for Tomcat 10+) -->
        <dependency>
            <groupId>jakarta.servlet.jsp.jstl</groupId>
            <artifactId>jakarta.servlet.jsp.jstl-api</artifactId>
            <version>${jakarta.servlet.jsp.jstl.version}</version>
        </dependency>

        <!-- Glassfish JSTL Implementation -->
        <dependency>
            <groupId>org.glassfish.web</groupId>
            <artifactId>jakarta.servlet.jsp.jstl</artifactId>
            <version>${jakarta.servlet.jsp.jstl.version}</version>
        </dependency>

        <!-- MySQL Connector -->
        <dependency>
            <groupId>com.mysql</groupId>
            <artifactId>mysql-connector-j</artifactId>
            <version>${mysql.connector.version}</version>
        </dependency>

        <!-- JUnit for testing (optional) -->
        <dependency>
            <groupId>junit</groupId>
            <artifactId>junit</artifactId>
            <version>4.13.2</version>
            <scope>test</scope>
        </dependency>
    </dependencies>

    <build>
        <finalName>student-management-mvc</finalName>
        <plugins>
            <!-- Maven Compiler Plugin -->
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-compiler-plugin</artifactId>
                <version>3.11.0</version>
                <configuration>
                    <source>17</source>
                    <target>17</target>
                </configuration>
            </plugin>

            <!-- Maven WAR Plugin -->
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-war-plugin</artifactId>
                <version>3.3.2</version>
                <configuration>
                    <failOnMissingWebXml>false</failOnMissingWebXml>
                </configuration>
            </plugin>

            <!-- Tomcat Maven Plugin (for easy deployment) -->
            <plugin>
                <groupId>org.apache.tomcat.maven</groupId>
                <artifactId>tomcat7-maven-plugin</artifactId>
                <version>2.2</version>
                <configuration>
                    <url>http://localhost:8080/manager/text</url>
                    <server>TomcatServer</server>
                    <path>/student-mvc</path>
                </configuration>
            </plugin>
        </plugins>
    </build>
</project>
```

### web.xml
```xml
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns="https://jakarta.ee/xml/ns/jakartaee"
   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
   xsi:schemaLocation="https://jakarta.ee/xml/ns/jakartaee https://jakarta.ee/xml/ns/jakartaee/web-app_6_0.xsd"
   version="6.0">
    <session-config>
        <session-timeout>
            30
        </session-timeout>
    </session-config>
</web-app>

```
### 4.4 Key Dependencies Explained

| Dependency | Version | Purpose | Scope |
|------------|---------|---------|-------|
| `jakarta.servlet-api` | 6.0.0 | Servlet API for Tomcat 10+ | provided |
| `jakarta.servlet.jsp-api` | 3.1.1 | JSP API | provided |
| `jakarta.servlet.jsp.jstl-api` | 3.0.1 | JSTL API | compile |
| `jakarta.servlet.jsp.jstl` | 3.0.1 | JSTL Implementation | compile |
| `mysql-connector-j` | 8.0.33 | MySQL JDBC Driver | compile |

**Important Notes:**

1. **Jakarta vs Javax:** Tomcat 10+ uses Jakarta EE (namespace changed from `javax.*` to `jakarta.*`)
2. **Scope provided:** Tomcat already has these libraries, don't include in WAR
3. **JSTL needs both:** API + Implementation (Glassfish)

### 4.5 Create Package Structure

Right-click on `src/main/java` → Create packages:

```
com.student.model
com.student.dao
com.student.controller
```

### 4.6 Update Maven Dependencies

After creating/editing `pom.xml`:

**IntelliJ IDEA:**
- Click "Load Maven Changes" (icon in top right)
- Or: Right-click `pom.xml` → Maven → Reload Project

**NetBeans:**
- Right-click project → Build with Dependencies

**Command Line:**
```bash
mvn clean install
```

---

## 5. SAMPLE CODE - MVC IMPLEMENTATION

### 5.1 MODEL Layer

#### Student JavaBean (POJO)

**File:** `src/main/java/com/student/model/Student.java`

```java
package com.student.model;

import java.sql.Timestamp;

public class Student {
    private int id;
    private String studentCode;
    private String fullName;
    private String email;
    private String major;
    private Timestamp createdAt;
    
    // No-arg constructor (required for JavaBean)
    public Student() {
    }
    
    // Constructor for creating new student (without ID)
    public Student(String studentCode, String fullName, String email, String major) {
        this.studentCode = studentCode;
        this.fullName = fullName;
        this.email = email;
        this.major = major;
    }
    
    // Getters and Setters
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public String getStudentCode() {
        return studentCode;
    }
    
    public void setStudentCode(String studentCode) {
        this.studentCode = studentCode;
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
    
    public String getMajor() {
        return major;
    }
    
    public void setMajor(String major) {
        this.major = major;
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    
    @Override
    public String toString() {
        return "Student{" +
                "id=" + id +
                ", studentCode='" + studentCode + '\'' +
                ", fullName='" + fullName + '\'' +
                ", email='" + email + '\'' +
                ", major='" + major + '\'' +
                '}';
    }
}
```

**JavaBean Requirements:**
✅ Public no-arg constructor  
✅ Private attributes  
✅ Public getters/setters  
✅ Serializable (optional but recommended)

---

#### Data Access Object (DAO)

**File:** `src/main/java/com/student/dao/StudentDAO.java`

```java
package com.student.dao;

import com.student.model.Student;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class StudentDAO {
    
    // Database configuration
    private static final String DB_URL = "jdbc:mysql://localhost:3306/student_management";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "your_password";
    
    // Get database connection
    private Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
        } catch (ClassNotFoundException e) {
            throw new SQLException("MySQL Driver not found", e);
        }
    }
    
    // Get all students
    public List<Student> getAllStudents() {
        List<Student> students = new ArrayList<>();
        String sql = "SELECT * FROM students ORDER BY id DESC";
        
        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Student student = new Student();
                student.setId(rs.getInt("id"));
                student.setStudentCode(rs.getString("student_code"));
                student.setFullName(rs.getString("full_name"));
                student.setEmail(rs.getString("email"));
                student.setMajor(rs.getString("major"));
                student.setCreatedAt(rs.getTimestamp("created_at"));
                students.add(student);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return students;
    }
    
    // Get student by ID
    public Student getStudentById(int id) {
        String sql = "SELECT * FROM students WHERE id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                Student student = new Student();
                student.setId(rs.getInt("id"));
                student.setStudentCode(rs.getString("student_code"));
                student.setFullName(rs.getString("full_name"));
                student.setEmail(rs.getString("email"));
                student.setMajor(rs.getString("major"));
                student.setCreatedAt(rs.getTimestamp("created_at"));
                return student;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    // Add new student
    public boolean addStudent(Student student) {
        String sql = "INSERT INTO students (student_code, full_name, email, major) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, student.getStudentCode());
            pstmt.setString(2, student.getFullName());
            pstmt.setString(3, student.getEmail());
            pstmt.setString(4, student.getMajor());
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Update student
    public boolean updateStudent(Student student) {
        String sql = "UPDATE students SET student_code = ?, full_name = ?, email = ?, major = ? WHERE id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, student.getStudentCode());
            pstmt.setString(2, student.getFullName());
            pstmt.setString(3, student.getEmail());
            pstmt.setString(4, student.getMajor());
            pstmt.setInt(5, student.getId());
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Delete student
    public boolean deleteStudent(int id) {
        String sql = "DELETE FROM students WHERE id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
```

**DAO Pattern Benefits:**
- ✅ Centralized database logic
- ✅ Easy to test
- ✅ Reusable across controllers
- ✅ Easy to switch databases

---

### 5.2 CONTROLLER Layer

**File:** `src/main/java/com/student/controller/StudentController.java`

```java
package com.student.controller;

import com.student.dao.StudentDAO;
import com.student.model.Student;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/student")
public class StudentController extends HttpServlet {
    
    private StudentDAO studentDAO;
    
    @Override
    public void init() {
        studentDAO = new StudentDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "list";
        }
        
        switch (action) {
            case "new":
                showNewForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteStudent(request, response);
                break;
            default:
                listStudents(request, response);
                break;
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        switch (action) {
            case "insert":
                insertStudent(request, response);
                break;
            case "update":
                updateStudent(request, response);
                break;
        }
    }
    
    // List all students
    private void listStudents(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<Student> students = studentDAO.getAllStudents();
        request.setAttribute("students", students);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/student-list.jsp");
        dispatcher.forward(request, response);
    }
    
    // Show form for new student
    private void showNewForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/student-form.jsp");
        dispatcher.forward(request, response);
    }
    
    // Show form for editing student
    private void showEditForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int id = Integer.parseInt(request.getParameter("id"));
        Student existingStudent = studentDAO.getStudentById(id);
        
        request.setAttribute("student", existingStudent);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/student-form.jsp");
        dispatcher.forward(request, response);
    }
    
    // Insert new student
    private void insertStudent(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        String studentCode = request.getParameter("studentCode");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String major = request.getParameter("major");
        
        Student newStudent = new Student(studentCode, fullName, email, major);
        
        if (studentDAO.addStudent(newStudent)) {
            response.sendRedirect("student?action=list&message=Student added successfully");
        } else {
            response.sendRedirect("student?action=list&error=Failed to add student");
        }
    }
    
    // Update student
    private void updateStudent(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        int id = Integer.parseInt(request.getParameter("id"));
        String studentCode = request.getParameter("studentCode");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String major = request.getParameter("major");
        
        Student student = new Student(studentCode, fullName, email, major);
        student.setId(id);
        
        if (studentDAO.updateStudent(student)) {
            response.sendRedirect("student?action=list&message=Student updated successfully");
        } else {
            response.sendRedirect("student?action=list&error=Failed to update student");
        }
    }
    
    // Delete student
    private void deleteStudent(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        int id = Integer.parseInt(request.getParameter("id"));
        
        if (studentDAO.deleteStudent(id)) {
            response.sendRedirect("student?action=list&message=Student deleted successfully");
        } else {
            response.sendRedirect("student?action=list&error=Failed to delete student");
        }
    }
}
```

**Controller Pattern:**
- ✅ Single entry point for all student operations
- ✅ Routes based on `action` parameter
- ✅ Separates GET (display) from POST (modify)
- ✅ Uses forward for views, redirect after POST

---

### 5.3 VIEW Layer

#### Student List View

**File:** `src/main/webapp/views/student-list.jsp`

```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student List - MVC</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
        }
        
        h1 {
            color: #333;
            margin-bottom: 10px;
            font-size: 32px;
        }
        
        .subtitle {
            color: #666;
            margin-bottom: 30px;
            font-style: italic;
        }
        
        .message {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 5px;
            font-weight: 500;
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
            padding: 12px 24px;
            text-decoration: none;
            border-radius: 5px;
            font-weight: 500;
            transition: all 0.3s;
            border: none;
            cursor: pointer;
            font-size: 14px;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }
        
        .btn-secondary {
            background-color: #6c757d;
            color: white;
        }
        
        .btn-danger {
            background-color: #dc3545;
            color: white;
            padding: 8px 16px;
            font-size: 13px;
        }
        
        .btn-danger:hover {
            background-color: #c82333;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        
        thead {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        th, td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        
        th {
            font-weight: 600;
            text-transform: uppercase;
            font-size: 13px;
            letter-spacing: 0.5px;
        }
        
        tbody tr {
            transition: background-color 0.2s;
        }
        
        tbody tr:hover {
            background-color: #f8f9fa;
        }
        
        .actions {
            display: flex;
            gap: 10px;
        }
        
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #999;
        }
        
        .empty-state-icon {
            font-size: 64px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>📚 Student Management System</h1>
        <p class="subtitle">MVC Pattern with Jakarta EE & JSTL</p>
        
        <!-- Success Message -->
        <c:if test="${not empty param.message}">
            <div class="message success">
                ✅ ${param.message}
            </div>
        </c:if>
        
        <!-- Error Message -->
        <c:if test="${not empty param.error}">
            <div class="message error">
                ❌ ${param.error}
            </div>
        </c:if>
        
        <!-- Add New Student Button -->
        <div style="margin-bottom: 20px;">
            <a href="student?action=new" class="btn btn-primary">
                ➕ Add New Student
            </a>
        </div>
        
        <!-- Student Table -->
        <c:choose>
            <c:when test="${not empty students}">
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Student Code</th>
                            <th>Full Name</th>
                            <th>Email</th>
                            <th>Major</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="student" items="${students}">
                            <tr>
                                <td>${student.id}</td>
                                <td><strong>${student.studentCode}</strong></td>
                                <td>${student.fullName}</td>
                                <td>${student.email}</td>
                                <td>${student.major}</td>
                                <td>
                                    <div class="actions">
                                        <a href="student?action=edit&id=${student.id}" class="btn btn-secondary">
                                            ✏️ Edit
                                        </a>
                                        <a href="student?action=delete&id=${student.id}" 
                                           class="btn btn-danger"
                                           onclick="return confirm('Are you sure you want to delete this student?')">
                                            🗑️ Delete
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <div class="empty-state-icon">📭</div>
                    <h3>No students found</h3>
                    <p>Start by adding a new student</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</body>
</html>
```

**Key JSTL Tags Used:**

| Tag | Purpose | Example |
|-----|---------|---------|
| `<c:if>` | Conditional display | Show message if exists |
| `<c:choose>` | Multiple conditions | Like if-else |
| `<c:when>` | Condition branch | When students exist |
| `<c:otherwise>` | Default branch | When no students |
| `<c:forEach>` | Loop through collection | Display each student |
| `${expression}` | EL expression | Access Java objects |

---

#### Student Form View

**File:** `src/main/webapp/views/student-form.jsp`

```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>
        <c:choose>
            <c:when test="${student != null}">Edit Student</c:when>
            <c:otherwise>Add New Student</c:otherwise>
        </c:choose>
    </title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }
        
        .container {
            background: white;
            border-radius: 10px;
            padding: 40px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
            width: 100%;
            max-width: 600px;
        }
        
        h1 {
            color: #333;
            margin-bottom: 30px;
            font-size: 28px;
            text-align: center;
        }
        
        .form-group {
            margin-bottom: 25px;
        }
        
        label {
            display: block;
            margin-bottom: 8px;
            color: #555;
            font-weight: 500;
            font-size: 14px;
        }
        
        input[type="text"],
        input[type="email"],
        select {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
            transition: border-color 0.3s;
        }
        
        input:focus,
        select:focus {
            outline: none;
            border-color: #667eea;
        }
        
        .required {
            color: #dc3545;
        }
        
        .button-group {
            display: flex;
            gap: 15px;
            margin-top: 30px;
        }
        
        .btn {
            flex: 1;
            padding: 14px;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
            text-align: center;
            display: inline-block;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }
        
        .btn-secondary {
            background-color: #6c757d;
            color: white;
        }
        
        .btn-secondary:hover {
            background-color: #5a6268;
        }
        
        .info-text {
            font-size: 12px;
            color: #666;
            margin-top: 5px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>
            <c:choose>
                <c:when test="${student != null}">
                    ✏️ Edit Student
                </c:when>
                <c:otherwise>
                    ➕ Add New Student
                </c:otherwise>
            </c:choose>
        </h1>
        
        <form action="student" method="POST">
            <!-- Hidden field for action -->
            <input type="hidden" name="action" 
                   value="${student != null ? 'update' : 'insert'}">
            
            <!-- Hidden field for ID (only for update) -->
            <c:if test="${student != null}">
                <input type="hidden" name="id" value="${student.id}">
            </c:if>
            
            <!-- Student Code -->
            <div class="form-group">
                <label for="studentCode">
                    Student Code <span class="required">*</span>
                </label>
                <input type="text" 
                       id="studentCode" 
                       name="studentCode" 
                       value="${student.studentCode}"
                       ${student != null ? 'readonly' : 'required'}
                       placeholder="e.g., SV001, IT123">
                <p class="info-text">Format: 2 letters + 3+ digits</p>
            </div>
            
            <!-- Full Name -->
            <div class="form-group">
                <label for="fullName">
                    Full Name <span class="required">*</span>
                </label>
                <input type="text" 
                       id="fullName" 
                       name="fullName" 
                       value="${student.fullName}"
                       required
                       placeholder="Enter full name">
            </div>
            
            <!-- Email -->
            <div class="form-group">
                <label for="email">
                    Email <span class="required">*</span>
                </label>
                <input type="email" 
                       id="email" 
                       name="email" 
                       value="${student.email}"
                       required
                       placeholder="student@example.com">
            </div>
            
            <!-- Major -->
            <div class="form-group">
                <label for="major">
                    Major <span class="required">*</span>
                </label>
                <select id="major" name="major" required>
                    <option value="">-- Select Major --</option>
                    <option value="Computer Science" 
                            ${student.major == 'Computer Science' ? 'selected' : ''}>
                        Computer Science
                    </option>
                    <option value="Information Technology" 
                            ${student.major == 'Information Technology' ? 'selected' : ''}>
                        Information Technology
                    </option>
                    <option value="Software Engineering" 
                            ${student.major == 'Software Engineering' ? 'selected' : ''}>
                        Software Engineering
                    </option>
                    <option value="Business Administration" 
                            ${student.major == 'Business Administration' ? 'selected' : ''}>
                        Business Administration
                    </option>
                </select>
            </div>
            
            <!-- Buttons -->
            <div class="button-group">
                <button type="submit" class="btn btn-primary">
                    <c:choose>
                        <c:when test="${student != null}">
                            💾 Update Student
                        </c:when>
                        <c:otherwise>
                            ➕ Add Student
                        </c:otherwise>
                    </c:choose>
                </button>
                <a href="student?action=list" class="btn btn-secondary">
                    ❌ Cancel
                </a>
            </div>
        </form>
    </div>
</body>
</html>
```

---

## 6. JSTL WITH JAKARTA EE

### 6.1 JSTL Taglib Declaration

**For Tomcat 10+ (Jakarta EE), use:**

```jsp
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
```

**For older Tomcat (Javax), use:**

```jsp
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
```

### 6.2 Common JSTL Tags

#### Conditional Tags

```jsp
<!-- Simple condition -->
<c:if test="${not empty students}">
    <p>Found ${students.size()} students</p>
</c:if>

<!-- Multiple conditions -->
<c:choose>
    <c:when test="${student.major == 'CS'}">
        <span class="badge blue">Computer Science</span>
    </c:when>
    <c:when test="${student.major == 'IT'}">
        <span class="badge green">Information Technology</span>
    </c:when>
    <c:otherwise>
        <span class="badge gray">${student.major}</span>
    </c:otherwise>
</c:choose>
```

#### Iteration Tags

```jsp
<!-- Loop with index -->
<c:forEach var="student" items="${students}" varStatus="status">
    <tr class="${status.index % 2 == 0 ? 'even' : 'odd'}">
        <td>${status.count}</td>
        <td>${student.fullName}</td>
    </tr>
</c:forEach>

<!-- Loop with range -->
<c:forEach var="i" begin="1" end="10">
    <option value="${i}">Page ${i}</option>
</c:forEach>
```

#### Variable Tags

```jsp
<!-- Set variable -->
<c:set var="total" value="${students.size()}" />
<p>Total: ${total}</p>

<!-- Remove variable -->
<c:remove var="total" />
```

#### URL Tags

```jsp
<!-- Build URL with parameters -->
<c:url value="/student" var="editUrl">
    <c:param name="action" value="edit" />
    <c:param name="id" value="${student.id}" />
</c:url>
<a href="${editUrl}">Edit</a>
```

### 6.3 Expression Language (EL)

```jsp
<!-- Access properties -->
${student.fullName}          <!-- Calls student.getFullName() -->

<!-- Access map/list -->
${students[0]}               <!-- First student -->
${studentMap['key']}         <!-- Map access -->

<!-- Arithmetic -->
${price * quantity}

<!-- Comparison -->
${age >= 18}

<!-- Logical operators -->
${!empty students and students.size() > 0}

<!-- Ternary operator -->
${student != null ? 'Edit' : 'Add'}

<!-- Null-safe access -->
${student.email}             <!-- Returns empty string if null -->

<!-- Access request parameters -->
${param.action}              <!-- request.getParameter("action") -->

<!-- Access session attributes -->
${sessionScope.user}         <!-- session.getAttribute("user") -->
```

---

## 7. RUNNING THE DEMO

### 7.1 Database Setup

```sql
CREATE DATABASE IF NOT EXISTS student_management;
USE student_management;

CREATE TABLE students (
    id INT PRIMARY KEY AUTO_INCREMENT,
    student_code VARCHAR(20) UNIQUE NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    major VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample data
INSERT INTO students (student_code, full_name, email, major) VALUES
('SV001', 'Nguyen Van A', 'a.nguyen@example.com', 'Computer Science'),
('SV002', 'Tran Thi B', 'b.tran@example.com', 'Information Technology'),
('SV003', 'Le Van C', 'c.le@example.com', 'Software Engineering');
```

### 7.2 Build and Deploy

**Using Maven:**

```bash
# Clean and build
mvn clean package

# Deploy to Tomcat (if configured)
mvn tomcat7:deploy

# Or manually copy WAR file
cp target/student-management-mvc.war $TOMCAT_HOME/webapps/
```

**Using IDE:**

**IntelliJ IDEA:**
1. Run → Edit Configurations
2. Add New → Tomcat Server → Local
3. Deployment tab → Add artifact → WAR exploded
4. Click Run

**NetBeans:**
1. Right-click project → Run
2. NetBeans auto-deploys to bundled Tomcat

### 7.3 Access Application

```
http://localhost:8080/student-management-mvc/student
```

**URL Structure:**
```
http://localhost:8080/[war-name]/[servlet-mapping]?action=[action]&id=[id]
```

**Examples:**
```
http://localhost:8080/student-management-mvc/student?action=list
http://localhost:8080/student-management-mvc/student?action=new
http://localhost:8080/student-management-mvc/student?action=edit&id=1
```

---

## 8. COMPARISON: BEFORE VS AFTER

### Before MVC (JSP Only)

```jsp
<%-- student-list.jsp (OLD WAY) --%>
<%@ page import="java.sql.*" %>
<html>
<body>
    <h1>Students</h1>
    <%
        Connection conn = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/db", "root", "pass");
            
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT * FROM students");
            
            while (rs.next()) {
    %>
        <tr>
            <td><%= rs.getString("student_code") %></td>
            <td><%= rs.getString("full_name") %></td>
            <td>
                <a href="edit-student.jsp?id=<%= rs.getInt("id") %>">Edit</a>
                <a href="delete-student.jsp?id=<%= rs.getInt("id") %>">Delete</a>
            </td>
        </tr>
    <%
            }
        } catch (Exception e) {
            out.println("Error: " + e.getMessage());
        } finally {
            if (conn != null) conn.close();
        }
    %>
</body>
</html>
```

**Problems:**
- ❌ Mixing Java code with HTML
- ❌ Database logic in presentation layer
- ❌ Code duplication across pages
- ❌ Hard to test
- ❌ Hard to maintain

### After MVC

**Controller:**
```java
@WebServlet("/student")
public class StudentController extends HttpServlet {
    private StudentDAO dao = new StudentDAO();
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) {
        List<Student> students = dao.getAllStudents();
        request.setAttribute("students", students);
        request.getRequestDispatcher("/views/student-list.jsp").forward(request, response);
    }
}
```

**View:**
```jsp
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<html>
<body>
    <h1>Students</h1>
    <c:forEach var="student" items="${students}">
        <tr>
            <td>${student.studentCode}</td>
            <td>${student.fullName}</td>
            <td>
                <a href="student?action=edit&id=${student.id}">Edit</a>
                <a href="student?action=delete&id=${student.id}">Delete</a>
            </td>
        </tr>
    </c:forEach>
</body>
</html>
```

**Benefits:**
- ✅ Clean separation of concerns
- ✅ No Java code in JSP
- ✅ Reusable DAO layer
- ✅ Easy to test
- ✅ Easy to maintain
- ✅ Professional code structure

---

## TROUBLESHOOTING

### Issue 1: JSTL Tags Show as Text

**Problem:**
```jsp
<c:if test="${not empty students}">  <!-- Shows as text -->
```

**Solution:**
1. Check taglib declaration:
```jsp
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
```

2. Verify dependencies in `pom.xml`:
```xml
<dependency>
    <groupId>jakarta.servlet.jsp.jstl</groupId>
    <artifactId>jakarta.servlet.jsp.jstl-api</artifactId>
    <version>3.0.1</version>
</dependency>
<dependency>
    <groupId>org.glassfish.web</groupId>
    <artifactId>jakarta.servlet.jsp.jstl</artifactId>
    <version>3.0.1</version>
</dependency>
```

3. Rebuild project: `mvn clean install`

### Issue 2: ClassNotFoundException for Jakarta Servlet

**Problem:**
```
java.lang.ClassNotFoundException: jakarta.servlet.http.HttpServlet
```

**Solution:**
1. Check Tomcat version (must be 10+)
2. Verify `pom.xml` uses `jakarta.*` not `javax.*`
3. Clean and rebuild: `mvn clean install`

### Issue 3: 404 Error - Servlet Not Found

**Problem:**
```
HTTP Status 404 – Not Found
```

**Solution:**
1. Check servlet annotation:
```java
@WebServlet("/student")  // Correct
```

2. Verify URL:
```
http://localhost:8080/student-management-mvc/student
                      ↑ WAR name          ↑ Servlet path
```

3. Check deployment:
```bash
ls $TOMCAT_HOME/webapps/
# Should see student-management-mvc.war or folder
```

### Issue 4: MySQL Connection Failed

**Problem:**
```
com.mysql.cj.jdbc.exceptions.CommunicationsException
```

**Solution:**
1. Check MySQL is running
2. Verify connection URL in `StudentDAO.java`:
```java
private static final String DB_URL = "jdbc:mysql://localhost:3306/student_management";
private static final String DB_USER = "root";
private static final String DB_PASSWORD = "your_password";
```

3. Test connection:
```bash
mysql -u root -p
USE student_management;
SHOW TABLES;
```

### Issue 5: Maven Build Fails

**Problem:**
```
[ERROR] Failed to execute goal
```

**Solution:**
1. Check Java version:
```bash
java -version  # Should be 17+
mvn -version   # Should use Java 17+
```

2. Update `pom.xml`:
```xml
<properties>
    <maven.compiler.source>17</maven.compiler.source>
    <maven.compiler.target>17</maven.compiler.target>
</properties>
```

3. Clean and rebuild:
```bash
mvn clean
mvn install
```

---

## NEXT STEPS

Now that you understand MVC basics:

1. ✅ Complete Lab 5 exercises
2. ✅ Add validation to forms
3. ✅ Implement search functionality
4. ✅ Add pagination
5. ✅ Learn about Filters for authentication
6. ✅ Explore RESTful APIs with servlets

**Next Lab:** Session Management and Authentication

---

## SUMMARY

### Key Takeaways:

1. **MVC Pattern** separates application into Model, View, Controller
2. **Jakarta EE** (Tomcat 10+) uses `jakarta.*` namespace
3. **Maven** simplifies dependency management
4. **JSTL** eliminates scriptlets in JSP
5. **Servlets** act as controllers handling HTTP requests
6. **DAO Pattern** centralizes database operations

### Project Structure:
```
Maven Project
├── pom.xml (dependencies)
├── src/main/java/com/student/
│   ├── model/Student.java
│   ├── dao/StudentDAO.java
│   └── controller/StudentController.java
└── src/main/webapp/views/
    ├── student-list.jsp
    └── student-form.jsp
```

### Maven Dependencies for Tomcat 10+:
- `jakarta.servlet-api` (6.0.0)
- `jakarta.servlet.jsp-api` (3.1.1)
- `jakarta.servlet.jsp.jstl-api` (3.0.1)
- `jakarta.servlet.jsp.jstl` (3.0.1)
- `mysql-connector-j` (8.0.33)

**Good luck with Lab 5! 🚀**