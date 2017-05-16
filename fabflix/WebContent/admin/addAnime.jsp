<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<html>
    <head>
        <%@ include file="head.jsp"%>
        <title>Add new Anime</title>
    </head>
<body>
    <%!

    %>
    
    <%@ include file="header.jsp"%>
    
    <div class="container">
        <div class="row">
        <div class="col-xs-6 center-block">
        	<br><br><br><br><br><br><br><br><br><br>
            <div class="form-group label-floating is-empty">
                <label for="title" class="control-label">Title :</label>
                <input type="text" class="form-control" id="title">
            </div>
            <div class="form-group label-floating is-empty">
                    <label for="year" class="control-label">Year :</label>
                    <input type="text" class="form-control" id="year">
            </div>
            <div class="form-group label-floating is-empty">
                    <label for="director" class="control-label">Director :</label>
                    <input type="text" class="form-control" id="director">
            </div>
            <div class="form-group label-floating is-empty">
                    <label for="vafirstname" class="control-label">Voice Actor First Name :</label>
                    <input type="text" class="form-control" id="vafirstname">
            </div>
            <div class="form-group label-floating is-empty">
                    <label for=""valastname"" class="control-label">Voice Actor Last Name :</label>
                    <input type="text" class="form-control" id="valastname">
            </div>
            <div class="form-group label-floating is-empty">
                    <label for="genre" class="control-label">Genre :</label>
                    <input type="text" class="form-control" id="genre">
            </div>
             <button class="btn btn-primary" type="button" onclick="JavaScript:addNewAnime()">Log In</button>
        </div>
        </div>
    </div>
    <%@ include file="footer.jsp"%>
</body>
</html>