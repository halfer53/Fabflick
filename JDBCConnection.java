import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.*;
import java.util.*;
import java.text.*;

public class JDBCConnection {
    static String username;
    static String password;
    static String url;
        static Connection conn;
        static PreparedStatement pst;
    static ResultSet rs;

    public static void main(String[] args) {
        try{
            JDBCConnection conn = new JDBCConnection("","","jdbc:mysql:///moviedb?autoReconnect=true&useSSL=false");
            //System.out.println(conn.showMoviesGivenStar("Ben"));
            //System.out.println(conn.showMoviesGivenStar("Ben Stiller"));
            System.out.println(conn.insertStarByName("Bruce Tan","1955/11/30","abc"));
            //System.out.println(conn.insertCustomer("Bruce Tan","addr123","b@gmail.com","123","2011-11-11"));
        }catch(Exception e){
            e.printStackTrace();
        }
        
    }


    public JDBCConnection(String username, String password, String url) throws Exception{
        this.username = username;
        this.password = password;
        this.url = url;
        Class.forName("com.mysql.jdbc.Driver").newInstance();
    }

    private String[] nameStringHelper(String name){
        String[] strs = name.trim().split(" ");
        if(strs.length == 1){
            return new String[]{"",strs[0]};
        }else if(strs.length != 2){
            return Arrays.copyOfRange(strs,0,2);
        }else{
            return strs;
        }
    }
    
    //DONE Print out (to the screen) the movies featuring a given star. All movie attributes should appear, labeled and neatly arranged; the star can be queried via first name and/or last name or by ID. First name and/or last name means that a star should be queried by both a) first name AND last name b) first name or last name.
    //DONE Insert a new star into the database. If the star has a single name, add it as his last_name and assign an empty string ("") to first_name.
    //DONE Insert a customer into the database. Do not allow insertion of a customer if his credit card does not exist in the credit card table. The credit card table simulates the bank records. If the customer has a single name, add it as his last_name and assign an empty string ("") to first_name.
    
    //DONE Delete a customer from the database.
    //Provide the metadata of the database; in particular, print out the name of each table and, for each table, each attribute and its type.
    //Enter a valid SELECT/UPDATE/INSERT/DELETE SQL command. The system should take the corresponding action, and return and display the valid results. For a SELECT query, display the answers. For the other types of queries, give enough information about the status of the execution of the query. For instance, for an UPDATE query, show the user how many records have been successfully changed.
    //Exit the menu (and return to the get-the-database/user/password state)
    //Exit the program. 
    
    public String showMoviesGivenStar(String name) throws Exception{
        String[] names = nameStringHelper(name);
        String firstname = names[0];
        String lastname = names[1];
        StringBuilder sb = new StringBuilder();
        String query = "SELECT m.* FROM stars_in_movies as sm, stars as s, movies as m WHERE sm.star_id = s.id AND sm.movie_id = m.id AND s.first_name like '%"+firstname+"%' AND s.last_name like '%"+lastname+"%'";
        try (Connection conn = DriverManager.getConnection(url,username,password ) ) {
            try (Statement stmt = conn.createStatement()) {
                try(ResultSet rs = stmt.executeQuery(query)){
                    while ( rs.next() ) {
                        for (int i = 1; i <= rs.getMetaData().getColumnCount(); i++) {
                            int type = rs.getMetaData().getColumnType(i);
                            if (type == Types.VARCHAR || type == Types.CHAR) {
                             sb.append(rs.getString(i)+" ");
                            } else {
                             sb.append(rs.getLong(i)+" ");
                            }
                        }
                        sb.append("\n");
                    }
                }
                
            }
        }
        return sb.toString();
    }


    public int insertStarByName(String name, String dob, String photo) throws Exception{
        int result = 0;
        String[] names = nameStringHelper(name);
        String firstName = names[0];
        String lastName = names[1];
        try {
            // Class.forName("com.mysql.jdbc.Driver").newInstance();
            conn = DriverManager.getConnection(url,username, password);
            System.out.println("Database connection successfully");
            
            String sql = "insert into stars(first_name, last_name, dob, photo_url) values (?,?,?,?)";
            PreparedStatement pst =conn.prepareStatement(sql);
            pst.setString(1, firstName);
            pst.setString(2, lastName);
            pst.setString(3, dob);
            pst.setString(4, photo);
            
            result = pst.executeUpdate();
            if (conn != null) conn.close();
            if (pst != null) pst.close();
            if (rs != null) rs.close();
            
        } catch (Exception e) {
            e.printStackTrace();
        } 
        
        return result;
    }

    public int existCreditCard(String firstname, String lastname, String exp) throws Exception{
        String query = "SELECT * FROM creditcards WHERE firstname= ? AND lastname= ? AND expiration= ?";
        try (Connection conn = DriverManager.getConnection(url,username,password ) ) {
            try (PreparedStatement stmt = conn.prepareStatement(query)) {
                stmt.setString(1,firstname);
                stmt.setString(2,lastname);
                stmt.setDate(3,java.sql.Date.valueOf(exp));
                try(ResultSet rs = stmt.executeQuery(query)){
                    if(rs.next()){
                        return rs.getInt(1);//return id
                    }else{
                        return -1;
                    }
                }
            }
        }
    }
    public String insertCustomer(String name, String address, String email, String password, String expiration) throws Exception{
        String[] names = nameStringHelper(name);
        String firstname = names[0];
        String lastname = names[1];
        int cc_id = 0;
        String query = "INSERT INTO customers VALUES ("+firstname+", "+lastname+", "+cc_id+", "+address+", "+email+", "+password+")";
        if((cc_id = existCreditCard(firstname,lastname,expiration)) >=0){
            try (Connection conn = DriverManager.getConnection(url,username,password ) ) {
                try (Statement stmt = conn.createStatement()){
                    try(ResultSet rs = stmt.executeQuery(query)){

                    }
                }
            }
        }else{
            return "Credit Card does not exist";
        }
        return "Success";
    } 
    
    public void showDatabaseSchema()throws Exception {
         try{
             conn = DriverManager.getConnection(url,username, password);
        
             DatabaseMetaData dbm = conn.getMetaData();
             String[] types = {"TABLE"};
             ResultSet rs = dbm.getTables(null,null,"%",types);
            
             while (rs.next()){
                 
                 System.out.print("Table name: ");
                 String table = rs.getString("TABLE_NAME");
                 System.out.println(table);
                
                 String sql =  "DESCRIBE "+table;
                 pst =conn.prepareStatement(sql);
                 ResultSet rsSub = pst.executeQuery("DESCRIBE "+table);
                 ResultSetMetaData mdSub = rsSub.getMetaData();
                 int col = mdSub.getColumnCount();
                 /*
                 for (int i = 1; i <= col; i++){
                     String col_name = mdSub.getColumnName(i);
                     System.out.print(col_name+"\t");
                 }*/
                 
                 
                 System.out.println("Column Name " + "\t" + "Column Type");
                 DatabaseMetaData dbmSub = conn.getMetaData();
                 ResultSet rs1 = dbmSub.getColumns(null,"%",table,"%");
                 while (rs1.next()){
                     String col_name = rs1.getString("COLUMN_NAME");
                     String data_type = rs1.getString("TYPE_NAME");
                     int data_size = rs1.getInt("COLUMN_SIZE");
                     System.out.print(col_name+"\t"+data_type+"("+data_size+")"+"\t");
                     System.out.println();
                 }
                 
                
                 System.out.println();
                 
             }
             conn.close();
         } catch (Exception e){
              e.printStackTrace();
             System.out.println("No any table in the database");
              
         
         }
              
        
    }
    
    public int deleteCustomerById(int id)throws Exception {
        int result = 0;
        try {
            conn = DriverManager.getConnection(url,username, password);
    
            String sql = "delete from customers where id = ?";
            pst =conn.prepareStatement(sql);
            pst.setInt(1, id);
            result = pst.executeUpdate();
            if (conn != null) conn.close();
            if (pst != null) pst.close();
            if (rs != null) rs.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }
    
    public void executeSQL(String sql) throws Exception {
        try{
            conn = DriverManager.getConnection(url,username, password);
            if (sql.trim().startsWith("select")) {
                pst = conn.prepareStatement(sql);
                rs = pst.executeQuery();
                ResultSetMetaData rsmd = rs.getMetaData();
                int columnsNumber = rsmd.getColumnCount();
                while (rs.next()) {
                    for (int i = 0; i < columnsNumber; i++) {
                        System.out.printf("%-15s",rs.getString(i + 1));
                    }
                    System.out.println();
                }
                
            } else {
                pst = conn.prepareStatement(sql);
                int count = pst.executeUpdate();
                System.out.println(count + " row have been updated");
                
            }
            if (conn != null) conn.close();
            if (pst != null) pst.close();
            if (rs != null) rs.close();
        } catch (Exception e) {
            System.out.println("the SQL you input can not be executed to DBMS");
        }
    }
    public void testDB() {
        try {
            Class.forName("com.mysql.jdbc.Driver").newInstance();
            conn = DriverManager.getConnection(url,username, password);
            System.out.println("Database connection successfully");
            //String sql = "select city.id as cityId from city, country where city.partOf = country.id and city.name = ? and country.name = ?";
            //pst =conn.prepareStatement(sql);
            
            if (conn != null) conn.close();
            if (pst != null) pst.close();
            if (rs != null) rs.close();
            
        } catch (Exception e) {
            e.printStackTrace();
        } 
        
    }
     

}
