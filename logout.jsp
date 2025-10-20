<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Invalidate the current user session
    session = request.getSession(false);
    if (session != null) {
        session.invalidate();
    }

    // Redirect to login or home page
    response.sendRedirect("index.jsp");
%>
