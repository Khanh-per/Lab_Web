<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.StringJoiner" %>
<%
    String[] studentIds = request.getParameterValues("student_id");

    if (studentIds == null || studentIds.length == 0) {
        response.sendRedirect("list_students.jsp?error=No students selected for deletion");
        return;
    }

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/student_management",
            "root",
            "Khanh2005@"
        );


        StringJoiner questionMarks = new StringJoiner(", ");
        for (int i = 0; i < studentIds.length; i++) {
            questionMarks.add("?");
        }

        String sql = "DELETE FROM students WHERE id IN (" + questionMarks.toString() + ")";

        pstmt = conn.prepareStatement(sql);

        for (int i = 0; i < studentIds.length; i++) {
            pstmt.setInt(i + 1, Integer.parseInt(studentIds[i]));
        }

        // 4. Thực thi
        int rowsAffected = pstmt.executeUpdate();

        if (rowsAffected > 0) {
            response.sendRedirect("list_students.jsp?message=" + rowsAffected + " student(s) deleted successfully");
        } else {
            response.sendRedirect("list_students.jsp?error=Delete operation failed");
        }

    } catch (Exception e) {
        response.sendRedirect("list_students.jsp?error=Error occurred during deletion: " + e.getMessage());
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