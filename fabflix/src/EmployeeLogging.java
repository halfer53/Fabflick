

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import javax.naming.InitialContext;
import javax.naming.Context;
import javax.sql.DataSource;

/**
 * Servlet implementation class EmployeeLogging
 */
@WebServlet("/servlet/EmployeeLogging")
public class EmployeeLogging extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
			public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
		    throws ServletException
		    {
		       try{
		            request.setCharacterEncoding("UTF-8");
		            chain.doFilter(request, response);
		        }catch(Exception e){
		            e.printStackTrace();
		        }
		    }
			public void doPost(HttpServletRequest request,HttpServletResponse response) throws ServletException, IOException {
		         PrintWriter out = response.getWriter();
		        try{
		            response.setContentType("text/html");
		            out.println("<!DOCTYPE html><html lang='en'><body>");
		            
		            String username = request.getParameter("user_name");
		            String password = request.getParameter("password");
		            
		            String gRecaptchaResponse = request.getParameter("g-recaptcha-response");
		            boolean valid = false;
		            if(gRecaptchaResponse != null && !gRecaptchaResponse.isEmpty()){
		            	System.out.println("gRecaptchaResponse=" + gRecaptchaResponse);
		              	// Verify CAPTCHA.
		            	try{
		            		valid = VerifyUtils.verify(gRecaptchaResponse);
		            	}catch(Exception e){
		            		out.println(e.getMessage()+"ddd");
		            	}
		              	
		            }else{
		            	out.print("No Recaptcha\n");
		            	
		            }
		            String referer = request.getHeader("Referer");
		            if(username.isEmpty() ||username==null || password.isEmpty() || password == null){
		                out.println("Plz Provide username and password");
		            }else if(valid){
		                String eid = null;
		                if((eid = login(username,password)) !=null){
		                    HttpSession session = request.getSession(true);
		                    session.setAttribute("eid",eid);
		                    response.sendRedirect(request.getContextPath() + "/admin/Main.jsp");
		                }else{
		                	out.print("Incorrect user name or password\n");
		                }
		            }
		            
		            out.println("<script>window.setTimeout(function(){window.location.href = '"+referer+"';}, 2000);</script>");
		            
		        }catch(Exception e){
		        	e.printStackTrace();
		        	out.print(e.getMessage()+" abc");
		        }
		        out.close();
		        
		    }

		    public String login(String username,String password) throws Exception{
		        Class.forName("com.mysql.jdbc.Driver").newInstance();
		        try {
		        Context initCtx = new InitialContext();
                 Context envCtx = (Context) initCtx.lookup("java:comp/env");
                 DataSource ds = (DataSource) envCtx.lookup("jdbc/AnimeDB");
                 Connection conn = ds.getConnection();

		            String query = "SELECT * FROM employees WHERE email = ? AND password = ?";
		            try(PreparedStatement stmt = conn.prepareStatement(query)) {
		                stmt.setString(1,username);
		                stmt.setString(2,password);
		                try(ResultSet rs = stmt.executeQuery()){
		                    if(rs.first()){
		                        return rs.getString(1);
		                    }
		                }
		            }  
		        }catch(Exception e){
		        	e.printStackTrace();
		        }
		        return null;
		    }

}
