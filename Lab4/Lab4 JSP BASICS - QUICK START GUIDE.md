---
title: Lab4 JSP BASICS - QUICK START GUIDE

---

# JSP BASICS - QUICK START GUIDE

**Course:** Web Application Development  
**Purpose:** Introduction to JSP before Lab 4  

> **Note:** This guide introduces JSP fundamentals. Read this BEFORE starting Lab 1.

---

## 📋 TABLE OF CONTENTS

1. [What is JSP?](#1-what-is-jsp)
2. [JSP Syntax Elements](#2-jsp-syntax-elements)
3. [JSP Directives](#3-jsp-directives)
4. [JSP Scripting Elements](#4-jsp-scripting-elements)
5. [JSP Implicit Objects](#5-jsp-implicit-objects)
6. [Working with Forms](#6-working-with-forms)
7. [Sample Applications](#7-sample-applications)
8. [Common Patterns](#8-common-patterns)

---

## 1. WHAT IS JSP?

### Definition

**JSP (JavaServer Pages)** is a technology for developing web pages that support dynamic content. JSP files are HTML files with embedded Java code.

### How JSP Works

```
Browser Request → Tomcat Server → JSP File → Compile to Servlet → Execute → HTML Response
```

1. User requests `.jsp` file
2. Tomcat converts JSP to Java Servlet (first time only)
3. Servlet is compiled to bytecode
4. Servlet executes and generates HTML
5. HTML sent back to browser

### JSP vs HTML

**HTML (Static):**
```html
<h1>Hello World</h1>
<p>The current time is: 10:30 AM</p>
```
Always shows same content.

**JSP (Dynamic):**
```jsp
<h1>Hello World</h1>
<p>The current time is: <%= new java.util.Date() %></p>
```
Shows current time when page loads.

### First JSP Example

**File:** `hello.jsp`

```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>My First JSP</title>
</head>
<body>
    <h1>Hello from JSP!</h1>
    <p>Current time: <%= new java.util.Date() %></p>
</body>
</html>
```

**Explanation:**
- `<%@ page ... %>` - Page directive (configuration)
- `<%= ... %>` - JSP expression (prints value)
- Mix of HTML and Java code
- Browser only sees final HTML output

---

## 2. JSP SYNTAX ELEMENTS

### 2.1 JSP Comments

```jsp
<%-- JSP Comment: Not visible in HTML source --%>
<!-- HTML Comment: Visible in HTML source -->
```

**Example:**
```jsp
<%-- This is processed by server, not sent to browser --%>
<!-- This is sent to browser, visible in View Source -->
```

**When to use:**
- JSP comments: For server-side notes, sensitive info
- HTML comments: For client-side documentation

### 2.2 Scriptlet Tags Overview

| Tag | Name | Purpose | Example |
|-----|------|---------|---------|
| `<%@ ... %>` | Directive | Page configuration | `<%@ page import="java.util.*" %>` |
| `<% ... %>` | Scriptlet | Java code block | `<% int x = 5; %>` |
| `<%= ... %>` | Expression | Print value | `<%= x %>` |
| `<%! ... %>` | Declaration | Declare methods/variables | `<%! int count = 0; %>` |

---

## 3. JSP DIRECTIVES

Directives provide information about the page to the JSP container.

### 3.1 Page Directive

Most commonly used directive.

```jsp
<%@ page 
    language="java" 
    contentType="text/html; charset=UTF-8" 
    pageEncoding="UTF-8"
    import="java.util.*, java.sql.*"
    errorPage="error.jsp"
%>
```

**Common Attributes:**

| Attribute | Purpose | Example |
|-----------|---------|---------|
| `language` | Programming language | `"java"` |
| `contentType` | MIME type | `"text/html; charset=UTF-8"` |
| `import` | Import Java classes | `"java.util.*, java.sql.*"` |
| `errorPage` | Error handler page | `"error.jsp"` |
| `session` | Enable session | `"true"` (default) |

**Example - Import Classes:**
```jsp
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Date, java.text.SimpleDateFormat" %>

<% 
ArrayList<String> items = new ArrayList<>();
Date now = new Date();
%>
```

### 3.2 Include Directive

Include content from another file at translation time.

```jsp
<%@ include file="header.jsp" %>
<h1>Main Content</h1>
<%@ include file="footer.jsp" %>
```

**Example - Header File:**

**File:** `header.jsp`
```jsp
<header>
    <h1>My Website</h1>
    <nav>
        <a href="home.jsp">Home</a>
        <a href="about.jsp">About</a>
    </nav>
</header>
```

**File:** `home.jsp`
```jsp
<%@ include file="header.jsp" %>
<main>
    <p>Welcome to the home page!</p>
</main>
```

**Explanation:**
- Content included at compile time
- One JSP file created with combined content
- Changes to included file require recompilation

### 3.3 Taglib Directive

Declares tag libraries (covered in Lab 2).

```jsp
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
```

---

## 4. JSP SCRIPTING ELEMENTS

### 4.1 Scriptlets `<% ... %>`

Execute Java code within JSP.

**Basic Example:**
```jsp
<% 
    int number = 42;
    String message = "Hello";
    System.out.println("This prints to console");
%>
```

**Explanation:**
- Any valid Java code
- Variables declared here are local
- `System.out.println()` outputs to server console, not browser

**Loop Example:**
```jsp
<ul>
<% 
    for (int i = 1; i <= 5; i++) {
%>
    <li>Item <%= i %></li>
<%
    }
%>
</ul>
```

**Output:**
```html
<ul>
    <li>Item 1</li>
    <li>Item 2</li>
    <li>Item 3</li>
    <li>Item 4</li>
    <li>Item 5</li>
</ul>
```

**Explanation:**
- Mix Java control structures with HTML
- Open `<%` and close `%>` around HTML
- `<%= i %>` prints loop variable

**Conditional Example:**
```jsp
<% 
    int hour = java.time.LocalTime.now().getHour();
    String greeting;
    
    if (hour < 12) {
        greeting = "Good Morning";
    } else if (hour < 18) {
        greeting = "Good Afternoon";
    } else {
        greeting = "Good Evening";
    }
%>
<h1><%= greeting %>!</h1>
```

**Explanation:**
- Java if-else logic
- Store result in variable
- Display with expression

### 4.2 Expressions `<%= ... %>`

Output value directly to page.

**Basic Examples:**
```jsp
<p>2 + 2 = <%= 2 + 2 %></p>
<p>Your IP: <%= request.getRemoteAddr() %></p>
<p>Random number: <%= Math.random() %></p>
<p>Current date: <%= new java.util.Date() %></p>
```

**Output:**
```html
<p>2 + 2 = 4</p>
<p>Your IP: 192.168.1.100</p>
<p>Random number: 0.7234567</p>
<p>Current date: Mon Nov 04 10:30:45 ICT 2025</p>
```

**Explanation:**
- `<%= expression %>` equivalent to `out.print(expression)`
- No semicolon needed
- Expression must return a value
- Automatically converted to String

**Method Call Example:**
```jsp
<%
    String getName() {
        return "John Doe";
    }
    
    int multiply(int a, int b) {
        return a * b;
    }
%>

<p>Name: <%= getName() %></p>
<p>5 × 3 = <%= multiply(5, 3) %></p>
```

**Note:** Method declarations should use `<%! ... %>` (see next section).

### 4.3 Declarations `<%! ... %>`

Declare class-level variables and methods.

**Variable Declaration:**
```jsp
<%! 
    private int pageVisits = 0;
    private String siteName = "My Website";
%>

<%
    pageVisits++;
%>

<p>Site: <%= siteName %></p>
<p>Total visits: <%= pageVisits %></p>
```

**Explanation:**
- `<%! ... %>` creates class-level members
- `<% ... %>` creates local variables
- Class-level variables persist between requests (⚠️ not thread-safe!)

**Method Declaration:**
```jsp
<%!
    public String formatDate(java.util.Date date) {
        java.text.SimpleDateFormat sdf = 
            new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        return sdf.format(date);
    }
    
    public boolean isEven(int number) {
        return number % 2 == 0;
    }
%>

<p>Formatted date: <%= formatDate(new java.util.Date()) %></p>
<p>Is 10 even? <%= isEven(10) %></p>
<p>Is 7 even? <%= isEven(7) %></p>
```

**Comparison:**

```jsp
<%-- Class-level (<%! %>) --%>
<%! int classVar = 0; %>

<%-- Local (within method) (<% %>) --%>
<% int localVar = 0; %>
```

---

## 5. JSP IMPLICIT OBJECTS

JSP provides built-in objects you can use without declaring.

### 5.1 Overview of Implicit Objects

| Object | Type | Description |
|--------|------|-------------|
| `request` | HttpServletRequest | Client request data |
| `response` | HttpServletResponse | Response to client |
| `out` | JspWriter | Output to client |
| `session` | HttpSession | User session data |
| `application` | ServletContext | Application-wide data |
| `config` | ServletConfig | Servlet configuration |
| `pageContext` | PageContext | Page scope attributes |
| `page` | Object | Current servlet instance |
| `exception` | Throwable | Exception (error pages) |

### 5.2 Request Object

Access HTTP request information.

**Get Request Information:**
```jsp
<h2>Request Information</h2>
<p>Method: <%= request.getMethod() %></p>
<p>URI: <%= request.getRequestURI() %></p>
<p>Protocol: <%= request.getProtocol() %></p>
<p>Server: <%= request.getServerName() %>:<%= request.getServerPort() %></p>
<p>Client IP: <%= request.getRemoteAddr() %></p>
<p>User Agent: <%= request.getHeader("User-Agent") %></p>
```

**Example Output:**
```
Method: GET
URI: /myapp/info.jsp
Protocol: HTTP/1.1
Server: localhost:8080
Client IP: 127.0.0.1
User Agent: Mozilla/5.0 ...
```

**Get Parameters:**
```jsp
<%-- URL: demo.jsp?name=John&age=25 --%>

<p>Name: <%= request.getParameter("name") %></p>
<p>Age: <%= request.getParameter("age") %></p>

<%
    String name = request.getParameter("name");
    if (name != null && !name.isEmpty()) {
%>
    <h3>Welcome, <%= name %>!</h3>
<%
    } else {
%>
    <h3>Welcome, Guest!</h3>
<%
    }
%>
```

**Explanation:**
- `getParameter("name")` returns String value
- Returns `null` if parameter doesn't exist
- Always check for null before using

### 5.3 Response Object

Control HTTP response.

**Redirect:**
```jsp
<%
    String user = request.getParameter("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
    }
%>
```

**Set Headers:**
```jsp
<%
    response.setHeader("Cache-Control", "no-cache");
    response.setContentType("text/plain");
%>
```

### 5.4 Out Object

Write output to client.

**Basic Usage:**
```jsp
<%
    out.println("<h1>Hello</h1>");
    out.print("Line without newline");
    out.flush();
%>
```

**Equivalent:**
```jsp
<h1>Hello</h1>
Line without newline
```

**When to use `out`:**
- Inside scriptlets when mixing logic
- Most times, use expressions `<%= %>` instead

### 5.5 Session Object

Store user-specific data across requests.

**Store Data:**
```jsp
<%-- login.jsp --%>
<%
    String username = request.getParameter("username");
    session.setAttribute("user", username);
    session.setAttribute("loginTime", new java.util.Date());
%>
<p>Login successful!</p>
```

**Retrieve Data:**
```jsp
<%-- welcome.jsp --%>
<%
    String user = (String) session.getAttribute("user");
    java.util.Date loginTime = (java.util.Date) session.getAttribute("loginTime");
%>

<% if (user != null) { %>
    <h1>Welcome back, <%= user %>!</h1>
    <p>Logged in at: <%= loginTime %></p>
<% } else { %>
    <p>Please <a href="login.jsp">login</a></p>
<% } %>
```

**Session Methods:**
```jsp
<%
    session.setAttribute("key", value);           // Store
    Object value = session.getAttribute("key");   // Retrieve
    session.removeAttribute("key");               // Remove
    session.invalidate();                         // Destroy session
    String id = session.getId();                  // Get session ID
    boolean isNew = session.isNew();              // Check if new
%>
```

**Explanation:**
- Session persists across page requests
- Unique per user
- Stored on server
- Expires after timeout (default: 30 minutes)

### 5.6 Application Object

Share data across all users.

**Store Application Data:**
```jsp
<%
    application.setAttribute("websiteName", "My Site");
    application.setAttribute("startTime", new java.util.Date());
    
    Integer visitors = (Integer) application.getAttribute("visitors");
    if (visitors == null) {
        visitors = 0;
    }
    visitors++;
    application.setAttribute("visitors", visitors);
%>

<h1><%= application.getAttribute("websiteName") %></h1>
<p>Total visitors: <%= application.getAttribute("visitors") %></p>
```

**Explanation:**
- Shared by ALL users
- Persists until server restarts
- Useful for: site settings, counters, cached data

---

## 6. WORKING WITH FORMS

### 6.1 Simple Form

**File:** `form.jsp`

```jsp
<!DOCTYPE html>
<html>
<head>
    <title>Simple Form</title>
</head>
<body>
    <h2>Enter Your Information</h2>
    <form action="process.jsp" method="POST">
        <label>Name:</label>
        <input type="text" name="name" required><br><br>
        
        <label>Email:</label>
        <input type="email" name="email" required><br><br>
        
        <label>Age:</label>
        <input type="number" name="age" min="1" max="120"><br><br>
        
        <button type="submit">Submit</button>
    </form>
</body>
</html>
```

**File:** `process.jsp`

```jsp
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Form Result</title>
</head>
<body>
    <h2>Form Submitted!</h2>
    <%
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String ageStr = request.getParameter("age");
        
        int age = 0;
        if (ageStr != null && !ageStr.isEmpty()) {
            age = Integer.parseInt(ageStr);
        }
    %>
    
    <p><strong>Name:</strong> <%= name %></p>
    <p><strong>Email:</strong> <%= email %></p>
    <p><strong>Age:</strong> <%= age %></p>
    
    <% if (age >= 18) { %>
        <p style="color: green;">You are an adult.</p>
    <% } else { %>
        <p style="color: orange;">You are a minor.</p>
    <% } %>
    
    <a href="form.jsp">Back to Form</a>
</body>
</html>
```

**Explanation:**

**Form Attributes:**
- `action="process.jsp"` - where to send data
- `method="POST"` - HTTP method (POST for forms)
- `name="fieldname"` - used to retrieve value

**Processing:**
- `request.getParameter("name")` gets form value
- Returns String or null
- Convert to other types: `Integer.parseInt()`

### 6.2 Form with Multiple Values

**Checkboxes:**

```jsp
<form action="process.jsp" method="POST">
    <p>Select your hobbies:</p>
    <input type="checkbox" name="hobby" value="Reading"> Reading<br>
    <input type="checkbox" name="hobby" value="Sports"> Sports<br>
    <input type="checkbox" name="hobby" value="Music"> Music<br>
    <input type="checkbox" name="hobby" value="Gaming"> Gaming<br>
    <button type="submit">Submit</button>
</form>
```

**Processing Multiple Values:**

```jsp
<%
    String[] hobbies = request.getParameterValues("hobby");
    
    if (hobbies != null && hobbies.length > 0) {
%>
    <h3>Your hobbies:</h3>
    <ul>
    <%
        for (String hobby : hobbies) {
    %>
        <li><%= hobby %></li>
    <%
        }
    %>
    </ul>
<%
    } else {
%>
    <p>No hobbies selected.</p>
<%
    }
%>
```

**Explanation:**
- `getParameterValues()` returns String array
- Used for checkboxes or multi-select dropdowns
- Check for null before using

### 6.3 Form Validation

**Client-Side (HTML5):**

```jsp
<form action="process.jsp" method="POST">
    <label>Email:</label>
    <input type="email" name="email" required>
    
    <label>Age:</label>
    <input type="number" name="age" min="18" max="100" required>
    
    <label>Website:</label>
    <input type="url" name="website">
    
    <label>Phone:</label>
    <input type="tel" name="phone" pattern="[0-9]{10}" 
           title="10 digit phone number">
    
    <button type="submit">Submit</button>
</form>
```

**Server-Side Validation:**

```jsp
<%
    String email = request.getParameter("email");
    String ageStr = request.getParameter("age");
    
    StringBuilder errors = new StringBuilder();
    
    if (email == null || email.trim().isEmpty()) {
        errors.append("Email is required.<br>");
    } else if (!email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
        errors.append("Invalid email format.<br>");
    }
    
    if (ageStr == null || ageStr.trim().isEmpty()) {
        errors.append("Age is required.<br>");
    } else {
        try {
            int age = Integer.parseInt(ageStr);
            if (age < 18 || age > 100) {
                errors.append("Age must be between 18 and 100.<br>");
            }
        } catch (NumberFormatException e) {
            errors.append("Age must be a number.<br>");
        }
    }
    
    if (errors.length() > 0) {
%>
        <div style="color: red; padding: 10px; border: 1px solid red;">
            <h3>Validation Errors:</h3>
            <%= errors.toString() %>
        </div>
        <a href="form.jsp">Go Back</a>
<%
    } else {
%>
        <p>Form is valid! Processing...</p>
<%
    }
%>
```

**Explanation:**
- Always validate on server!
- Client validation can be bypassed
- Check for null, empty, format, range
- Collect all errors before displaying

---

## 7. SAMPLE APPLICATIONS

### 7.1 Simple Calculator

**File:** `calculator.jsp`

```jsp
<!DOCTYPE html>
<html>
<head>
    <title>Simple Calculator</title>
    <style>
        .container { width: 400px; margin: 50px auto; }
        input { padding: 8px; margin: 5px; }
        button { padding: 10px 20px; background: #007bff; color: white; border: none; }
        .result { padding: 15px; background: #d4edda; margin-top: 20px; border-radius: 5px; }
    </style>
</head>
<body>
    <div class="container">
        <h2>Calculator</h2>
        <form method="POST">
            <input type="number" name="num1" placeholder="First number" required>
            <select name="operation">
                <option value="add">+</option>
                <option value="subtract">-</option>
                <option value="multiply">×</option>
                <option value="divide">÷</option>
            </select>
            <input type="number" name="num2" placeholder="Second number" required>
            <button type="submit">Calculate</button>
        </form>
        
        <%
            String num1Str = request.getParameter("num1");
            String num2Str = request.getParameter("num2");
            String operation = request.getParameter("operation");
            
            if (num1Str != null && num2Str != null) {
                double num1 = Double.parseDouble(num1Str);
                double num2 = Double.parseDouble(num2Str);
                double result = 0;
                String operationSymbol = "";
                
                switch (operation) {
                    case "add":
                        result = num1 + num2;
                        operationSymbol = "+";
                        break;
                    case "subtract":
                        result = num1 - num2;
                        operationSymbol = "-";
                        break;
                    case "multiply":
                        result = num1 * num2;
                        operationSymbol = "×";
                        break;
                    case "divide":
                        if (num2 != 0) {
                            result = num1 / num2;
                            operationSymbol = "÷";
                        } else {
                            out.println("<div class='result' style='background: #f8d7da;'>");
                            out.println("Error: Cannot divide by zero!");
                            out.println("</div>");
                            return;
                        }
                        break;
                }
        %>
                <div class="result">
                    <strong>Result:</strong> 
                    <%= num1 %> <%= operationSymbol %> <%= num2 %> = <%= result %>
                </div>
        <%
            }
        %>
    </div>
</body>
</html>
```

**Explanation:**
- Single page for form and processing
- Check if parameters exist before calculating
- Handle division by zero error
- Display result on same page

### 7.2 Simple Login System

**File:** `login.jsp`

```jsp
<!DOCTYPE html>
<html>
<head>
    <title>Login</title>
    <style>
        .login-box {
            width: 300px;
            margin: 100px auto;
            padding: 30px;
            border: 1px solid #ddd;
            border-radius: 10px;
        }
        input { width: 100%; padding: 10px; margin: 10px 0; box-sizing: border-box; }
        button { width: 100%; padding: 10px; background: #28a745; color: white; border: none; }
        .error { color: red; }
    </style>
</head>
<body>
    <div class="login-box">
        <h2>Login</h2>
        
        <% if (request.getParameter("error") != null) { %>
            <p class="error">Invalid username or password!</p>
        <% } %>
        
        <form action="verify_login.jsp" method="POST">
            <input type="text" name="username" placeholder="Username" required>
            <input type="password" name="password" placeholder="Password" required>
            <button type="submit">Login</button>
        </form>
    </div>
</body>
</html>
```

**File:** `verify_login.jsp`

```jsp
<%
    String username = request.getParameter("username");
    String password = request.getParameter("password");
    
    if ("admin".equals(username) && "admin123".equals(password)) {
        session.setAttribute("username", username);
        session.setAttribute("loginTime", new java.util.Date());
        response.sendRedirect("dashboard.jsp");
    } else {
        response.sendRedirect("login.jsp?error=1");
    }
%>
```

**File:** `dashboard.jsp`

```jsp
<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Dashboard</title>
</head>
<body>
    <h1>Welcome, <%= username %>!</h1>
    <p>Login time: <%= session.getAttribute("loginTime") %></p>
    <a href="logout.jsp">Logout</a>
</body>
</html>
```

**File:** `logout.jsp`

```jsp
<%
    session.invalidate();
    response.sendRedirect("login.jsp");
%>
```

**Explanation:**

**Login Flow:**
1. User enters credentials
2. `verify_login.jsp` checks username/password
3. If valid: create session, redirect to dashboard
4. If invalid: redirect back with error
5. Dashboard checks session before displaying
6. Logout invalidates session

**Security Notes (for production):**
- Never store passwords in plain text
- Use database for user credentials
- Implement password hashing (bcrypt)
- Add CAPTCHA for brute force protection

### 7.3 Shopping Cart

**File:** `products.jsp`

```jsp
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Products</title>
    <style>
        .product { border: 1px solid #ddd; padding: 15px; margin: 10px; display: inline-block; }
        .cart-icon { position: fixed; top: 20px; right: 20px; background: #007bff; color: white; padding: 10px; }
    </style>
</head>
<body>
    <div class="cart-icon">
        Cart: <%= session.getAttribute("cartSize") != null ? session.getAttribute("cartSize") : 0 %> items
        | <a href="cart.jsp" style="color: white;">View Cart</a>
    </div>
    
    <h1>Products</h1>
    
    <div class="product">
        <h3>Laptop</h3>
        <p>Price: $999</p>
        <a href="add_to_cart.jsp?id=1&name=Laptop&price=999">Add to Cart</a>
    </div>
    
    <div class="product">
        <h3>Mouse</h3>
        <p>Price: $29</p>
        <a href="add_to_cart.jsp?id=2&name=Mouse&price=29">Add to Cart</a>
    </div>
    
    <div class="product">
        <h3>Keyboard</h3>
        <p>Price: $79</p>
        <a href="add_to_cart.jsp?id=3&name=Keyboard&price=79">Add to Cart</a>
    </div>
</body>
</html>
```

**File:** `add_to_cart.jsp`

```jsp
<%@ page import="java.util.*" %>
<%
    String id = request.getParameter("id");
    String name = request.getParameter("name");
    String priceStr = request.getParameter("price");
    
    @SuppressWarnings("unchecked")
    Map<String, Map<String, String>> cart = 
        (Map<String, Map<String, String>>) session.getAttribute("cart");
    
    if (cart == null) {
        cart = new HashMap<>();
    }
    
    Map<String, String> item = new HashMap<>();
    item.put("name", name);
    item.put("price", priceStr);
    
    if (cart.containsKey(id)) {
        int quantity = Integer.parseInt(cart.get(id).get("quantity"));
        item.put("quantity", String.valueOf(quantity + 1));
    } else {
        item.put("quantity", "1");
    }
    
    cart.put(id, item);
    session.setAttribute("cart", cart);
    session.setAttribute("cartSize", cart.size());
    
    response.sendRedirect("products.jsp");
%>
```

**File:** `cart.jsp`

```jsp
<%@ page import="java.util.*" %>
<%
    @SuppressWarnings("unchecked")
    Map<String, Map<String, String>> cart = 
        (Map<String, Map<String, String>>) session.getAttribute("cart");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Shopping Cart</title>
    <style>
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 10px; border: 1px solid #ddd; }
        th { background: #007bff; color: white; }
    </style>
</head>
<body>
    <h1>Your Shopping Cart</h1>
    
    <% if (cart == null || cart.isEmpty()) { %>
        <p>Your cart is empty.</p>
    <% } else { %>
        <table>
            <tr>
                <th>Product</th>
                <th>Price</th>
                <th>Quantity</th>
                <th>Subtotal</th>
            </tr>
            <%
                double total = 0;
                for (Map.Entry<String, Map<String, String>> entry : cart.entrySet()) {
                    Map<String, String> item = entry.getValue();
                    String name = item.get("name");
                    double price = Double.parseDouble(item.get("price"));
                    int quantity = Integer.parseInt(item.get("quantity"));
                    double subtotal = price * quantity;
                    total += subtotal;
            %>
            <tr>
                <td><%= name %></td>
                <td>$<%= price %></td>
                <td><%= quantity %></td>
                <td>$<%= subtotal %></td>
            </tr>
            <%
                }
            %>
            <tr>
                <th colspan="3">Total:</th>
                <th>$<%= total %></th>
            </tr>
        </table>
    <% } %>
    
    <br>
    <a href="products.jsp">Continue Shopping</a>
    <% if (cart != null && !cart.isEmpty()) { %>
        | <a href="clear_cart.jsp">Clear Cart</a>
    <% } %>
</body>
</html>
```

**File:** `clear_cart.jsp`

```jsp
<%
    session.removeAttribute("cart");
    session.removeAttribute("cartSize");
    response.sendRedirect("cart.jsp");
%>
```

**Explanation:**

**Cart Structure:**
- Stored in session as Map<String, Map<String, String>>
- Outer map: product ID → item details
- Inner map: name, price, quantity

**Features:**
- Add items to cart
- Increment quantity if item exists
- Display cart contents
- Calculate total
- Clear cart

---

## 8. COMMON PATTERNS

### 8.1 Redirect vs Forward

**Redirect (New Request):**
```jsp
<%
    response.sendRedirect("success.jsp");
%>
```
- Client makes new request
- URL changes in browser
- Use after POST to prevent re-submission

**Forward (Same Request):**
```jsp
<%
    request.setAttribute("data", someData);
    RequestDispatcher dispatcher = request.getRequestDispatcher("display.jsp");
    dispatcher.forward(request, response);
%>
```
- Server-side transfer
- URL doesn't change
- Request attributes preserved

### 8.2 Include Pattern

**Static Include (Compile Time):**
```jsp
<%@ include file="header.jsp" %>
```
- Included at compile time
- Changes require recompilation

**Dynamic Include (Runtime):**
```jsp
<jsp:include page="header.jsp" />
```
- Included at request time
- Can pass parameters:
```jsp
<jsp:include page="header.jsp">
    <jsp:param name="title" value="Home Page" />
</jsp:include>
```

### 8.3 Error Handling

**Specify Error Page:**
```jsp
<%@ page errorPage="error.jsp" %>
<%
    int result = 10 / 0;  // Throws exception
%>
```

**Error Page:**
```jsp
<%@ page isErrorPage="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>Error</title>
</head>
<body>
    <h1>An Error Occurred</h1>
    <p>Error: <%= exception.getMessage() %></p>
</body>
</html>
```

**Explanation:**
- `errorPage` specifies handler
- `isErrorPage="true"` enables `exception` object
- Graceful error display for users

### 8.4 Best Practices

**✅ DO:**
- Validate all user input
- Close database connections
- Use PreparedStatement for SQL
- Store sensitive data in session, not URL
- Handle exceptions gracefully
- Comment complex logic

**❌ DON'T:**
- Mix too much Java in JSP
- Store passwords in plain text
- Trust client-side validation
- Put business logic in JSP
- Ignore exception handling

---

## 9. QUICK REFERENCE

### JSP Elements Cheatsheet

```jsp
<%-- Comment: Not sent to browser --%>

<%@ page attribute="value" %>                    <%-- Directive --%>

<% int x = 5; %>                                  <%-- Scriptlet --%>

<%= x %>                                          <%-- Expression --%>

<%! int count = 0; %>                             <%-- Declaration --%>
```

### Implicit Objects Quick Reference

```jsp
<%= request.getParameter("name") %>               <%-- Get form data --%>
<% response.sendRedirect("page.jsp"); %>          <%-- Redirect --%>
<% out.println("Hello"); %>                       <%-- Print output --%>
<% session.setAttribute("key", value); %>         <%-- Store in session --%>
<% application.setAttribute("key", value); %>     <%-- Application scope --%>
```

### Common Tasks

**Get Current Date:**
```jsp
<%= new java.util.Date() %>
```

**Format Date:**
```jsp
<%
    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
    String formattedDate = sdf.format(new java.util.Date());
%>
<%= formattedDate %>
```

**Check if Parameter Exists:**
```jsp
<% if (request.getParameter("name") != null) { %>
    Name provided
<% } %>
```

**Loop 1 to 10:**
```jsp
<% for (int i = 1; i <= 10; i++) { %>
    <%= i %>
<% } %>
```

---

## 10. SUMMARY

### What You Learned

✅ JSP basics and how it works  
✅ JSP syntax: directives, scriptlets, expressions, declarations  
✅ Implicit objects: request, response, session, application  
✅ Form handling and validation  
✅ Common patterns and best practices

### Key Takeaways

1. **JSP = HTML + Java** - Mix static and dynamic content
2. **Use `<%= %>` for output** - Simpler than `out.print()`
3. **Session for user data** - Persists across requests
4. **Always validate server-side** - Client validation can be bypassed
5. **Keep logic minimal in JSP** - Better to use MVC (Lab 2)

### Next Steps

**You're now ready for Lab 4!**

Lab 4 will teach you:
- Connect JSP to MySQL database
- CRUD operations
- PreparedStatement for security
- Building a complete application

### Additional Resources

- **JSP Specification:** https://jakarta.ee/specifications/pages/
- **W3Schools JSP:** https://www.w3schools.com/jsp/
- **TutorialsPoint JSP:** https://www.tutorialspoint.com/jsp/

---

**End of JSP Basics Guide**

*Read this before starting Lab 1. Practice the examples!*