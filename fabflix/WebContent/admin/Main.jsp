<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<html>
    <head>
        <%@ include file="head.jsp"%>
        <title>Main</title>
    </head>
<body>
    <%
	    String eid = (String)session.getAttribute("eid");
          
    %>
    
    <%!
	    private String showDatabaseSchema(){
    		StringBuffer sb = new StringBuffer();
	        try{
	        	Class.forName("com.mysql.jdbc.Driver").newInstance();
	        	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/animedb","root","cs122b" );
	       
	            DatabaseMetaData dbm = conn.getMetaData();
	            String[] types = {"TABLE"};
	            ResultSet rs = dbm.getTables(null,null,"%",types);
	           
	            while (rs.next()){
	                
	                System.out.print("Table name: ");
	                String table = rs.getString("TABLE_NAME");
	                System.out.println(table);
	               
	                String sql =  "DESCRIBE "+table;
	                PreparedStatement pst = conn.prepareStatement(sql);
	                ResultSet rsSub = pst.executeQuery("DESCRIBE "+table);
	                ResultSetMetaData mdSub = rsSub.getMetaData();
	                int col = mdSub.getColumnCount();
	                /*
	                for (int i = 1; i <= col; i++){
	                    String col_name = mdSub.getColumnName(i);
	                    System.out.print(col_name+"\t");
	                }*/
	                
	                
	                sb.append("Column Name " + "    " + "Column Type<br>");
	                DatabaseMetaData dbmSub = conn.getMetaData();
	                ResultSet rs1 = dbmSub.getColumns(null,"%",table,"%");
	                while (rs1.next()){
	                    String col_name = rs1.getString("COLUMN_NAME");
	                    String data_type = rs1.getString("TYPE_NAME");
	                    int data_size = rs1.getInt("COLUMN_SIZE");
	                    sb.append(col_name+"    "+data_type+"("+data_size+")"+"    <br><br>");
	                }
	                sb.append("<br>");
	                
	            }
	            conn.close();
	        } catch (Exception e){
	             sb.append(e.getMessage());
	        }
	        return sb.toString();
	   	}
    %>
    <%@ include file="header.jsp"%>
    
	
    <div class="container">
    	<h2>Add New Voice Actor</h2>
    	<div class="row">
        <div class="col-xs-6 center-block">
            <div class="form-group label-floating is-empty">
                    <label for="name-input" class="control-label">Name :</label>
                    <input type="name" class="form-control" id="name-input">
            </div>
            <div class="form-group label-floating is-empty">
                    <label for="photo_url-input" class="control-label">photo_url :</label>
                    <input type="photo_url" class="form-control" id="photo_url-input">
            </div>
             <button class="btn btn-primary" type="button" onclick="JavaScript:addNewStar()">Add New Star</button>
        </div>
        </div>
    </div>
    
    <div class="container">
    	<%= showDatabaseSchema() %>
    
    </div>
    <%@ include file="footer.jsp"%>
</body>
</html>