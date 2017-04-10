import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.util.logging.Logger;

public class JDBCConnection {
	static String username;
	static String password;
	static String url;
    static Connection conn;
    static PreparedStatement pst;
	static ResultSet rs;

	public JDBCConnection(String username, String password, String url) {
		this.username = username;
		this.password = password;
		this.url = url;
	}
	
	
	public boolean existCreditByCardNumber(int number) {
		try {
			Class.forName("com.mysql.jdbc.Driver").newInstance();
			conn = DriverManager.getConnection(url,username, password);
			
			String sql = "select * from creditcards where id = ?";
			pst =conn.prepareStatement(sql);
			pst.setInt(1, number);
		    rs = pst.executeQuery();
		    if (rs.next()) return true;
			if (conn != null) conn.close();
			if (pst != null) pst.close();
			if (rs != null) rs.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}
	public int insertCustomer(int number, String name) {
		int result = 0;
		if (existCreditByCardNumber(number)) {
			result = 1;
		}
 		
		return result;
	} 
	
	public void showStarsByNameOrId(String names, int id) {
		
	}
	public int insertStarByName(String name, String dob, String photo) {
		String[] strs = name.trim().split(" ");
		String firstName = "";
		String lastName = "";
		int result = 0;
		switch (strs.length) {
		case 0:
			return result;
		case 1:
			lastName = strs[0];
			break;
		case 2:
			firstName = strs[0];
			lastName = strs[1];
			break;
		case 3: 
			return result;
		}
		try {
			Class.forName("com.mysql.jdbc.Driver").newInstance();
			conn = DriverManager.getConnection(url,username, password);
			System.out.println("Database connection successfully");
			
			String sql = "insert into stars(first_name, last_name, dob, photo_url) values (?,?,?,?)";
			pst =conn.prepareStatement(sql);
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
	
	public void showDatabaseSchema() {
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
	
	public int deleteCustomerById(int id) {
		int result = 0;
		try {
			Class.forName("com.mysql.jdbc.Driver").newInstance();
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
	
	public void executeSQL(String sql) {
		try{
			Class.forName("com.mysql.jdbc.Driver").newInstance();
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
