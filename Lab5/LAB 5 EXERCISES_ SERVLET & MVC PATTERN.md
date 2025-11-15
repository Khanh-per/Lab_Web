---
title: 'LAB 5 EXERCISES: SERVLET & MVC PATTERN'

---

---
title: 'LAB 5 EXERCISES: SERVLET & MVC PATTERN'

---

# LAB 5 EXERCISES: SERVLET & MVC PATTERN

**Course:** Web Application Development  
**Lab Duration:** 2.5 hours  
**Total Points:** 100 points (In-class: 60 points, Homework: 40 points)

---

## 📚 BEFORE YOU START

### Prerequisites:
- ✅ Completed Lab 4 (JSP + MySQL CRUD)
- ✅ Read Lab 5 Setup Guide
- ✅ MySQL running with `student_management` database
- 
- ✅ Understanding of MVC concepts

### Lab Objectives:
By the end of this lab, you should be able to:
1. Refactor JSP-only code into MVC architecture
2. Create JavaBeans (POJOs) and DAOs
3. Implement Servlets as Controllers
4. Use JSTL and EL in JSP views
5. Understand separation of concerns

---

## PART A: IN-CLASS EXERCISES (60 points)

**Time Allocation:** 2.5 hours  
**Submission:** Demonstrate to instructor at end of class

---

### EXERCISE 1: PROJECT SETUP & MODEL LAYER (15 points)

**Estimated Time:** 25 minutes

#### Task 1.1: Create Project Structure (5 points)

Create proper MVC folder structure:

```
StudentManagementMVC/
├── Source Packages/
│   ├── model/
│   ├── dao/
│   └── controller/
└── Web Pages/
    └── views/
```

**Steps:**
1. Create new Web Application project: `StudentManagementMVC`
2. Create Java packages: `model`, `dao`, `controller`
3. Create `views` folder inside Web Pages
4. Add MySQL Connector/J library

**Evaluation Criteria:**
| Criteria | Points |
|----------|--------|
| Project created correctly | 2 |
| Packages structured properly | 2 |
| Libraries added | 1 |

---

#### Task 1.2: Create Student JavaBean (5 points)

**File:** `src/model/Student.java`

**Requirements:**
- Private attributes: id, studentCode, fullName, email, major, createdAt
- Public no-arg constructor
- Public parameterized constructor (without id)
- Public getters and setters for all attributes
- Override `toString()` method

**Template to complete:**
```java
package model;

import java.sql.Timestamp;

public class Student {
    // TODO: Declare private attributes
    
    // TODO: Create no-arg constructor
    
    // TODO: Create parameterized constructor
    
    // TODO: Generate getters and setters
    
    // TODO: Override toString()
}
```

**Evaluation Criteria:**
| Criteria | Points |
|----------|--------|
| All attributes declared | 2 |
| Constructors implemented | 1 |
| Getters/setters complete | 1 |
| toString() implemented | 1 |

---

#### Task 1.3: Create StudentDAO (5 points)

**File:** `src/dao/StudentDAO.java`

**Requirements:**
- Constants for database configuration
- `getConnection()` method
- `getAllStudents()` method - returns List<Student>
- Use try-with-resources
- Proper exception handling

**Code skeleton:**
```java
package dao;

import model.Student;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class StudentDAO {
    // TODO: Add database configuration constants
    
    // TODO: Implement getConnection() method
    
    // TODO: Implement getAllStudents() method
}
```

**Test Your DAO:**
```java
// Add this main method to test (remove after testing)
public static void main(String[] args) {
    StudentDAO dao = new StudentDAO();
    List<Student> students = dao.getAllStudents();
    for (Student s : students) {
        System.out.println(s);
    }
}
```

**Evaluation Criteria:**
| Criteria | Points |
|----------|--------|
| getConnection() works | 2 |
| getAllStudents() returns data | 2 |
| Try-with-resources used | 1 |

**Checkpoint #1:** Show instructor that Student model and DAO work correctly.

---

### EXERCISE 2: CONTROLLER LAYER (20 points)

**Estimated Time:** 40 minutes

#### Task 2.1: Create Basic Servlet (10 points)

**File:** `src/controller/StudentController.java`

**Requirements:**
- Extend `HttpServlet`
- Use `@WebServlet("/student")` annotation
- Override `init()` to initialize StudentDAO
- Override `doGet()` to handle GET requests
- Implement `listStudents()` method
- Forward to JSP view

**Code template:**
```java
package controller;

import dao.StudentDAO;
import model.Student;

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
        // TODO: Initialize studentDAO
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        // TODO: If action is null, set to "list"
        
        // TODO: Route to appropriate method based on action
        switch (action) {
            case "list":
                listStudents(request, response);
                break;
            // TODO: Add more cases later
        }
    }
    
    private void listStudents(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // TODO: 1. Get list of students from DAO
        // TODO: 2. Set as request attribute
        // TODO: 3. Forward to student-list.jsp
    }
}
```

**Evaluation Criteria:**
| Criteria | Points |
|----------|--------|
| Servlet properly configured | 2 |
| init() initializes DAO | 2 |
| doGet() routes correctly | 2 |
| listStudents() gets data from DAO | 2 |
| Sets request attribute | 1 |
| Forwards to JSP | 1 |

---

#### Task 2.2: Add More CRUD Methods (10 points)

Add these methods to `StudentController`:

**Required Methods:**
1. `showNewForm()` - Display add form
2. `showEditForm()` - Display edit form
3. `doPost()` - Handle POST requests
4. `insertStudent()` - Add new student
5. `updateStudent()` - Update student
6. `deleteStudent()` - Delete student

**Hints:**

```java
// GET request handler
protected void doGet(...) {
    String action = request.getParameter("action");
    
    if (action == null) action = "list";
    
    switch (action) {
        case "list": listStudents(request, response); break;
        case "new": showNewForm(request, response); break;
        case "edit": showEditForm(request, response); break;
        case "delete": deleteStudent(request, response); break;
    }
}

// POST request handler
protected void doPost(...) {
    String action = request.getParameter("action");
    
    switch (action) {
        case "insert": insertStudent(request, response); break;
        case "update": updateStudent(request, response); break;
    }
}
```

**Evaluation Criteria:**
| Criteria | Points |
|----------|--------|
| showNewForm() forwards to form | 2 |
| showEditForm() loads student and forwards | 2 |
| doPost() routes correctly | 2 |
| insertStudent() creates student | 2 |
| updateStudent() modifies student | 1 |
| deleteStudent() removes student | 1 |

**Checkpoint #2:** Show instructor that all controller methods work.

---

### EXERCISE 3: VIEW LAYER WITH JSTL (15 points)

**Estimated Time:** 35 minutes

#### Task 3.1: Create Student List View (8 points)

**File:** `WebContent/views/student-list.jsp`

**Requirements:**
- Add JSTL taglib directive
- No scriptlets (no `<% %>`)
- Use `<c:if>` for messages
- Use `<c:forEach>` for student list
- Use EL `${}` for all data access
- Handle empty list case

**Template:**
```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Student List</title>
    <!-- TODO: Add CSS styling -->
</head>
<body>
    <h1>📚 Student Management (MVC)</h1>
    
    <!-- TODO: Display success message if param.message exists -->
    
    <!-- TODO: Display error message if param.error exists -->
    
    <!-- TODO: Add button to add new student -->
    
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Code</th>
                <th>Name</th>
                <th>Email</th>
                <th>Major</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <!-- TODO: Use c:forEach to loop through students -->
            
            <!-- TODO: Display student data using EL ${} -->
            
            <!-- TODO: Add Edit and Delete links -->
            
            <!-- TODO: Handle empty list with c:if -->
        </tbody>
    </table>
</body>
</html>
```

**Examples:**

**Display message:**
```jsp
<c:if test="${not empty param.message}">
    <div class="success">${param.message}</div>
</c:if>
```

**Loop through students:**
```jsp
<c:forEach var="student" items="${students}">
    <tr>
        <td>${student.id}</td>
        <td>${student.studentCode}</td>
        <!-- etc -->
    </tr>
</c:forEach>
```

**Handle empty list:**
```jsp
<c:if test="${empty students}">
    <tr>
        <td colspan="6">No students found</td>
    </tr>
</c:if>
```

**Evaluation Criteria:**
| Criteria | Points |
|----------|--------|
| JSTL taglib included | 1 |
| No scriptlets used | 2 |
| c:if for messages | 1 |
| c:forEach for students | 2 |
| EL for data access | 1 |
| Empty list handled | 1 |

---

#### Task 3.2: Create Student Form View (7 points)

**File:** `WebContent/views/student-form.jsp`

**Requirements:**
- Single form for both Add and Edit
- Use `<c:choose>` for dynamic title
- Use `<c:if>` to show/hide fields conditionally
- Pre-fill values for edit mode
- No scriptlets

**Template:**
```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>
        <!-- TODO: Use c:choose to show "Edit" or "Add" based on student existence -->
    </title>
</head>
<body>
    <div class="container">
        <!-- TODO: Dynamic heading using c:if -->
        
        <form action="student" method="POST">
            <!-- TODO: Hidden field for action (insert or update) -->
            
            <!-- TODO: Hidden field for id if editing -->
            
            <!-- TODO: Student code field (readonly if editing) -->
            
            <!-- TODO: Full name field (pre-filled if editing) -->
            
            <!-- TODO: Email field -->
            
            <!-- TODO: Major field -->
            
            <!-- TODO: Submit button with dynamic text -->
            
            <a href="student?action=list">Cancel</a>
        </form>
    </div>
</body>
</html>
```

**Key JSTL patterns:**

**Dynamic title:**
```jsp
<c:choose>
    <c:when test="${student != null}">Edit Student</c:when>
    <c:otherwise>Add New Student</c:otherwise>
</c:choose>
```

**Dynamic action:**
```jsp
<input type="hidden" name="action" 
       value="${student != null ? 'update' : 'insert'}">
```

**Conditional attributes:**
```jsp
<input type="text" name="studentCode" 
       value="${student.studentCode}" 
       ${student != null ? 'readonly' : 'required'}>
```

**Evaluation Criteria:**
| Criteria | Points |
|----------|--------|
| c:choose for title | 1 |
| c:if for heading | 1 |
| Dynamic action field | 1 |
| Conditional id field | 1 |
| Pre-filled values | 2 |
| No scriptlets | 1 |

**Checkpoint #3:** Show instructor complete MVC application working.

---

### EXERCISE 4: COMPLETE CRUD OPERATIONS (10 points)

**Estimated Time:** 20 minutes

#### Task 4.1: Complete DAO Methods (5 points)

Add remaining methods to `StudentDAO.java`:

**Required methods:**
```java
public Student getStudentById(int id) {
    // TODO: Implement
}

public boolean addStudent(Student student) {
    // TODO: Implement
}

public boolean updateStudent(Student student) {
    // TODO: Implement
}

public boolean deleteStudent(int id) {
    // TODO: Implement
}
```

**Evaluation Criteria:**
| Criteria | Points |
|----------|--------|
| getStudentById works | 1 |
| addStudent works | 1.5 |
| updateStudent works | 1.5 |
| deleteStudent works | 1 |

---

#### Task 4.2: Integration Testing (5 points)

Test all CRUD operations:

**Test Sequence:**

1. **List:** Navigate to `/student` - should see existing students
2. **Add:** Click "Add New Student"
   - Fill form with test data
   - Submit
   - Should redirect to list with success message
3. **Edit:** Click "Edit" on test student
   - Form should pre-fill
   - Modify data
   - Submit
   - Should redirect with update message
4. **Delete:** Click "Delete" on test student
   - Should confirm
   - Should redirect with delete message
5. **Empty State:** Delete all students
   - Should show "No students found" message

**Evaluation Criteria:**
| Criteria | Points |
|----------|--------|
| All operations work | 3 |
| Messages display correctly | 1 |
| No errors in console | 1 |

---

### DEMONSTRATION CHECKLIST (In-class)

At end of class, demonstrate to instructor:

**Model Layer:**
- [ ] Student JavaBean follows conventions
- [ ] StudentDAO has all CRUD methods
- [ ] Database operations work correctly

**Controller Layer:**
- [ ] Servlet properly annotated
- [ ] Routes requests correctly
- [ ] Calls DAO methods
- [ ] Sets request attributes
- [ ] Forwards/redirects appropriately

**View Layer:**
- [ ] No scriptlets in JSP
- [ ] JSTL tags used correctly
- [ ] EL for all data access
- [ ] Single form for add/edit works

**Functionality:**
- [ ] List students
- [ ] Add student
- [ ] Edit student
- [ ] Delete student
- [ ] Messages display

**Grading Notes:**
- Full MVC implementation: 55-60 points
- Most features work: 45-54 points
- Basic structure only: 35-44 points
- Incomplete: <35 points

---


## PART B: HOMEWORK EXERCISES (40 points)

**Deadline:** Before next lab session (1 week)  
**Submission:** Upload ZIP file to LMS

---

### EXERCISE 5: SEARCH FUNCTIONALITY (12 points)

**Estimated Time:** 45 minutes

**Objective:** Add search capability to find students by name, code, or email.

---

#### 5.1: Update StudentDAO (4 points)

**Task:** Add `searchStudents(String keyword)` method to `StudentDAO.java`

**Requirements:**
- Method should return `List<Student>`
- Search across THREE columns: `student_code`, `full_name`, `email`
- Use SQL `LIKE` operator with wildcards (%)
- Handle the keyword parameter safely using `PreparedStatement`
- Return results ordered by id descending
- Use try-with-resources for proper resource management

**Hints:**
```java
// SQL pattern structure
String sql = "SELECT * FROM students WHERE column1 LIKE ? OR column2 LIKE ? OR column3 LIKE ? ORDER BY id DESC";

// How to add wildcards to keyword
String searchPattern = "%" + keyword + "%";

// You need to set the same search pattern for all three placeholders in PreparedStatement
```

**Think about:**
- How will you reuse the code from `getAllStudents()` to build Student objects?
- What happens if keyword is null or empty?
- Should you validate the keyword before building the SQL?

**Testing your method:**
```java
// Create a simple test in main() or controller
StudentDAO dao = new StudentDAO();
List<Student> results = dao.searchStudents("john");
System.out.println("Found " + results.size() + " students");
for (Student s : results) {
    System.out.println(s);
}
```

**Evaluation Criteria:**
| Criteria | Points |
|----------|--------|
| SQL query searches 3 columns with OR operator | 1.5 |
| PreparedStatement used with proper placeholders | 1 |
| Wildcard pattern applied correctly | 0.5 |
| Returns List<Student> with proper mapping | 1 |

---

#### 5.2: Add Search Controller Method (4 points)

**Task:** Add search handling to `StudentController.java`

**Requirements:**
1. Create private method `searchStudents(request, response)`
2. Get `keyword` parameter from request
3. Handle null/empty keyword appropriately (show all students)
4. Call DAO's search method
5. Set BOTH `students` and `keyword` as request attributes
6. Forward to student-list.jsp
7. Update `doGet()` switch to handle "search" action

**Think about:**
- What should happen if the user submits an empty search?
- Why do we need to set `keyword` as an attribute?
- How is this different from `listStudents()` method?

**Method structure hint:**
```java
private void searchStudents(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
    
    // 1. Get keyword parameter
    
    // 2. Decide which DAO method to call
    
    // 3. Get the student list
    
    // 4. Set request attributes
    
    // 5. Forward to view
}
```

**Don't forget to:**
- Add the case in your `doGet()` switch statement
- Handle potential SQLException from DAO

**Evaluation Criteria:**
| Criteria | Points |
|----------|--------|
| searchStudents() method properly structured | 1 |
| Handles null/empty keyword gracefully | 1 |
| Calls appropriate DAO method | 1 |
| Sets attributes and forwards correctly | 1 |

---

#### 5.3: Update Student List View (4 points)

**Task:** Add search form to `student-list.jsp`

**Requirements:**
1. Create a search form that submits to `student` servlet
2. Use GET method (not POST)
3. Include hidden field: `<input type="hidden" name="action" value="search">`
4. Text input field for keyword with meaningful placeholder
5. Submit button (can use emoji like 🔍)
6. Show "Clear" or "Show All" button ONLY when a search is active
7. Display search keyword in a message like "Search results for: [keyword]"
8. Preserve the keyword in the input field after search

**Think about:**
- Where should you place the search form? (Above the table? In header?)
- How do you check if a search is active? (Check if keyword attribute exists)
- How do you preserve the keyword value in the input field?

**JSTL patterns to use:**
```jsp
<!-- Check if keyword exists -->
<c:if test="${not empty keyword}">
    <!-- Show something -->
</c:if>

<!-- Preserve value in input -->
<input type="text" name="keyword" value="${keyword}">
```

**Form structure hint:**
```jsp
<div class="search-box">
    <form action="student" method="get">
        <!-- Hidden action field -->
        <!-- Text input for keyword -->
        <!-- Submit button -->
        <!-- Conditional clear button -->
    </form>
</div>

<!-- Conditional search results message -->
```

**Styling suggestion (optional):**
- Make the search form stand out with a border or background color
- Use flexbox to align form elements horizontally
- Add some spacing between elements

**Evaluation Criteria:**
| Criteria | Points |
|----------|--------|
| Search form submits correctly with proper action | 1 |
| Keyword value preserved in input field | 1 |
| Clear/Show All button appears only when searching | 1 |
| "Search results for:" message displays correctly | 1 |

---

### EXERCISE 6: SERVER-SIDE VALIDATION (10 points)

**Estimated Time:** 40 minutes

**Objective:** Add server-side validation to prevent invalid data entry.

---

#### 6.1: Create Validation Method (5 points)

**Task:** Add `validateStudent()` method to `StudentController.java`

**Requirements:**
- Method signature: `private boolean validateStudent(Student student, HttpServletRequest request)`
- Return `true` if all validations pass, `false` if any fail
- For each validation error, set an error message as request attribute
- Validate the following fields:

**Validation Rules:**

1. **Student Code:**
   - Cannot be null or empty
   - Must match pattern: 2 uppercase letters + 3 or more digits (e.g., "SV001", "IT123")
   - Error attribute names: `errorCode`

2. **Full Name:**
   - Cannot be null or empty
   - Minimum length: 2 characters
   - Error attribute name: `errorName`

3. **Email:**
   - If provided (not empty), must be valid email format
   - Use regex or simple validation (contains @ and .)
   - Error attribute name: `errorEmail`

4. **Major:**
   - Cannot be null or empty
   - Error attribute name: `errorMajor`

**Regex hints:**
```java
// Student code pattern: 2 letters + 3+ digits
String codePattern = "[A-Z]{2}[0-9]{3,}";
student.getStudentCode().matches(codePattern)

// Email pattern (simple version)
String emailPattern = "^[A-Za-z0-9+_.-]+@(.+)$";
student.getEmail().matches(emailPattern)
```

**Method structure:**
```java
private boolean validateStudent(Student student, HttpServletRequest request) {
    boolean isValid = true;
    
    // Validate student code
    if (/* code is null or empty */) {
        request.setAttribute("errorCode", "Student code is required");
        isValid = false;
    } else if (/* code doesn't match pattern */) {
        request.setAttribute("errorCode", "Invalid format. Use 2 letters + 3+ digits (e.g., SV001)");
        isValid = false;
    }
    
    // TODO: Validate full name
    
    // TODO: Validate email (only if provided)
    
    // TODO: Validate major
    
    return isValid;
}
```

**Evaluation Criteria:**
| Criteria | Points |
|----------|--------|
| Student code validation (null check + pattern) | 1.5 |
| Full name validation | 1 |
| Email validation (conditional) | 1.5 |
| Major validation | 0.5 |
| Returns boolean correctly | 0.5 |

---

#### 6.2: Integrate Validation into Insert/Update (3 points)

**Task:** Use validation in `insertStudent()` and `updateStudent()` methods

**Requirements:**
1. Call `validateStudent()` BEFORE calling DAO
2. If validation fails:
   - Set the student object as request attribute (to preserve entered data)
   - Forward back to the form (student-form.jsp)
   - Return immediately (don't proceed with insert/update)
3. If validation passes:
   - Proceed with DAO operation
   - Redirect with success message

**Insert method pattern:**
```java
private void insertStudent(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
    
    // 1. Get parameters and create Student object
    
    // 2. Validate
    if (!validateStudent(student, request)) {
        // Set student as attribute (to preserve entered data)
        request.setAttribute("student", student);
        // Forward back to form
        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/student-form.jsp");
        dispatcher.forward(request, response);
        return; // STOP here
    }
    
    // 3. If valid, proceed with insert
    if (studentDAO.addStudent(student)) {
        response.sendRedirect("student?action=list&message=Added successfully");
    } else {
        response.sendRedirect("student?action=list&error=Failed to add student");
    }
}
```

**Important:** Apply the same pattern to `updateStudent()` method!

**Evaluation Criteria:**
| Criteria | Points |
|----------|--------|
| Validation called in insertStudent() | 1 |
| Validation called in updateStudent() | 1 |
| Failed validation forwards back to form with data | 1 |

---

#### 6.3: Display Validation Errors in Form (2 points)

**Task:** Update `student-form.jsp` to show validation errors

**Requirements:**
- Display error messages near the relevant form fields
- Use red color for error messages
- Show error ONLY if it exists (use `<c:if>`)
- Error message should be clear and helpful

**Example for one field:**
```jsp
<div class="form-group">
    <label for="studentCode">Student Code:</label>
    <input type="text" id="studentCode" name="studentCode" 
           value="${student.studentCode}">
    <c:if test="${not empty errorCode}">
        <span class="error">${errorCode}</span>
    </c:if>
</div>
```

**CSS hint (add to your style section):**
```css
.error {
    color: red;
    font-size: 14px;
    display: block;
    margin-top: 5px;
}
```

**Apply this pattern for:**
- Student code field
- Full name field
- Email field
- Major field

**Evaluation Criteria:**
| Criteria | Points |
|----------|--------|
| All error messages display conditionally | 1 |
| Error styling applied (red text) | 0.5 |
| Errors positioned near relevant fields | 0.5 |

---

### EXERCISE 7: SORTING & FILTERING (10 points)

**Estimated Time:** 50 minutes

**Objective:** Add ability to sort by columns and filter by major.

---

#### 7.1: Add Sort & Filter Methods to DAO (4 points)

**Task:** Add two new methods to `StudentDAO.java`

**Method 1: Sort Students**
```java
public List<Student> getStudentsSorted(String sortBy, String order)
```

**Requirements:**
- Accept two parameters: `sortBy` (column name) and `order` ("asc" or "desc")
- Valid sortBy values: "id", "student_code", "full_name", "email", "major"
- Default to "id" and "asc" if parameters are invalid
- Build dynamic SQL: `"SELECT * FROM students ORDER BY " + sortBy + " " + order`

**Security note:** Since sortBy comes from user input, validate it against allowed values!

**Method 2: Filter Students by Major**
```java
public List<Student> getStudentsByMajor(String major)
```

**Requirements:**
- Use PreparedStatement with WHERE clause
- SQL: `"SELECT * FROM students WHERE major = ? ORDER BY id DESC"`

**Challenge (Optional, +2 bonus points):** 
Create ONE method that handles BOTH sorting AND filtering:
```java
public List<Student> getStudentsFiltered(String major, String sortBy, String order)
```

**Hints:**
```java
// Validate sortBy parameter
private String validateSortBy(String sortBy) {
    // List of allowed columns
    String[] validColumns = {"id", "student_code", "full_name", "email", "major"};
    
    // Check if sortBy is in validColumns
    // If not, return "id" as default
}

// Validate order parameter
private String validateOrder(String order) {
    if ("desc".equalsIgnoreCase(order)) {
        return "DESC";
    }
    return "ASC"; // default
}
```

**Evaluation Criteria:**
| Criteria | Points |
|----------|--------|
| getStudentsSorted() works with validation | 2.5 |
| getStudentsByMajor() works correctly | 1.5 |
| Combined method (bonus) | +2 |

---

#### 7.2: Add Controller Methods (3 points)

**Task:** Add sorting and filtering to `StudentController.java`

**Option 1: Separate methods**
```java
private void sortStudents(HttpServletRequest request, HttpServletResponse response)
```
- Get `sortBy` and `order` parameters
- Call DAO method
- Set results and parameters as attributes
- Forward to list view

```java
private void filterStudents(HttpServletRequest request, HttpServletResponse response)
```
- Get `major` parameter
- Call DAO method
- Set results and major as attributes
- Forward to list view

**Option 2: Modify listStudents()** to check for sort/filter parameters and call appropriate DAO methods

**Don't forget:** Add cases in `doGet()` switch for "sort" and "filter" actions

**Evaluation Criteria:**
| Criteria | Points |
|----------|--------|
| Sorting controller logic implemented | 1.5 |
| Filtering controller logic implemented | 1.5 |

---

#### 7.3: Update View with Sort & Filter UI (3 points)

**Task:** Add sorting and filtering controls to `student-list.jsp`

**Requirements:**

**A) Sortable Column Headers:**
Make column headers clickable to sort by that column:

```jsp
<thead>
    <tr>
        <th><a href="student?action=sort&sortBy=id&order=asc">ID</a></th>
        <th><a href="student?action=sort&sortBy=student_code&order=asc">Code</a></th>
        <th><a href="student?action=sort&sortBy=full_name&order=asc">Name</a></th>
        <!-- etc -->
    </tr>
</thead>
```

**B) Major Filter Dropdown:**
Add a filter form above the table:

```jsp
<div class="filter-box">
    <form action="student" method="get">
        <input type="hidden" name="action" value="filter">
        <label>Filter by Major:</label>
        <select name="major">
            <option value="">All Majors</option>
            <option value="Computer Science">Computer Science</option>
            <option value="Information Technology">Information Technology</option>
            <option value="Software Engineering">Software Engineering</option>
            <option value="Business Administration">Business Administration</option>
        </select>
        <button type="submit">Apply Filter</button>
        <c:if test="${not empty selectedMajor}">
            <a href="student?action=list">Clear Filter</a>
        </c:if>
    </form>
</div>
```

**Challenge:** 
- Show current sort column and order
- Reverse order when clicking same column again
- Preserve selected major in dropdown after filtering

**Hints:**
```jsp
<!-- Show selected option in dropdown -->
<option value="Computer Science" ${selectedMajor == 'Computer Science' ? 'selected' : ''}>
    Computer Science
</option>

<!-- Show sort indicator -->
<c:if test="${sortBy == 'full_name'}">
    ${order == 'asc' ? '▲' : '▼'}
</c:if>
```

**Evaluation Criteria:**
| Criteria | Points |
|----------|--------|
| Sortable column headers work | 1.5 |
| Filter dropdown works | 1 |
| UI shows current state (sort/filter) | 0.5 |

---

### EXERCISE 8: PAGINATION (8 points) - OPTIONAL

**Estimated Time:** 60 minutes

**Objective:** Implement pagination to handle large datasets.

**Note:** This exercise is OPTIONAL but recommended if you finish exercises 5-7.

---

#### 8.1: Add Pagination Methods to DAO (3 points)

**Task:** Add methods to support pagination in `StudentDAO.java`

**Method 1: Get Total Count**
```java
public int getTotalStudents()
```
- Execute: `SELECT COUNT(*) FROM students`
- Return the count as integer

**Method 2: Get Paginated Results**
```java
public List<Student> getStudentsPaginated(int offset, int limit)
```
- Use SQL: `SELECT * FROM students ORDER BY id DESC LIMIT ? OFFSET ?`
- `offset`: starting position (e.g., 0, 10, 20)
- `limit`: number of records (e.g., 10)

**How pagination works:**
- Page 1: offset=0, limit=10 (records 1-10)
- Page 2: offset=10, limit=10 (records 11-20)
- Page 3: offset=20, limit=10 (records 21-30)

**Formula:** `offset = (currentPage - 1) * recordsPerPage`

**Evaluation Criteria:**
| Criteria | Points |
|----------|--------|
| getTotalStudents() returns correct count | 1 |
| getStudentsPaginated() returns correct records | 2 |

---

#### 8.2: Add Pagination Controller Logic (3 points)

**Task:** Modify `listStudents()` or create new method for pagination

**Requirements:**
1. Get `page` parameter from request (default to 1 if not provided)
2. Define `recordsPerPage` (typically 10)
3. Calculate `offset` and `totalPages`
4. Call DAO pagination methods
5. Set multiple attributes: students, currentPage, totalPages
6. Forward to view

**Calculation logic:**
```java
// Get current page (default to 1)
String pageParam = request.getParameter("page");
int currentPage = (pageParam != null) ? Integer.parseInt(pageParam) : 1;

// Records per page
int recordsPerPage = 10;

// Calculate offset
int offset = (currentPage - 1) * recordsPerPage;

// Get data
List<Student> students = studentDAO.getStudentsPaginated(offset, recordsPerPage);
int totalRecords = studentDAO.getTotalStudents();

// Calculate total pages
int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);

// Set attributes
request.setAttribute("students", students);
request.setAttribute("currentPage", currentPage);
request.setAttribute("totalPages", totalPages);
```

**Edge cases to handle:**
- What if page < 1? (default to 1)
- What if page > totalPages? (default to last page)

**Evaluation Criteria:**
| Criteria | Points |
|----------|--------|
| Page parameter handled correctly | 1 |
| Offset calculation correct | 1 |
| All pagination attributes set | 1 |

---

#### 8.3: Add Pagination Controls to View (2 points)

**Task:** Add pagination UI to `student-list.jsp`

**Requirements:**
- Show "Previous" button (disabled on first page)
- Show page numbers (current page highlighted)
- Show "Next" button (disabled on last page)
- Display "Showing page X of Y" message

**Basic pagination UI:**
```jsp
<div class="pagination">
    <!-- Previous button -->
    <c:if test="${currentPage > 1}">
        <a href="student?action=list&page=${currentPage - 1}">« Previous</a>
    </c:if>
    
    <!-- Page numbers -->
    <c:forEach begin="1" end="${totalPages}" var="i">
        <c:choose>
            <c:when test="${i == currentPage}">
                <strong>${i}</strong>
            </c:when>
            <c:otherwise>
                <a href="student?action=list&page=${i}">${i}</a>
            </c:otherwise>
        </c:choose>
    </c:forEach>
    
    <!-- Next button -->
    <c:if test="${currentPage < totalPages}">
        <a href="student?action=list&page=${currentPage + 1}">Next »</a>
    </c:if>
</div>

<p>Showing page ${currentPage} of ${totalPages}</p>
```

**Advanced (Optional):**
- Limit page numbers shown (e.g., show only 5 pages around current)
- Add "First" and "Last" buttons
- Show record range: "Showing 11-20 of 50 records"

**CSS hint:**
```css
.pagination {
    margin: 20px 0;
    text-align: center;
}

.pagination a {
    padding: 8px 12px;
    margin: 0 4px;
    border: 1px solid #ddd;
    text-decoration: none;
}

.pagination strong {
    padding: 8px 12px;
    margin: 0 4px;
    background-color: #4CAF50;
    color: white;
    border: 1px solid #4CAF50;
}
```

**Evaluation Criteria:**
| Criteria | Points |
|----------|--------|
| Previous/Next buttons work correctly | 1 |
| Page numbers clickable with current highlighted | 0.5 |
| Page info displays correctly | 0.5 |

---

## BONUS EXERCISES (Optional - Extra Credit)

**Not required, earn up to 15 bonus points**

### BONUS 1: Export to Excel (5 points)

**Challenge:** Add "Export to Excel" button that downloads student list as Excel file.

**Requirements:**
- Use Apache POI library (add to project)
- Create new servlet: `ExportServlet` mapped to `/export`
- Generate Excel workbook with student data
- Set proper content type: `application/vnd.ms-excel`
- Set download filename: `Content-Disposition: attachment; filename=students.xlsx`

**Research needed:**
- How to add Apache POI dependency
- How to create Excel workbook programmatically
- How to write workbook to response stream

**Hints:**
- Look up `XSSFWorkbook` class
- Study how to create sheets, rows, and cells
- Don't forget to close workbook after writing

---

### BONUS 2: Photo Upload (5 points)

**Challenge:** Add photo upload capability for students.

**Requirements:**
- Add `photo` column to database (VARCHAR, store filename)
- Add `@MultipartConfig` annotation to servlet
- Handle file upload in controller using `request.getPart("photo")`
- Save uploaded files to `/uploads` directory in project
- Display photos in student list (thumbnail)
- Update form to include file input

**Research needed:**
- How to handle multipart form data
- How to save uploaded files to disk
- How to display images from uploads directory

**Security considerations:**
- Validate file type (only allow images)
- Limit file size
- Generate unique filenames to prevent conflicts

---

### BONUS 3: Combined Search + Filter + Sort (5 points)

**Challenge:** Combine search, filter, and sort in one interface that maintains all parameters.

**Requirements:**
- Single DAO method that accepts: keyword, major, sortBy, order
- Build dynamic SQL query based on which parameters are provided
- Maintain ALL parameters across page refreshes
- Update URL to include all active parameters

**Example URL:**
```
student?action=list&keyword=john&major=CS&sortBy=full_name&order=asc
```

**Hints:**
```java
// Build dynamic SQL
StringBuilder sql = new StringBuilder("SELECT * FROM students WHERE 1=1");

if (keyword != null && !keyword.isEmpty()) {
    sql.append(" AND (full_name LIKE ? OR student_code LIKE ?)");
}

if (major != null && !major.isEmpty()) {
    sql.append(" AND major = ?");
}

sql.append(" ORDER BY ").append(validateSortBy(sortBy))
   .append(" ").append(validateOrder(order));
```

**UI Challenge:**
- Show all active filters/search at top
- Allow clearing individual filters
- Maintain parameters in form hidden fields

---

## HOMEWORK SUBMISSION GUIDELINES

### What to Submit:

**1. Complete Project ZIP:**
```
StudentManagementMVC.zip
├── src/
│   ├── model/
│   │   └── Student.java
│   ├── dao/
│   │   └── StudentDAO.java
│   └── controller/
│       └── StudentController.java
├── WebContent/
│   └── views/
│       ├── student-list.jsp
│       └── student-form.jsp
└── README.txt
```

**2. README.txt:**
```
STUDENT INFORMATION:
Name: [Your Name]
Student ID: [Your ID]
Class: [Your Class]

COMPLETED EXERCISES:
[x] Exercise 5: Search
[x] Exercise 6: Validation
[x] Exercise 7: Sorting & Filtering
[ ] Exercise 8: Pagination
[ ] Bonus 1: Export Excel

MVC COMPONENTS:
- Model: Student.java
- DAO: StudentDAO.java
- Controller: StudentController.java
- Views: student-list.jsp, student-form.jsp

FEATURES IMPLEMENTED:
- All CRUD operations
- Search functionality
- Server-side validation
- Sorting by columns
- Filter by major

KNOWN ISSUES:
- [List any bugs]

EXTRA FEATURES:
- [List any bonus features]

TIME SPENT: [Approximate hours]
```

**3. Screenshots:**
- Home page with student list
- Add student form
- Edit student form (pre-filled)
- Search results
- Validation errors
- Sorted list
- Filtered list

---

## EVALUATION RUBRIC

### In-Class (60 points):
| Component | Points |
|-----------|--------|
| Model & DAO | 15 |
| Controller | 20 |
| View with JSTL | 15 |
| Complete CRUD | 10 |

### Homework (40 points):
| Exercise | Points |
|----------|--------|
| Search | 12 |
| Validation | 10 |
| Sorting & Filtering | 10 |
| Pagination | 8 |

### Bonus (15 points):
| Feature | Points |
|---------|--------|
| Export Excel | 5 |
| Photo Upload | 5 |
| Advanced Filter | 5 |

**Total Possible: 115 points (including bonus)**

---

## COMMON MISTAKES TO AVOID

### ❌ DON'T:

**1. Mix concerns:**
```jsp
<%-- DON'T do database operations in JSP --%>
<% 
    Connection conn = DriverManager.getConnection(...);
%>
```

**2. Use scriptlets in views:**
```jsp
<%-- DON'T use scriptlets --%>
<% for (Student s : students) { %>
```

**3. Hard-code SQL in controller:**
```java
// DON'T write SQL in controller
String sql = "SELECT * FROM students";
```

**4. Forget to close resources:**
```java
// DON'T forget finally or try-with-resources
Connection conn = getConnection();
// ... use it
// FORGOT TO CLOSE!
```

### ✅ DO:

**1. Separate concerns:**
- Model: Data representation
- DAO: Database operations
- Controller: Business logic
- View: Presentation only

**2. Use JSTL:**
```jsp
<c:forEach var="s" items="${students}">
    <td>${s.fullName}</td>
</c:forEach>
```

**3. Keep SQL in DAO:**
```java
// DAO method
public List<Student> getAllStudents() {
    String sql = "SELECT * FROM students";
    // ...
}
```

**4. Always close resources:**
```java
try (Connection conn = getConnection();
     PreparedStatement pstmt = conn.prepareStatement(sql)) {
    // Use resources
} // Auto-closed
```

---

## TROUBLESHOOTING

### Issue 1: Servlet Not Found (404)

**Solution:**
- Check `@WebServlet` URL mapping
- Verify servlet class in correct package
- Clean and rebuild project
- Restart Tomcat

---

### Issue 2: JSTL Tags Show as Text

**Solution:**
- Add JSTL library to WEB-INF/lib
- Include taglib directive:
```jsp
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
```

---

### Issue 3: EL Not Working

**Solution:**
- Check web.xml version (should be 2.5+)
- Ensure JSP 2.0+ specification
- Don't use scriptlets mixing with EL

---

### Issue 4: DAO Returns Empty List

**Solution:**
- Test DAO with main() method
- Check database has data
- Print SQL query to console
- Verify connection parameters

---

## RESOURCES

### MVC Pattern:
- **Oracle MVC Guide:** https://www.oracle.com/java/technologies/mvc-javaee.html
- **Servlet Tutorial:** https://docs.oracle.com/javaee/7/tutorial/servlets.htm

### JSTL:
- **JSTL Reference:** https://jakarta.ee/specifications/tags/
- **JSTL Examples:** https://www.javatpoint.com/jstl

### DAO Pattern:
- **DAO Tutorial:** https://www.baeldung.com/java-dao-pattern

---

## SUMMARY

### In-Class Checklist:
✅ Created MVC project structure  
✅ Implemented Student model  
✅ Created StudentDAO with CRUD  
✅ Built StudentController servlet  
✅ Created views with JSTL  
✅ Tested all operations

### Homework Checklist:
✅ Added search functionality  
✅ Implemented validation  
✅ Added sorting  
✅ Added filtering  
✅ Implemented pagination (optional)

### Key Takeaways:
1. **MVC separates concerns** - easier to maintain
2. **JSTL eliminates scriptlets** - cleaner views
3. **DAO centralizes data access** - reusable
4. **Servlets control flow** - coordinated logic

### Next Lab Preview:

**Lab 7: Authentication & Session Management**
- Building on MVC foundation
- User login/logout
- Session handling
- Role-based access control
- Authorization filters

---

**Good luck with Lab 6! 🚀**

*Remember: The goal is to understand MVC, not just complete tasks!*