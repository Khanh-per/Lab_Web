<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="java.net.URLEncoder" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student List</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }

        h1 {
            color: #333;
            text-align: center;
        }

        .message {
            padding: 12px 15px;
            margin-bottom: 20px;
            border-radius: 5px;
            font-weight: bold;
            display: block;
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
        .success::before {
            content: "✓ ";
            font-weight: bold;
            margin-right: 5px;
        }
        .error::before {
            content: "× ";
            font-weight: bold;
            margin-right: 5px;
        }

        .btn {
            display: inline-block;
            padding: 10px 20px;
            margin-bottom: 20px;
            background-color: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 5px;
        }
        .btn-export {
            background-color: #17a2b8;
            margin-left: 10px;
        }
        .btn-delete-bulk {
            background-color: #dc3545;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
            margin-top: 10px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }
        th {
            background-color: #007bff;
            color: white;
            padding: 12px;
            text-align: left;
        }
        /* Sắp xếp (Sort) (Bonus 2) */
        th.sortable a {
            color: white;
            text-decoration: none;
        }
        th.sortable a:hover {
            text-decoration: underline;
        }
        th.sortable a.asc::after { content: " ▲"; }
        th.sortable a.desc::after { content: " ▼"; }

        td {
            padding: 10px;
            border-bottom: 1px solid #ddd;
        }
        tr:hover { background-color: #f8f9fa; }
        .action-link {
            color: #007bff;
            text-decoration: none;
            margin-right: 10px;
        }
        .delete-link {
            color: #dc3545;
        }

        form[name="searchForm"] {
            margin-bottom: 20px;
        }
        form[name="searchForm"] input[type="text"] {
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        form[name="searchForm"] button {
            padding: 8px 15px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        form[name="searchForm"] button:disabled {
            background-color: #aaa;
            cursor: not-allowed;
        }
        form[name="searchForm"] a {
            margin-left: 10px;
            color: #dc3545;
            text-decoration: none;
        }

        .pagination {
            margin-top: 20px;
            text-align: center;
        }
        .pagination a, .pagination strong {
            display: inline-block;
            padding: 8px 12px;
            margin-right: 5px;
            border: 1px solid #ddd;
            text-decoration: none;
            color: #007bff;
            background-color: white;
        }
        .pagination strong {
            background-color: #007bff;
            color: white;
            border-color: #007bff;
        }
        .pagination a:hover {
            background-color: #f4f4f4;
        }

        .table-responsive {
            overflow-x: auto;
        }

        @media (max-width: 768px) {
            table {
                font-size: 12px;
            }
            th, td {
                padding: 5px;
            }
        }


    </style>
</head>
<body>
    <div class="container">

        <h1>📚 Student Management System</h1>

        <%
            String keyword = request.getParameter("keyword");

            String pageParam = request.getParameter("page");
            int currentPage = (pageParam == null) ? 1 : Integer.parseInt(pageParam);
            int recordsPerPage = 10;
            int offset = (currentPage - 1) * recordsPerPage;

            String sortBy = request.getParameter("sort");
            String order = request.getParameter("order");


            if (sortBy == null || sortBy.trim().isEmpty()) {
                sortBy = "id";
            }
            if (order == null || order.trim().isEmpty()) {
                order = "DESC";
            }

            String safeSortBy = "id";
            if (sortBy.equals("full_name")) safeSortBy = "full_name";
            if (sortBy.equals("created_at")) safeSortBy = "created_at";
            if (sortBy.equals("student_code")) safeSortBy = "student_code";
            if (sortBy.equals("email")) safeSortBy = "email";
            if (sortBy.equals("major")) safeSortBy = "major";

            String safeOrder = "DESC";
            if (order.equalsIgnoreCase("asc")) safeOrder = "ASC";

            String orderClause = " ORDER BY " + safeSortBy + " " + safeOrder + " ";
            String nextOrder = order.equalsIgnoreCase("asc") ? "desc" : "asc";

            int totalRecords = 0;
            int totalPages = 0;

            String paginationQuery = "";
            if (keyword != null && !keyword.trim().isEmpty()) {
                paginationQuery += "&keyword=" + URLEncoder.encode(keyword, "UTF-8");
            }
            paginationQuery += "&sort=" + URLEncoder.encode(safeSortBy, "UTF-8");
            paginationQuery += "&order=" + URLEncoder.encode(safeOrder, "UTF-8");

            String baseSortQuery = "list_students.jsp?page=1";
            if (keyword != null && !keyword.trim().isEmpty()) {
                baseSortQuery += "&keyword=" + URLEncoder.encode(keyword, "UTF-8");
            }


            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
        %>

        <form name="searchForm" action="list_students.jsp" method="GET" onsubmit="return submitForm(this)">
            <input type="text" name="keyword" placeholder="Search by name, code, or major..."
                   value="<%= (keyword != null ? keyword : "") %>">
            <button type="submit">Search</button>
            <a href="list_students.jsp">Clear</a>
        </form>

        <% if (request.getParameter("message") != null) { %>
            <div class="message success">
                <%= request.getParameter("message") %>
            </div>
        <% } %>

        <% if (request.getParameter("error") != null) { %>
            <div class="message error">
                <%= request.getParameter("error") %>
            </div>
        <% } %>

        <a href="add_student.jsp" class="btn">➕ Add New Student</a>

        <a href="export_csv.jsp?keyword=<%= (keyword != null ? URLEncoder.encode(keyword, "UTF-8") : "") %>&sort=<%= safeSortBy %>&order=<%= safeOrder %>"
           class="btn btn-export">Export to CSV</a>

        <form name="bulkDeleteForm" action="bulk_delete.jsp" method="POST" onsubmit="return confirmBulkDelete()">
            <div class="table-responsive">
                <table>
                        <thead>
                            <tr>
                                <!-- Checkbox "Select All" -->
                                <th><input type="checkbox" id="selectAll" onclick="toggleAll(this)"></th>

                                <!-- Tiêu đề cột Sắp xếp (Bonus 2) -->
                                <th class="sortable">
                                    <a href="<%= baseSortQuery %>&sort=id&order=<%= (safeSortBy.equals("id") ? nextOrder : "asc") %>"
                                       class="<%= (safeSortBy.equals("id") ? safeOrder.toLowerCase() : "") %>">ID</a>
                                </th>
                                <th class="sortable">
                                    <a href="<%= baseSortQuery %>&sort=student_code&order=<%= (safeSortBy.equals("student_code") ? nextOrder : "asc") %>"
                                       class="<%= (safeSortBy.equals("student_code") ? safeOrder.toLowerCase() : "") %>">Student Code</a>
                                </th>
                                <th class="sortable">
                                    <a href="<%= baseSortQuery %>&sort=full_name&order=<%= (safeSortBy.equals("full_name") ? nextOrder : "asc") %>"
                                       class="<%= (safeSortBy.equals("full_name") ? safeOrder.toLowerCase() : "") %>">Full Name</a>
                                </th>
                                <th class="sortable">
                                    <a href="<%= baseSortQuery %>&sort=email&order=<%= (safeSortBy.equals("email") ? nextOrder : "asc") %>"
                                       class="<%= (safeSortBy.equals("email") ? safeOrder.toLowerCase() : "") %>">Email</a>
                                </th>
                                <th class="sortable">
                                    <a href="<%= baseSortQuery %>&sort=major&order=<%= (safeSortBy.equals("major") ? nextOrder : "asc") %>"
                                       class="<%= (safeSortBy.equals("major") ? safeOrder.toLowerCase() : "") %>">Major</a>
                                </th>
                                <th class="sortable">
                                    <a href="<%= baseSortQuery %>&sort=created_at&order=<%= (safeSortBy.equals("created_at") ? nextOrder : "asc") %>"
                                       class="<%= (safeSortBy.equals("created_at") ? safeOrder.toLowerCase() : "") %>">Created At</a>
                                </th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
            <%
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection(
                        "jdbc:mysql://localhost:3306/student_management",
                        "root",
                        "Khanh2005@" // <-- Mật khẩu của bạn
                    );

                    String countSql;
                    PreparedStatement countPstmt;
                    List<String> params = new ArrayList<>();

                    String whereClause = "";
                    if (keyword != null && !keyword.trim().isEmpty()) {
                        whereClause = " WHERE full_name LIKE ? OR student_code LIKE ? OR major LIKE ? ";
                        String searchKeyword = "%" + keyword + "%";
                        params.add(searchKeyword);
                        params.add(searchKeyword);
                        params.add(searchKeyword);
                    }

                    countSql = "SELECT COUNT(*) FROM students" + whereClause;

                    countPstmt = conn.prepareStatement(countSql);
                    for (int i = 0; i < params.size(); i++) {
                        countPstmt.setString(i + 1, params.get(i));
                    }

                    ResultSet countRs = countPstmt.executeQuery();
                    if (countRs.next()) {
                        totalRecords = countRs.getInt(1);
                    }
                    totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);
                    countRs.close();
                    countPstmt.close();

                    String sql = "SELECT * FROM students" + whereClause + orderClause + " LIMIT ? OFFSET ?";

                    pstmt = conn.prepareStatement(sql);

                    int paramIndex = 1;
                    for (String param : params) {
                        pstmt.setString(paramIndex++, param);
                    }

                    pstmt.setInt(paramIndex++, recordsPerPage);
                    pstmt.setInt(paramIndex++, offset);

                    rs = pstmt.executeQuery();

                    boolean hasResults = false;

                    while (rs.next()) {
                        hasResults = true;
                        int id = rs.getInt("id");
                        String studentCode = rs.getString("student_code");
                        String fullName = rs.getString("full_name");
                        String email = rs.getString("email");
                        String major = rs.getString("major");
                        Timestamp createdAt = rs.getTimestamp("created_at");
            %>
                        <tr>
                            <td><input type="checkbox" name="student_id" value="<%= id %>" class="student-checkbox"></td>
                            <td><%= id %></td>
                            <td><%= studentCode %></td>
                            <td><%= fullName %></td>
                            <td><%= email != null ? email : "N/A" %></td>
                            <td><%= major != null ? major : "N/A" %></td>
                            <td><%= createdAt %></td>
                            <td>
                                <a href="edit_student.jsp?id=<%= id %>" class="action-link">✏️ Edit</a>
                                <a href="delete_student.jsp?id=<%= id %>"
                                   class="action-link delete-link"
                                   onclick="return confirm('Are you sure?')">🗑️ Delete</a>
                            </td>
                        </tr>
            <%
                    }

                    if (!hasResults) {
                        out.println("<tr><td colspan='9' style='text-align:center;'>No students found.</td></tr>");
                    }

                } catch (ClassNotFoundException e) {
                    out.println("<tr><td colspan='9'>Error: JDBC Driver not found!</td></tr>");
                    e.printStackTrace();
                } catch (SQLException e) {
                    out.println("<tr><td colspan='9'>Database Error: " + e.getMessage() + "</td></tr>");
                    e.printStackTrace();
                } finally {
                    try {
                        if (rs != null) rs.close();
                        if (pstmt != null) pstmt.close();
                        if (conn != null) conn.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
            %>
                    </tbody>
                </table>
            </div>

            <button type="submit" class="btn-delete-bulk">Delete Selected</button>

            </form>

            <div class="pagination">
                <% if (currentPage > 1) { %>
                    <a href="list_students.jsp?page=<%= currentPage - 1 %>">Previous</a>
                <% } %>

                <% for (int i = 1; i <= totalPages; i++) { %>
                    <% if (i == currentPage) { %>
                        <strong><%= i %></strong>
                    <% } else { %>
                        <a href="list_students.jsp?page=<%= i %>"><%= i %></a>
                    <% } %>
                <% } %>

                <% if (currentPage < totalPages) { %>
                    <a href="list_students.jsp?page=<%= currentPage + 1 %>">Next</a>
                <% } %>
            </div>


    </div>

    <script>
        window.setTimeout(function() {
            var messages = document.querySelectorAll('.message');
            messages.forEach(function(msg) {
                msg.style.display = 'none';
            });
        }, 3000);

        function submitForm(form) {
            var btn = form.querySelector('button[type="submit"]');
            btn.disabled = true;
            btn.textContent = 'Processing...';
            return true;
        }

        function toggleAll(source) {
            var checkboxes = document.querySelectorAll('.student-checkbox');
            for (var i = 0; i < checkboxes.length; i++) {
                checkboxes[i].checked = source.checked;
            }
        }

        function confirmBulkDelete() {
            var selectedCount = document.querySelectorAll('.student-checkbox:checked').length;
            if (selectedCount === 0) {
                alert('Please select at least one student to delete.');
                return false; // Ngăn form submit
            }
            return confirm('Are you sure you want to delete ' + selectedCount + ' selected student(s)?');
        }
    </script>
</body>
</html>