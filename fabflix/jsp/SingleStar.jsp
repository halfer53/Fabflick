<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%> 
<html>
    <head>
        <%@ include file="head.jsp"%>
        <title>Single Star</title>
    </head>
<body>
    <%
        Integer uid = (Integer)session.getAttribute("uid");
        String sid = request.getParameter("id");
        Integer star_id = sid==null ? new Integer(0) : Integer.valueOf(sid);
          
    %>
    <%@ include file="header.jsp"%>

    To Be Implemented
    //TODO

    
    <%@ include file="footer.jsp"%>
</body>
</html>