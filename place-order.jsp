<%@ page import="java.sql.*, java.util.*" %>
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

    // Get all cart items into a list first
    PreparedStatement ps1 = con.prepareStatement(
        "SELECT p.name, p.price, c.quantity FROM cart c JOIN products p ON c.product_id = p.id WHERE c.user_id = ?");
    ps1.setInt(1, userId);
    ResultSet rs = ps1.executeQuery();

    List<Map<String, Object>> items = new ArrayList<>();
    double total = 0;

    while (rs.next()) {
        Map<String, Object> item = new HashMap<>();
        item.put("name", rs.getString("name"));
        item.put("price", rs.getDouble("price"));
        item.put("quantity", rs.getInt("quantity"));
        item.put("subtotal", rs.getDouble("price") * rs.getInt("quantity"));
        total += rs.getDouble("price") * rs.getInt("quantity");
        items.add(item);
    }

    if (items.isEmpty()) {
        response.sendRedirect("view-cart.jsp?msg=empty");
        return;
    }

    // Insert into orders table
    PreparedStatement ps2 = con.prepareStatement(
        "INSERT INTO orders (user_id, total_amount) VALUES (?, ?)", Statement.RETURN_GENERATED_KEYS);
    ps2.setInt(1, userId);
    ps2.setDouble(2, total);
    ps2.executeUpdate();

    ResultSet rs2 = ps2.getGeneratedKeys();
    rs2.next();
    int orderId = rs2.getInt(1);

    // Insert each item into order_items
    for (Map<String, Object> item : items) {
        PreparedStatement ps3 = con.prepareStatement(
            "INSERT INTO order_items (order_id, product_name, quantity, price, subtotal) VALUES (?, ?, ?, ?, ?)");
        ps3.setInt(1, orderId);
        ps3.setString(2, (String) item.get("name"));
        ps3.setInt(3, (Integer) item.get("quantity"));
        ps3.setDouble(4, (Double) item.get("price"));
        ps3.setDouble(5, (Double) item.get("subtotal"));
        ps3.executeUpdate();
    }

    // Clear the user's cart
    PreparedStatement ps4 = con.prepareStatement("DELETE FROM cart WHERE user_id=?");
    ps4.setInt(1, userId);
    ps4.executeUpdate();

    con.close();

    response.sendRedirect("my-orders.jsp?success=true");
%>
