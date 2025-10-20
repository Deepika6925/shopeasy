<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Register | ShopEasy</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #28a745, #20c997);
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        .register-card {
            background: white;
            padding: 40px;
            border-radius: 15px;
            width: 450px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.2);
        }
        .btn-success {
            width: 100%;
            border-radius: 10px;
        }
    </style>
</head>
<body>

<div class="register-card">
    <h3 class="text-center text-success mb-3">Create an Account</h3>

    <form method="post">
        <div class="mb-3">
            <label class="form-label">First Name</label>
            <input type="text" name="first" class="form-control" required>
        </div>
        <div class="mb-3">
            <label class="form-label">Last Name</label>
            <input type="text" name="last" class="form-control" required>
        </div>
        <div class="mb-3">
            <label class="form-label">Email</label>
            <input type="email" name="email" class="form-control" required>
        </div>
        <div class="mb-3">
            <label class="form-label">Password</label>
            <input type="password" name="password" class="form-control" required>
        </div>
        <div class="mb-3">
            <label class="form-label">Role</label>
            <select class="form-select" name="role" required>
                <option value="customer" selected>Customer</option>
                <option value="admin">Admin</option>
            </select>
        </div>
        <button type="submit" class="btn btn-success">Register</button>
    </form>

    <div class="text-center mt-3">
        Already have an account? <a href="login.jsp" class="text-success">Login</a>
    </div>

<%
    // ✅ Process registration
    String first = request.getParameter("first");
    String last = request.getParameter("last");
    String email = request.getParameter("email");
    String password = request.getParameter("password");
    String role = request.getParameter("role");

    if (email != null && password != null) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/shopeasy", "root", "");

            // Check if email already exists
            PreparedStatement check = conn.prepareStatement("SELECT * FROM users WHERE email = ?");
            check.setString(1, email);
            ResultSet rs = check.executeQuery();

            if (rs.next()) {
%>
                <div class="alert alert-warning text-center mt-3">Email already registered. Please login instead.</div>
<%
            } else {
                PreparedStatement ps = conn.prepareStatement("INSERT INTO users (first, last, email, password_hash, role) VALUES (?, ?, ?, ?, ?)");
                ps.setString(1, first);
                ps.setString(2, last);
                ps.setString(3, email);
                ps.setString(4, password);
                ps.setString(5, role);
                int rows = ps.executeUpdate();

                if (rows > 0) {
%>
                    <script>
                        alert("Registration successful! You can now log in.");
                        window.location = "login.jsp";
                    </script>
<%
                }
                ps.close();
            }
            conn.close();
        } catch (Exception e) {
            out.println("<div class='alert alert-danger text-center mt-3'>Error: " + e.getMessage() + "</div>");
        }
    }
%>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
