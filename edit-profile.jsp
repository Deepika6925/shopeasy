<%@ page import="java.sql.*, java.io.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // --- Configuration: update if your DB / user table differs ---
    final String JDBC_URL = "jdbc:mysql://localhost:3306/shopeasy";
    final String JDBC_USER = "root";
    final String JDBC_PASS = "";

    // --- Session / auth check ---
    Object userObj = session.getAttribute("user_id");
    if (userObj == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    int userId = (userObj instanceof Integer) ? (Integer) userObj : Integer.parseInt(userObj.toString());

    String message = "";
    String messageType = ""; // "error" or "success"

    // form values (defaults)
    String first = "";
    String last = "";
    String email = "";
    String phone = "";
    String address = "";
    String profilePhoto = "default-profile.jfif"; // fallback

    // --- Helper: get list of image files in /images folder ---
    String[] imageFiles = new String[0];
    try {
        String imagesPath = application.getRealPath("/images");
        if (imagesPath != null) {
            File imgDir = new File(imagesPath);
            if (imgDir.exists() && imgDir.isDirectory()) {
                File[] files = imgDir.listFiles(new FilenameFilter() {
                    public boolean accept(File dir, String name) {
                        String lower = name.toLowerCase();
                        return lower.endsWith(".png") || lower.endsWith(".jpg") || lower.endsWith(".jpeg") || lower.endsWith(".gif") || lower.endsWith(".webp") || lower.endsWith(".jfif");
                    }
                });
                if (files != null) {
                    List<String> names = new ArrayList<>();
                    for (File f : files) names.add(f.getName());
                    imageFiles = names.toArray(new String[0]);
                }
            }
        }
    } catch (Exception e) {
        // ignore — image dropdown will be empty
    }

    // --- If POST: process update ---
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        // read parameters (names match DB columns: first, last, email, phone, address, profile_photo)
        String pFirst = request.getParameter("first");
        String pLast = request.getParameter("last");
        String pEmail = request.getParameter("email");
        String pPhone = request.getParameter("phone");
        String pAddress = request.getParameter("address");
        String pPhoto = request.getParameter("profile_photo"); // selected filename from dropdown (or can be blank)

        // basic validation
        if (pFirst == null || pFirst.trim().isEmpty()) {
            message = "First name is required.";
            messageType = "error";
        } else if (pEmail == null || pEmail.trim().isEmpty()) {
            message = "Email is required.";
            messageType = "error";
        } else {
            // sanitize selected photo filename: allow only basename from images list
            String chosenPhoto = profilePhoto; // fallback
            if (pPhoto != null && !pPhoto.trim().isEmpty()) {
                // ensure pPhoto exists in imageFiles
                for (String f : imageFiles) {
                    if (f.equals(pPhoto)) {
                        chosenPhoto = f;
                        break;
                    }
                }
            }

            // update DB
            Connection conn = null;
            PreparedStatement ps = null;
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS);

                // Use the exact column names you have in DB: first,last,email,phone,address,profile_photo
                String sql = "UPDATE users SET first=?, last=?, email=?, phone=?, address=?, profile_photo=? WHERE id=?";
                ps = conn.prepareStatement(sql);
                ps.setString(1, pFirst.trim());
                ps.setString(2, (pLast == null ? "" : pLast.trim()));
                ps.setString(3, pEmail.trim());
                ps.setString(4, (pPhone == null ? "" : pPhone.trim()));
                ps.setString(5, (pAddress == null ? "" : pAddress.trim()));
                ps.setString(6, chosenPhoto);
                ps.setInt(7, userId);

                int updated = ps.executeUpdate();
                if (updated > 0) {
                    // success: optionally refresh values and redirect to profile.jsp
                    message = "Profile updated successfully.";
                    messageType = "success";
                    // redirect to profile page
                    response.sendRedirect("profile.jsp");
                    return;
                } else {
                    message = "No rows updated. Please try again.";
                    messageType = "error";
                }

            } catch (Exception ex) {
                message = "Error updating profile: " + ex.getMessage();
                messageType = "error";
            } finally {
                try { if (ps != null) ps.close(); } catch (Exception ignored) {}
                try { if (conn != null) conn.close(); } catch (Exception ignored) {}
            }
        }

        // if we got here, update failed or validation error — set form fields to submitted values so user can correct
        first = (pFirst == null) ? "" : pFirst;
        last = (pLast == null) ? "" : pLast;
        email = (pEmail == null) ? "" : pEmail;
        phone = (pPhone == null) ? "" : pPhone;
        address = (pAddress == null) ? "" : pAddress;
        // profilePhoto remains current or chosen — keep chosen only if it exists in list
        if (pPhoto != null) {
            for (String f : imageFiles) if (f.equals(pPhoto)) { profilePhoto = pPhoto; break; }
        }
    } else {
        // --- GET: load existing user data to show in form ---
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS);
            ps = conn.prepareStatement("SELECT first, last, email, phone, address, profile_photo FROM users WHERE id = ?");
            ps.setInt(1, userId);
            rs = ps.executeQuery();
            if (rs.next()) {
                first = rs.getString("first") != null ? rs.getString("first") : "";
                last = rs.getString("last") != null ? rs.getString("last") : "";
                email = rs.getString("email") != null ? rs.getString("email") : "";
                phone = rs.getString("phone") != null ? rs.getString("phone") : "";
                address = rs.getString("address") != null ? rs.getString("address") : "";
                String dbPhoto = rs.getString("profile_photo");
                if (dbPhoto != null && !dbPhoto.trim().isEmpty()) {
                    // ensure the photo file actually exists in /images, otherwise keep default
                    for (String f : imageFiles) {
                        if (f.equals(dbPhoto)) { profilePhoto = dbPhoto; break; }
                    }
                }
            }
        } catch (Exception ex) {
            message = "Error loading profile: " + ex.getMessage();
            messageType = "error";
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception ignored) {}
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (conn != null) conn.close(); } catch (Exception ignored) {}
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>Edit Profile - ShopEasy</title>
    <style>
        body { font-family: Arial, Helvetica, sans-serif; background:#f6f7fb; margin:0; padding:0; }
        header { background:#2563eb; color:white; padding:12px 24px; display:flex; align-items:center; justify-content:space-between; }
        header h1 { margin:0; font-size:20px; }
        nav a { color:white; margin-left:12px; text-decoration:none; font-weight:500; }
        .wrap { max-width:920px; margin:30px auto; padding:20px; }
        .card { background:white; border-radius:10px; padding:20px; box-shadow:0 6px 18px rgba(0,0,0,0.06); }
        .profile-top { display:flex; gap:20px; align-items:center; margin-bottom:20px; }
        .profile-top img { width:96px; height:96px; object-fit:cover; border-radius:50%; border:3px solid #2563eb; }
        .profile-top .name { font-size:20px; font-weight:600; color:#111827; }
        .form-row { display:flex; gap:20px; margin-bottom:12px; }
        .form-row .col { flex:1; display:flex; flex-direction:column; }
        label { font-size:13px; color:#374151; margin-bottom:6px; }
        input[type="text"], input[type="email"], textarea, select { padding:10px; border-radius:6px; border:1px solid #d1d5db; font-size:14px; }
        textarea { min-height:90px; resize:vertical; }
        .actions { display:flex; justify-content:flex-end; gap:10px; margin-top:14px; }
        .btn { padding:10px 16px; border-radius:8px; border:none; cursor:pointer; font-weight:600; }
        .btn-primary { background:#2563eb; color:white; }
        .btn-secondary { background:#e5e7eb; color:#111827; }
        .msg { margin-bottom:12px; padding:10px 12px; border-radius:6px; }
        .msg.error { background:#fee2e2; color:#991b1b; }
        .msg.success { background:#d1fae5; color:#065f46; }
    </style>
</head>
<body>

<header>
    <h1>ShopEasy</h1>
    <nav>
        <a href="customer-main.jsp">Home</a>
        <a href="view-cart.jsp">Cart</a>
        <a href="my-orders.jsp">Orders</a>
        <a href="profile.jsp">Profile</a>
        <a href="logout.jsp">Logout</a>
    </nav>
</header>

<div class="wrap">
    <div class="card">
        <% if (message != null && !message.isEmpty()) { %>
            <div class="msg <%= "error".equals(messageType) ? "error" : "success" %>"><%= message %></div>
        <% } %>

        <div class="profile-top">
            <img src="images/<%= profilePhoto %>" alt="Profile">
            <div>
                <div class="name"><%= (first == null || first.isEmpty()) ? "User" : first %> <%= (last==null) ? "" : last %></div>
                <div style="color:#6b7280; margin-top:6px;"><%= (email==null) ? "" : email %></div>
            </div>
        </div>

        <!-- Single form handles POST to same page. NO file upload; photo chosen from existing /images -->
        <form method="post" action="edit-profile.jsp">
            <div class="form-row">
                <div class="col">
                    <label for="first">First name</label>
                    <input id="first" name="first" type="text" value="<%= first %>" required>
                </div>
                <div class="col">
                    <label for="last">Last name</label>
                    <input id="last" name="last" type="text" value="<%= last %>">
                </div>
            </div>

            <div class="form-row">
                <div class="col">
                    <label for="email">Email</label>
                    <input id="email" name="email" type="email" value="<%= email %>" required>
                </div>
                <div class="col">
                    <label for="phone">Phone</label>
                    <input id="phone" name="phone" type="text" value="<%= phone %>">
                </div>
            </div>

            <div class="form-row">
                <div class="col">
                    <label for="address">Address</label>
                    <textarea id="address" name="address"><%= address %></textarea>
                </div>

                <div class="col">
                    <label for="profile_photo">Profile photo (choose existing)</label>
                    <select id="profile_photo" name="profile_photo">
                        <option value="">-- keep current --</option>
                        <% for (String f : imageFiles) { %>
                            <option value="<%= f %>" <%= (f.equals(profilePhoto) ? "selected" : "") %>><%= f %></option>
                        <% } %>
                    </select>
                    <p style="font-size:12px;color:#6b7280;margin-top:8px;">Put images in <code>/images</code> folder. Selected image will be used as profile photo.</p>
                </div>
            </div>

            <div class="actions">
                <button type="button" onclick="window.location.href='profile.jsp'" class="btn btn-secondary">Cancel</button>
                <button type="submit" class="btn btn-primary">Save changes</button>
            </div>
        </form>
    </div>
</div>

</body>
</html>
