package com.fabflix
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
    String username;
    String password;
    String url;
    Connection conn;
    PreparedStatement pst;
    ResultSet rs;
    String[] movie_attrs = new String[]{"Title: ","Year: ","Director: ","Banner_url: ","Trailer_url: "};

    public static void main(String[] args) {
        try{
            new JDBCConnection("jdbc:mysql:///moviedb?autoReconnect=true&useSSL=false").read();
        }catch(Exception e){
            e.printStackTrace();
        }
        
    }

    public boolean login(String username,String password){
        try {
            Connection conn = DriverManager.getConnection(url,username,password );
            conn.close();
            return true;
        }catch(Exception e){
            return false;
        }
    }

    public void logout(){
        this.username = null;
        this.password = null;
    }

    private void read(){
        try{
            Scanner sc = new Scanner(System.in);
            while(true){
                login_phase:{
                    while(true){
                        System.out.println("Type login or exit:");
                        String ll = sc.nextLine();
                        if(ll.equals("login")){
                            while(true){
                                System.out.println("Plz provide username and password");
                                System.out.print("User Name: ");
                                String line = sc.nextLine();
                                username = line;

                                System.out.print("Password: ");
                                password = sc.nextLine();
                                if(login()){
                                    break login_phase;
                                }else{
                                    System.out.println("Incorrect username or password");
                                }
                            }
                        }else if(ll.equals("exit")){
                            return;
                        }
                    }
                }
                menu:{
                    while(true){
                        try{
                            System.out.print("JDBC> ");
                            String line = sc.nextLine();
                            String[] lines = line.split(" ");
                            switch(lines[0]){
                                case "searchStar":
                                    switch(lines[1]){
                                        case "-i":
                                            showMoviesGivenStarByID(Integer.parseInt(lines[2]));
                                            break;
                                        case "-f":
                                            showMoviesGivenStar(lines[2]);
                                            break;
                                        case "-l":
                                            showMoviesGivenStar(lines[2]);
                                            break;
                                        case "-fl":
                                            showMoviesGivenStar(lines[2]+" "+lines[3]);
                                            break;
                                        default:
                                            showMoviesGivenStar(lines[1]);
                                            break;
                                    }
                                    break;
                                case "newStar":
                                    if(lines.length==4){
                                        insertStarByName(lines[1],lines[2],lines[3]);
                                    }else if(lines.length == 5){
                                        insertStarByName(lines[1]+" "+lines[2],lines[3],lines[4]);
                                    }else{
                                        System.out.println("Incorrect Input");
                                    }
                                    break;
                                case "newCustomer":
                                    if(lines.length==6){
                                        insertCustomer(lines[1],lines[2],lines[3],lines[4],lines[5]);
                                    }else if(lines.length == 7){
                                        insertCustomer(lines[1]+" "+lines[2],lines[3],lines[4],lines[5],lines[6]);
                                    }else{
                                        System.out.println("Incorrect Input");
                                    }
                                    break;
                                case "deleteCustomer":
                                    if(lines.length==2){
                                        deleteCustomerById(Integer.parseInt(lines[1]));
                                    }else{
                                        System.out.println("Incorrect Input");
                                    }
                                    break;
                                case "showDatabaseSchema":
                                    showDatabaseSchema();
                                    break;
                                case "sql":
                                    executeSQL(line.substring(line.indexOf(' ')+1));
                                    break;
                                case "exit":
                                    break menu;
                                case "logout":
                                    logout();
                                    break menu;
                                default:
                                    System.out.println("No command found");
                                    break;
                            }
                        }catch(Exception e){
                            System.out.println("Incorrect Input");
                        }
                    }
                }
            }

        }catch(Exception e){
            e.printStackTrace();
        }
    }


    public JDBCConnection(String url) throws Exception{
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
    
    public void showMoviesGivenStar(String firstname,String lastname) throws Exception{
        StringBuilder sb = new StringBuilder();
        String query = "SELECT m.* FROM stars_in_movies as sm, stars as s, movies as m WHERE sm.star_id = s.id AND sm.movie_id = m.id AND s.first_name like '%"+firstname+"%' AND s.last_name like '%"+lastname+"%'";

        try (Connection conn = DriverManager.getConnection(url,username,password ) ) {
            try (Statement stmt = conn.createStatement()) {
                try(ResultSet rs = stmt.executeQuery(query)){
                    while ( rs.next() ) {
                        for (int i = 2; i <= rs.getMetaData().getColumnCount(); i++) {
                            int type = rs.getMetaData().getColumnType(i);
                            sb.append(movie_attrs[i-2]);
                            if (type == Types.VARCHAR || type == Types.CHAR) {
                                sb.append(rs.getString(i)+" ");
                            } else {
                                sb.append(rs.getLong(i)+" ");
                            }
                            if(i==4||i==5){
                                sb.append("\n\t");
                            }
                        }
                        sb.append("\n");
                    }
                }
                
            }
        }
        System.out.println(sb.toString());
    }

    public void showMoviesGivenStarByID(int id) throws Exception{
        StringBuilder sb = new StringBuilder();
        String query = "SELECT m.* FROM stars_in_movies as sm, stars as s, movies as m WHERE sm.star_id = s.id AND sm.movie_id = m.id AND s.id="+id;

        try (Connection conn = DriverManager.getConnection(url,username,password ) ) {
            try (Statement stmt = conn.createStatement()) {
                try(ResultSet rs = stmt.executeQuery(query)){
                    
                    while ( rs.next() ) {
                        for (int i = 2; i <= rs.getMetaData().getColumnCount(); i++) {
                            int type = rs.getMetaData().getColumnType(i);
                            sb.append(movie_attrs[i-2]);
                            if (type == Types.VARCHAR || type == Types.CHAR) {
                                sb.append(rs.getString(i)+" ");
                            } else {
                                sb.append(rs.getLong(i)+" ");
                            }
                            if(i==4||i==5){
                                sb.append("\n\t");
                            }
                        }
                        sb.append("\n");
                    }
                }
                
            }
        }
        System.out.println(sb.toString());
    }


    public void insertStarByName(String firstname,String lastname, String dob, String photo) throws Exception{
        int result = 0;
        try {
            // Class.forName("com.mysql.jdbc.Driver").newInstance();
            conn = DriverManager.getConnection(url,username, password);
            
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
            System.out.println("Incorrect format");
            e.printStackTrace();
        } 
        
        System.out.println("Sucess");
    }

     public boolean existCreditByCardNumber(String number) {
        try {
            //Class.forName("com.mysql.jdbc.Driver").newInstance();
            conn = DriverManager.getConnection(url, username, password);

            String sql = "select * from creditcards where id = ?";
            pst = conn.prepareStatement(sql);
            pst.setString(1, number);
            rs = pst.executeQuery();
            if (rs.next())
                return true;
            if (conn != null)
                conn.close();
            if (pst != null)
                pst.close();
            if (rs != null)
                rs.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public void insertCustomer(String firstname,String lastname, String cc_id, String address, String email, String pass) throws Exception{
        if (existCreditByCardNumber(cc_id)) {
            try(Connection conn = DriverManager.getConnection(url, username, password)) {
                String sql = "insert into customers (first_name, last_name, cc_id, address, email, password)  values (?, ? , ?, ? , ? ,?)";
                try(PreparedStatement pst = conn.prepareStatement(sql)){
                    pst.setString(1, firstName);
                    pst.setString(2, lastName);
                    pst.setString(3, cc_id);
                    pst.setString(4, address);
                    pst.setString(5, email);
                    pst.setString(6, pass);
                    
                    int result = pst.executeUpdate();               
                    
                    if (conn != null)
                        conn.close();
                    if (pst != null)
                        pst.close();
                    System.out.println("Success");
                    return;
                }
            }
        }else{
            System.out.println("No Creditcard found");
        }
        
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
    
    public void deleteCustomerById(int id)throws Exception {
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
            System.out.println("Incorrect input");
        }
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