<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Object userObj = session.getAttribute("user_id");
    if (userObj == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int userId = Integer.parseInt(userObj.toString());
    String firstName = "", lastName = "", email = "", phone = "", address = "", photo = "default-profile.jfif";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/shopeasy", "root", "");
        PreparedStatement ps = con.prepareStatement("SELECT * FROM users WHERE id=?");
        ps.setInt(1, userId);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            firstName = rs.getString("first");
            lastName = rs.getString("last");
            email = rs.getString("email");
            phone = rs.getString("phone");
            address = rs.getString("address");
            if (rs.getString("profile_photo") != null && !rs.getString("profile_photo").isEmpty()) {
                photo = rs.getString("profile_photo");
            }
        }
        con.close();
    } catch (Exception e) {
        out.println("<p style='color:red;text-align:center;'>Error: " + e.getMessage() + "</p>");
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Profile - ShopEasy</title>
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f9fafb;
            margin: 0;
        }

        header {
            background-color: #2563eb;
            color: white;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 12px 40px;
        }

        header h1 {
            margin: 0;
            font-size: 24px;
        }

        nav a {
            color: white;
            text-decoration: none;
            margin: 0 15px;
            font-weight: 500;
        }

        nav a:hover {
            text-decoration: underline;
        }

        .container {
            width: 90%;
            max-width: 800px;
            margin: 40px auto;
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            padding: 30px;
            text-align: center;
        }

        .profile-pic {
            width: 140px;
            height: 140px;
            border-radius: 50%;
            border: 4px solid #2563eb;
            object-fit: cover;
            margin-bottom: 20px;
        }

        h2 {
            color: #111827;
            margin-bottom: 10px;
        }

        .info {
            text-align: left;
            margin: 20px auto;
            width: 80%;
            line-height: 1.8;
        }

        .info strong {
            color: #2563eb;
        }

        .edit-btn {
            background-color: #2563eb;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 8px;
            cursor: pointer;
            font-size: 15px;
            transition: 0.3s;
        }

        .edit-btn:hover {
            background-color: #1e40af;
        }

        footer {
            background-color: #2563eb;
            color: white;
            text-align: center;
            padding: 15px;
            margin-top: 50px;
        }
    </style>
</head>

<body>

<header>
    <h1>ShopEasy 🛍️</h1>
    <nav>
        <a href="customer-main.jsp">Home</a>
        <a href="view-cart.jsp">My Cart</a>
        <a href="my-orders.jsp">Orders</a>
        <a href="logout.jsp">Logout</a>
    </nav>
</header>

<div class="container">
    <img src="images/<%= photo %>" alt="Profile Picture" class="profile-pic">
    <h2><%= firstName %> <%= lastName %></h2>

    <div class="info">
        <p><strong>Email:</strong> <%= email %></p>
        <p><strong>Phone:</strong> <%= phone %></p>
        <p><strong>Address:</strong> <%= address %></p>
    </div>

    <form action="edit-profile.jsp" method="get">
        <button type="submit" class="edit-btn">Edit Profile</button>
    </form>
</div>

<footer>
    <p>© 2025 ShopEasy | All rights reserved.</p>
</footer>

</body>
</html>
