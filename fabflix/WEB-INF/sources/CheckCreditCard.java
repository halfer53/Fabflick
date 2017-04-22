
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
import java.time.LocalDate;
import java.util.stream.*;

public class CheckCreditCard extends HttpServlet{
    public void doGet(HttpServletRequest request,HttpServletResponse response) throws ServletException, IOException {
         PrintWriter out = response.getWriter();
        try{
                

            response.setContentType("text/plain");

            Class.forName("com.mysql.jdbc.Driver").newInstance();
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/moviedb","root","cs122b" );

            String firstname = request.getParameter("firstname");
            String lastname = request.getParameter("lastname");
            String expiration = request.getParameter("expiration");
            String[] movies = request.getParameterValues("moviesid[]");
            List<Integer> moviesid = movies==null ? new ArrayList<Integer>() : Arrays.stream(movies).map(Integer::valueOf).collect(Collectors.toList());
            
            for(Iterator it = moviesid.iterator();it.hasNext();){
                out.println((Integer)it.next());
            }

            HttpSession session = request.getSession(true);
            Integer uid = (Integer)session.getAttribute("uid");

            if(firstname.isEmpty() ||firstname==null || lastname.isEmpty() || lastname == null || expiration.isEmpty() || expiration==null){
                response.sendError(407,"Plz Provide proper parameters");
            }
            if(uid==null){
                response.sendError(403,"Plz login first");
            }else{
                if(checkCard(conn,uid,firstname,lastname,expiration)){
                    newSale(conn,uid,moviesid);
                    out.print("Success");
                    session.setAttribute("cart-id",UUID.randomUUID().toString());

                }else{
                    out.println("Credit Card does not match");
                }
            }
            
        }catch(Exception e){
            out.println("Abc"+e.getMessage());
            // response.sendError(403,e.getMessage());
        }
        
    }

    private Integer parseIntC(String s){
        return s==null ? new Integer(0) : Integer.parseInt(s);
    }

    private boolean customerHasCreditCard(Connection conn,Integer uid, String cc_id) throws Exception{
        String query = "SELECT * FROM customers WHERE id= ? AND cc_id = ?";
        try(PreparedStatement pst = conn.prepareStatement(query)){
            pst.setInt(1,uid);
            pst.setString(2,cc_id);
            try(ResultSet rs = pst.executeQuery()){
                if(rs.next())   return true;
            }
        }
        return false;
    }

    private void newSale(Connection con,Integer uid,List<Integer> moviesid) throws Exception{
        String query = "INSERT INTO sales(customer_id,movie_id,sale_date) values(?,?,?)";
        LocalDate date = LocalDate.now();
        for(Iterator it = moviesid.iterator();it.hasNext();){
            PreparedStatement pst = con.prepareStatement(query);
            pst.setInt(1,uid);
            pst.setInt(2,(Integer)it.next());
            pst.setDate(3, java.sql.Date.valueOf(LocalDate.now()));
            int result = pst.executeUpdate();
        }
    }

    private boolean checkCard(Connection conn,int uid,String firstname,String lastname,String expiration) throws Exception{
        String query = "SELECT * FROM creditcards WHERE first_name = ? AND last_name = ? AND expiration = ?";
        PreparedStatement stmt = conn.prepareStatement(query);
        stmt.setString(1,firstname);
        stmt.setString(2,lastname);
        stmt.setString(3,expiration);
        ResultSet rs = stmt.executeQuery();
        if(rs.next()){
            String cc_id = rs.getString("id");
            if(customerHasCreditCard(conn,uid,cc_id)){
                return true;
            }
        }
        return false;
    }


}

