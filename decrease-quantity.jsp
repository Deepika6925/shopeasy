<%@ page import="java.sql.*" %>
<%
    int cartId = Integer.parseInt(request.getParameter("cart_id"));
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/shopeasy", "root", "");

    // ✅ Decrease quantity only if it's more than 1
    PreparedStatement ps = con.prepareStatement(
        "UPDATE cart SET quantity = quantity - 1 WHERE id = ? AND quantity > 1");
    ps.setInt(1, cartId);
    ps.executeUpdate();

    response.sendRedirect("view-cart.jsp");
%>
