
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
    public void doGet(HttpServletRequest request,HttpServletResponse response) throws ServletException, IOException {
         PrintWriter out = response.getWriter();
        try{
            response.setContentType("text/plain");

            Class.forName("com.mysql.jdbc.Driver").newInstance();
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/animedb","root","cs122b" );
            String id = request.getParameter("id");
            String firstname = request.getParameter("firstname");
            String lastname = request.getParameter("lastname");
            String expiration = request.getParameter("expiration");
            String[] animes = request.getParameterValues("animesid[]");
            List<Integer> animesid = animes==null ? new ArrayList<Integer>() : Arrays.stream(animes).map(Integer::valueOf).collect(Collectors.toList());
            
            for(Iterator it = animesid.iterator();it.hasNext();){
                out.println((Integer)it.next());
            }

            HttpSession session = request.getSession(true);
            Integer uid = (Integer)session.getAttribute("uid");

            if(id.isEmpty() || id==null || firstname.isEmpty() ||firstname==null || lastname.isEmpty() || lastname == null || expiration.isEmpty() || expiration==null){
                response.sendError(417,"Please provide proper parameter");
            }
            if(uid==null){
                response.sendError(403,"Plz login first");
            }else{
                if(checkCard(conn,id,firstname,lastname,expiration)){
                    newSale(conn,uid,animesid);
                    out.print("Success");
                    session.setAttribute("cart-id",UUID.randomUUID().toString());

                }else{
                    response.sendError(417,"Credit Card does not match");
                }
            }
            
        }catch(Exception e){
            out.println(e.getMessage());
        }
        out.close();
        
    }

    private Integer parseIntC(String s){
        return s==null ? new Integer(0) : Integer.parseInt(s);
    }

    private void newSale(Connection con,Integer uid,List<Integer> animesid) throws Exception{
        String query = "INSERT INTO sales(customer_id,anime_id,sale_date) values(?,?,?)";
        LocalDate date = LocalDate.now();
        for(Iterator it = animesid.iterator();it.hasNext();){
            PreparedStatement pst = con.prepareStatement(query);
            pst.setInt(1,uid);
            pst.setInt(2,(Integer)it.next());
            pst.setDate(3, java.sql.Date.valueOf(LocalDate.now()));
            int result = pst.executeUpdate();
        }
    }

    private boolean checkCard(Connection conn,String cid,String firstname,String lastname,String expiration) throws Exception{
        String query = "SELECT * FROM creditcards WHERE id = ? AND first_name = ? AND last_name = ? AND expiration = ?";
        PreparedStatement stmt = conn.prepareStatement(query);
        stmt.setString(1,cid);
        stmt.setString(2,firstname);
        stmt.setString(3,lastname);
        stmt.setString(4,expiration);
        ResultSet rs = stmt.executeQuery();
        if(rs.next()){
            return true;
        }
        return false;
    }


}

