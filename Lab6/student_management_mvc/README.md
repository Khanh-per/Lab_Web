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

