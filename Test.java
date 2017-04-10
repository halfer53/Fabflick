
public class Test {
	public static void main(String[] args) {
		String url = "jdbc:mysql://localhost/moviedb?useSSL=false";
		String username = "root";
		String password = "857263";
		JDBCConnection jdbc = new JDBCConnection(username, password, url);
		//jdbc.testDB();
		//int result = jdbc.insertStarByName("Yue Sun", "1987-05-27", "yuesun.bmp");
		//System.out.println(result);
		//jdbc.showDatabaseSchema();
		jdbc.executeSQL("insert into stars(first_name, last_name, dob, photo_url) values ('Jun', 'Jun' , '1985-06-23', 'url is url')");
		//jdbc.executeSQL("select * from stars");
	}
}
