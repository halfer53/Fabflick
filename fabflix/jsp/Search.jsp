<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%> 
<html>
    <head>
        <%@ include file="head.jsp"%>
        <title>Search</title>
    </head>
<body>
    <%
        Integer uid = (Integer)session.getAttribute("uid");
    %>
    <%@ include file="header.jsp"%>
    

    <div class="container">
        <div class="row">
            <div class="col-xs-6 center-block">
                <form action="/fabflix/jsp/Movie.jsp">
                    <div class="form-group label-floating is-empty">
                        <label for="title-input" class="control-label">Title:</label>
                        <input type="text" class="form-control" id="title-input" name="title">
                    </div>
                    <div class="form-group label-floating is-empty">
                            <label for="year-input" class="control-label">Year :</label>
                            <input type="text" class="form-control" id="year-input" name="year">
                    </div>
                    <div class="form-group label-floating is-empty">
                            <label for="director-input" class="control-label">Director :</label>
                            <input type="text" class="form-control" id="director-input" name="director">
                    </div>
                    <div class="form-group label-floating is-empty">
                            <label for="star_firstname-input" class="control-label">Star's First Name :</label>
                            <input type="text" class="form-control" id="star_firstname-input" name="star_firstname">
                    </div>
                    <div class="form-group label-floating is-empty">
                            <label for="star_lastname-input" class="control-label">Star's Last Name :</label>
                            <input type="text" class="form-control" id="star_lastname-input" name="star_lastname">
                    </div>
                    <input  class="btn btn-primary" type="submit" value="submit">
                 </form>
            </div>
        </div>
    </div>
    <%@ include file="footer.jsp"%>
</body>
</html>