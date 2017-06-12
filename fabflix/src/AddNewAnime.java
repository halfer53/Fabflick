

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.mysql.jdbc.CallableStatement;
import javax.naming.InitialContext;
import javax.naming.Context;
import javax.sql.DataSource;
/**
 * Servlet implementation class AddNewAnime
 */
@WebServlet("/servlet/AddNewAnime")
public class AddNewAnime extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AddNewAnime() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
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
			CallableStatement st = (CallableStatement)conn.prepareCall("{call add_anime(?, ?,?,?,?,?,?)}");
			String title = parse(request.getParameter("title"));
			Integer year = Integer.parseInt(parse(request.getParameter("year")));
			String director = parse(request.getParameter("director"));
			String vafirstname = parse(request.getParameter("vafirstname"));
			String valastname = parse(request.getParameter("valastname"));
			String genre = parse(request.getParameter("genre"));
			
			st.setString(1, title);
			st.setInt(2, year);
			st.setString(3, director);
			st.setString(4, vafirstname);
			st.setString(5, valastname);
			st.setString(6, genre);
			st.registerOutParameter(7, java.sql.Types.VARCHAR);
			
			st.executeUpdate();
			
			String output = st.getString(7);
			response.setContentType("text/plain");  // Set content type of the response so that jQuery knows what it can expect.
		    response.setCharacterEncoding("UTF-8"); // You want world domination, huh?
			System.out.println(output);
			out.write(output);
			conn.close();
			
		}catch(Exception e){
        	response.setStatus(407);
		}
		out.close();
		
	}
	
	private String parse(String str){
		return str == null ? "" : str;
	}

}
