<%@ page import="java.sql.*,org.json.JSONObject" %>
<%@ page contentType="application/json;charset=UTF-8" language="java" %>

<%
    JSONObject json = new JSONObject();

    try {
        Object userObj = session.getAttribute("user_id");
        String cartIdStr = request.getParameter("cart_id");
        String action = request.getParameter("action");

        if (userObj == null || cartIdStr == null || action == null) {
            json.put("success", false);
            json.put("error", "Missing session or parameters");
        } else {
            int userId = (userObj instanceof Integer) ? (Integer) userObj : Integer.parseInt(userObj.toString());
            int cartId = Integer.parseInt(cartIdStr);

            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/shopeasy", "root", "");

            // Get current quantity and price
            PreparedStatement ps = con.prepareStatement(
                "SELECT c.quantity, p.price FROM cart c JOIN products p ON c.product_id = p.id WHERE c.id = ? AND c.user_id = ?");
            ps.setInt(1, cartId);
            ps.setInt(2, userId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                int quantity = rs.getInt("quantity");
                double price = rs.getDouble("price");

                // Update based on action
                if ("increase".equals(action)) quantity++;
                if ("decrease".equals(action) && quantity > 1) quantity--;

                PreparedStatement update = con.prepareStatement("UPDATE cart SET quantity=? WHERE id=? AND user_id=?");
                update.setInt(1, quantity);
                update.setInt(2, cartId);
                update.setInt(3, userId);
                update.executeUpdate();

                // Get total cart value
                PreparedStatement totalPS = con.prepareStatement(
                    "SELECT SUM(c.quantity * p.price) FROM cart c JOIN products p ON c.product_id=p.id WHERE c.user_id=?");
                totalPS.setInt(1, userId);
                ResultSet totalRS = totalPS.executeQuery();
                double total = 0;
                if (totalRS.next()) total = totalRS.getDouble(1);

                json.put("success", true);
                json.put("quantity", quantity);
                json.put("subtotal", quantity * price);
                json.put("total", total);

                totalRS.close(); totalPS.close();
                update.close();
            } else {
                json.put("success", false);
                json.put("error", "Cart item not found");
            }

            rs.close();
            ps.close();
            con.close();
        }
    } catch (Exception e) {
        json.put("success", false);
        json.put("error", e.toString());
    }

    out.print(json.toString());
%>
