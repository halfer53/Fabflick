

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Iterator;
import java.util.UUID;
import java.util.stream.Collectors;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import javax.naming.InitialContext;
import javax.naming.Context;
import javax.sql.DataSource;

/**
 * Servlet implementation class AddNewStar
 */
@WebServlet("/servlet/AddNewStar")
public class AddNewStar extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AddNewStar() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		PrintWriter out = response.getWriter();
		try{

            Class.forName("com.mysql.jdbc.Driver").newInstance();
            Context initCtx = new InitialContext();
                 Context envCtx = (Context) initCtx.lookup("java:comp/env");
                 DataSource ds = (DataSource) envCtx.lookup("jdbc/AnimeDB");
                 Connection conn = ds.getConnection();
;
            String firstname = parse(request.getParameter("first_name"));
            String lastname = parse(request.getParameter("last_name"));
            String photo = parse(request.getParameter("photo_url"));
            
            HttpSession session = request.getSession(true);
    	    String eid = (String)session.getAttribute("eid");

            if(lastname.isEmpty()){
            	response.resetBuffer();
            	response.setStatus(407);
            	response.getOutputStream().print("{\"errorMessage\":\"Plz provide proper data!\"}");
            	response.flushBuffer();//marks response as committed -- if we don't do this the request will go through normally!
            }
            if(eid==null){
            	response.resetBuffer();
            	response.setStatus(407);
            	response.getOutputStream().print("{\"errorMessage\":\"Plz Login first!\"}");
            	response.flushBuffer();
            }else{
                newStar(conn,firstname,lastname,photo);
            }
            conn.close();
            
        }catch(Exception e){
        	
        	response.sendError(500,e.getMessage());
        }
		out.close();
	}
	
	private String parse(String str){
		return str == null ? "" : str;
	}
	
	private void newStar(Connection con,String firstname,String lastname,String photo_url) throws Exception{
        String query = "INSERT INTO voice_actors(first_name,last_name,picture_url) values(?,?,?)";
        PreparedStatement pst = con.prepareStatement(query);
        pst.setString(1,firstname);
        pst.setString(2,lastname);
        pst.setString(3, photo_url);
        int result = pst.executeUpdate();
        pst.close();
    }

}
