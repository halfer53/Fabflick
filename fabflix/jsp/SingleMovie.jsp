<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%> 
<html>
    <head>
        <%@ include file="head.jsp"%>
        <title>Single Movie</title>
    </head>
<body>
    <%
        Integer uid = (Integer)session.getAttribute("uid");
        String sid = (String)request.getParameter("id");
        Integer movieid = sid==null ? new Integer(0) : Integer.valueOf(sid);
    %>

    <%@ include file="header.jsp"%>

    To Be Implemented
    //TODO

    
    <%@ include file="footer.jsp"%>
</body>
</html>