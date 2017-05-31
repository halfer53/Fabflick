

import java.io.IOException;

import javax.json.Json;
import javax.json.JsonObject;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;
import org.json.JSONObject;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.*;

import java.util.ArrayList;
import java.util.Arrays;
/**
 * Servlet implementation class AjaxAnime
 */
@WebServlet("/AjaxAnime")
public class AjaxAnime extends HttpServlet {
	private final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AjaxAnime() {
        super();
        // TODO Auto-generated constructor stub
    }
    
    Integer LIMIT = new Integer(20);

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		try{
			String spage = request.getParameter("page");
	        Integer start = spage == null ? new Integer(0) : Integer.valueOf(spage) * LIMIT;

	        String title = setEmptyIfNull(request.getParameter("title"));
	        
	        JSONObject jb =  getResult(title,start);
	        response.getWriter().print(jb.toString());
		}catch(Exception e){
			response.getWriter().print(e.getMessage());
			e.printStackTrace();
		}
	}
	
	
	public String setEmptyIfNull(String input){
        input = input==null ? "" : input;
        return input;
    }

    public Integer parseParaInt(String input){

        return (input==null || input.isEmpty()) ? null : Integer.valueOf(input);
    }

   
  private JSONObject getResult(String title, Integer start){
	  JSONObject json = new JSONObject();
	  try{
		  Connection conn = null;
		  Class.forName("com.mysql.jdbc.Driver").newInstance();
		  
		  JSONArray sanimes = new JSONArray();
		  String[] words = title.split(" ");
		  if(words.length == 0)
			  return json;
		  String query = "SELECT * FROM animes WHERE ";
		  for(int i=0;i<words.length;i++){
			  String word = words[i].replace("'", "\\\'");
			  if(i != words.length-1){
				  query += " MATCH(title) against ('"+word+"') AND ";
			  }else{
				  query += " MATCH(title) against('"+word+"*' in boolean mode)";
			  }
		  }
		  query += " LIMIT ?,?";
		  System.out.println(query);
    	  conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/animedb","root","cs122b" );
          try(PreparedStatement stmt = conn.prepareStatement(query)) {
              stmt.setInt(1,start);
              stmt.setInt(2,LIMIT);
              
              System.out.println(start);
              try(ResultSet rs = stmt.executeQuery()){
                  while(rs.next()){
//                	  JSONObject animejson = new JSONObject();
//                	  animejson.put("id", rs.getString("id"));
//                	  animejson.put("title", rs.getString("title"));
                      sanimes.put(rs.getString("title"));
                  }
              }
          }  
	      
	      json.put("Animes",sanimes);
	      json.put("page", start/LIMIT);
	      json.put("prev", start > 0 ? true : false);
	      json.put("next", hasPage(conn,query,start+LIMIT));
	      
	      
	      conn.close();
	  }catch(Exception e){
		  e.printStackTrace();
		  return null;
	  }
	  
      return json;
      
  }



  private boolean hasPage(Connection conn, String query, Integer start) throws SQLException{
    try{
        Class.forName("com.mysql.jdbc.Driver").newInstance();

                try(PreparedStatement stmt = conn.prepareStatement(query)) {
                    stmt.setInt(1,start);
                    stmt.setInt(2,LIMIT);
                    try(ResultSet rs = stmt.executeQuery()){
                        if(rs.next()){
                            return true;
                        }
                    }
                }  
          
       
    }catch(Exception e){
        e.printStackTrace();
    }
    return false;
  }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
