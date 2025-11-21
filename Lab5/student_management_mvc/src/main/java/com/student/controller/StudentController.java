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

    private static final long serialVersionUID = 1L;
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

            // ---------------------------------------------------------------
            // Task 7.2: Handle "sort" and "filter" actions
            // We route them (along with search & list) to the unified method
            // ---------------------------------------------------------------
            case "sort":
            case "filter":
            case "search":
            case "list":
            default:
                listStudents(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "insert":
                insertStudent(request, response);
                break;
            case "update":
                updateStudent(request, response);
                break;
            default:
                listStudents(request, response);
                break;
        }
    }

    // --- UNIFIED LIST METHOD (Handles List, Search, Filter, Sort) ---
    // Implements Option 2: Modify listStudents to check for parameters
    private void listStudents(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Get all parameters from the request
        String keyword = request.getParameter("keyword");
        String major = request.getParameter("major");
        String sortBy = request.getParameter("sortBy");
        String order = request.getParameter("order");

        // 2. Call the Master DAO method
        // This method supports dynamic SQL for any combination of inputs
        List<Student> students = studentDAO.searchAndFilterStudents(keyword, major, sortBy, order);

        // 3. Set attributes to preserve the "View State" in the JSP
        request.setAttribute("students", students);
        request.setAttribute("keyword", keyword);       // Keep search box filled
        request.setAttribute("selectedMajor", major);   // Keep dropdown selected
        request.setAttribute("sortBy", sortBy);         // Keep active sort column
        request.setAttribute("order", order);           // Keep sort direction

        // 4. Forward to view
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
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Student existingStudent = studentDAO.getStudentById(id);
            request.setAttribute("student", existingStudent);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/views/student-form.jsp");
            dispatcher.forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect("student?action=list&error=Invalid Student ID");
        }
    }

    // Insert new student
    private void insertStudent(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String studentCode = request.getParameter("studentCode");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String major = request.getParameter("major");

        Student newStudent = new Student(studentCode, fullName, email, major);

        // Validation
        if (!validateStudent(newStudent, request)) {
            request.setAttribute("student", newStudent); // Preserve data
            RequestDispatcher dispatcher = request.getRequestDispatcher("/views/student-form.jsp");
            dispatcher.forward(request, response);
            return;
        }

        if (studentDAO.addStudent(newStudent)) {
            response.sendRedirect("student?action=list&message=Student added successfully");
        } else {
            response.sendRedirect("student?action=list&error=Failed to add student");
        }
    }

    // Update student
    private void updateStudent(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Safety Check for ID
        String idStr = request.getParameter("id");
        int id = 0;
        try {
            id = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            response.sendRedirect("student?action=list&error=Invalid Student ID");
            return;
        }

        String studentCode = request.getParameter("studentCode");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String major = request.getParameter("major");

        Student student = new Student(studentCode, fullName, email, major);
        student.setId(id);

        // Validation
        if (!validateStudent(student, request)) {
            request.setAttribute("student", student); // Preserve data
            RequestDispatcher dispatcher = request.getRequestDispatcher("/views/student-form.jsp");
            dispatcher.forward(request, response);
            return;
        }

        if (studentDAO.updateStudent(student)) {
            response.sendRedirect("student?action=list&message=Student updated successfully");
        } else {
            response.sendRedirect("student?action=list&error=Failed to update student");
        }
    }

    // Delete student
    private void deleteStudent(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            if (studentDAO.deleteStudent(id)) {
                response.sendRedirect("student?action=list&message=Student deleted successfully");
            } else {
                response.sendRedirect("student?action=list&error=Failed to delete student");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("student?action=list&error=Invalid Student ID");
        }
    }

    // Validation method
    private boolean validateStudent(Student student, HttpServletRequest request) {
        boolean isValid = true;

        // 1. Code: 2 Uppercase + 3 Digits
        String code = student.getStudentCode();
        String codePattern = "[A-Z]{2}[0-9]{3,}";
        if(code == null || code.trim().isEmpty()) {
            request.setAttribute("errorCode", "Student Code is required");
            isValid = false;
        } else if(!code.matches(codePattern)) {
            request.setAttribute("errorCode", "Invalid format. Use 2 UPPERCASE letters + 3+ digits (e.g., SV001)");
            isValid = false;
        }

        // 2. Name: Min 2 chars
        String name = student.getFullName();
        if (name == null || name.trim().isEmpty()) {
            request.setAttribute("errorName", "Full name is required");
            isValid = false;
        } else if(name.trim().length() < 2) {
            request.setAttribute("errorName", "Name must be at least 2 characters");
            isValid = false;
        }

        // 3. Email: Optional but must be valid
        String email = student.getEmail();
        String emailPattern = "^[A-Za-z0-9+_.-]+@(.+)$";
        if(email != null && !email.trim().isEmpty()) {
            if (!email.matches(emailPattern)) {
                request.setAttribute("errorEmail", "Invalid email format");
                isValid = false;
            }
        }

        // 4. Major: Required
        String major = student.getMajor();
        if(major == null || major.trim().isEmpty()) {
            request.setAttribute("errorMajor", "Major is required");
            isValid = false;
        }

        return isValid;
    }
}