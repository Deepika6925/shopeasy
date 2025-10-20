<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Delete Product</title>
    <style>
        body {
            font-family: "Poppins", sans-serif;
            background-color: #f3f4f6;
            text-align: center;
            padding-top: 100px;
            color: #1e293b;
        }
        a {
            color: #2563eb;
            text-decoration: none;
        }
        a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

<%
    String jdbcURL = "jdbc:mysql://localhost:3306/shopeasy";
    String dbUser = "root";
    String dbPassword = ""; // change if needed

    String idParam = request.getParameter("id");

    if (idParam != null && !idParam.trim().isEmpty()) {
        int id = Integer.parseInt(idParam);
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
            PreparedStatement ps = conn.prepareStatement("DELETE FROM products WHERE id = ?");
            ps.setInt(1, id);
            int rows = ps.executeUpdate();
            conn.close();

            if (rows > 0) {
                response.sendRedirect("admin-dashboard.jsp");
                return;
            } else {
                out.println("<h3>No product found with ID: " + id + "</h3>");
            }
        } catch (Exception e) {
            out.println("<h3 style='color:red;'>Error deleting product: " + e.getMessage() + "</h3>");
        }
    } else {
        out.println("<h3 style='color:red;'>Invalid product ID.</h3>");
    }
%>

<p><a href="admin-dashboard.jsp">← Back to Dashboard</a></p>

</body>
</html>
