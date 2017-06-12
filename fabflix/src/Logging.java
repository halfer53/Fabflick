
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.net.*;
import java.util.*;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;

import javax.naming.InitialContext;
import javax.naming.Context;
import javax.sql.DataSource;

public class Logging extends HttpServlet{
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
                int uid = -1;
                if((uid = login(username,password)) >= 0){
                    HttpSession session = request.getSession(true);
                    session.setAttribute("uid",uid);
                    response.sendRedirect(request.getContextPath() + "/jsp/Main.jsp");
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

    public int login(String username,String password) throws Exception{
        Class.forName("com.mysql.jdbc.Driver").newInstance();
        try {
        		Context initCtx = new InitialContext();
                 Context envCtx = (Context) initCtx.lookup("java:comp/env");
                 DataSource ds = (DataSource) envCtx.lookup("jdbc/AnimeDB");
                 Connection conn = ds.getConnection();

            String query = "SELECT * FROM customers WHERE email = ? AND password = ?";
            try(PreparedStatement stmt = conn.prepareStatement(query)) {
                stmt.setString(1,username);
                stmt.setString(2,password);
                try(ResultSet rs = stmt.executeQuery()){
                    if(rs.first()){
                    	conn.close();
                        return rs.getInt(1);
                    }
                }
            }  
        }catch(Exception e){
        	e.printStackTrace();
        }
        return -1;
    }
}