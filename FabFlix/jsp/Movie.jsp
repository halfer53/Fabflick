<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%> 
<html>
    <head>
        <%@ include file="head.jsp"%>
        <title>Movie</title>
    </head>
<body>
    <%  

        Integer uid = (Integer)session.getAttribute("uid");
        final int LIMIT = 15;
        String spage = request.getParameter("page");
        Integer start = spage == null ? new Integer(0) : Integer.valueOf(spage) * LIMIT;

        String title = setEmptyIfNull(request.getParameter("title"));
        String syear = request.getParameter("year");
        Integer year = (syear==null || syear.isEmpty()) ? null : Integer.valueOf(syear);
        String director = setEmptyIfNull(request.getParameter("director"));
        String star_firstname = setEmptyIfNull(request.getParameter("star_firstname"));
        String star_lastname = setEmptyIfNull(request.getParameter("star_lastname"));
        String sortby = request.getParameter("sortby");
        String sorttype = request.getParameter("sorttype");

        String genre = setEmptyIfNull(request.getParameter("genre"));

        String title_start_with = setEmptyIfNull(request.getParameter("title_start_with"));

        String queryParameter = request.getQueryString();
        queryParameter = queryParameter == null ? "" : queryParameter;
        String url = request.getRequestURL()+"?"+queryParameter;
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
                 <li><a href="/fabflix/jsp/Browse.jsp">Browse</a></li>
                 <li class="active"><a href="#">Movies</a></li> 
                 <li><a href="/fabflix/jsp/Search.jsp">Search</a></li>
                 <%=getRightButton(uid)%>
             </ul> 
             </div> 
            </div> 
        </nav>
    </div>
    



    <%-- Declare and define the runQuery() method. --%>
    <%! 
        private String getRightButton(Integer uid){
            if(uid == null){
                return "<li class='pull-right'><a href='/fabflix'>Login</a></li> ";
            }
            return "<li class='pull-right'><a href='/fabflix/jsp/ShoppingCart.jsp'>Shopping Cart</a></li> ";

        }
        public String setEmptyIfNull(String input){
            return input==null ? "%" : input;
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

        private String getGenreQuery(){
            return "SELECT DISTINCT m.* FROM genres_in_movies as gm, movies as m, genres as g WHERE gm.movie_id = m.id AND gm.genre_id = g.id AND g.name =  ? LIMIT ?,?";
        }

        private String getMovieTitleStartWithQuery(String title_start_with){
            return "SELECT * FROM movies WHERE title LIKE '"+title_start_with+"%' LIMIT ?,?";
        }

        private String getMovieQuery(String title,Integer year,String director,String star_firstname,String star_lastname,Integer start,Integer LIMIT){
            String query = "SELECT DISTINCT m.* FROM stars_in_movies as sm, stars as s, movies as m WHERE sm.star_id = s.id AND sm.movie_id = m.id AND s.first_name LIKE '%"+star_firstname+"%' AND s.last_name LIKE '%" +star_lastname+"%' AND m.title LIKE '%"+title+"%' AND m.director LIKE '%"+director+"%' ";
            String yquery = "AND m.year = ";
            String lquery = " LIMIT ?,?";
            if(year != null){
                query += (yquery + year.toString());
            }
            query += lquery;
            return query;
        }

        private String getMovieListByTitleStart(String title_start,Integer start, Integer LIMIT){
            try{
                Class.forName("com.mysql.jdbc.Driver").newInstance();
                try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/moviedb","root","cs122b" )) {
                        String query = getMovieTitleStartWithQuery(title_start);
                        try(PreparedStatement stmt = conn.prepareStatement(query)) {
                            stmt.setInt(1,start);
                            stmt.setInt(2,LIMIT);
                            try(ResultSet rs = stmt.executeQuery()){
                                return formatResult(conn,rs);
                            }
                        }  
                  }
               
            }catch(Exception e){
                return e.getMessage();
            }

        }

        private String getMovieListByGenre(String genre,Integer start, Integer LIMIT){
            try{
                Class.forName("com.mysql.jdbc.Driver").newInstance();
                try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/moviedb","root","cs122b" )) {
                        String query = getGenreQuery();
                        try(PreparedStatement stmt = conn.prepareStatement(query)) {
                            stmt.setString(1,genre);
                            stmt.setInt(2,start);
                            stmt.setInt(3,LIMIT);
                            try(ResultSet rs = stmt.executeQuery()){
                                return formatResult(conn,rs);
                            }
                        }  
                  }
               
            }catch(Exception e){
                return e.getMessage();
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
       private String getMovieList(String title,Integer year,String director,String star_firstname,String star_lastname,Integer start,Integer LIMIT,String sortby, String sorttype) throws SQLException {
            String query = "";
            
            try{
                Class.forName("com.mysql.jdbc.Driver").newInstance();
                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/moviedb","root","cs122b" );

                String movie_query = getMovieQuery(title,year,director,star_firstname,star_lastname,start,LIMIT);
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
                        "<td><div><input type='text' class='form-control' aria-label='...' maxlength='3' size='3' title='"+m_title+"' id='th-"+ m_id+ "'></div><div><button type='button' class='btn btn-default' onclick='addToCartByInput("+ m_id+ ")'>Add to Cart</button></div> </td>" +
                    "</tr>\n");
        }
        
        return sb.toString();
      }

      private String pageCursor(String title,Integer year,String director,String star_firstname,String star_lastname,Integer start, Integer LIMIT,String url) throws SQLException{

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
        if(hasPage(title,year,director,star_firstname,star_lastname,start, LIMIT)){
            sb.append("<li class='next pull-right'><a href='");
        }else{
            sb.append("<li class='next pull-right'><a class='btn disabled' href='");
        }
            sb.append(curl+"&page="+Integer.toString(page_num));
            sb.append("'>Next <span aria-hidden='true'>&rarr;</span></a></li>");
        
        sb.append("</ul></nav>");
        return sb.toString();
      }

      private boolean hasPage(String title,Integer year,String director,String star_firstname,String star_lastname,Integer start, Integer LIMIT) throws SQLException{
        try{
            Class.forName("com.mysql.jdbc.Driver").newInstance();
            try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/moviedb","root","cs122b" )) {
                    String query = getMovieQuery(title,year,director,star_firstname,star_lastname,start,LIMIT);
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
    <div class="container">
        <div id="message"></div>
    </div>
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
                <%= getMovieList(title,year,director,star_firstname,star_lastname,start,LIMIT,sortby,sorttype) %>
                
            </table>
            <%= pageCursor(title,year,director,star_firstname,star_lastname,start,LIMIT,url) %>
        </div>
    </div>
    
    
    <%@ include file="footer.jsp"%>
</body>
</html>