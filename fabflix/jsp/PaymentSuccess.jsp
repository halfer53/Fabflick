<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%> 
<html>
    <head>
        <%@ include file="head.jsp"%>
        <title>Payment Success</title>
    </head>
<body>
    <%
        Integer uid = (Integer)session.getAttribute("uid");
        String uuid = (String)session.getAttribute("cart-id");
        if(uuid==null){
            response.sendError(403,"You have not complete any transaction yet");
        }else{
            session.removeAttribute("cart-id");
        }
    %>
    
    <%@ include file="header.jsp"%>
    <div class="container">
        <h2 class="text-center">Thank you for your purchase</h2>
    </div>
    
    <%@ include file="footer.jsp"%>
    <script type="text/javascript">
        localStorage.removeItem("Cart");
    </script>
</body>
</html>