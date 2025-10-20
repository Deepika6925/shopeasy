<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Add Product - Admin</title>
    <style>
        body {
            font-family: "Poppins", sans-serif;
            background-color: #f3f4f6;
            display: flex;
            align-items: center;
            justify-content: center;
            height: 100vh;
            margin: 0;
        }
        .container {
            background: white;
            padding: 30px 40px;
            border-radius: 12px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.15);
            width: 400px;
        }
        h2 {
            text-align: center;
            color: #1e293b;
        }
        form {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }
        input, textarea {
            padding: 10px;
            border: 1px solid #cbd5e1;
            border-radius: 6px;
            font-size: 15px;
        }
        button {
            background: #2563eb;
            color: white;
            border: none;
            padding: 10px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 16px;
        }
        button:hover {
            background: #1d4ed8;
        }
        .back {
            text-align: center;
            margin-top: 10px;
        }
        .back a {
            color: #2563eb;
            text-decoration: none;
        }
        .back a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

<%
    // Check if form is submitted
    String method = request.getMethod();
    if ("POST".equalsIgnoreCase(method)) {
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String priceStr = request.getParameter("price");
        String image = request.getParameter("image");

        if (name != null && priceStr != null && !name.trim().isEmpty()) {
            double price = Double.parseDouble(priceStr);

            String jdbcURL = "jdbc:mysql://localhost:3306/shopeasy";
            String dbUser = "root";
            String dbPassword = ""; // Update if needed

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

                String sql = "INSERT INTO products (name, description, price, image) VALUES (?, ?, ?, ?)";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setString(1, name);
                ps.setString(2, description);
                ps.setDouble(3, price);
                ps.setString(4, image);

                ps.executeUpdate();
                conn.close();

                // Redirect to dashboard
                response.sendRedirect("admin-dashboard.jsp");
                return;
            } catch (Exception e) {
                out.println("<p style='color:red;text-align:center;'>Error: " + e.getMessage() + "</p>");
            }
        }
    }
%>

<div class="container">
    <h2>Add Product</h2>
    <form method="post">
        <input type="text" name="name" placeholder="Product Name" required>
        <textarea name="description" placeholder="Description" rows="3"></textarea>
        <input type="number" name="price" placeholder="Price" step="0.01" required>
        <input type="text" name="image" placeholder="Image filename (e.g. product1.jpg)">
        <button type="submit">Add Product</button>
    </form>
    <div class="back">
        <a href="admin-dashboard.jsp">← Back to Dashboard</a>
    </div>
</div>

</body>
</html>
