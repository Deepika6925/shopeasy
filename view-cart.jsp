<%@ page import="java.sql.*,java.util.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    Object userObj = session.getAttribute("user_id");

    if (userObj == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int userId = (userObj instanceof Integer) ? (Integer) userObj : Integer.parseInt(userObj.toString());

    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/shopeasy", "root", "");

    PreparedStatement ps = con.prepareStatement(
        "SELECT c.id, c.product_id, p.name, p.price, p.image_url, c.quantity " +
        "FROM cart c JOIN products p ON c.product_id = p.id WHERE c.user_id = ?");
    ps.setInt(1, userId);
    ResultSet rs = ps.executeQuery();
%>

<!DOCTYPE html>
<html>
<head>
    <title>My Cart</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f3f3f3;
            margin: 0;
            padding: 0;
        }
        .cart-container {
            width: 80%;
            margin: 40px auto;
            background: #fff;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            text-align: center;
            padding: 12px;
            border-bottom: 1px solid #ddd;
        }
        th {
            background: #4CAF50;
            color: white;
        }
        img {
            width: 80px;
            border-radius: 8px;
        }
        .qty-btn {
            background: #007BFF;
            border: none;
            color: white;
            padding: 5px 10px;
            cursor: pointer;
            border-radius: 4px;
            font-size: 16px;
        }
        .qty-btn:hover {
            background: #0056b3;
        }
        .remove-btn {
            background: red;
            border: none;
            color: white;
            padding: 5px 12px;
            border-radius: 4px;
            cursor: pointer;
        }
        .total {
            text-align: right;
            font-size: 20px;
            margin-top: 20px;
            font-weight: bold;
        }
        .order-btn {
            background: #28a745;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 6px;
            font-size: 18px;
            cursor: pointer;
            float: right;
            margin-top: 20px;
        }
        .order-btn:hover {
            background: #218838;
        }
        a {
            text-decoration: none;
            color: white;
        }
    </style>
</head>

<body>
<div class="cart-container">
    <h2>🛒 Your Cart</h2>
    <table>
        <tr>
            <th>Product</th>
            <th>Image</th>
            <th>Price</th>
            <th>Quantity</th>
            <th>Subtotal</th>
            <th>Action</th>
        </tr>

        <%
            double total = 0;
            while (rs.next()) {
                int cartId = rs.getInt("id");
                int quantity = rs.getInt("quantity");
                double price = rs.getDouble("price");
                double subtotal = price * quantity;
                total += subtotal;
        %>
        <tr>
            <td><%= rs.getString("name") %></td>
            <td><img src="<%= rs.getString("image_url") %>" alt="product"></td>
            <td>₹<%= price %></td>
            <td>
                <a href="decrease-quantity.jsp?cart_id=<%= cartId %>">
                    <button class="qty-btn">−</button>
                </a>
                <span><%= quantity %></span>
                <a href="increase-quantity.jsp?cart_id=<%= cartId %>">
                    <button class="qty-btn">+</button>
                </a>
            </td>
            <td>₹<%= subtotal %></td>
            <td>
                <a href="remove-from-cart.jsp?cart_id=<%= cartId %>">
                    <button class="remove-btn">Remove</button>
                </a>
            </td>
        </tr>
        <% } %>
    </table>

    <div class="total">
        Total: ₹<%= total %>
    </div>

    <!-- ✅ Place Order Button -->
    <form action="place-order.jsp" method="post">
        <input type="hidden" name="user_id" value="<%= userId %>">
        <button type="submit" class="order-btn">Place Order</button>
    </form>

</div>
</body>
</html>
