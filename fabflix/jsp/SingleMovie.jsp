<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<html>
    <head>
        <%@ include file="head.jsp"%>
        <title>Single Movie</title>
    </head>
<body>
    <%
        
        String sid = (String)request.getParameter("id");
        Integer movieid = sid==null ? new Integer(0) : Integer.valueOf(sid);
    %>

    <%@ include file="header.jsp"%>

    To Be Implemented
    //TODO

    
    <%@ include file="footer.jsp"%>
</body>
</html>