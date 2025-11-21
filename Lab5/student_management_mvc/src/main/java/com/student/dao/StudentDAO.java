package com.student.dao;

import com.student.model.Student;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class StudentDAO {

    // Database configuration
    private static final String DB_URL = "jdbc:mysql://localhost:3306/student_management";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "Khanh2005@"; // Check your password

    // Get database connection
    private Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
        } catch (ClassNotFoundException e) {
            throw new SQLException("MySQL Driver not found", e);
        }
    }

    // --- 1. BASIC CRUD OPERATIONS ---

    // Get all students
    public List<Student> getAllStudents() {
        return searchAndFilterStudents(null, null, "id", "DESC");
    }

    // Get student by ID
    public Student getStudentById(int id) {
        String sql = "SELECT * FROM students WHERE id = ?";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToStudent(rs);
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

    // --- 2. HELPER METHODS ---

    // Helper to map ResultSet to Student object
    private Student mapResultSetToStudent(ResultSet rs) throws SQLException {
        Student student = new Student();
        student.setId(rs.getInt("id"));
        student.setStudentCode(rs.getString("student_code"));
        student.setFullName(rs.getString("full_name"));
        student.setEmail(rs.getString("email"));
        student.setMajor(rs.getString("major"));
        student.setCreatedAt(rs.getTimestamp("created_at"));
        return student;
    }

    // Validate Sort Column
    private String validateSortColumn(String sortBy) {
        if (sortBy == null) return "id";
        switch (sortBy) {
            case "student_code": return "student_code";
            case "full_name":    return "full_name";
            case "email":        return "email";
            case "major":        return "major";
            default:             return "id";
        }
    }

    // Validate Sort Order
    private String validateOrder(String order) {
        return "desc".equalsIgnoreCase(order) ? "DESC" : "ASC";
    }

    // --- 3. MASTER SEARCH METHOD ---

    public List<Student> searchAndFilterStudents(String keyword, String major, String sortBy, String order) {
        List<Student> students = new ArrayList<>();

        StringBuilder sql = new StringBuilder("SELECT * FROM students WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        // 1. Handle Search Keyword
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (student_code LIKE ? OR full_name LIKE ? OR email LIKE ?) ");
            String searchPattern = "%" + keyword.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
        }

        // 2. Handle Major Filter
        if (major != null && !major.trim().isEmpty()) {
            sql.append("AND major = ? ");
            params.add(major);
        }

        // 3. Handle Sorting
        String safeCol = validateSortColumn(sortBy);
        String safeOrd = validateOrder(order);
        sql.append("ORDER BY ").append(safeCol).append(" ").append(safeOrd);

        // 4. Execute
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                pstmt.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    students.add(mapResultSetToStudent(rs));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return students;
    }

    // --- 4. EXERCISE SPECIFIC WRAPPER METHODS ---
    // These methods exist to match the exact function names in your assignment text.

    // Requirement 5.1: Search Students
    public List<Student> searchStudents(String keyword) {
        return searchAndFilterStudents(keyword, null, "id", "DESC");
    }

    // Requirement 7.1 Method 1: Sort Students
    public List<Student> getStudentsSorted(String sortBy, String order) {
        return searchAndFilterStudents(null, null, sortBy, order);
    }

    // Requirement 7.1 Method 2: Filter Students by Major
    public List<Student> getStudentsByMajor(String major) {
        return searchAndFilterStudents(null, major, "id", "DESC");
    }

    // Requirement 7.1 Challenge: Filter AND Sort (Combined)
    public List<Student> getStudentsFiltered(String major, String sortBy, String order) {
        return searchAndFilterStudents(null, major, sortBy, order);
    }
}