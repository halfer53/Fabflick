<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<html>
    <head>
        <%@ include file="head.jsp"%>
        <title>Single Anime</title>
    </head>
<body>
    <%
        
        String sid = (String)request.getParameter("id");
        Integer animeid = sid==null ? new Integer(0) : Integer.valueOf(sid);
    %>

    <%!
         private String getGenreByanimeID(Connection conn, int animeid) throws SQLException{
            StringBuffer sb = new StringBuffer();
            String query = "SELECT g.* FROM genres_in_animes as gm, genres as g WHERE gm.genre_id = g.id AND gm.anime_id = ?";
            PreparedStatement pst = conn.prepareStatement(query);
            pst.setInt(1,animeid);
            ResultSet rs = pst.executeQuery();
            sb.append("<ul class='list-inline'>");
            while(rs.next()){
                Integer gid = rs.getInt("id");
                String name = rs.getString("name");
                sb.append("<li><a href='/fabflix/jsp/Anime.jsp?genre="+name+ "'>");
                sb.append(name);
                sb.append("</a></li>");
            }
            sb.append("</ul>");
            pst.close();
            rs.close();
            return sb.toString();
        }

        

        private String getvoice_actorsByID(Connection conn, int animeid) throws SQLException{
            StringBuffer sb = new StringBuffer();
            String query = "SELECT s.* FROM voice_actors_in_animes as sm, voice_actors as s WHERE sm.voice_actor_id = s.id AND sm.anime_id = ?";
            PreparedStatement pst = conn.prepareStatement(query);
            pst.setInt(1,animeid);
            ResultSet rs = pst.executeQuery();
            sb.append("<ul class='list-inline'>");
            while(rs.next()){
                Integer sid = rs.getInt("id");
                String name = rs.getString("first_name")+" "+rs.getString("last_name");
                sb.append("<li><a href='/fabflix/jsp/SingleVoiceActor.jsp?id="+sid.toString()+ "'>");
                sb.append(name);
                sb.append("</a></li>");
            }
            sb.append("</ul>");
            pst.close();
            rs.close();
            return sb.toString();

        }

        String formatResult(Integer animeid){
            StringBuffer sb = new StringBuffer();
            try{
                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/animedb","root","cs122b" );
                
                String query = "SELECT * from animes where id = ?";
                PreparedStatement pst = conn.prepareStatement(query);
                pst.setInt(1,animeid);
                ResultSet rs = pst.executeQuery();
                sb.append("<div class='panel panel-default'><div class='panel-heading'>");
                while(rs.next()){
                    Integer aid = rs.getInt("id");
                    String title = rs.getString("title");
                    String ja_title = rs.getString("ja_title");
                    String director = rs.getString("director");
                    Integer year = rs.getInt("year");
                    Float rating = rs.getFloat("rating");
                    String picture_url = rs.getString("picture_url");
                    String description  = rs.getString("description");
                    sb.append("<span class='h3 single-anime-title'>"+title+"</span>");
                    sb.append("<button class='btn btn-default pull-right' onclick=\"addToCartByAttr("+aid.toString()+",1,'"+title+"')\">Add to Chart</button>");
                    sb.append("</div><div class='single-image'><img src='"+picture_url+"'></div>");
                    sb.append("<ul class='list-group'>");
                    sb.append("<li class='list-group-item'>Japanese Title:\t"+ja_title+"</li>");
                    sb.append("<li class='list-group-item'>Director:\t"+director+"</li>");
                    sb.append("<li class='list-group-item'>Year:\t"+year.toString()+"</li>");
                    sb.append("<li class='list-group-item'>Rating :\t"+rating.toString()+"</li>");
                    sb.append("<li class='list-group-item'>Genres :\t");
                    sb.append(getGenreByanimeID(conn,animeid));
                    sb.append("</li>");
                    sb.append("<li class='list-group-item'>Voice Actors :\t");
                    sb.append(getvoice_actorsByID(conn,animeid));
                    sb.append("</li>");
                    sb.append("</ul>");
                    sb.append("<div class='panel-body'><p>");
                    sb.append(description);
                    sb.append("</p></div>");
                    
                }
                sb.append("</div>");
                pst.close();
                rs.close();
                conn.close();
                
            }catch(Exception e){
                return e.getMessage();
            }
            return sb.toString();
        }

    %>

    <%@ include file="header.jsp"%>

    <div class="container">
    <%= formatResult(animeid) %>
    </div>

    
    <%@ include file="footer.jsp"%>
</body>
</html>