
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
            response.setContentType("text/plain");
            String username = request.getParameter("user_name");
            String password = request.getParameter("password");
            if(username.isEmpty() ||username==null || password.isEmpty() || password == null){
                out.println("Plz Provide username and password");
            }else{
                int uid = -1;
                if((uid = login(username,password)) >= 0){
                    HttpSession session = request.getSession(true);
                    session.setAttribute("uid",uid);
                }else{
                    response.sendError(403,"Incorrect Username or Password");
                }
            }
            
        }catch(Exception e){
            out.println(e);
        }
        
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