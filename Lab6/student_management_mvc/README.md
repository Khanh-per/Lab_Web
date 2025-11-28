---
title: 'LAB 6 [GUIDE]: AUTHENTICATION & SESSION MANAGEMENT'

---

---
title: 'LAB 6 [GUIDE]: AUTHENTICATION & SESSION MANAGEMENT'

---

title: LAB 6 AUTHENTICATION & SESSION MANAGEMENTRN
---



**Course:** Web Application Development  
**Lab Duration:** 2.5 hours  
**Total Points:** 100 points (In-class: 60 points, Homework: 40 points)

> Name: Le Hoang Khanh
> ID: ITCSIU23013
> Tutor: Nguyen Trung Ngh
> **Note:** This lab builds on Lab 5 by adding user authentication, session management, and role-based access control. Read this BEFORE the lab session
---

## PART A: IN-CLASS EXERCISES (60 points)

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

---

### EXERCISE 2: USER MODEL & DAO (15 points)

**Estimated Time:** 30 minutes

#### Task 2.1: Create User Model (7 points)

**File:** `src/main/java/com/student/model/User.java`

![alt screenshot](/student_management_mvc/image/UserFile.png)

---

#### Task 2.2: Create UserDAO (8 points)

**File:** `src/main/java/com/student/dao/UserDAO.java`

![alt screenshot](/student_management_mvc/image/UserDAOFile.png)


**Test Your DAO:**
```java
// Add this main method to test (remove after testing)
public static void main(String[] args) {
    UserDAO dao = new UserDAO();
    
    // Test authentication
    User user = dao.authenticate("admin", "123");
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

**Checkpoint #2:** Show instructor UserDAO authentication working.
![alt screenshot](/student_management_mvc/image/Task2_2.png)

---

### EXERCISE 3: LOGIN/LOGOUT CONTROLLERS (15 points)

**Estimated Time:** 35 minutes

#### Task 3.1: Create Login Controller (10 points)

**File:** `src/main/java/com/student/controller/LoginController.java`


**Code template:**
```java
 @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // If already logged in, redirect to dashboard
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            response.sendRedirect("dashboard");
            return;
        }

        // Show login page
        request.getRequestDispatcher("/views/login.jsp").forward(request, response);
    }

    /**
     * Process login form
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String rememberMe = request.getParameter("remember");

        // Validate input
        if (username == null || username.trim().isEmpty() ||
                password == null || password.trim().isEmpty()) {

            request.setAttribute("error", "Username and password are required");
            request.getRequestDispatcher("/views/login.jsp").forward(request, response);
            return;
        }

        // Authenticate user
        User user = userDAO.authenticate(username, password);

        if (user != null) {
            // Authentication successful

            // Invalidate old session (prevent session fixation)
            HttpSession oldSession = request.getSession(false);
            if (oldSession != null) {
                oldSession.invalidate();
            }

            // Create new session
            HttpSession session = request.getSession(true);
            session.setAttribute("user", user);
            session.setAttribute("role", user.getRole());
            session.setAttribute("fullName", user.getFullName());

            // Set session timeout (30 minutes)
            session.setMaxInactiveInterval(30 * 60);

            // Handle "Remember Me" (optional - cookie implementation)
            if ("on".equals(rememberMe)) {
                // TODO: Implement remember me functionality with cookie
            }

            // Redirect based on role
            if (user.isAdmin()) {
                response.sendRedirect("dashboard");
            } else {
                response.sendRedirect("student?action=list");
            }

        } else {
            // Authentication failed
            request.setAttribute("error", "Invalid username or password");
            request.setAttribute("username", username); // Keep username in form
            request.getRequestDispatcher("/views/login.jsp").forward(request, response);
        }
    }
```

---

#### Task 3.2: Create Logout Controller (5 points)

**File:** `src/main/java/com/student/controller/LogoutController.java`


**Code template:**
```java
@Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get current session
        HttpSession session = request.getSession(false);

        if (session != null) {
            // Invalidate session
            session.invalidate();
        }

        // Redirect to login page with message
        response.sendRedirect("login?message=You have been logged out successfully");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
```

**Checkpoint #3:** Show instructor login and logout working.
![alt screenshot](/student_management_mvc/image/LoginPage.png)
![alt screenshot](/student_management_mvc/image/HomePageStudent.png)
---

### EXERCISE 4: VIEWS & DASHBOARD (15 points)

**Estimated Time:** 30 minutes

#### Task 4.1: Create Login View (8 points)

**File:** `src/main/webapp/views/login.jsp`


**Template:**
```jsp
<body>
    <div class="login-container">
        <div class="login-header">
            <h1>🔐 Login</h1>
            <p>Student Management System</p>
        </div>

        <!-- Error Message -->
        <c:if test="${not empty error}">
            <div class="alert alert-error">
                ❌ ${error}
            </div>
        </c:if>

        <!-- Success Message -->
        <c:if test="${not empty param.message}">
            <div class="alert alert-success">
                ✅ ${param.message}
            </div>
        </c:if>

        <!-- Login Form -->
        <form action="login" method="post">
            <div class="form-group">
                <label for="username">Username</label>
                <input type="text"
                       id="username"
                       name="username"
                       value="${username}"
                       placeholder="Enter your username"
                       required
                       autofocus>
            </div>

            <div class="form-group">
                <label for="password">Password</label>
                <input type="password"
                       id="password"
                       name="password"
                       placeholder="Enter your password"
                       required>
            </div>

            <div class="remember-me">
                <input type="checkbox" id="remember" name="remember">
                <label for="remember">Remember me</label>
            </div>

            <button type="submit" class="btn-login">Login</button>
        </form>

        <!-- Demo Credentials -->
        <div class="demo-credentials">
            <h4>Demo Credentials:</h4>
            <p><strong>Admin:</strong> username: admin / password: password123</p>
            <p><strong>User:</strong> username: john / password: password123</p>
        </div>
    </div>
</body>
```

---

#### Task 4.2: Create Dashboard (7 points)

**File:** `src/main/java/com/student/controller/DashboardController.java`

```java
 @Override
    public void init() {
        studentDAO = new StudentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get user from session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }

        User user = (User) session.getAttribute("user");

        // Get statistics
        int totalStudents = studentDAO.getTotalStudents();

        // Set attributes
        request.setAttribute("totalStudents", totalStudents);
        request.setAttribute("welcomeMessage", "Welcome back, " + user.getFullName() + "!");

        // Forward to dashboard
        request.getRequestDispatcher("/views/dashboard.jsp").forward(request, response);
    }
```


**File:** `src/main/webapp/views/dashboard.jsp`

```jsp
<body>
    <!-- Navigation Bar -->
    <div class="navbar">
        <h2>📚 Student Management System</h2>
        <div class="navbar-right">
            <div class="user-info">
                <span>${sessionScope.fullName}</span>
                <span class="role-badge role-${sessionScope.role}">
                    ${sessionScope.role}
                </span>
            </div>
            <a href="logout" class="btn-logout">Logout</a>
        </div>
    </div>

    <!-- Main Content -->
    <div class="container">
        <!-- Welcome Card -->
        <div class="welcome-card">
            <h1>${welcomeMessage}</h1>
            <p>Here's what's happening with your students today.</p>
        </div>

        <!-- Statistics -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon stat-icon-students">
                    👨‍🎓
                </div>
                <div class="stat-content">
                    <h3>${totalStudents}</h3>
                    <p>Total Students</p>
                </div>
            </div>
        </div>

        <!-- Quick Actions -->
        <div class="quick-actions">
            <h2>Quick Actions</h2>
            <div class="action-grid">
                <a href="student?action=list" class="action-btn action-btn-primary">
                    📋 View All Students
                </a>

                <c:if test="${sessionScope.role eq 'admin'}">
                    <a href="student?action=new" class="action-btn action-btn-success">
                        ➕ Add New Student
                    </a>
                </c:if>

                <a href="student?action=search" class="action-btn action-btn-warning">
                    🔍 Search Students
                </a>
            </div>
        </div>
    </div>
</body>
```
**Checkpoint #4:** Show instrustor Dashboard Admin.
![alt screenshot](/student_management_mvc/image/ViewAllStudentAd.png)
---
**4. Test Login Flow:**

```
1. Access: http://localhost:8080/student_management_mvc/login

   → Redirected to login (AuthFilter)

2. Login with: admin / password123
   → Creates session
   → Redirected to dashboard

3. Click "View All Students"

   → Shows student list
   → Edit/Delete buttons visible (admin)

4. Logout

   → Session invalidated
   → Redirected to login

5. Login with: john / password123 

   → Regular user view
   → No Edit/Delete buttons

6. Try to access: /student?action=new

   → AdminFilter blocks access
   → Error message displayed
```

### Test URLs

```
Public (no login required):
- /login
- /logout

Protected (login required):
- /dashboard
- /student?action=list

Admin only:
- /student?action=new
- /student?action=edit&id=1
- /student?action=delete&id=1
```

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
@WebFilter(filterName = "AuthFilter", urlPatterns = {"/*"})
public class AuthFilter implements Filter {

    // Public URLs that don't require authentication
    private static final String[] PUBLIC_URLS = {
            "/login",
            "/logout",
            ".css",
            ".js",
            ".png",
            ".jpg",
            ".jpeg",
            ".gif"
    };

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        System.out.println("AuthFilter initialized");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        String path = requestURI.substring(contextPath.length());

        // Check if this is a public URL
        if (isPublicUrl(path)) {
            // Allow access to public URLs
            chain.doFilter(request, response);
            return;
        }

        // Check if user is logged in
        HttpSession session = httpRequest.getSession(false);
        boolean isLoggedIn = (session != null && session.getAttribute("user") != null);

        if (isLoggedIn) {
            // User is logged in, allow access
            chain.doFilter(request, response);
        } else {
            // User not logged in, redirect to login
            String loginURL = contextPath + "/login";
            httpResponse.sendRedirect(loginURL);
        }
    }

    @Override
    public void destroy() {
        System.out.println("AuthFilter destroyed");
    }

    /**
     * Check if URL is public (doesn't require authentication)
     */
    private boolean isPublicUrl(String path) {
        for (String publicUrl : PUBLIC_URLS) {
            if (path.contains(publicUrl)) {
                return true;
            }
        }
        return false;
    }
}
```

**Testing:**
1. Deploy application
2. Try accessing `/student` without login → Should redirect to login
3. Login successfully
![alt screenshoot](image/HomePageStudent.png)
4. Access `/student` → Should work
![alt screenshoot](image/StudentLinkPage.png)
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
        System.out.println("AdminFilter initialized");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        String action = httpRequest.getParameter("action");

        // Check if this action requires admin role
        if (isAdminAction(action)) {
            HttpSession session = httpRequest.getSession(false);

            if (session != null) {
                User user = (User) session.getAttribute("user");

                if (user != null && user.isAdmin()) {
                    // User is admin, allow access
                    chain.doFilter(request, response);
                } else {
                    // User is not admin, deny access
                    httpResponse.sendRedirect(httpRequest.getContextPath() +
                            "/student?action=list&error=Access denied. Admin privileges required.");
                }
            } else {
                // No session, redirect to login
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
            }
        } else {
            // Not an admin action, allow access
            chain.doFilter(request, response);
        }
    }

    @Override
    public void destroy() {
        System.out.println("AdminFilter destroyed");
    }

    /**
     * Check if action requires admin role
     */
    private boolean isAdminAction(String action) {
        if (action == null) return false;

        for (String adminAction : ADMIN_ACTIONS) {
            if (adminAction.equals(action)) {
                return true;
            }
        }
        return false;
    }
}
```


**Testing:**
1. Login as admin [!alt screenshoot](image/AfterLoginAdmin.png), [!alt screenshoot](image/AdPage.png) → Try edit/delete → Should work [!alt screenshoot](image/ViewAllStudentAd.png)
2. Logout 
[!alt sceenshoot](image/AfterLogoutAd.png)
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
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Management System</title>
    <style>
       ....
    </style>
</head>
<body>

    <div class="navbar">
        <h2>📚 SMS Portal</h2>
        <div class="navbar-right">
            <div class="user-info">
                <span>Welcome, <strong>${sessionScope.fullName}</strong></span>
                <span class="role-badge role-${sessionScope.role}">
                    ${sessionScope.role}
                </span>
            </div>
            <a href="dashboard" class="btn-nav">Dashboard</a>
            <a href="logout" class="btn-logout">Logout</a>
        </div>
    </div>

<div class="container">
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
        <div>
            <h1>🎓 Student List</h1>
            <p class="subtitle">Manage your student records</p>
        </div>

        <c:if test="${sessionScope.role eq 'admin'}">
            <a href="student?action=new" class="btn btn-add">➕ Add New Student</a>
        </c:if>
    </div>

    <c:if test="${not empty param.message}">
        <div class="message success">✅ ${param.message}</div>
    </c:if>
    <c:if test="${not empty param.error}">
        <div class="message error">❌ ${param.error}</div>
    </c:if>

    <div class="controls">
        <form action="student" method="get" class="search-form">
            <input type="hidden" name="action" value="list">
            <input type="hidden" name="sortBy" value="${sortBy}">
            <input type="hidden" name="order" value="${order}">

            <input type="text" name="keyword" class="form-input search-input"
                   placeholder="Search by Name, Email, or ID..."
                   value="${keyword}">

            <select name="major" class="form-input filter-select" onchange="this.form.submit()">
                <option value="">-- All Majors --</option>
                <option value="Computer Science" ${selectedMajor == 'Computer Science' ? 'selected' : ''}>Computer Science</option>
                <option value="Information Technology" ${selectedMajor == 'Information Technology' ? 'selected' : ''}>Information Technology</option>
                <option value="Software Engineering" ${selectedMajor == 'Software Engineering' ? 'selected' : ''}>Software Engineering</option>
                <option value="Business Administration" ${selectedMajor == 'Business Administration' ? 'selected' : ''}>Business Administration</option>
            </select>

            <button type="submit" class="btn btn-primary">Apply Filters</button>

            <c:if test="${not empty keyword or not empty selectedMajor}">
                <a href="student?action=list" class="btn btn-outline">Clear</a>
            </c:if>
        </form>
    </div>

    <c:choose>
        <c:when test="${not empty students}">
            <table>
                <thead>
                    <tr>
                        <th width="10%">
                            <a href="student?action=list&sortBy=id&order=${sortBy == 'id' && order == 'asc' ? 'desc' : 'asc'}&keyword=${keyword}&major=${selectedMajor}">
                                ID <c:if test="${sortBy == 'id'}">${order == 'asc' ? '▲' : '▼'}</c:if>
                            </a>
                        </th>
                        <th width="15%">
                            <a href="student?action=list&sortBy=student_code&order=${sortBy == 'student_code' && order == 'asc' ? 'desc' : 'asc'}&keyword=${keyword}&major=${selectedMajor}">
                                Code <c:if test="${sortBy == 'student_code'}">${order == 'asc' ? '▲' : '▼'}</c:if>
                            </a>
                        </th>
                        <th width="20%">
                            <a href="student?action=list&sortBy=full_name&order=${sortBy == 'full_name' && order == 'asc' ? 'desc' : 'asc'}&keyword=${keyword}&major=${selectedMajor}">
                                Full Name <c:if test="${sortBy == 'full_name'}">${order == 'asc' ? '▲' : '▼'}</c:if>
                            </a>
                        </th>
                        <th width="25%">
                            <a href="student?action=list&sortBy=email&order=${sortBy == 'email' && order == 'asc' ? 'desc' : 'asc'}&keyword=${keyword}&major=${selectedMajor}">
                                Email <c:if test="${sortBy == 'email'}">${order == 'asc' ? '▲' : '▼'}</c:if>
                            </a>
                        </th>
                        <th width="15%">
                            <a href="student?action=list&sortBy=major&order=${sortBy == 'major' && order == 'asc' ? 'desc' : 'asc'}&keyword=${keyword}&major=${selectedMajor}">
                                Major <c:if test="${sortBy == 'major'}">${order == 'asc' ? '▲' : '▼'}</c:if>
                            </a>
                        </th>

                        <c:if test="${sessionScope.role eq 'admin'}">
                            <th width="15%">Actions</th>
                        </c:if>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="student" items="${students}">
                        <tr>
                            <td>${student.id}</td>
                            <td><strong>${student.studentCode}</strong></td>
                            <td>${student.fullName}</td>
                            <td>${student.email}</td>
                            <td><span style="background: #e9ecef; padding: 4px 8px; border-radius: 4px; font-size: 12px;">${student.major}</span></td>

                            // admin page ONLY
                            <c:if test="${sessionScope.role eq 'admin'}">
                                <td>
                                    <a href="student?action=edit&id=${student.id}" class="btn-edit">✏️ Edit</a>
                                    <a href="student?action=delete&id=${student.id}" class="btn-delete"
                                       onclick="return confirm('Delete student ${student.studentCode}?')">🗑️</a>
                                </td>
                            </c:if>

                        </tr>
                    </c:forEach>
                </tbody>
            </table>

            <div style="margin-top: 15px; color: #6c757d; font-size: 14px; text-align: right;">
                Showing ${students.size()} record(s)
            </div>

        </c:when>
        <c:otherwise>
            <div class="empty-state">
                <span class="empty-icon">📭</span>
                <h3>No students found</h3>
                <p>Try adjusting your search filters or add a new student.</p>
                <br>
                <a href="student?action=list" class="btn-secondary" style="padding: 10px 20px; text-decoration:none; border-radius:4px;">Reset All Filters</a>
            </div>
        </c:otherwise>
    </c:choose>
</div>

</body>
</html>
```

- This is Admin Page [!alt screenshoot](image/AdPage.png)

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



**2. View:** `WebContent/views/change-password.jsp`



**3. DAO Method:** Add to `UserDAO.java`



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