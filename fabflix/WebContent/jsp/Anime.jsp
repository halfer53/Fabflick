<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<html>
    <head>
        <%@ include file="../base/head.jsp"%>
        <title>anime</title>
    </head>
<body>
    
    <%  
        Integer LIMIT = parseParaInt(request.getParameter("limit"));
        LIMIT = LIMIT==null? 20 : LIMIT;
        String spage = request.getParameter("page");
        Integer start = spage == null ? new Integer(0) : Integer.valueOf(spage) * LIMIT;

        String title = setEmptyIfNull(request.getParameter("title"));
        Integer year = parseParaInt(request.getParameter("year"));
        String director = setEmptyIfNull(request.getParameter("director"));
        String voice_actor_firstname = setEmptyIfNull(request.getParameter("voice_actor_firstname"));
        String voice_actor_lastname = setEmptyIfNull(request.getParameter("voice_actor_lastname"));
        String sortby = request.getParameter("sortby");
        String sorttype = request.getParameter("sorttype");
        

        String genre = request.getParameter("genre");

        String title_start_with = request.getParameter("title_start_with");

        String queryParameter = request.getQueryString();
        queryParameter = queryParameter == null ? "" : queryParameter;
        String url = request.getRequestURL()+"?"+queryParameter;
    %>


    <%@ include file="../base/header.jsp"%>



    <%! 
        public String setEmptyIfNull(String input){
            input = input==null ? "" : input;
            if(!input.contains("%")){
                return "%"+input+"%";
            }
            return input;
        }

        public Integer parseParaInt(String input){

                return (input==null || input.isEmpty()) ? null : Integer.valueOf(input);
        }

        public String sortQuery(String input_query, String sortby, String sorttype){

            ArrayList<String> sortTypeList = new ArrayList<String>(Arrays.asList("year", "title","rating"));
            String squery = " ORDER BY ";
            String stype_a = " ASC";
            String stype_d = " DESC";


            String query = "SELECT * FROM (" + input_query + ") as a";
            if(sortby != null && sortTypeList.contains(sortby)){

                query += squery + sortby ;
                //sorttype
                if(sorttype != null){
                    if(sorttype.equalsIgnoreCase("asc")){
                        query += stype_a;
                    }else if(sorttype.equalsIgnoreCase("desc")){
                        query += stype_d;
                    }
                }
                
            }
            return query;
        }

        private String getGenreQuery(String genre){

            return "SELECT DISTINCT m.* FROM genres_in_animes as gm, animes as m, genres as g WHERE gm.anime_id = m.id AND gm.genre_id = g.id AND g.name = '"+genre+"' LIMIT ?,?";
        }

        private String getanimeTitleStartWithQuery(String title_start_with){
            return "SELECT * FROM animes WHERE title LIKE '"+title_start_with+"%' LIMIT ?,?";
        }

        private String getanimeQuery(String title,Integer year,String director,String voice_actor_firstname,String voice_actor_lastname){
            String query = "SELECT DISTINCT m.* FROM voice_actors_in_animes as sm, voice_actors as s, animes as m WHERE sm.voice_actor_id = s.id AND sm.anime_id = m.id AND s.first_name LIKE '"+voice_actor_firstname+"' AND s.last_name LIKE '" +voice_actor_lastname+"' AND m.title LIKE '"+title+"' AND m.director LIKE '"+director+"' ";
            String yquery = "AND m.year = ";
            String lquery = " LIMIT ?,?";
            if(year != null){
                query += (yquery + year.toString());
            }
            query += lquery;
            return query;
        }

        private String getanimeListByTitleStart(String title_start,Integer start, Integer LIMIT,String sortby,String sorttype){
            String query="";
            try{
                Class.forName("com.mysql.jdbc.Driver").newInstance();
                try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/animedb","root","cs122b" )) {
                        query = sortQuery(getanimeTitleStartWithQuery(title_start),sortby,sorttype);
                        try(PreparedStatement stmt = conn.prepareStatement(query)) {
                            stmt.setInt(1,start);
                            stmt.setInt(2,LIMIT);
                            try(ResultSet rs = stmt.executeQuery()){
                                return formatResult(conn,rs);
                            }
                        }  
                  }
               
            }catch(Exception e){
                return query + " "+e.getMessage();
            }

        }

        private String getanimeListByGenre(String genre,Integer start, Integer LIMIT,String sortby, String sorttype){
            String query="";
            try{

                Class.forName("com.mysql.jdbc.Driver").newInstance();
                try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/animedb","root","cs122b" )) {
                        query = sortQuery(getGenreQuery(genre),sortby,sorttype);
                        try(PreparedStatement stmt = conn.prepareStatement(query)) {
                            stmt.setInt(1,start);
                            stmt.setInt(2,LIMIT);
                            try(ResultSet rs = stmt.executeQuery()){
                                return formatResult(conn,rs);
                            }
                        }  
                  }
               
            }catch(Exception e){
                return query + " "+e.getMessage();
            }

        }

        public String getSortClass(String sortby, String this_sortby, String sorttype){
            String r = "class='sortable ";
            if(sortby != null && sortby.equals(this_sortby)){
                if(sorttype == null){
                return r+"both'";
                }else if(sorttype.equals("asc")){
                    return r+"asc'";
                }else if(sorttype.equals("desc")){
                    return r+"desc'";
                }
            }
            return r+"both'";
            
        }


        private String getGenreByanimeID(Connection conn, int animeid) throws SQLException{
            StringBuffer sb = new StringBuffer();
            String query = "SELECT g.* FROM genres_in_animes as gm, genres as g WHERE gm.genre_id = g.id AND gm.anime_id = ?";
            PreparedStatement pst = conn.prepareStatement(query);
            pst.setInt(1,animeid);
            ResultSet rs = pst.executeQuery();
            int counter = 0;
            while(rs.next()){
                Integer gid = rs.getInt("id");
                String name = rs.getString("name");
                if(counter == 5){
                    sb.append("<span class=\"complete\">");
                }
                sb.append("<a href='/fabflix/jsp/Anime.jsp?genre="+name+ "'>");
                sb.append(name);
                sb.append("</a><br>");
                counter++;
            }
            if(counter > 5){
                sb.append("</span>");
                sb.append("<button class=\"btn btn-default center-block more\">more...</button>");
            }
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
            int counter = 0;
            while(rs.next()){
                Integer sid = rs.getInt("id");
                String name = rs.getString("first_name")+" "+rs.getString("last_name");
                if(counter == 5){
                    sb.append("<span class=\"complete\">");
                }
                sb.append("<a href='/fabflix/jsp/SingleVoiceActor.jsp?id="+sid.toString()+ "'>");
                sb.append(name);
                sb.append("</a><br>");
                counter++;
            }
            if(counter > 5){
                sb.append("</span>");
                sb.append("<button class=\"btn btn-default center-block more\">more...</button>");
            }
            pst.close();
            rs.close();
            return sb.toString();

        }

        private String getanimeList(String title,Integer year,String director,String voice_actor_firstname,String voice_actor_lastname,String genre, String title_start_with, Integer start,Integer LIMIT,String sortby, String sorttype) throws SQLException {
            String query = "";
            
            try{
                if(genre != null && !genre.isEmpty()){
                    return getanimeListByGenre(genre,start,LIMIT,sortby,sorttype);
                }else if(title_start_with != null && !title_start_with.isEmpty()){
                    return getanimeListByTitleStart(title_start_with,start,LIMIT,sortby,sorttype);
                }else{
                    return getanimeListGeneral(title,year,director,voice_actor_firstname,voice_actor_lastname,start,LIMIT,sortby,sorttype);
                }
              
            }catch(Exception e){
            //for debugging purpose only, delete this when it's officially deployed
                return query + e.getMessage();
            }
        }

       private String getanimeListGeneral (String title,Integer year,String director,String voice_actor_firstname,String voice_actor_lastname,Integer start,Integer LIMIT,String sortby, String sorttype) throws SQLException {
            

            String query = "";
            
            try{
                Class.forName("com.mysql.jdbc.Driver").newInstance();
                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/animedb","root","cs122b" );

                String anime_query = getanimeQuery(title,year,director,voice_actor_firstname,voice_actor_lastname);
                query = sortQuery(anime_query,sortby,sorttype);

                PreparedStatement pst = conn.prepareStatement(query);
                pst.setInt(1,start);
                pst.setInt(2,LIMIT);
                
                ResultSet mrs = pst.executeQuery();

                String result = formatResult(conn,mrs);

                mrs.close();
                pst.close();
                conn.close();

                return result;
              
            }catch(Exception e){
            //for debugging purpose only, delete this when it's officially deployed
                return query + e.getMessage();
            }
      }
      private String formatResult(Connection conn,ResultSet rs) throws SQLException {
         StringBuffer sb = new StringBuffer();
        
         while (rs.next()){
            Integer m_id = rs.getInt("id");
            String m_title = rs.getString("title");
            String m_director = rs.getString("director");
            Integer m_year = rs.getInt("year");
            Float m_rating = rs.getFloat("rating");
            sb.append(  "<tr>" + "<td>" + m_id + "</td>" + 
                        "<td><a class='anime-row' id='"+m_id +"' href='/fabflix/jsp/SingleAnime.jsp?id="+m_id + "'>" + m_title + "</a></td>" + 
                        "<td>" + m_director + "</td>" +
                        "<td>" + m_rating.toString() + "</td>" +
                        "<td>" + m_year.toString() + "</td>" +
                        "<td>" + getGenreByanimeID(conn,m_id) + "</td>" +
                        "<td>" + getvoice_actorsByID(conn,m_id) + "</td>" +
                        "<td><div><input type='text' class='form-control text-center' aria-label='...' value='1' title='"+m_title+"' id='th-"+ m_id+ "'></div><div class='text-center'><button type='button' class='btn btn-default' onclick='addToCartByInput("+ m_id+ ")'>Add to Cart</button></div> </td>" +
                    "</tr>\n");
        }
        
        return sb.toString();
      }

      private String getPage(String title,Integer year,String director,String voice_actor_firstname,String voice_actor_lastname,String genre, String title_start_with,Integer start, Integer LIMIT,String url) throws SQLException{
            String query = "";
            if(genre != null && !genre.isEmpty()){
                query = getGenreQuery(genre);//genre,start,LIMIT
            }else if(title_start_with != null && !title_start_with.isEmpty()){
                query = getanimeTitleStartWithQuery(title_start_with);
            }else{
                query = getanimeQuery(title,year,director,voice_actor_firstname,voice_actor_lastname);
            }
            return pageCursor(query,start,LIMIT,url);

      }

      private String pageCursor(String query, Integer start, Integer LIMIT,String url) throws SQLException{

        StringBuffer sb = new StringBuffer();
        String curl = url.replaceAll("[&]?page=[0-9]+","");
        curl = curl.replaceAll("[&]?sortby=[a-z]+","");
        curl = curl.replaceAll("[&]?sorttype=[a-z]+","");

        int page_num = start / LIMIT ;
        if(start > 0){
            sb.append("<nav aria-label='...'><ul class='pager'><li class='previous pull-left'><a href='");
        }else{
            sb.append("<nav aria-label='...'><ul class='pager'><li class='previous pull-left'><a class='btn disabled' href='");
        }
        
        sb.append(curl+"&page="+Integer.toString(page_num-1));
        sb.append("'><span aria-hidden='true'>&larr;</span> Previous</a></li>");
        sb.append("<li class='center-block'><a class='disabled' href='#'>");
        page_num++;
        sb.append(Integer.toString(page_num));
        sb.append("</a></li>");
        if(hasPage(query,start, LIMIT)){
            sb.append("<li class='next pull-right'><a href='");
        }else{
            sb.append("<li class='next pull-right'><a class='btn disabled' href='");
        }
            sb.append(curl+"&page="+Integer.toString(page_num));
            sb.append("'>Next <span aria-hidden='true'>&rarr;</span></a></li>");
        
        sb.append("</ul></nav>");
        return sb.toString();
      }

      private boolean hasPage(String query,Integer start, Integer LIMIT) throws SQLException{
        try{
            Class.forName("com.mysql.jdbc.Driver").newInstance();
            try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/animedb","root","cs122b" )) {
                    try(PreparedStatement stmt = conn.prepareStatement(query)) {
                        stmt.setInt(1,start+LIMIT);
                        stmt.setInt(2,LIMIT);
                        try(ResultSet rs = stmt.executeQuery()){
                            if(rs.next()){
                                return true;
                            }
                        }
                    }  
              }
           
        }catch(Exception e){
            e.printStackTrace();
        }
        return false;
    }
        
    
    %>
    <div class="container-fluid">
        <div class="table-responsive anime-table">
            <table width="100%" class="table table-hover">
                <thead>
                    <tr>
                       <th>ID</th>
                       <th id="th-title"><div onclick="requestSort(this.className,'title')" <%= getSortClass(sortby,"title",sorttype) %>>Title</div></th>
                       <th>Director</th>
                       <th id="th-year"><div onclick="requestSort(this.className,'rating')" <%= getSortClass(sortby,"rating",sorttype) %>>Rating</div></th>
                       <th id="th-year"><div onclick="requestSort(this.className,'year')" <%= getSortClass(sortby,"year",sorttype) %>>Year</div></th>
                       <th>Genres</th>
                       <th>voice_actors</th>
                    </tr>
                </thead>
                <%= getanimeList(title,year,director,voice_actor_firstname,voice_actor_lastname,genre,title_start_with,start,LIMIT,sortby,sorttype) %>
                
            </table>

            
            
        </div>
        <div class="dropup pull-right">
                      <button href="" data-target="#" class="dropdown-toggle btn btn-primary" data-toggle="dropdown" aria-expanded="false"><%=LIMIT%>
                        <b class="caret"></b><div class="ripple-container"></div></button>
                      <ul class="dropdown-menu">
                        <li><a href="javascript:void(0)" onclick="changePageItemNum(10)">10</a></li>
                        <li><a href="javascript:void(0)" onclick="changePageItemNum(20)">20</a></li>
                        <li><a href="javascript:void(0)" onclick="changePageItemNum(30)">30</a></li>
                        <li><a href="javascript:void(0)" onclick="changePageItemNum(40)">40</a></li>
                        <li><a href="javascript:void(0)" onclick="changePageItemNum(50)">50</a></li>
                      </ul>
            </div>
            <div class="clearfix"></div>
        <%= getPage(title,year,director,voice_actor_firstname,voice_actor_lastname,genre,title_start_with,start,LIMIT,url) %>
    </div>

    
    
    
    <%@ include file="../base/footer.jsp"%>
</body>
</html>