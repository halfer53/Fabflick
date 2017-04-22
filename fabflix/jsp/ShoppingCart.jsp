<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%> 
<html>
    <head>
        <%@ include file="head.jsp"%>
        <title>Shopping Cart</title>
    </head>
<body>
    <%
        Integer uid = (Integer)session.getAttribute("uid");
    %>
    
    <%@ include file="header.jsp"%>
    <div class="container-fluid">
        <div class="table-responsive">
            <table width="100%" class="table table-hover">
                <thead>
                    <tr>
                       <th >Title</th>
                       <th>Quantity</th>
                    </tr>
                </thead>
                    <tbody id="Cart-data">
                    </tbody>
                
            </table>
            <button class="btn btn-default" onclick="checkout(<%=uid%>)">Checkout </button>
        </div>
    </div>
    
    <%@ include file="footer.jsp"%>

    <script>
        $("#Cart-data").html(getCart());
    </script>
</body>
</html>