<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<html>
    <head>
        <%@ include file="head.jsp"%>
        <title>Browse</title>
    </head>
<body>
    <%
         
    %>
    
    <%@ include file="header.jsp"%>
    <div class="container">
    <h3>Browse by genre</h3>
    <ul class="list-inline">
        <li class=""><a href="/fabflix/jsp/Movie.jsp?genre=classic">classic</a></li>
        <li class=""><a href="/fabflix/jsp/Movie.jsp?genre=advanture">advanture</a></li>
        <li class=""><a href="/fabflix/jsp/Movie.jsp?genre=kid">kid</a></li>
        <li class=""><a href="/fabflix/jsp/Movie.jsp?genre=musial">musial</a></li>
        <li class=""><a href="/fabflix/jsp/Movie.jsp?genre=arts">arts</a></li>
        <li class=""><a href="/fabflix/jsp/Movie.jsp?genre=SCI/FI">SCI/FI</a></li>
        <li class=""><a href="/fabflix/jsp/Movie.jsp?genre=Commedy">Commedy</a></li>
        <li class=""><a href="/fabflix/jsp/Movie.jsp?genre=Coming-of-Age-Drama">Coming-of-Age-Drama</a></li>
        <li class=""><a href="/fabflix/jsp/Movie.jsp?genre=Detective">Detective</a></li>
        <li class=""><a href="/fabflix/jsp/Movie.jsp?genre=Gangster">Gangster</a></li>
        <li class=""><a href="/fabflix/jsp/Movie.jsp?genre=Love">Love</a></li>
        <li class=""><a href="/fabflix/jsp/Movie.jsp?genre=Suspense">Suspense</a></li>
        <li class=""><a href="/fabflix/jsp/Movie.jsp?genre=Indie">Indie</a></li>
        <li class=""><a href="/fabflix/jsp/Movie.jsp?genre=epics">epics</a></li>
        <li class=""><a href="/fabflix/jsp/Movie.jsp?genre=spy">spy</a></li>
        <li class=""><a href="/fabflix/jsp/Movie.jsp?genre=JamesBond">JamesBond</a></li>
        <li class=""><a href="/fabflix/jsp/Movie.jsp?genre=Roman">Roman</a></li>
        <li class=""><a href="/fabflix/jsp/Movie.jsp?genre=Epics/Historial">Epics/Historial</a></li>
        <li class=""><a href="/fabflix/jsp/Movie.jsp?genre=Tragedy">Tragedy</a></li>
        <li class=""><a href="/fabflix/jsp/Movie.jsp?genre=SciFi">SciFi</a></li>
        <li class=""><a href="/fabflix/jsp/Movie.jsp?genre=Animation">Animation</a></li>
        <li class=""><a href="/fabflix/jsp/Movie.jsp?genre=Film-Noir">Film-Noir</a></li>
        <li class=""><a href="/fabflix/jsp/Movie.jsp?genre=Musical">Musical</a></li>
        <li class=""><a href="/fabflix/jsp/Movie.jsp?genre=Mystery">Mystery</a></li>
        <li class=""><a href="/fabflix/jsp/Movie.jsp?genre=Short">Short</a></li>
        <li class=""><a href="/fabflix/jsp/Movie.jsp?genre=Western">Western</a></li>
        <li class=""><a href="/fabflix/jsp/Movie.jsp?genre=ScienceFiction/Fantasy">ScienceFiction/Fantasy</a></li>
        <li class=""><a href="/fabflix/jsp/Movie.jsp?genre=Documentary">Documentary</a></li>
        <li class=""><a href="/fabflix/jsp/Movie.jsp?genre=Musical/PerformingArts">Musical/PerformingArts</a></li>
        <li class=""><a href="/fabflix/jsp/Movie.jsp?genre=Crime">Crime</a></li>
        <li class=""><a href="/fabflix/jsp/Movie.jsp?genre=Music">Music</a></li>
        <li class=""><a href="/fabflix/jsp/Movie.jsp?genre=Crime/Gangster">Crime/Gangster</a></li>
        <li class=""><a href="/fabflix/jsp/Movie.jsp?genre=Epics/Historical">Epics/Historical</a></li>
        <li class=""><a href="/fabflix/jsp/Movie.jsp?genre=Musicals">Musicals</a></li>
        <li class=""><a href="/fabflix/jsp/Movie.jsp?genre=ScienceFiction">ScienceFiction</a></li>
        <li class=""><a href="/fabflix/jsp/Movie.jsp?genre=War">War</a></li>
        <li class=""><a href="/fabflix/jsp/Movie.jsp?genre=Westerns">Westerns</a></li>
        <li class=""><a href="/fabflix/jsp/Movie.jsp?genre=Family">Family</a></li>
        <li class=""><a href="/fabflix/jsp/Movie.jsp?genre=Action">Action</a></li>
        <li class=""><a href="/fabflix/jsp/Movie.jsp?genre=Adventure">Adventure</a></li>
        <li class=""><a href="/fabflix/jsp/Movie.jsp?genre=Drama">Drama</a></li>
        <li class=""><a href="/fabflix/jsp/Movie.jsp?genre=Comedy">Comedy</a></li>
        <li class=""><a href="/fabflix/jsp/Movie.jsp?genre=Horror">Horror</a></li>
        <li class=""><a href="/fabflix/jsp/Movie.jsp?genre=Thriller">Thriller</a></li>
        <li class=""><a href="/fabflix/jsp/Movie.jsp?genre=Foreign">Foreign</a></li>
        <li class=""><a href="/fabflix/jsp/Movie.jsp?genre=Sci-Fi">Sci-Fi</a></li>
        <li class=""><a href="/fabflix/jsp/Movie.jsp?genre=Romance">Romance</a></li>
        <li class=""><a href="/fabflix/jsp/Movie.jsp?genre=Fantasy">Fantasy</a></li>
    </ul>

    <h3>Browse by First Character</h3>
    <ul class="list-inline">
        <li class=''><a href='/fabflix/jsp/Movie.jsp?title_start_with=a'>A</a></li>
        <li class=''><a href='/fabflix/jsp/Movie.jsp?title_start_with=b'>B</a></li>
        <li class=''><a href='/fabflix/jsp/Movie.jsp?title_start_with=c'>C</a></li>
        <li class=''><a href='/fabflix/jsp/Movie.jsp?title_start_with=d'>D</a></li>
        <li class=''><a href='/fabflix/jsp/Movie.jsp?title_start_with=e'>E</a></li>
        <li class=''><a href='/fabflix/jsp/Movie.jsp?title_start_with=f'>F</a></li>
        <li class=''><a href='/fabflix/jsp/Movie.jsp?title_start_with=g'>G</a></li>
        <li class=''><a href='/fabflix/jsp/Movie.jsp?title_start_with=h'>H</a></li>
        <li class=''><a href='/fabflix/jsp/Movie.jsp?title_start_with=i'>I</a></li>
        <li class=''><a href='/fabflix/jsp/Movie.jsp?title_start_with=j'>J</a></li>
        <li class=''><a href='/fabflix/jsp/Movie.jsp?title_start_with=k'>K</a></li>
        <li class=''><a href='/fabflix/jsp/Movie.jsp?title_start_with=l'>L</a></li>
        <li class=''><a href='/fabflix/jsp/Movie.jsp?title_start_with=m'>M</a></li>
        <li class=''><a href='/fabflix/jsp/Movie.jsp?title_start_with=n'>N</a></li>
        <li class=''><a href='/fabflix/jsp/Movie.jsp?title_start_with=o'>O</a></li>
        <li class=''><a href='/fabflix/jsp/Movie.jsp?title_start_with=p'>P</a></li>
        <li class=''><a href='/fabflix/jsp/Movie.jsp?title_start_with=q'>Q</a></li>
        <li class=''><a href='/fabflix/jsp/Movie.jsp?title_start_with=r'>R</a></li>
        <li class=''><a href='/fabflix/jsp/Movie.jsp?title_start_with=s'>S</a></li>
        <li class=''><a href='/fabflix/jsp/Movie.jsp?title_start_with=t'>T</a></li>
        <li class=''><a href='/fabflix/jsp/Movie.jsp?title_start_with=u'>U</a></li>
        <li class=''><a href='/fabflix/jsp/Movie.jsp?title_start_with=v'>V</a></li>
        <li class=''><a href='/fabflix/jsp/Movie.jsp?title_start_with=w'>W</a></li>
        <li class=''><a href='/fabflix/jsp/Movie.jsp?title_start_with=x'>X</a></li>
        <li class=''><a href='/fabflix/jsp/Movie.jsp?title_start_with=y'>Y</a></li>
        <li class=''><a href='/fabflix/jsp/Movie.jsp?title_start_with=z'>Z</a></li>
    </ul>
    </div>
    <%@ include file="footer.jsp"%>
</body>
</html>