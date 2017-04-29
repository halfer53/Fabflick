<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<html>
    <head>
        <%@ include file="head.jsp"%>
        <title>Checkout</title>
    </head>
<body>
    <%
    %>

    <%@ include file="header.jsp"%>
        <div class="container-fluid">
        <div class="table-responsive">
            <h4 class="text-center">Your Cart Detail</h4>
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
        </div>
    </div>
        <div class="container">
                    <h4 class="text-center">Please enter your credit detail to complete the transaction</h4>
                    <div class="form-group label-floating is-empty">
                        <label for="id-input" class="control-label">ID:</label>
                        <input type="text" class="form-control" id="id-input" name="id">
                    </div>
                    <div class="form-group label-floating is-empty">
                        <label for="firstname-input" class="control-label">First Name:</label>
                        <input type="text" class="form-control" id="firstname-input" name="firstname">
                    </div>
                    <div class="form-group label-floating is-empty">
                            <label for="lastname-input" class="control-label">Last Name :</label>
                            <input type="text" class="form-control" id="lastname-input" name="lastname">
                    </div>
                    <div class="form-group label-floating is-empty">
                            <label for="expiration-input" class="control-label">Expiration Date (yyyy/mm/dd):</label>
                            <input type="text" class="form-control" id="expiration-input" name="expiration">
                    </div>

                    <button class="btn btn-primary" onclick="checkCreditCard(<%=uid%>)">Confirm</button>
    </div>

    
    <%@ include file="footer.jsp"%>

    <script>
        $("#Cart-data").html(getCart());
    </script>
</body>
</html>