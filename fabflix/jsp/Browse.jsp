<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%> 
<html>
    <head>
        <%@ include file="head.jsp"%>
        <title>Browse</title>
    </head>
<body>
    <%
        Integer uid = (Integer)session.getAttribute("uid");
        
          
    %>
    <%!
        private String getRightButton(Integer uid){
            if(uid == null){
                return "<li class='pull-right'><a href='/fabflix'>Login</a></li> ";
            }
            return "<li class='pull-right'><a href='/fabflix/jsp/ShoppingCart.jsp'>Shopping Cart</a></li> ";

        }

    %>
    <div class="container-fluid mb-70">
        <nav class="navbar navbar-default navbar-fixed-top"> 
            <div class="container-fluid"> <div class="navbar-header"> 
                <button type="button" class="collapsed navbar-toggle" data-toggle="collapse" data-target="#bs-example-navbar-collapse-6" aria-expanded="false"> 
                <span class="sr-only">Toggle navigation</span> 
                <span class="icon-bar"></span>
                 <span class="icon-bar"></span> 
                 <span class="icon-bar"></span> 
                 </button> <a href="/fabflix/jsp/Main.jsp" class="navbar-brand">Fabflix</a> 
            </div>
             <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-6"> 
             <ul class="nav navbar-nav"> 
                 <li><a href="/fabflix/jsp/Main.jsp">Main</a></li>
                 <li class="active"><a href="#">Browse</a></li>
                 <li><a href="/fabflix/jsp/Movie.jsp">Movies</a></li> 
                 <li><a href="/fabflix/jsp/Search.jsp">Search</a></li>
                 <%=getRightButton(uid)%>
             </ul> 
             </div> 
            </div> 
        </nav>
    </div>
    

    To Be Implemented
    <%@ include file="footer.jsp"%>
</body>
</html>