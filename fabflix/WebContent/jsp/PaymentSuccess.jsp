<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*,javax.naming.InitialContext, javax.naming.Context, javax.sql.DataSource"%>
<%@ page contentType="text/html; charset=UTF-8" %>
<html>
    <head>
        <%@ include file="../base/head.jsp"%>
        <title>Payment Success</title>
    </head>
<body>
    <%
        
        String uuid = (String)session.getAttribute("cart-id");
        if(uuid==null){
            response.sendError(403,"You have not complete any transaction yet");
        }else{
            session.removeAttribute("cart-id");
        }
    %>
    
    <%@ include file="../base/header.jsp"%>
    <div class="container">
        <h2 class="text-center">Thank you for your purchase</h2>
    </div>
    
    <%@ include file="../base/footer.jsp"%>
    <script type="text/javascript">
        localStorage.removeItem("Cart");
    </script>
</body>
</html>