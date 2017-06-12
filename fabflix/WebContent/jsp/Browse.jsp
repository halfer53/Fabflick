<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*,javax.naming.InitialContext, javax.naming.Context, javax.sql.DataSource"%>
<%@ page contentType="text/html; charset=UTF-8" %>
<html>
    <head>
        <%@ include file="../base/head.jsp"%>
        <title>Browse</title>
    </head>
<body>
    <%!
         String getAllGenre(){
            StringBuffer sb = new StringBuffer();
            try{
            	
                //Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/animedb","root","cs122b" );
                Context initCtx = new InitialContext();
                 Context envCtx = (Context) initCtx.lookup("java:comp/env");
                 DataSource ds = (DataSource) envCtx.lookup("jdbc/AnimeDB");
                 Connection conn = ds.getConnection();
                 
                String query = "SELECT * from genres";
                PreparedStatement stmt = conn.prepareStatement(query);
                

                ResultSet rs = stmt.executeQuery();
                while(rs.next()){
                    String name = rs.getString("name");
                    sb.append("<li class=\"\"><a href=\"/fabflix/jsp/Anime.jsp?genre="+name+"\">"+name+"</a></li>\n");
                }
                stmt.close();
                rs.close();
                conn.close();
                
            }catch(Exception e){
                e.printStackTrace();
            }
            return sb.toString();
        }
    %>
    
    <%@ include file="../base/header.jsp"%>
    <div class="container">
    <h3 id="b_genre">Browse by genre</h3>
    <ul class="list-inline">
        <%=getAllGenre()%>
        
    </ul>

    <h3 id="b_firstchar">Browse by First Character</h3>
    <ul class="list-inline">
        <li class=''><a href='/fabflix/jsp/Anime.jsp?title_start_with=a'>A</a></li>
        <li class=''><a href='/fabflix/jsp/Anime.jsp?title_start_with=b'>B</a></li>
        <li class=''><a href='/fabflix/jsp/Anime.jsp?title_start_with=c'>C</a></li>
        <li class=''><a href='/fabflix/jsp/Anime.jsp?title_start_with=d'>D</a></li>
        <li class=''><a href='/fabflix/jsp/Anime.jsp?title_start_with=e'>E</a></li>
        <li class=''><a href='/fabflix/jsp/Anime.jsp?title_start_with=f'>F</a></li>
        <li class=''><a href='/fabflix/jsp/Anime.jsp?title_start_with=g'>G</a></li>
        <li class=''><a href='/fabflix/jsp/Anime.jsp?title_start_with=h'>H</a></li>
        <li class=''><a href='/fabflix/jsp/Anime.jsp?title_start_with=i'>I</a></li>
        <li class=''><a href='/fabflix/jsp/Anime.jsp?title_start_with=j'>J</a></li>
        <li class=''><a href='/fabflix/jsp/Anime.jsp?title_start_with=k'>K</a></li>
        <li class=''><a href='/fabflix/jsp/Anime.jsp?title_start_with=l'>L</a></li>
        <li class=''><a href='/fabflix/jsp/Anime.jsp?title_start_with=m'>M</a></li>
        <li class=''><a href='/fabflix/jsp/Anime.jsp?title_start_with=n'>N</a></li>
        <li class=''><a href='/fabflix/jsp/Anime.jsp?title_start_with=o'>O</a></li>
        <li class=''><a href='/fabflix/jsp/Anime.jsp?title_start_with=p'>P</a></li>
        <li class=''><a href='/fabflix/jsp/Anime.jsp?title_start_with=q'>Q</a></li>
        <li class=''><a href='/fabflix/jsp/Anime.jsp?title_start_with=r'>R</a></li>
        <li class=''><a href='/fabflix/jsp/Anime.jsp?title_start_with=s'>S</a></li>
        <li class=''><a href='/fabflix/jsp/Anime.jsp?title_start_with=t'>T</a></li>
        <li class=''><a href='/fabflix/jsp/Anime.jsp?title_start_with=u'>U</a></li>
        <li class=''><a href='/fabflix/jsp/Anime.jsp?title_start_with=v'>V</a></li>
        <li class=''><a href='/fabflix/jsp/Anime.jsp?title_start_with=w'>W</a></li>
        <li class=''><a href='/fabflix/jsp/Anime.jsp?title_start_with=x'>X</a></li>
        <li class=''><a href='/fabflix/jsp/Anime.jsp?title_start_with=y'>Y</a></li>
        <li class=''><a href='/fabflix/jsp/Anime.jsp?title_start_with=z'>Z</a></li>
    </ul>
    </div>
    <%@ include file="../base/footer.jsp"%>
</body>
</html>