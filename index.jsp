<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ShopEasy - Home</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <style>
        body {
            background-color: #f8f9fa;
        }
        .navbar {
            background-color: #28a745;
        }
        .navbar-brand {
            color: white !important;
            font-weight: bold;
            font-size: 1.5rem;
        }
        .profile-dropdown {
            position: relative;
            display: inline-block;
        }
        .dropdown-content {
            display: none;
            position: absolute;
            right: 0;
            background-color: #fff;
            min-width: 150px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            z-index: 1;
            border-radius: 8px;
        }
        .dropdown-content a {
            color: #000;
            padding: 10px;
            text-decoration: none;
            display: block;
        }
        .dropdown-content a:hover {
            background-color: #f1f1f1;
        }
        .profile-dropdown:hover .dropdown-content {
            display: block;
        }
        .product-card {
            border-radius: 15px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.15);
            transition: all 0.3s;
        }
        .product-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        .product-img {
            border-radius: 15px 15px 0 0;
            height: 200px;
            object-fit: cover;
            width: 100%;
        }
    </style>
</head>
<body>

<!-- ✅ Navbar -->
<nav class="navbar navbar-expand-lg">
    <div class="container">
        <a class="navbar-brand" href="index.jsp">ShopEasy</a>
        <div class="ms-auto d-flex align-items-center">
            <button class="btn btn-light me-3" onclick="window.location.href='register.jsp'">Get Started</button>

            <div class="profile-dropdown">
                <img src="https://cdn-icons-png.flaticon.com/512/149/149071.png"
                     alt="Profile" width="40" height="40" class="rounded-circle" style="cursor: pointer;">
                <div class="dropdown-content">
                    <a href="login.jsp">Login</a>
                    <a href="register.jsp">Sign Up</a>
                </div>
            </div>
        </div>
    </div>
</nav>

<!-- ✅ Product Listing Section -->
<div class="container mt-5">
    <h2 class="text-center mb-4 text-success">Available Products</h2>
    <div class="row g-4">
        <%
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/shopeasy", "root", "");
                Statement st = conn.createStatement();
                ResultSet rs = st.executeQuery("SELECT * FROM products");

                while (rs.next()) {
        %>
                    <div class="col-md-3">
                        <div class="card product-card">
                            <img src="<%= rs.getString("image_url") != null ? rs.getString("image_url") : "https://via.placeholder.com/300" %>"
                                 alt="Product" class="product-img">
                            <div class="card-body">
                                <h5 class="card-title text-success"><%= rs.getString("name") %></h5>
                                <p class="card-text"><%= rs.getString("description") %></p>
                                <p class="fw-bold text-dark">₹<%= rs.getDouble("price") %></p>
                            </div>
                        </div>
                    </div>
        <%
                }
                conn.close();
            } catch (Exception e) {
                out.println("<div class='text-center text-danger'>Error loading products: " + e.getMessage() + "</div>");
            }
        %>
    </div>
</div>

</body>
</html>
