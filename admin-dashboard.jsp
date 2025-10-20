<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard - ShopEasy</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        body {
            font-family: "Poppins", sans-serif;
            background: #f3f4f6;
            margin: 0;
            padding: 0;
        }
        header {
            background: #1e293b;
            color: white;
            padding: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        header h1 { margin: 0; font-size: 22px; }
        .add-btn {
            background: #10b981;
            color: white;
            padding: 10px 18px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .add-btn:hover { background: #059669; }

        .products {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 20px;
            padding: 30px;
        }

        .card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
            text-align: center;
        }

        .card img {
            width: 100%;
            height: 180px;
            object-fit: cover;
            border-radius: 8px;
        }

        .card h3 {
            margin: 10px 0 5px;
            color: #111827;
        }

        .card p {
            color: #6b7280;
            font-size: 14px;
        }

        .card .price {
            color: #2563eb;
            font-weight: bold;
            font-size: 16px;
        }

        .card button {
            margin-top: 10px;
            padding: 8px 14px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            color: white;
        }

        .edit-btn { background: #3b82f6; }
        .delete-btn { background: #ef4444; }
        .edit-btn:hover { background: #2563eb; }
        .delete-btn:hover { background: #dc2626; }
    </style>
</head>
<body>

<header>
    <h1>Admin Dashboard</h1>
    <form action="add-product.jsp" method="get">
        <button class="add-btn">+ Add Product</button>
    </form>
</header>

<div class="products">
<%
    String jdbcURL = "jdbc:mysql://localhost:3306/shopeasy";
    String dbUser = "root";
    String dbPassword = ""; // Change if you have a password

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT * FROM products");

        while(rs.next()) {
            int id = rs.getInt("id");
            String name = rs.getString("name");
            String description = rs.getString("description");
            double price = rs.getDouble("price");
            String image = rs.getString("image_url");
%>
        <div class="card">
             <img src="<%= request.getContextPath() + "/" + rs.getString("image_url") %>" 
                 alt="<%= rs.getString("name") %>" 
                 style="width:200px;height:200px;">
            <h3><%= name %></h3>
            <p><%= description %></p>
            <div class="price">$<%= price %></div>
            <form action="edit-product.jsp" method="get" style="display:inline;">
                <input type="hidden" name="id" value="<%= id %>">
                <button class="edit-btn">Edit</button>
            </form>
            <form action="delete-product.jsp" method="post" style="display:inline;">
                <input type="hidden" name="id" value="<%= id %>">
                <button class="delete-btn">Delete</button>
            </form>
        </div>
<%
        }
        conn.close();
    } catch (Exception e) {
        out.println("<p style='color:red;text-align:center;'>Error: " + e.getMessage() + "</p>");
    }
%>
</div>

</body>
</html>
