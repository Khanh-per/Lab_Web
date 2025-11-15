<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    String keyword = request.getParameter("keyword");

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/student_management",
            "root",
            "Khanh2005@"
        );

        String sql;
        List<String> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql = "SELECT * FROM students WHERE full_name LIKE ? OR student_code LIKE ? OR major LIKE ? ORDER BY id DESC";
            String searchKeyword = "%" + keyword + "%";
            params.add(searchKeyword);
            params.add(searchKeyword);
            params.add(searchKeyword);
        } else {
            sql = "SELECT * FROM students ORDER BY id DESC";
        }

        pstmt = conn.prepareStatement(sql);
        for (int i = 0; i < params.size(); i++) {
            pstmt.setString(i + 1, params.get(i));
        }

        rs = pstmt.executeQuery();


        response.setContentType("text/csv");
        response.setHeader("Content-Disposition", "attachment; filename=\"students.csv\"");

        out.println("ID,Student Code,Full Name,Email,Major,Created At");

        while (rs.next()) {
            out.print("\"" + rs.getInt("id") + "\",");
            out.print("\"" + rs.getString("student_code") + "\",");
            out.print("\"" + rs.getString("full_name") + "\",");
            out.print("\"" + (rs.getString("email") != null ? rs.getString("email") : "") + "\",");
            out.print("\"" + (rs.getString("major") != null ? rs.getString("major") : "") + "\",");
            out.print("\"" + rs.getTimestamp("created_at") + "\"");
            out.println();
        }

    } catch (Exception e) {
        out.println("Error generating CSV: " + e.getMessage());
        e.printStackTrace(response.getWriter());
    } finally {
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace(response.getWriter());
        }
    }
%>