<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<html>
    <head>
        <%@ include file="head.jsp"%>
        <title>Movie</title>
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
        String star_firstname = setEmptyIfNull(request.getParameter("star_firstname"));
        String star_lastname = setEmptyIfNull(request.getParameter("star_lastname"));
        String sortby = request.getParameter("sortby");
        String sorttype = request.getParameter("sorttype");
        

        String genre = request.getParameter("genre");

        String title_start_with = request.getParameter("title_start_with");

        String queryParameter = request.getQueryString();
        queryParameter = queryParameter == null ? "" : queryParameter;
        String url = request.getRequestURL()+"?"+queryParameter;
    %>


    <%@ include file="header.jsp"%>



    <%! 
        public String setEmptyIfNull(String input){
            return input==null ? "%" : input;
        }

        public Integer parseParaInt(String input){
            return (input==null || input.isEmpty()) ? null : Integer.valueOf(input);
        }

        public String sortQuery(String input_query, String sortby, String sorttype){

            ArrayList<String> sortTypeList = new ArrayList<String>(Arrays.asList("year", "title"));
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

            return "SELECT DISTINCT m.* FROM genres_in_movies as gm, movies as m, genres as g WHERE gm.movie_id = m.id AND gm.genre_id = g.id AND g.name = '"+genre+"' LIMIT ?,?";
        }

        private String getMovieTitleStartWithQuery(String title_start_with){
            return "SELECT * FROM movies WHERE title LIKE '"+title_start_with+"%' LIMIT ?,?";
        }

        private String getMovieQuery(String title,Integer year,String director,String star_firstname,String star_lastname){
            String query = "SELECT DISTINCT m.* FROM stars_in_movies as sm, stars as s, movies as m WHERE sm.star_id = s.id AND sm.movie_id = m.id AND s.first_name LIKE '%"+star_firstname+"%' AND s.last_name LIKE '%" +star_lastname+"%' AND m.title LIKE '%"+title+"%' AND m.director LIKE '%"+director+"%' ";
            String yquery = "AND m.year = ";
            String lquery = " LIMIT ?,?";
            if(year != null){
                query += (yquery + year.toString());
            }
            query += lquery;
            return query;
        }

        private String getMovieListByTitleStart(String title_start,Integer start, Integer LIMIT,String sortby,String sorttype){
            String query="";
            try{
                Class.forName("com.mysql.jdbc.Driver").newInstance();
                try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/moviedb","root","cs122b" )) {
                        query = sortQuery(getMovieTitleStartWithQuery(title_start),sortby,sorttype);
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

        private String getMovieListByGenre(String genre,Integer start, Integer LIMIT,String sortby, String sorttype){
            String query="";
            try{

                Class.forName("com.mysql.jdbc.Driver").newInstance();
                try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/moviedb","root","cs122b" )) {
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

        public String getSortClass(String sortby, Integer isortby, String sorttype){
            String r = "class='sortable ";
            String this_sortby = isortby == 1? "title" : "year";
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


        private String getGenreByMovieID(Connection conn, int movieid) throws SQLException{
            StringBuffer sb = new StringBuffer();
            String query = "SELECT g.* FROM genres_in_movies as gm, genres as g WHERE gm.genre_id = g.id AND gm.movie_id = ?";
            PreparedStatement pst = conn.prepareStatement(query);
            pst.setInt(1,movieid);
            ResultSet rs = pst.executeQuery();

            while(rs.next()){
                Integer gid = rs.getInt("id");
                String name = rs.getString("name");
                sb.append("<a href='/fabflix/jsp/Movie.jsp?genre="+name+ "'>");
                sb.append(name);
                sb.append("</a><br>");
            }
            pst.close();
            rs.close();
            return sb.toString();

        }

        

        private String getStarsByID(Connection conn, int movieid) throws SQLException{
            StringBuffer sb = new StringBuffer();
            String query = "SELECT s.* FROM stars_in_movies as sm, stars as s WHERE sm.star_id = s.id AND sm.movie_id = ?";
            PreparedStatement pst = conn.prepareStatement(query);
            pst.setInt(1,movieid);
            ResultSet rs = pst.executeQuery();

            while(rs.next()){
                Integer sid = rs.getInt("id");
                String name = rs.getString("first_name")+" "+rs.getString("last_name");
                sb.append("<a href='/fabflix/jsp/SingleStar.jsp?id="+sid.toString()+ "'>");
                sb.append(name);
                sb.append("</a><br>");
            }
            pst.close();
            rs.close();
            return sb.toString();

        }

        private String getMovieList(String title,Integer year,String director,String star_firstname,String star_lastname,String genre, String title_start_with, Integer start,Integer LIMIT,String sortby, String sorttype) throws SQLException {
            String query = "";
            
            try{
                if(genre != null && !genre.isEmpty()){
                    return getMovieListByGenre(genre,start,LIMIT,sortby,sorttype);
                }else if(title_start_with != null && !title_start_with.isEmpty()){
                    return getMovieListByTitleStart(title_start_with,start,LIMIT,sortby,sorttype);
                }else{
                    return getMovieListGeneral(title,year,director,star_firstname,star_lastname,start,LIMIT,sortby,sorttype);
                }
              
            }catch(Exception e){
            //for debugging purpose only, delete this when it's officially deployed
                return query + e.getMessage();
            }
        }

       private String getMovieListGeneral (String title,Integer year,String director,String star_firstname,String star_lastname,Integer start,Integer LIMIT,String sortby, String sorttype) throws SQLException {
            

            String query = "";
            
            try{
                Class.forName("com.mysql.jdbc.Driver").newInstance();
                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/moviedb","root","cs122b" );

                String movie_query = getMovieQuery(title,year,director,star_firstname,star_lastname);
                query = sortQuery(movie_query,sortby,sorttype);

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
            String m_banner_url = rs.getString("banner_url");
            String m_trailer_url = rs.getString("trailer_url");
            sb.append(  "<tr>" + "<td>" + m_id + "</td>" + 
                        "<td><a href='/fabflix/jsp/SingleMovie.jsp?id="+m_id + "'>" + m_title + "</a></td>" + 
                        "<td>" + m_director + "</td>" +
                        "<td>" + Integer.toString(m_year) + "</td>" +
                        "<td><a href='" + m_trailer_url + "'>Link</a></td>" +
                        "<td>" + getGenreByMovieID(conn,m_id) + "</td>" +
                        "<td>" + getStarsByID(conn,m_id) + "</td>" +
                        "<td><div><input type='text' class='form-control text-center' aria-label='...' value='1' title='"+m_title+"' id='th-"+ m_id+ "'></div><div class='text-center'><button type='button' class='btn btn-default' onclick='addToCartByInput("+ m_id+ ")'>Add to Cart</button></div> </td>" +
                    "</tr>\n");
        }
        
        return sb.toString();
      }

      private String getPage(String title,Integer year,String director,String star_firstname,String star_lastname,String genre, String title_start_with,Integer start, Integer LIMIT,String url) throws SQLException{
            String query = "";
            if(genre != null && !genre.isEmpty()){
                query = getGenreQuery(genre);//genre,start,LIMIT
            }else if(title_start_with != null && !title_start_with.isEmpty()){
                query = getMovieTitleStartWithQuery(title_start_with);
            }else{
                query = getMovieQuery(title,year,director,star_firstname,star_lastname);
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
            try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/moviedb","root","cs122b" )) {
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
        <div class="table-responsive movie-table">
            <table width="100%" class="table table-hover">
                <thead>
                    <tr>
                       <th>ID</th>
                       <th id="th-title"><div onclick="requestSort(this.className,'title')" <%= getSortClass(sortby,1,sorttype) %>>Title</div></th>
                       <th>Director</th>
                       <th id="th-year"><div onclick="requestSort(this.className,'year')" <%= getSortClass(sortby,2,sorttype) %>>Year</div></th>
                       <th>Trailer URL</th>
                       <th>Genres</th>
                       <th>Stars</th>
                    </tr>
                </thead>
                <%= getMovieList(title,year,director,star_firstname,star_lastname,genre,title_start_with,start,LIMIT,sortby,sorttype) %>
                
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
        <%= getPage(title,year,director,star_firstname,star_lastname,genre,title_start_with,start,LIMIT,url) %>
    </div>

    
    
    
    <%@ include file="footer.jsp"%>
</body>
</html>