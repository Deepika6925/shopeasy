<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Product - Admin</title>
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
            width: 420px;
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
        .image-preview {
            text-align: center;
        }
        .image-preview img {
            width: 150px;
            height: 150px;
            border-radius: 10px;
            object-fit: cover;
            border: 1px solid #ccc;
        }
    </style>
</head>
<body>

<%
    String jdbcURL = "jdbc:mysql://localhost:3306/shopeasy";
    String dbUser = "root";
    String dbPassword = ""; // update if needed

    String method = request.getMethod();
    int id = 0;
    String name = "", description = "", image_url = "";
    double price = 0.0;

    // --- GET request (load existing data) ---
    if ("GET".equalsIgnoreCase(method)) {
        id = Integer.parseInt(request.getParameter("id"));
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
            PreparedStatement ps = conn.prepareStatement("SELECT * FROM products WHERE id = ?");
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                name = rs.getString("name");
                description = rs.getString("description");
                price = rs.getDouble("price");
                image_url = rs.getString("image_url");
            }
            conn.close();
        } catch (Exception e) {
            out.println("<p style='color:red;text-align:center;'>Error loading product: " + e.getMessage() + "</p>");
        }
    }

    // --- POST request (update product) ---
    if ("POST".equalsIgnoreCase(method)) {
        id = Integer.parseInt(request.getParameter("id"));
        name = request.getParameter("name");
        description = request.getParameter("description");
        price = Double.parseDouble(request.getParameter("price"));
        image_url = request.getParameter("image_url");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
            PreparedStatement ps = conn.prepareStatement(
                "UPDATE products SET name=?, description=?, price=?, image_url=? WHERE id=?");
            ps.setString(1, name);
            ps.setString(2, description);
            ps.setDouble(3, price);
            ps.setString(4, image_url);
            ps.setInt(5, id);
            ps.executeUpdate();
            conn.close();

            response.sendRedirect("admin-dashboard.jsp");
            return;
        } catch (Exception e) {
            out.println("<p style='color:red;text-align:center;'>Error updating product: " + e.getMessage() + "</p>");
        }
    }
%>

<div class="container">
    <h2>Edit Product</h2>

    <div class="image-preview">
        <% if (image_url != null && !image_url.trim().isEmpty()) { %>
            <img src="<%= request.getContextPath() + "/" + image_url %>" alt="Product Image">
        <% } else { %>
            <p style="color:#888;">No image available</p>
        <% } %>
    </div>

    <form method="post">
        <input type="hidden" name="id" value="<%= id %>">
        <input type="text" name="name" placeholder="Product Name" value="<%= name %>" required>
        <textarea name="description" placeholder="Description" rows="3"><%= description %></textarea>
        <input type="number" name="price" placeholder="Price" step="0.01" value="<%= price %>" required>
        <input type="text" name="image_url" placeholder="Image path (e.g. images/product1.jpg)" value="<%= image_url %>">
        <button type="submit">Update Product</button>
    </form>

    <div class="back">
        <a href="admin-dashboard.jsp">← Back to Dashboard</a>
    </div>
</div>

</body>
</html>
