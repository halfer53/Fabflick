<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<html>
    <head>
        <%@ include file="../base/head.jsp"%>
        <title>Single Anime</title>
    </head>
<body>
    <%
        String sid = request.getParameter("id");
        Integer voice_actor_id = sid==null ? new Integer(0) : Integer.valueOf(sid);
    %>

    <%!
        String getAnimesGivenVA(Connection conn,Integer voice_actors_id) throws Exception{
            StringBuffer sb = new StringBuffer();
            String query = "SELECT DISTINCT a.* from animes as a,voice_actors_in_animes as va WHERE va.anime_id = a.id AND va.voice_actor_id = ?";
            PreparedStatement pst = conn.prepareStatement(query);
            pst.setInt(1,voice_actors_id);
            ResultSet rs = pst.executeQuery();
            sb.append("<div><h3>List of Animes </h3><ul class='list-inline'>");
            while(rs.next()){
                Integer animeid = rs.getInt("id");
                String title = rs.getString("title");
                sb.append("<li><a href='/fabflix/jsp/SingleAnime.jsp?id="+animeid+ "'>");
                sb.append(title);
                sb.append("</a></li>");
            }
            sb.append("</ul></div>");
            pst.close();
            rs.close();
            return sb.toString();
        }
        String formatResult(Integer voice_actor_id){
            StringBuffer sb = new StringBuffer();
            try{
                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/animedb","root","cs122b" );
                
                String query = "SELECT * from voice_actors where id = ?";
                PreparedStatement pst = conn.prepareStatement(query);
                pst.setInt(1,voice_actor_id);
                ResultSet rs = pst.executeQuery();
                while(rs.next()){
                    Integer gid = rs.getInt("id");
                    String firstname = rs.getString("first_name");
                    String lastname = rs.getString("last_name");
                    String photo_url = rs.getString("picture_url");
                    sb.append("<h3>"+firstname+" "+lastname+"</h3>");
                    sb.append("<p><img src='"+photo_url+"' ></p>");
                    sb.append(getAnimesGivenVA(conn,voice_actor_id));
                }
                pst.close();
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
    <%=formatResult(voice_actor_id)%>
    </div>

    
    <%@ include file="../base/footer.jsp"%>
</body>
</html>