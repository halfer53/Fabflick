

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.DriverManager;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

/**
 * Servlet implementation class AjaxLogin
 */
@WebServlet("/AjaxLogin")
public class AjaxLogin extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AjaxLogin() {
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
    
    public void doGet(HttpServletRequest request,HttpServletResponse response)throws ServletException, IOException{
    	doPost(request,response);
    }
    public void doPost(HttpServletRequest request,HttpServletResponse response) throws ServletException, IOException {
         PrintWriter out = response.getWriter();
        try{
            
            String username = request.getParameter("user_name");
            String password = request.getParameter("password");
            
            if(username==null || username.isEmpty() || password == null || password.isEmpty()){
                response.sendError(407,"Plz Provide username and password");
            }else {
                int uid = -1;
                if((uid = login(username,password)) >= 0){
                    HttpSession session = request.getSession(true);
                    session.setAttribute("uid",uid);
                    
                }else{
                	response.sendError(401,"Incorrect User Name or Password");
                }
            }
        }catch(Exception e){
        	e.printStackTrace();
        	out.print(e.getMessage()+" abc");
        }
        out.close();
        
    }

    public int login(String username,String password) throws Exception{
        Class.forName("com.mysql.jdbc.Driver").newInstance();
        try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/animedb","root","cs122b" )) {
            String query = "SELECT * FROM customers WHERE email = ? AND password = ?";
            try(PreparedStatement stmt = conn.prepareStatement(query)) {
                stmt.setString(1,username);
                stmt.setString(2,password);
                try(ResultSet rs = stmt.executeQuery()){
                    if(rs.first()){
                        return rs.getInt(1);
                    }
                }
            }  
        }
        return -1;
    }

}




