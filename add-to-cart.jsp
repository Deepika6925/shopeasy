<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String jdbcURL = "jdbc:mysql://localhost:3306/shopeasy";
    String dbUser = "root";
    String dbPass = "";

    String productIdStr = request.getParameter("product_id");
    Object userIdObj = session.getAttribute("user_id");

    if (productIdStr == null || userIdObj == null) {
        out.println("<p style='color:red;text-align:center;'>Invalid session or missing product ID</p>");
        out.println("<p><a href='login.jsp'>Go to Login</a></p>");
        return;
    }

    int productId = Integer.parseInt(productIdStr);
    int userId = Integer.parseInt(userIdObj.toString());

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection(jdbcURL, dbUser, dbPass);

        // Check if item already in cart
        PreparedStatement check = conn.prepareStatement("SELECT * FROM cart WHERE user_id=? AND product_id=?");
        check.setInt(1, userId);
        check.setInt(2, productId);
        ResultSet rs = check.executeQuery();

        if (rs.next()) {
            PreparedStatement ps = conn.prepareStatement(
                "UPDATE cart SET quantity = quantity + 1 WHERE user_id=? AND product_id=?");
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            ps.executeUpdate();
        } else {
            PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO cart (user_id, product_id, quantity) VALUES (?, ?, ?)");
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            ps.setInt(3, 1);
            ps.executeUpdate();
        }

        conn.close();
        response.sendRedirect("customer-main.jsp?msg=added");
    } catch (Exception e) {
        out.println("<p style='color:red;text-align:center;'>Error adding to cart: " + e.getMessage() + "</p>");
    }
%>
