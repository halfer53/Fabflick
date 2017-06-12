

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;
import javax.naming.InitialContext;
import javax.naming.Context;
import javax.sql.DataSource;
/**
 * Servlet implementation class AjaxSingleAnime
 */
@WebServlet("/AjaxSingleAnime")
public class AjaxSingleAnime extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AjaxSingleAnime() {
        super();
        // TODO Auto-generated constructor stub
    }
    
    public void doFilter(HttpServletRequest request, HttpServletResponse response, FilterChain chain)
    throws ServletException
    {
       try{
            request.setCharacterEncoding("UTF-8");
            chain.doFilter(request, response);
        }catch(Exception e){
            e.printStackTrace();
        }
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		PrintWriter out = response.getWriter();
        try{
            
            String id = request.getParameter("id");
            JSONObject json = new JSONObject();
            if(id==null || id.isEmpty() ){
                response.sendError(407,"Plz Anime ID");
            }else {
            	Class.forName("com.mysql.jdbc.Driver").newInstance();
                try {Context initCtx = new InitialContext();
                 Context envCtx = (Context) initCtx.lookup("java:comp/env");
                 DataSource ds = (DataSource) envCtx.lookup("jdbc/AnimeDB");
                 Connection conn = ds.getConnection();

                    String query = "SELECT * FROM animes WHERE id = ?";
                    try(PreparedStatement stmt = conn.prepareStatement(query)) {
                        stmt.setString(1,id);
                        try(ResultSet rs = stmt.executeQuery()){
                            if(rs.first()){
                            	json.put("id", rs.getInt("id"));
                            	json.put("title", rs.getString("title"));
                            	json.put("director", rs.getString("director"));
                            	json.put("year", rs.getInt("year"));
                            	String description = rs.getString("description").replaceAll("(http[^ ]+) \\[([^\\]]+)\\]","<a href='$1'>$2</a>");
                                description = description.replaceAll("\\\\n","<br>");
                            	json.put("description", description);
                            }
                        }
                    }
                    conn.close();
                }catch(Exception e){
                	e.printStackTrace();
                }
            }
            out.print(json.toString());
        }catch(Exception e){
        	e.printStackTrace();
        	out.print(e.getMessage()+" abc");
        }
        out.close();
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
