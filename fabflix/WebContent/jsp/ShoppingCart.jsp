<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<html>
    <head>
        <%@ include file="../base/head.jsp"%>
        <title>Shopping Cart</title>
    </head>
<body>
    <%
        
    %>
    
    <%@ include file="../base/header.jsp"%>
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
    
    <%@ include file="../base/footer.jsp"%>

    <script>
        $("#Cart-data").html(getCart());
    </script>
</body>
</html>