<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Product Details</title>
    <style>
        body {
            font-family: "Poppins", sans-serif;
            background-color: #f9fafb;
            margin: 0;
            padding: 20px;
        }
        .product-container {
            display: flex;
            gap: 30px;
            max-width: 900px;
            margin: 40px auto;
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            padding: 30px;
        }
        img {
            width: 300px;
            border-radius: 10px;
        }
        .details {
            flex: 1;
        }
        h2 { color: #1e293b; margin-bottom: 10px; }
        p { color: #475569; }
        .price { font-size: 20px; color: #2563eb; font-weight: bold; }
        form button {
            background: #2563eb;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            margin-top: 15px;
        }
        form button:hover { background: #1d4ed8; }
    </style>
</head>
<body>

<%
    int productId = Integer.parseInt(request.getParameter("id"));
    String jdbcURL = "jdbc:mysql://localhost:3306/shopeasy";
    String dbUser = "root";
    String dbPass = "";

    String name = "", description = "", image_url = "";
    double price = 0.0;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection(jdbcURL, dbUser, dbPass);
        PreparedStatement ps = conn.prepareStatement("SELECT * FROM products WHERE id=?");
        ps.setInt(1, productId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            name = rs.getString("name");
            description = rs.getString("description");
            price = rs.getDouble("price");
            image_url = rs.getString("image_url");
        }
        conn.close();
    } catch (Exception e) {
        out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
    }
%>

<div class="product-container">
    <img src="<%= image_url %>" alt="<%= name %>">
    <div class="details">
        <h2><%= name %></h2>
        <p><%= description %></p>
        <p class="price">₹<%= price %></p>

        <form action="add-to-cart.jsp" method="post">
            <input type="hidden" name="product_id" value="<%= productId %>">
            <input type="hidden" name="user_id" value="<%= session.getAttribute("user_id") %>">
            <button type="submit">Add to Cart</button>
        </form>
    </div>
</div>

</body>
</html>
