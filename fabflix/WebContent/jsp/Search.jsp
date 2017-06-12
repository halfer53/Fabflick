<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*,javax.naming.InitialContext, javax.naming.Context, javax.sql.DataSource"%>
<%@ page contentType="text/html; charset=UTF-8" %>
<html>
    <head>
        <%@ include file="../base/head.jsp"%>
        <title>Search</title>
    </head>
<body>
    <%
        
    %>
    <%@ include file="../base/header.jsp"%>
    

    <div class="container">
        <div class="row">
            <div class="col-xs-6 center-block">
                <form action="/fabflix/jsp/Anime.jsp" id="search-anime">
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
                            <label for="voice_actor_firstname-input" class="control-label">Voice Actor's First Name :</label>
                            <input type="text" class="form-control" id="voice_actor_firstname-input" name="voice_actor_firstname">
                    </div>
                    <div class="form-group label-floating is-empty">
                            <label for="voice_actor_lastname-input" class="control-label">Voice Actor's Last Name :</label>
                            <input type="text" class="form-control" id="voice_actor_lastname-input" name="voice_actor_lastname">
                    </div>
                    <input  class="btn btn-primary" type="submit" value="submit">
                 </form>
            </div>
        </div>
    </div>
    <%@ include file="../base/footer.jsp"%>
</body>
</html>