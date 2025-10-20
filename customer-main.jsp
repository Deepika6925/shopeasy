<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Object userObj = session.getAttribute("user_id");
    if (userObj == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    int userId = Integer.parseInt(userObj.toString());

    // Fetch user's name and photo
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/shopeasy", "root", "");
    PreparedStatement ps1 = con.prepareStatement("SELECT first, profile_photo FROM users WHERE id=?");
    ps1.setInt(1, userId);
    ResultSet rs1 = ps1.executeQuery();

    String firstName = "User";
    String profilePhoto = "default-profile.jfif"; // fallback
    if (rs1.next()) {
        String tempName = rs1.getString("first");
        String tempPhoto = rs1.getString("profile_photo");
        if (tempName != null && !tempName.isEmpty()) firstName = tempName;
        if (tempPhoto != null && !tempPhoto.isEmpty()) profilePhoto = tempPhoto;
    }

    rs1.close();
    ps1.close();
    con.close();

    String selectedCategory = request.getParameter("category");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>ShopEasy - Home</title>
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f9fafb;
            margin: 0;
        }

        header {
            background-color: #2563eb;
            color: white;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 12px 40px;
        }

        header h1 {
            margin: 0;
            font-size: 24px;
        }

        nav a {
            color: white;
            text-decoration: none;
            margin: 0 15px;
            font-weight: 500;
        }

        nav a:hover {
            text-decoration: underline;
        }

        .profile-section {
            display: flex;
            align-items: center;
            gap: 10px;
            cursor: pointer;
        }

        .profile-section img {
            width: 45px;
            height: 45px;
            border-radius: 50%;
            border: 2px solid white;
            object-fit: cover;
        }

        .profile-section span {
            font-weight: 500;
        }

        /* Category Bar */
        .category-bar {
            background-color: #e5e7eb;
            display: flex;
            justify-content: center;
            flex-wrap: wrap;
            padding: 10px;
        }

        .category-bar a {
            background: white;
            color: #2563eb;
            border-radius: 20px;
            padding: 8px 16px;
            margin: 5px;
            text-decoration: none;
            border: 1px solid #2563eb;
            transition: 0.3s;
        }

        .category-bar a:hover {
            background-color: #2563eb;
            color: white;
        }

        /* Product Grid */
        .container {
            width: 90%;
            margin: 30px auto;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 25px;
        }

        .card {
            background: white;
            border-radius: 10px;
            box-shadow: 0 5px 10px rgba(0,0,0,0.1);
            overflow: hidden;
            transition: transform 0.3s ease;
        }

        .card:hover {
            transform: translateY(-5px);
        }

        .card img {
            width: 100%;
            height: 200px;
            object-fit: contain;
            background: #f3f4f6;
        }

        .card-content {
            padding: 15px;
            text-align: center;
        }

        .card-content h3 {
            font-size: 18px;
            color: #111827;
            margin: 8px 0;
        }

        .price {
            color: #2563eb;
            font-weight: 600;
        }

        .view-btn {
            background-color: #2563eb;
            color: white;
            border: none;
            padding: 8px 14px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
            margin-top: 10px;
        }

        .view-btn:hover {
            background-color: #1e40af;
        }

        footer {
            background-color: #2563eb;
            color: white;
            text-align: center;
            padding: 15px;
            margin-top: 40px;
        }
    </style>
</head>

<body>

<header>
    <h1>ShopEasy 🛍️</h1>

    <nav>
        <a href="customer-main.jsp">Home</a>
        <a href="view-cart.jsp">My Cart</a>
        <a href="my-orders.jsp">Orders</a>
        <a href="logout.jsp">Logout</a>
    </nav>

    <!-- Profile section -->
    <div class="profile-section" onclick="window.location.href='profile.jsp'">
        <img src="images/<%= profilePhoto %>" alt="Profile">
        <span><%= firstName %></span>
    </div>
</header>

<!-- Category Bar -->
<div class="category-bar">
    <%
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/shopeasy", "root", "");
            Statement stmt = conn.createStatement();
            ResultSet catRs = stmt.executeQuery("SELECT * FROM categories");

            while (catRs.next()) {
                int catId = catRs.getInt("id");
                String catName = catRs.getString("name");
    %>
                <a href="customer-main.jsp?category=<%= catId %>"><%= catName %></a>
    <%
            }
            conn.close();
        } catch (Exception e) {
            out.println("<p style='color:red;text-align:center;'>Category Error: " + e.getMessage() + "</p>");
        }
    %>
</div>

<!-- Products Section -->
<div class="container">
<%
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/shopeasy", "root", "");
        PreparedStatement ps;
        if (selectedCategory != null) {
            ps = conn.prepareStatement("SELECT * FROM products WHERE category_id = ?");
            ps.setInt(1, Integer.parseInt(selectedCategory));
        } else {
            ps = conn.prepareStatement("SELECT * FROM products");
        }

        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            int id = rs.getInt("id");
            String name = rs.getString("name");
            double price = rs.getDouble("price");
            String image = rs.getString("image_url");
%>
        <div class="card">
            <img src="<%= image %>" alt="<%= name %>">
            <div class="card-content">
                <h3><%= name %></h3>
                <p class="price">₹ <%= String.format("%.2f", price) %></p>
                <form action="product-details.jsp" method="get">
                    <input type="hidden" name="id" value="<%= id %>">
                    <button type="submit" class="view-btn">View Details</button>
                </form>
            </div>
        </div>
<%
        }
        conn.close();
    } catch (Exception e) {
        out.println("<p style='color:red;text-align:center;'>Error: " + e.getMessage() + "</p>");
    }
%>
</div>

<footer>
    <p>© 2025 ShopEasy | All rights reserved.</p>
</footer>

</body>
</html>
