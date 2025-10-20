<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    Object userObj = session.getAttribute("user_id");
    if (userObj == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int userId = Integer.parseInt(userObj.toString());

    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/shopeasy", "root", "");

    PreparedStatement ps = con.prepareStatement(
        "SELECT * FROM orders WHERE user_id = ? ORDER BY order_date DESC");
    ps.setInt(1, userId);
    ResultSet rs = ps.executeQuery();
%>

<!DOCTYPE html>
<html>
<head>
    <title>My Orders</title>
    <style>
        body { font-family: Arial; background: #f3f3f3; }
        .container { width: 80%; margin: 40px auto; background: #fff; padding: 20px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        h2 { color: #333; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { padding: 12px; border-bottom: 1px solid #ddd; text-align: center; }
        th { background: #4CAF50; color: white; }
    </style>
</head>
<body>
<div class="container">
    <h2>📦 My Orders</h2>
    <table>
        <tr>
            <th>Order ID</th>
            <th>Total Amount</th>
            <th>Date</th>
        </tr>
        <%
            while (rs.next()) {
        %>
        <tr>
            <td><%= rs.getInt("id") %></td>
            <td>₹<%= rs.getDouble("total_amount") %></td>
            <td><%= rs.getTimestamp("order_date") %></td>
        </tr>
        <% } %>
    </table>
</div>
</body>
</html>
