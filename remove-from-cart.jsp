<%@ page import="java.sql.*" %>
<%
    String cartIdStr = request.getParameter("cart_id");
    String action = request.getParameter("action");

    if (cartIdStr != null && action != null) {
        int cartId = Integer.parseInt(cartIdStr);

        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/eventdb", "root", "");

        String query = "";
        if ("increase".equals(action)) {
            query = "UPDATE cart SET quantity = quantity + 1 WHERE cart_id = ?";
        } else if ("decrease".equals(action)) {
            query = "UPDATE cart SET quantity = CASE WHEN quantity > 1 THEN quantity - 1 ELSE 1 END WHERE cart_id = ?";
        }

        PreparedStatement ps = con.prepareStatement(query);
        ps.setInt(1, cartId);
        ps.executeUpdate();

        con.close();
    }

    response.sendRedirect("view-cart.jsp");
%>
