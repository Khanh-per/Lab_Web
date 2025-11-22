---
title: 'LAB 6 [EXERCISES]: AUTHENTICATION & SESSION MANAGEMENT'

---

---
title: 'LAB 6 [EXERCISES]: AUTHENTICATION & SESSION MANAGEMENT'

---

---
title: 'LAB 6 EXERCISES: AUTHENTICATION & SESSION MANAGEMENT'

---

# LAB 6 EXERCISES: AUTHENTICATION & SESSION MANAGEMENT

**Course:** Web Application Development  
**Lab Duration:** 2.5 hours  
**Total Points:** 100 points (In-class: 60 points, Homework: 40 points)

---

## 📚 BEFORE YOU START

### Prerequisites:
- ✅ Completed Lab 5 (Servlet & MVC Pattern)
- ✅ Read Lab 6 Setup Guide
- ✅ MySQL running with `student_management` database
- ✅ BCrypt library (jbcrypt-0.4.jar) downloaded
- ✅ Understanding of authentication and session concepts

### Lab Objectives:
By the end of this lab, you should be able to:
1. Implement user authentication (login/logout)
2. Manage user sessions
3. Create and use Servlet Filters
4. Implement role-based access control
5. Secure passwords using BCrypt
6. Build protected pages with authorization

---

## PART A: IN-CLASS EXERCISES (60 points)

**Time Allocation:** 2.5 hours  
**Submission:** Demonstrate to instructor at end of class

---

### EXERCISE 1: DATABASE & USER MODEL (15 points)

**Estimated Time:** 25 minutes

#### Task 1.1: Create Users Table (5 points)

Execute this SQL in your MySQL database:

```sql
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    role ENUM('admin', 'user') DEFAULT 'user',
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP NULL
);
```

**Verification Query:**
```sql
DESCRIBE users;
```

**Evaluation Criteria:**
| Criteria | Points |
|----------|--------|
| Table created with correct structure | 3 |
| All columns with proper data types | 1 |
| Primary key and constraints set | 1 |

---

#### Task 1.2: Generate Hashed Passwords (5 points)

**Create test file:** `src/util/PasswordHashGenerator.java`

```java
package util;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordHashGenerator {
    
    public static void main(String[] args) {
        String plainPassword = "password123";
        
        // Generate hash
        String hashedPassword = BCrypt.hashpw(plainPassword, BCrypt.gensalt());
        
        System.out.println("Plain Password: " + plainPassword);
        System.out.println("Hashed Password: " + hashedPassword);
        System.out.println("\nCopy the hashed password to your INSERT statement");
        
        // Test verification
        boolean matches = BCrypt.checkpw(plainPassword, hashedPassword);
        System.out.println("\nVerification test: " + matches);
    }
}
```

**Steps:**
1. Add BCrypt library to project
2. Create PasswordHashGenerator class
3. Run the main method
4. Copy generated hash

**Evaluation Criteria:**
| Criteria | Points |
|----------|--------|
| BCrypt library added | 2 |
| Hash generated successfully | 2 |
| Verification works | 1 |

---

#### Task 1.3: Insert Test Users (5 points)

Use the hashed password from Task 1.2:

```sql
-- Replace YOUR_HASHED_PASSWORD with the actual hash
INSERT INTO users (username, password, full_name, role) VALUES
('admin', 'YOUR_HASHED_PASSWORD', 'Admin User', 'admin'),
('john', 'YOUR_HASHED_PASSWORD', 'John Doe', 'user'),
('jane', 'YOUR_HASHED_PASSWORD', 'Jane Smith', 'user');
```

**Verification:**
```sql
SELECT id, username, full_name, role, is_active FROM users;
```

**Evaluation Criteria:**
| Criteria | Points |
|----------|--------|
| At least 3 users inserted | 3 |
| One admin and two regular users | 1 |
| All passwords properly hashed | 1 |

**Checkpoint #1:** Show instructor the users table with test data.

---

### EXERCISE 2: USER MODEL & DAO (15 points)

**Estimated Time:** 30 minutes

#### Task 2.1: Create User Model (7 points)

**File:** `src/model/User.java`

**Requirements:**
- Private attributes matching database columns
- Two constructors (no-arg and parameterized)
- All getters and setters
- Utility methods: `isAdmin()`, `isUser()`
- Override `toString()`

**Code template:**
```java
package model;

import java.sql.Timestamp;

public class User {
    // TODO: Declare private attributes
    // - id (int)
    // - username (String)
    // - password (String)
    // - fullName (String)
    // - role (String)
    // - isActive (boolean)
    // - createdAt (Timestamp)
    // - lastLogin (Timestamp)
    
    // TODO: Create no-arg constructor
    
    // TODO: Create parameterized constructor (username, password, fullName, role)
    
    // TODO: Generate all getters and setters
    
    // TODO: Implement utility methods
    public boolean isAdmin() {
        // return true if role is "admin"
    }
    
    public boolean isUser() {
        // return true if role is "user"
    }
    
    // TODO: Override toString()
}
```

**Evaluation Criteria:**
| Criteria | Points |
|----------|--------|
| All attributes declared correctly | 2 |
| Constructors implemented | 2 |
| Getters/setters complete | 2 |
| Utility methods implemented | 1 |

---

#### Task 2.2: Create UserDAO (8 points)

**File:** `src/dao/UserDAO.java`

**Requirements:**
- Database connection method
- `authenticate(username, password)` method
- `getUserById(id)` method
- `updateLastLogin(userId)` method
- Use BCrypt for password verification

**Code skeleton:**
```java
package dao;

import model.User;
import org.mindrot.jbcrypt.BCrypt;
import java.sql.*;

public class UserDAO {
    
    private static final String DB_URL = "jdbc:mysql://localhost:3306/student_management";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "";
    
    // TODO: SQL queries constants
    private static final String SQL_AUTHENTICATE = 
        "SELECT * FROM users WHERE username = ? AND is_active = TRUE";
    
    private static final String SQL_UPDATE_LAST_LOGIN = 
        "UPDATE users SET last_login = NOW() WHERE id = ?";
    
    private static final String SQL_GET_BY_ID = 
        "SELECT * FROM users WHERE id = ?";
    
    // TODO: Implement getConnection()
    private Connection getConnection() throws SQLException {
        // Load driver and return connection
    }
    
    // TODO: Implement authenticate()
    public User authenticate(String username, String password) {
        // 1. Query user by username
        // 2. Get hashed password from database
        // 3. Use BCrypt.checkpw() to verify
        // 4. If valid, update last login and return user
        // 5. If invalid, return null
    }
    
    // TODO: Implement updateLastLogin()
    private void updateLastLogin(int userId) {
        // Update user's last_login timestamp
    }
    
    // TODO: Implement getUserById()
    public User getUserById(int id) {
        // Query and return user by ID
    }
    
    // TODO: Helper method to map ResultSet to User object
    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        // Create and populate User object from ResultSet
    }
}
```

**Test Your DAO:**
```java
// Add this main method to test (remove after testing)
public static void main(String[] args) {
    UserDAO dao = new UserDAO();
    
    // Test authentication
    User user = dao.authenticate("admin", "password123");
    if (user != null) {
        System.out.println("Authentication successful!");
        System.out.println(user);
    } else {
        System.out.println("Authentication failed!");
    }
    
    // Test with wrong password
    User invalidUser = dao.authenticate("admin", "wrongpassword");
    System.out.println("Invalid auth: " + (invalidUser == null ? "Correctly rejected" : "ERROR!"));
}
```

**Evaluation Criteria:**
| Criteria | Points |
|----------|--------|
| getConnection() works | 2 |
| authenticate() with BCrypt | 3 |
| updateLastLogin() works | 1 |
| getUserById() works | 1 |
| mapResultSetToUser() helper | 1 |

**Checkpoint #2:** Show instructor UserDAO authentication working.

---

### EXERCISE 3: LOGIN/LOGOUT CONTROLLERS (15 points)

**Estimated Time:** 35 minutes

#### Task 3.1: Create Login Controller (10 points)

**File:** `src/controller/LoginController.java`

**Requirements:**
- Handle GET: Display login page
- Handle POST: Process login form
- Create session on successful login
- Redirect based on user role
- Display error messages

**Code template:**
```java
package controller;

import dao.UserDAO;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/login")
public class LoginController extends HttpServlet {
    
    private UserDAO userDAO;
    
    @Override
    public void init() {
        // TODO: Initialize userDAO
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // TODO: Check if already logged in
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            // Already logged in, redirect to dashboard
            response.sendRedirect("dashboard");
            return;
        }
        
        // TODO: Forward to login.jsp
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // TODO: Get form parameters
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        // TODO: Validate input
        if (username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            // Set error and forward back to login
            request.setAttribute("error", "Username and password are required");
            request.getRequestDispatcher("/views/login.jsp").forward(request, response);
            return;
        }
        
        // TODO: Authenticate user
        User user = userDAO.authenticate(username, password);
        
        if (user != null) {
            // TODO: Authentication successful
            // 1. Invalidate old session (security)
            // 2. Create new session
            // 3. Store user data in session
            // 4. Set session timeout (30 minutes)
            // 5. Redirect based on role
            
        } else {
            // TODO: Authentication failed
            // Set error message and forward back to login
        }
    }
}
```

**Evaluation Criteria:**
| Criteria | Points |
|----------|--------|
| doGet() displays login page | 2 |
| doPost() validates input | 2 |
| Authenticates user correctly | 2 |
| Creates session with user data | 2 |
| Redirects based on role | 1 |
| Displays error messages | 1 |

---

#### Task 3.2: Create Logout Controller (5 points)

**File:** `src/controller/LogoutController.java`

**Requirements:**
- Invalidate session
- Redirect to login with message

**Code template:**
```java
package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/logout")
public class LogoutController extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // TODO: Get session (don't create if doesn't exist)
        
        // TODO: If session exists, invalidate it
        
        // TODO: Redirect to login with success message
        response.sendRedirect("login?message=You have been logged out successfully");
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}
```

**Evaluation Criteria:**
| Criteria | Points |
|----------|--------|
| Gets session correctly | 1 |
| Invalidates session | 2 |
| Redirects to login | 1 |
| Shows success message | 1 |

**Checkpoint #3:** Show instructor login and logout working.

---

### EXERCISE 4: VIEWS & DASHBOARD (15 points)

**Estimated Time:** 30 minutes

#### Task 4.1: Create Login View (8 points)

**File:** `WebContent/views/login.jsp`

**Requirements:**
- Professional design
- Display error messages
- Display success messages (from logout)
- Remember username on error
- Demo credentials shown

**Template:**
```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login</title>
    <style>
        /* TODO: Add CSS styling for:
         * - Centered login form
         * - Gradient background
         * - Input fields with focus effects
         * - Alert boxes for messages
         * - Button with hover effect
         */
    </style>
</head>
<body>
    <div class="login-container">
        <div class="login-header">
            <h1>🔐 Login</h1>
            <p>Student Management System</p>
        </div>
        
        <!-- TODO: Display error message if exists -->
        <c:if test="${not empty error}">
            <div class="alert alert-error">
                ❌ ${error}
            </div>
        </c:if>
        
        <!-- TODO: Display success message from URL parameter -->
        <c:if test="${not empty param.message}">
            <div class="alert alert-success">
                ✅ ${param.message}
            </div>
        </c:if>
        
        <!-- TODO: Create login form -->
        <form action="login" method="post">
            <!-- Username field -->
            <!-- Password field -->
            <!-- Remember me checkbox -->
            <!-- Submit button -->
        </form>
        
        <!-- TODO: Display demo credentials -->
        <div class="demo-credentials">
            <h4>Demo Credentials:</h4>
            <p><strong>Admin:</strong> admin / password123</p>
            <p><strong>User:</strong> john / password123</p>
        </div>
    </div>
</body>
</html>
```

**Evaluation Criteria:**
| Criteria | Points |
|----------|--------|
| Professional design | 2 |
| Form with username/password | 2 |
| Error messages display | 2 |
| Success messages display | 1 |
| Demo credentials shown | 1 |

---

#### Task 4.2: Create Dashboard (7 points)

**File:** `src/controller/DashboardController.java`

```java
package controller;

import dao.StudentDAO;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/dashboard")
public class DashboardController extends HttpServlet {
    
    private StudentDAO studentDAO;
    
    @Override
    public void init() {
        // TODO: Initialize studentDAO
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // TODO: Get user from session
        // TODO: Get statistics (total students)
        // TODO: Set attributes
        // TODO: Forward to dashboard.jsp
    }
}
```

**File:** `WebContent/views/dashboard.jsp`

**Requirements:**
- Navigation bar with user info and logout
- Welcome message
- Statistics cards
- Quick action buttons
- Role-based UI elements

**Evaluation Criteria:**
| Criteria | Points |
|----------|--------|
| DashboardController works | 2 |
| Navigation bar with user info | 2 |
| Statistics displayed | 1 |
| Quick actions | 1 |
| Professional design | 1 |

---

## PART B: HOMEWORK EXERCISES (40 points)

**Due:** Next lab session  
**Submission:** ZIP file with project + README

---

### EXERCISE 5: AUTHENTICATION FILTER (12 points)

**Estimated Time:** 45 minutes

#### Task 5.1: Create AuthFilter (12 points)

**File:** `src/filter/AuthFilter.java`

**Requirements:**
- Check if user is logged in for protected pages
- Allow public URLs (login, logout, static resources)
- Redirect to login if not authenticated
- Use `@WebFilter` annotation

**Implementation guide:**

```java
package filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebFilter(filterName = "AuthFilter", urlPatterns = {"/*"})
public class AuthFilter implements Filter {
    
    // Public URLs that don't require authentication
    private static final String[] PUBLIC_URLS = {
        "/login",
        "/logout",
        ".css",
        ".js",
        ".png",
        ".jpg"
    };
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // TODO: Log initialization
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        // TODO: Cast to HTTP servlet request/response
        
        // TODO: Get request URI and context path
        
        // TODO: Extract path (remove context path)
        
        // TODO: Check if URL is public
        if (isPublicUrl(path)) {
            chain.doFilter(request, response);
            return;
        }
        
        // TODO: Check if user is logged in
        // Get session (false = don't create)
        // Check if user attribute exists
        
        // TODO: If logged in, continue
        // TODO: If not, redirect to login
    }
    
    @Override
    public void destroy() {
        // TODO: Log destruction
    }
    
    private boolean isPublicUrl(String path) {
        // TODO: Check if path contains any public URL pattern
    }
}
```

**Testing:**
1. Deploy application
2. Try accessing `/student` without login → Should redirect to login
3. Login successfully
4. Access `/student` → Should work
5. Access static files (CSS, images) → Should work without login

**Evaluation Criteria:**
| Criteria | Points |
|----------|--------|
| Filter intercepts all requests | 3 |
| Public URLs allowed | 2 |
| Protected URLs blocked | 3 |
| Redirect to login works | 2 |
| Filter properly configured | 2 |

---

### EXERCISE 6: ADMIN AUTHORIZATION FILTER (10 points)

**Estimated Time:** 40 minutes

#### Task 6.1: Create AdminFilter (10 points)

**File:** `src/filter/AdminFilter.java`

**Requirements:**
- Check if user has admin role for admin actions
- Block non-admin users from creating/editing/deleting
- Show error message on denial

**Implementation guide:**

```java
package filter;

import model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebFilter(filterName = "AdminFilter", urlPatterns = {"/student"})
public class AdminFilter implements Filter {
    
    // Admin-only actions
    private static final String[] ADMIN_ACTIONS = {
        "new",
        "insert",
        "edit",
        "update",
        "delete"
    };
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // TODO: Log initialization
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        // TODO: Cast to HTTP types
        
        // TODO: Get action parameter
        
        // TODO: Check if action requires admin role
        if (isAdminAction(action)) {
            
            // TODO: Get session and user
            
            // TODO: Check if user is admin
            if (user != null && user.isAdmin()) {
                // Allow access
                chain.doFilter(request, response);
            } else {
                // Deny access
                // Redirect with error message
            }
        } else {
            // Not an admin action, allow
            chain.doFilter(request, response);
        }
    }
    
    @Override
    public void destroy() {
        // TODO: Log destruction
    }
    
    private boolean isAdminAction(String action) {
        // TODO: Check if action is in ADMIN_ACTIONS array
    }
}
```

**Testing:**
1. Login as admin → Try edit/delete → Should work
2. Logout
3. Login as regular user → Try edit/delete → Should be blocked
4. Try direct URL: `/student?action=delete&id=1` → Should be blocked

**Evaluation Criteria:**
| Criteria | Points |
|----------|--------|
| Filter checks admin role | 3 |
| Admin actions identified | 2 |
| Non-admin blocked correctly | 3 |
| Error message displayed | 2 |

---

### EXERCISE 7: ROLE-BASED UI (10 points)

**Estimated Time:** 35 minutes

#### Task 7.1: Update Student List View (10 points)

**File:** `WebContent/views/student-list.jsp`

**Requirements:**
- Add navigation bar with user info
- Show role badge
- Hide "Add Student" button for non-admins
- Hide Edit/Delete buttons for non-admins
- Show error messages from AdminFilter

**Updates needed:**

```jsp
<!-- TODO: Add navigation bar -->
<div class="navbar">
    <h2>📚 Student Management System</h2>
    <div class="navbar-right">
        <div class="user-info">
            <span>Welcome, ${sessionScope.fullName}</span>
            <span class="role-badge role-${sessionScope.role}">
                ${sessionScope.role}
            </span>
        </div>
        <a href="dashboard">Dashboard</a>
        <a href="logout">Logout</a>
    </div>
</div>

<!-- TODO: Show error from URL parameter -->
<c:if test="${not empty param.error}">
    <div class="alert alert-error">
        ${param.error}
    </div>
</c:if>

<!-- TODO: Add button - Admin only -->
<c:if test="${sessionScope.role eq 'admin'}">
    <a href="student?action=new">➕ Add New Student</a>
</c:if>

<!-- In table header -->
<c:if test="${sessionScope.role eq 'admin'}">
    <th>Actions</th>
</c:if>

<!-- In table rows -->
<c:if test="${sessionScope.role eq 'admin'}">
    <td>
        <a href="student?action=edit&id=${student.id}">Edit</a>
        <a href="student?action=delete&id=${student.id}">Delete</a>
    </td>
</c:if>
```

**Evaluation Criteria:**
| Criteria | Points |
|----------|--------|
| Navigation bar with user info | 2 |
| Role badge displayed | 1 |
| Add button shown for admin only | 2 |
| Edit/Delete buttons for admin only | 3 |
| Error messages displayed | 2 |

---

### EXERCISE 8: CHANGE PASSWORD (8 points) - Optional

**Estimated Time:** 45 minutes

#### Task 8.1: Implement Change Password Feature

**Requirements:**
- New page: `change-password.jsp`
- Validate current password
- Validate new password (minimum 8 characters)
- Confirm new password matches
- Hash and update password

**Files to create:**

**1. Controller:** `src/controller/ChangePasswordController.java`

```java
@WebServlet("/change-password")
public class ChangePasswordController extends HttpServlet {
    
    private UserDAO userDAO;
    
    protected void doGet(...) {
        // Show change password form
    }
    
    protected void doPost(...) {
        // TODO: Get current user from session
        // TODO: Get form parameters (currentPassword, newPassword, confirmPassword)
        // TODO: Validate current password
        // TODO: Validate new password (length, match)
        // TODO: Hash new password
        // TODO: Update in database
        // TODO: Show success/error message
    }
}
```

**2. View:** `WebContent/views/change-password.jsp`

```jsp
<form action="change-password" method="post">
    <input type="password" name="currentPassword" placeholder="Current Password">
    <input type="password" name="newPassword" placeholder="New Password">
    <input type="password" name="confirmPassword" placeholder="Confirm Password">
    <button type="submit">Change Password</button>
</form>
```

**3. DAO Method:** Add to `UserDAO.java`

```java
public boolean updatePassword(int userId, String newHashedPassword) {
    // Update user's password in database
}
```

**Evaluation:** 8 points total

---

## BONUS EXERCISES (Optional - Extra Credit)

**Not required, earn up to 15 bonus points**

---


## PART C: BONUS EXERCISES (20 points)

**Optional exercises for extra credit**

---

### BONUS 1: Cookie Utility Class (5 points)

**Estimated Time:** 20 minutes

Create a reusable utility class for cookie management that you can use throughout your application.

**File:** `src/util/CookieUtil.java`

**Requirements:**
- Static methods for cookie operations
- Create, read, update, delete cookies
- Proper null checking and error handling

```java
package util;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class CookieUtil {
    
    /**
     * Create and add cookie to response
     * @param response HTTP response
     * @param name Cookie name
     * @param value Cookie value
     * @param maxAge Cookie lifetime in seconds
     */
    public static void createCookie(HttpServletResponse response, 
                                   String name, 
                                   String value, 
                                   int maxAge) {
        // TODO: Implement
        // 1. Create new Cookie with name and value
        // 2. Set maxAge
        // 3. Set path to "/"
        // 4. Set httpOnly to true
        // 5. Add cookie to response
    }
    
    /**
     * Get cookie value by name
     * @param request HTTP request
     * @param name Cookie name
     * @return Cookie value or null if not found
     */
    public static String getCookieValue(HttpServletRequest request, String name) {
        // TODO: Implement
        // 1. Get all cookies from request
        // 2. Loop through cookies
        // 3. Find cookie with matching name
        // 4. Return value or null
    }
    
    /**
     * Check if cookie exists
     * @param request HTTP request
     * @param name Cookie name
     * @return true if cookie exists
     */
    public static boolean hasCookie(HttpServletRequest request, String name) {
        // TODO: Implement
        return getCookieValue(request, name) != null;
    }
    
    /**
     * Delete cookie by setting max age to 0
     * @param response HTTP response
     * @param name Cookie name to delete
     */
    public static void deleteCookie(HttpServletResponse response, String name) {
        // TODO: Implement
        // 1. Create cookie with same name and empty value
        // 2. Set maxAge to 0
        // 3. Set path to "/"
        // 4. Add to response
    }
    
    /**
     * Update existing cookie
     * @param response HTTP response
     * @param name Cookie name
     * @param newValue New cookie value
     * @param maxAge New max age
     */
    public static void updateCookie(HttpServletResponse response, 
                                   String name, 
                                   String newValue, 
                                   int maxAge) {
        // TODO: Implement
        // Simply create a new cookie with same name
        createCookie(response, name, newValue, maxAge);
    }
}
```

**Test Your Utility:**
```java
// In any servlet
// Create cookie
CookieUtil.createCookie(response, "theme", "dark", 7*24*60*60); // 7 days

// Read cookie
String theme = CookieUtil.getCookieValue(request, "theme");
System.out.println("Current theme: " + theme);

// Check if cookie exists
if (CookieUtil.hasCookie(request, "theme")) {
    System.out.println("Theme cookie exists");
}

// Update cookie
CookieUtil.updateCookie(response, "theme", "light", 7*24*60*60);

// Delete cookie
CookieUtil.deleteCookie(response, "theme");
```

**Evaluation Criteria:**
| Criteria | Points |
|----------|--------|
| createCookie() implemented correctly | 1 |
| getCookieValue() handles null cookies | 2 |
| deleteCookie() sets maxAge to 0 | 1 |
| All methods have proper error handling | 1 |

---

### BONUS 2: Remember Me Functionality (5 points)

**Estimated Time:** 35 minutes

Implement "Remember Me" checkbox that allows users to stay logged in for 30 days.

#### Step 1: Create Database Table (5 minutes)

Add table for storing remember tokens:
```sql
CREATE TABLE remember_tokens (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    token VARCHAR(255) NOT NULL UNIQUE,
    expires_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_token (token),
    INDEX idx_expires (expires_at)
);
```

#### Step 2: Update Login Form (3 minutes)

**File:** `login.jsp`

Add "Remember Me" checkbox before submit button:
```jsp
<div class="form-check mb-3">
    <input type="checkbox" class="form-check-input" 
           id="rememberMe" name="rememberMe" value="on">
    <label class="form-check-label" for="rememberMe">
        <i class="bi bi-clock-history"></i> Remember me for 30 days
    </label>
</div>
```

#### Step 3: Update LoginController (10 minutes)

**Modify doPost() to handle Remember Me:**
```java
// After successful authentication and session creation
String rememberMe = request.getParameter("rememberMe");

if ("on".equals(rememberMe)) {
    // 1. Generate secure random token
    String token = UUID.randomUUID().toString();
    
    // 2. Save token to database (expires in 30 days)
    userDAO.saveRememberToken(user.getId(), token);
    
    // 3. Create secure cookie
    Cookie rememberCookie = new Cookie("remember_token", token);
    rememberCookie.setMaxAge(30 * 24 * 60 * 60); // 30 days in seconds
    rememberCookie.setPath("/");
    rememberCookie.setHttpOnly(true); // Prevent JavaScript access (XSS protection)
    // rememberCookie.setSecure(true); // Enable in production with HTTPS
    response.addCookie(rememberCookie);
}
```

#### Step 4: Update AuthFilter (10 minutes)

**Add auto-login logic BEFORE session check:**
```java
@Override
public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
        throws IOException, ServletException {
    
    HttpServletRequest httpRequest = (HttpServletRequest) request;
    HttpServletResponse httpResponse = (HttpServletResponse) response;
    HttpSession session = httpRequest.getSession(false);
    
    // Check if user is NOT logged in
    if (session == null || session.getAttribute("user") == null) {
        
        // Check for remember_token cookie
        String token = null;
        Cookie[] cookies = httpRequest.getCookies();
        
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("remember_token".equals(cookie.getName())) {
                    token = cookie.getValue();
                    break;
                }
            }
        }
        
        // If remember token exists, try auto-login
        if (token != null) {
            UserDAO userDAO = new UserDAO();
            User user = userDAO.getUserByToken(token);
            
            if (user != null) {
                // Token is valid - auto-login user
                session = httpRequest.getSession(true);
                session.setAttribute("user", user);
                session.setAttribute("userId", user.getId());
                session.setAttribute("username", user.getUsername());
                session.setAttribute("role", user.getRole());
                session.setAttribute("fullName", user.getFullName());
                
                // Continue to requested page
                chain.doFilter(request, response);
                return;
            } else {
                // Token invalid/expired - delete cookie
                Cookie deleteCookie = new Cookie("remember_token", "");
                deleteCookie.setMaxAge(0);
                deleteCookie.setPath("/");
                httpResponse.addCookie(deleteCookie);
            }
        }
    }
    
    // Rest of authentication filter logic...
}
```

#### Step 5: Update UserDAO (5 minutes)

**Add these three methods:**
```java
/**
 * Save remember token to database
 */
public void saveRememberToken(int userId, String token) {
    String sql = "INSERT INTO remember_tokens (user_id, token, expires_at) " +
                 "VALUES (?, ?, DATE_ADD(NOW(), INTERVAL 30 DAY))";
    
    try (Connection conn = getConnection();
         PreparedStatement pstmt = conn.prepareStatement(sql)) {
        pstmt.setInt(1, userId);
        pstmt.setString(2, token);
        pstmt.executeUpdate();
    } catch (SQLException e) {
        e.printStackTrace();
    }
}

/**
 * Get user by valid (non-expired) token
 */
public User getUserByToken(String token) {
    String sql = "SELECT u.* FROM users u " +
                 "JOIN remember_tokens rt ON u.id = rt.user_id " +
                 "WHERE rt.token = ? " +
                 "AND rt.expires_at > NOW() " +
                 "AND u.is_active = TRUE";
    
    try (Connection conn = getConnection();
         PreparedStatement pstmt = conn.prepareStatement(sql)) {
        pstmt.setString(1, token);
        ResultSet rs = pstmt.executeQuery();
        
        if (rs.next()) {
            return mapResultSetToUser(rs);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return null;
}

/**
 * Delete remember token from database
 */
public void deleteRememberToken(String token) {
    String sql = "DELETE FROM remember_tokens WHERE token = ?";
    
    try (Connection conn = getConnection();
         PreparedStatement pstmt = conn.prepareStatement(sql)) {
        pstmt.setString(1, token);
        pstmt.executeUpdate();
    } catch (SQLException e) {
        e.printStackTrace();
    }
}
```

#### Step 6: Update LogoutController (2 minutes)

**Delete remember token on logout:**
```java
@Override
protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    
    HttpSession session = request.getSession(false);
    
    // Get remember token BEFORE invalidating session
    String token = null;
    Cookie[] cookies = request.getCookies();
    
    if (cookies != null) {
        for (Cookie cookie : cookies) {
            if ("remember_token".equals(cookie.getName())) {
                token = cookie.getValue();
                break;
            }
        }
    }
    
    // Invalidate session
    if (session != null) {
        session.invalidate();
    }
    
    // Delete remember token from database and cookie
    if (token != null) {
        UserDAO userDAO = new UserDAO();
        userDAO.deleteRememberToken(token);
        
        // Delete cookie
        Cookie deleteCookie = new Cookie("remember_token", "");
        deleteCookie.setMaxAge(0);
        deleteCookie.setPath("/");
        response.addCookie(deleteCookie);
    }
    
    // Redirect to login with message
    request.getSession().setAttribute("message", "You have been logged out successfully");
    response.sendRedirect("login");
}
```

**Testing Checklist:**
- ✅ Login WITHOUT checking "Remember Me"
  - Close browser and reopen → Should need to login again
- ✅ Login WITH "Remember Me" checked
  - Close browser completely
  - Reopen browser and visit protected page (e.g., /dashboard)
  - Should be automatically logged in
- ✅ While auto-logged in, click Logout
  - Token should be deleted from database
  - Cookie should be deleted
  - Next visit should require login again

**Evaluation Criteria:**
| Criteria | Points |
|----------|--------|
| Database table created correctly | 1 |
| Checkbox added to login form | 0.5 |
| Token saved and cookie created on login | 1 |
| Auto-login works in AuthFilter | 1.5 |
| Token and cookie deleted on logout | 1 |

---

### BONUS 3: User Theme Preference (3 points)

**Estimated Time:** 20 minutes

Allow users to choose between light and dark themes, saving preference in cookies.

#### Step 1: Create ThemeController (10 minutes)

**File:** `src/controller/ThemeController.java`

```java
package controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/theme")
public class ThemeController extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String theme = request.getParameter("mode");
        
        // Validate theme value (security: prevent injection)
        if ("light".equals(theme) || "dark".equals(theme)) {
            // Save preference in cookie for 1 year
            Cookie themeCookie = new Cookie("user_theme", theme);
            themeCookie.setMaxAge(365 * 24 * 60 * 60); // 1 year
            themeCookie.setPath("/");
            themeCookie.setHttpOnly(false); // Allow JavaScript to read for theme switching
            response.addCookie(themeCookie);
        }
        
        // Redirect back to the page user came from
        String referer = request.getHeader("Referer");
        if (referer != null && !referer.isEmpty()) {
            response.sendRedirect(referer);
        } else {
            response.sendRedirect("dashboard");
        }
    }
}
```

#### Step 2: Update Dashboard/Pages (10 minutes)

**Add theme switcher to `dashboard.jsp` (and other pages):**

```jsp
<%
    // Get theme from cookie, default to 'light'
    String currentTheme = "light";
    Cookie[] cookies = request.getCookies();
    if (cookies != null) {
        for (Cookie cookie : cookies) {
            if ("user_theme".equals(cookie.getName())) {
                currentTheme = cookie.getValue();
                break;
            }
        }
    }
%>

<!DOCTYPE html>
<html data-bs-theme="<%= currentTheme %>">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard</title>
    
    <!-- Bootstrap 5.3+ supports data-bs-theme -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" 
          rel="stylesheet">
    <link rel="stylesheet" 
          href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container-fluid">
            <a class="navbar-brand" href="#">Student Management</a>
            
            <!-- ... other nav items ... -->
            
            <!-- Theme Switcher Dropdown -->
            <div class="dropdown ms-3">
                <button class="btn btn-outline-light btn-sm dropdown-toggle" 
                        type="button" 
                        id="themeDropdown"
                        data-bs-toggle="dropdown" 
                        aria-expanded="false">
                    <i class="bi bi-palette"></i> 
                    Theme: <%= currentTheme.substring(0, 1).toUpperCase() + currentTheme.substring(1) %>
                </button>
                <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="themeDropdown">
                    <li>
                        <a class="dropdown-item <%= "light".equals(currentTheme) ? "active" : "" %>" 
                           href="theme?mode=light">
                            <i class="bi bi-sun"></i> Light
                        </a>
                    </li>
                    <li>
                        <a class="dropdown-item <%= "dark".equals(currentTheme) ? "active" : "" %>" 
                           href="theme?mode=dark">
                            <i class="bi bi-moon-stars"></i> Dark
                        </a>
                    </li>
                </ul>
            </div>
            
            <!-- Logout -->
            <a href="logout" class="btn btn-outline-light btn-sm ms-2">
                <i class="bi bi-box-arrow-right"></i> Logout
            </a>
        </div>
    </nav>
    
    <div class="container mt-4">
        <h1>Welcome, ${sessionScope.fullName}!</h1>
        <!-- Rest of page content -->
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
```

**Optional: Custom CSS for additional theme support**
```jsp
<style>
    /* Custom theme styles if needed */
    [data-bs-theme="dark"] {
        --bs-body-bg: #212529;
        --bs-body-color: #dee2e6;
    }
    
    [data-bs-theme="light"] {
        --bs-body-bg: #ffffff;
        --bs-body-color: #212529;
    }
</style>
```

**Testing:**
1. Go to dashboard
2. Click theme dropdown
3. Select "Dark" → Page should switch to dark theme
4. Refresh page → Theme should persist
5. Select "Light" → Page switches back
6. Close browser completely
7. Reopen and visit dashboard → Theme should still be applied

**Evaluation Criteria:**
| Criteria | Points |
|----------|--------|
| ThemeController saves cookie correctly | 1 |
| Theme applied on page load | 1 |
| Theme persists across browser sessions | 1 |

---

### BONUS 4: Session Timeout Warning (2 points)

**Estimated Time:** 15 minutes

Display warning message when user session is about to expire.

**Add to any protected page (e.g., dashboard.jsp):**

```jsp
<script>
// Configuration
const SESSION_TIMEOUT = 30 * 60 * 1000; // 30 minutes in milliseconds
const WARNING_TIME = 5 * 60 * 1000;    // Warn 5 minutes before expiry

// Track last user activity
let lastActivity = Date.now();

// Update activity time on user interactions
function updateActivity() {
    lastActivity = Date.now();
}

// Listen to user interactions
document.addEventListener('mousemove', updateActivity);
document.addEventListener('keypress', updateActivity);
document.addEventListener('click', updateActivity);
document.addEventListener('scroll', updateActivity);

// Check session status every minute
setInterval(function() {
    const timeElapsed = Date.now() - lastActivity;
    const timeRemaining = SESSION_TIMEOUT - timeElapsed;
    
    if (timeRemaining <= 0) {
        // Session expired
        alert('⏰ Your session has expired due to inactivity. Please login again.');
        window.location.href = 'logout';
    } else if (timeRemaining <= WARNING_TIME) {
        // Show warning
        const minutesLeft = Math.floor(timeRemaining / 60000);
        console.warn(`⚠️ Session will expire in ${minutesLeft} minute(s)`);
        
        // Optional: Show Bootstrap toast notification
        showSessionWarning(minutesLeft);
    }
}, 60000); // Check every 60 seconds

// Optional: Show Bootstrap toast for warning
function showSessionWarning(minutes) {
    // Create toast container if not exists
    let toastContainer = document.querySelector('.toast-container');
    if (!toastContainer) {
        toastContainer = document.createElement('div');
        toastContainer.className = 'toast-container position-fixed top-0 end-0 p-3';
        document.body.appendChild(toastContainer);
    }
    
    // Create toast HTML
    const toastHTML = `
        <div class="toast show" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="toast-header bg-warning text-dark">
                <i class="bi bi-exclamation-triangle me-2"></i>
                <strong class="me-auto">Session Warning</strong>
                <button type="button" class="btn-close" data-bs-dismiss="toast"></button>
            </div>
            <div class="toast-body">
                Your session will expire in ${minutes} minute${minutes !== 1 ? 's' : ''}. 
                Please save your work.
            </div>
        </div>
    `;
    
    // Remove old warnings
    const oldToasts = toastContainer.querySelectorAll('.toast');
    oldToasts.forEach(toast => toast.remove());
    
    // Add new toast
    toastContainer.innerHTML = toastHTML;
    
    // Auto-hide after 10 seconds
    setTimeout(() => {
        const toast = toastContainer.querySelector('.toast');
        if (toast) {
            toast.classList.remove('show');
            setTimeout(() => toast.remove(), 150);
        }
    }, 10000);
}

// Initial log
console.log('Session timeout tracking initialized. Timeout: 30 minutes');
</script>
```

**Alternative: Simpler console-only version:**
```jsp
<script>
const SESSION_TIMEOUT = 30 * 60 * 1000;
let lastActivity = Date.now();

['mousemove', 'keypress', 'click'].forEach(event => {
    document.addEventListener(event, () => lastActivity = Date.now());
});

setInterval(() => {
    const timeRemaining = SESSION_TIMEOUT - (Date.now() - lastActivity);
    const minutesLeft = Math.floor(timeRemaining / 60000);
    
    if (timeRemaining <= 0) {
        alert('Session expired. Please login again.');
        window.location.href = 'logout';
    } else if (minutesLeft <= 5 && minutesLeft > 0) {
        console.warn(`⚠️ Session expires in ${minutesLeft} minutes`);
    }
}, 60000);
</script>
```

**Testing:**
1. Login to application
2. Stay on a page without any interaction
3. Open browser console
4. Wait (you can reduce timeout for testing)
5. Should see warning messages
6. After timeout, should redirect to logout

**Evaluation Criteria:**
| Criteria | Points |
|----------|--------|
| Activity tracking works correctly | 1 |
| Warning displayed before expiry | 1 |

---

### BONUS 5: Activity Logging with Cookies (5 points)

**Estimated Time:** 25 minutes

Track user visits and last access time using cookies.

**Requirements:**
- Track number of visits
- Track last login time
- Display statistics on dashboard

**Implementation:**

1. **Update LoginController** to track visits:
```java
// After successful login
// Get visit count from cookie
int visitCount = 1;
Cookie[] cookies = request.getCookies();
if (cookies != null) {
    for (Cookie cookie : cookies) {
        if ("visit_count".equals(cookie.getName())) {
            try {
                visitCount = Integer.parseInt(cookie.getValue()) + 1;
            } catch (NumberFormatException e) {
                visitCount = 1;
            }
            break;
        }
    }
}

// Save updated visit count
Cookie visitCookie = new Cookie("visit_count", String.valueOf(visitCount));
visitCookie.setMaxAge(365 * 24 * 60 * 60); // 1 year
visitCookie.setPath("/");
response.addCookie(visitCookie);

// Save last login time
Cookie lastLoginCookie = new Cookie("last_login", 
    String.valueOf(System.currentTimeMillis()));
lastLoginCookie.setMaxAge(365 * 24 * 60 * 60);
lastLoginCookie.setPath("/");
response.addCookie(lastLoginCookie);
```

2. **Display on Dashboard**:
```jsp
<%
    int visitCount = 0;
    long lastLogin = 0;
    
    Cookie[] cookies = request.getCookies();
    if (cookies != null) {
        for (Cookie cookie : cookies) {
            if ("visit_count".equals(cookie.getName())) {
                visitCount = Integer.parseInt(cookie.getValue());
            } else if ("last_login".equals(cookie.getName())) {
                lastLogin = Long.parseLong(cookie.getValue());
            }
        }
    }
    
    // Format last login time
    String lastLoginStr = "First visit";
    if (lastLogin > 0) {
        java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("MMM dd, yyyy HH:mm");
        lastLoginStr = sdf.format(new java.util.Date(lastLogin));
    }
%>

<div class="alert alert-info">
    <h5><i class="bi bi-info-circle"></i> Your Statistics</h5>
    <p class="mb-1"><strong>Total Visits:</strong> <%= visitCount %></p>
    <p class="mb-0"><strong>Last Login:</strong> <%= lastLoginStr %></p>
</div>
```

**Evaluation Criteria:**
| Criteria | Points |
|----------|--------|
| Visit count tracked correctly | 2 |
| Last login time saved | 1 |
| Statistics displayed on dashboard | 2 |

---

**Requirements:**
- Track user activities (login, logout, CRUD operations)
- Store in `activity_log` table
- Admin can view activity logs

**Database:**
```sql
CREATE TABLE activity_log (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    activity_type VARCHAR(50),
    description VARCHAR(255),
    ip_address VARCHAR(45),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);
```

**Usage:**
```java
public void logActivity(int userId, String type, String description, String ip) {
    // Insert activity log
}

// In controllers
logActivity(user.getId(), "LOGIN", "User logged in", request.getRemoteAddr());
logActivity(user.getId(), "CREATE", "Created student: " + student.getName(), ip);
```

---

## HOMEWORK SUBMISSION GUIDELINES

### What to Submit:

**1. Complete Project ZIP:**
```
StudentManagementMVC_Lab6.zip
├── src/
│   ├── model/
│   │   ├── Student.java
│   │   └── User.java
│   ├── dao/
│   │   ├── StudentDAO.java
│   │   └── UserDAO.java
│   ├── controller/
│   │   ├── StudentController.java
│   │   ├── LoginController.java
│   │   ├── LogoutController.java
│   │   └── DashboardController.java
│   └── filter/
│       ├── AuthFilter.java
│       └── AdminFilter.java
├── WebContent/
│   └── views/
│       ├── student-list.jsp
│       ├── login.jsp
│       └── dashboard.jsp
├── database/
│   └── users_table.sql
└── README.txt
```

**2. SQL Script:**
Include `database/users_table.sql`:
```sql
-- Create users table
CREATE TABLE users (...);

-- Insert test data
INSERT INTO users (...) VALUES (...);
```

**3. README.txt:**
```
STUDENT INFORMATION:
Name: [Your Name]
Student ID: [Your ID]
Class: [Your Class]

COMPLETED EXERCISES:
[x] Exercise 1: Database & User Model
[x] Exercise 2: User Model & DAO
[x] Exercise 3: Login/Logout Controllers
[x] Exercise 4: Views & Dashboard
[x] Exercise 5: Authentication Filter
[x] Exercise 6: Admin Authorization Filter
[x] Exercise 7: Role-Based UI
[ ] Exercise 8: Change Password

AUTHENTICATION COMPONENTS:
- Models: User.java
- DAOs: UserDAO.java
- Controllers: LoginController.java, LogoutController.java, DashboardController.java
- Filters: AuthFilter.java, AdminFilter.java
- Views: login.jsp, dashboard.jsp, updated student-list.jsp

TEST CREDENTIALS:
Admin:
- Username: admin
- Password: password123

Regular User:
- Username: john
- Password: password123

FEATURES IMPLEMENTED:
- User authentication with BCrypt
- Session management
- Login/Logout functionality
- Dashboard with statistics
- Authentication filter for protected pages
- Admin authorization filter
- Role-based UI elements
- Password security

SECURITY MEASURES:
- BCrypt password hashing
- Session regeneration after login
- Session timeout (30 minutes)
- SQL injection prevention (PreparedStatement)
- Input validation
- XSS prevention (JSTL escaping)

KNOWN ISSUES:
- [List any bugs or limitations]

BONUS FEATURES:
- [List any bonus features implemented]

TIME SPENT: [Approximate hours]

TESTING NOTES:
[Describe how you tested authentication, filters, and authorization]
```

**4. Screenshots:**
Include screenshots showing:
- Login page
- Login with wrong credentials (error message)
- Dashboard after login
- Student list as admin (with Edit/Delete buttons)
- Student list as regular user (without Edit/Delete)
- Accessing protected page without login (redirect)
- Non-admin trying admin action (blocked)
- Logout success message

---

## EVALUATION RUBRIC

### In-Class (60 points):
| Component | Points |
|-----------|--------|
| Database & User Model | 15 |
| User Model & DAO | 15 |
| Login/Logout Controllers | 15 |
| Views & Dashboard | 15 |

### Homework (40 points):
| Exercise | Points |
|----------|--------|
| Authentication Filter | 12 |
| Admin Authorization Filter | 10 |
| Role-Based UI | 10 |
| Change Password | 8 |

### Bonus (15 points):
| Feature | Points |
|---------|--------|
| Session Timeout | 5 |
| Remember Me | 5 |
| Activity Log | 5 |

**Total Possible: 115 points (including bonus)**

---

## COMMON MISTAKES TO AVOID

### ❌ DON'T:

**1. Store plain text passwords:**
```java
// WRONG! Never store passwords like this
user.setPassword("password123");
dao.createUser(user);
```

**2. Skip session validation:**
```jsp
<!-- WRONG! Always check session -->
Welcome, ${sessionScope.fullName}
<!-- What if user is not logged in? -->
```

**3. Trust client-side validation only:**
```java
// WRONG! Always validate on server
String password = request.getParameter("password");
// What if user bypasses JavaScript validation?
```

**4. Forget to invalidate session on logout:**
```java
// WRONG! Session still active
response.sendRedirect("login");
// Should invalidate session first
```

**5. Hard-code role checks:**
```jsp
<!-- WRONG! Use role from session -->
<c:if test="${user.role == 'admin'}">
```

### ✅ DO:

**1. Hash all passwords:**
```java
// CORRECT! Always hash passwords
String hashedPassword = BCrypt.hashpw(plainPassword, BCrypt.gensalt());
user.setPassword(hashedPassword);
```

**2. Always validate session:**
```java
// CORRECT! Check session exists
HttpSession session = request.getSession(false);
if (session == null || session.getAttribute("user") == null) {
    response.sendRedirect("login");
    return;
}
```

**3. Validate on both client and server:**
```java
// CORRECT! Server-side validation
if (password == null || password.length() < 8) {
    request.setAttribute("error", "Password must be at least 8 characters");
    // ...
}
```

**4. Properly logout:**
```java
// CORRECT! Invalidate session
HttpSession session = request.getSession(false);
if (session != null) {
    session.invalidate();
}
response.sendRedirect("login");
```

**5. Use session attributes:**
```jsp
<!-- CORRECT! Use session role -->
<c:if test="${sessionScope.role eq 'admin'}">
```

---

## TROUBLESHOOTING

### Issue 1: BCrypt ClassNotFoundException

**Solution:**
- Download jbcrypt-0.4.jar
- Add to project libraries
- Or add to WEB-INF/lib folder
- Clean and rebuild project

---

### Issue 2: Filter Not Working

**Solution:**
- Check @WebFilter annotation
- Verify URL patterns
- Check filter order if multiple filters
- Look at server logs for errors

```java
// Correct filter annotation
@WebFilter(filterName = "AuthFilter", urlPatterns = {"/*"})
```

---

### Issue 3: Session is Null

**Solution:**
- Check `request.getSession(false)` usage
- Don't create session if not logged in
- Verify session creation in LoginController

```java
// Check session correctly
HttpSession session = request.getSession(false); // false = don't create
if (session != null && session.getAttribute("user") != null) {
    // User is logged in
}
```

---

### Issue 4: Password Verification Fails

**Solution:**
- Verify password is hashed in database
- Check BCrypt.checkpw() parameters order
- Test hash generation independently

```java
// Correct verification
boolean matches = BCrypt.checkpw(plainPassword, hashedPasswordFromDB);
```

---

### Issue 5: Infinite Redirect Loop

**Solution:**
- Check filter public URLs list
- Include /login in public URLs
- Verify filter logic doesn't block login page

```java
private static final String[] PUBLIC_URLS = {
    "/login",  // Must be in public URLs!
    "/logout",
    // ...
};
```

---

## RESOURCES

### Authentication & Security:
- **OWASP Top 10:** https://owasp.org/www-project-top-ten/
- **BCrypt Documentation:** https://github.com/jeremyh/jBCrypt
- **Java Servlet Security:** https://docs.oracle.com/javaee/7/tutorial/security-webtier.htm

### Session Management:
- **HttpSession API:** https://jakarta.ee/specifications/servlet/5.0/apidocs/jakarta/servlet/http/httpsession
- **Session Best Practices:** https://cheatsheetseries.owasp.org/cheatsheets/Session_Management_Cheat_Sheet.html

### Filters:
- **Filter Tutorial:** https://docs.oracle.com/javaee/7/tutorial/servlets007.htm
- **Filter Examples:** https://www.baeldung.com/intercepting-filter-pattern-in-java

---

## SUMMARY

### In-Class Checklist:
✅ Created users table  
✅ Implemented User model  
✅ Created UserDAO with authentication  
✅ Built Login/Logout controllers  
✅ Created login and dashboard views  
✅ Tested authentication flow

### Homework Checklist:
✅ Implemented AuthFilter  
✅ Implemented AdminFilter  
✅ Updated UI with role-based elements  
✅ Tested with different user roles  
✅ Verified security measures

### Key Takeaways:
1. **Authentication** - Verify user identity
2. **Authorization** - Control access by role
3. **Sessions** - Maintain state across requests
4. **Filters** - Intercept and process requests
5. **Security** - Hash passwords, validate input, protect sessions

### Security Principles Learned:
- Never store plain text passwords
- Always validate on server-side
- Use PreparedStatement to prevent SQL injection
- Regenerate session ID after login
- Set appropriate session timeout
- Implement defense in depth


**Good luck with Lab 6! 🔐**

*Remember: Security is not optional - it's essential!*