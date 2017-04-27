<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<html>
    <head>
        <%@ include file="head.jsp"%>
        <title>Single Star</title>
    </head>
<body>
    <%
        
        String sid = request.getParameter("id");
        Integer star_id = sid==null ? new Integer(0) : Integer.valueOf(sid);
    %>

    <%!

        String formatResult(Integer star_id){
            StringBuffer sb = new StringBuffer();
            try{
                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/moviedb","root","cs122b" );
                
                String query = "SELECT * from stars where id = ?";
                PreparedStatement pst = conn.prepareStatement(query);
                pst.setInt(1,star_id);
                ResultSet rs = pst.executeQuery();
                while(rs.next()){
                    Integer gid = rs.getInt("id");
                    String firstname = rs.getString("first_name");
                    String lastname = rs.getString("last_name");
                    String dob = rs.getString("dob");
                    String photo_url = rs.getString("photo_url");
                    sb.append("<h3>"+firstname+" "+lastname+"</h3>");
                    sb.append(dob+"\n");
                    sb.append("<img src='"+photo_url+"' >");
                }
                pst.close();
                rs.close();
                conn.close();
                
            }catch(Exception e){
                e.printStackTrace();
            }
            return sb.toString();
        }
    %>

    <%@ include file="header.jsp"%>

    <div class="container">
    <%=formatResult(star_id)%>
    </div>

    
    <%@ include file="footer.jsp"%>
</body>
</html>