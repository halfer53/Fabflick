<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%> 
<html>
    <head>
        <%@ include file="head.jsp"%>
        <title>Main</title>
    </head>
<body>
    <%
        Integer uid = (Integer)session.getAttribute("uid");
        
          
    %>
    <%@ include file="header.jsp"%>
    

    To Be Implemented
    <%@ include file="footer.jsp"%>
</body>
</html>