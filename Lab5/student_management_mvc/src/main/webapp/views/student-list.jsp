<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Management System</title>
    <style>
        /* --- GLOBAL STYLES --- */
        * { margin: 0; padding: 0; box-sizing: border-box; }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
        }

        /* --- HEADERS --- */
        h1 { color: #333; margin-bottom: 5px; font-size: 28px; }
        .subtitle { color: #666; margin-bottom: 25px; font-style: italic; font-size: 14px; }

        /* --- ALERTS --- */
        .message { padding: 15px; margin-bottom: 20px; border-radius: 5px; font-weight: 500; }
        .success { background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .error { background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }

        /* --- CONTROL PANEL (Search + Filter) --- */
        .controls {
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            border: 1px solid #e9ecef;
            margin-bottom: 20px;
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            align-items: center;
            justify-content: space-between;
        }

        .search-form {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            align-items: center;
            width: 100%;
        }

        .form-input {
            padding: 10px;
            border: 1px solid #ced4da;
            border-radius: 4px;
            font-size: 14px;
        }

        .search-input { flex-grow: 1; min-width: 200px; }
        .filter-select { min-width: 180px; }

        /* --- BUTTONS --- */
        .btn {
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 4px;
            font-weight: 500;
            font-size: 14px;
            border: none;
            cursor: pointer;
            transition: all 0.2s;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }

        .btn-primary { background: #007bff; color: white; }
        .btn-primary:hover { background: #0056b3; }

        .btn-add { 
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); 
            color: white; 
        }
        .btn-add:hover { transform: translateY(-2px); box-shadow: 0 4px 10px rgba(102, 126, 234, 0.4); }

        .btn-secondary { background: #6c757d; color: white; }
        .btn-secondary:hover { background: #545b62; }

        .btn-danger { background: #dc3545; color: white; padding: 6px 12px; font-size: 13px; }
        .btn-danger:hover { background: #c82333; }
        
        .btn-edit { background: #ffc107; color: #212529; padding: 6px 12px; font-size: 13px; }
        .btn-edit:hover { background: #e0a800; }

        .btn-outline { 
            background: transparent; 
            border: 1px solid #6c757d; 
            color: #6c757d; 
            padding: 9px 15px;
        }
        .btn-outline:hover { background: #e2e6ea; }

        /* --- TABLE --- */
        table { width: 100%; border-collapse: collapse; margin-top: 10px; box-shadow: 0 2px 8px rgba(0,0,0,0.05); }
        
        thead { 
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); 
            color: white; 
        }

        th, td { padding: 15px; text-align: left; border-bottom: 1px solid #dee2e6; }
        
        /* Sortable Header Links */
        th a {
            color: white;
            text-decoration: none;
            display: flex;
            align-items: center;
            justify-content: space-between;
            width: 100%;
            font-weight: 600;
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        th a:hover { background-color: rgba(255,255,255,0.1); border-radius: 4px; padding: 0 5px; margin: 0 -5px;}

        tbody tr:hover { background-color: #f8f9fa; }

        /* --- EMPTY STATE --- */
        .empty-state { text-align: center; padding: 60px 20px; color: #adb5bd; }
        .empty-icon { font-size: 48px; margin-bottom: 15px; display: block; }
    </style>
</head>
<body>

<div class="container">
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
        <div>
            <h1>🎓 Student Management</h1>
            <p class="subtitle">MVC Pattern • Search • Filter • Sort</p>
        </div>
        <a href="student?action=new" class="btn btn-add">➕ Add New Student</a>
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
                        <th width="15%">Actions</th>
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
                            <td>
                                <a href="student?action=edit&id=${student.id}" class="btn btn-edit">✏️ Edit</a>
                                <a href="student?action=delete&id=${student.id}" class="btn btn-danger"
                                   onclick="return confirm('Delete student ${student.studentCode}?')">🗑️</a>
                            </td>
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
                <a href="student?action=list" class="btn btn-secondary">Reset All Filters</a>
            </div>
        </c:otherwise>
    </c:choose>
</div>

</body>
</html>