import java.sql.*;
import java.util.List;

// If you are looking for Java data structures, these are highly useful.
// Remember that an important part of your mark is for doing as much in SQL (not Java) as you can.
// Solutions that use only or mostly Java will not receive a high mark.
//import java.util.ArrayList;
//import java.util.Map;
//import java.util.HashMap;
//import java.util.Set;
//import java.util.HashSet;
public class Assignment2 extends JDBCSubmission {

    public Assignment2() throws ClassNotFoundException {
        Class.forName("org.postgresql.Driver");
    }

    @Override
    public boolean connectDB(String url, String username, String password) {
        // Implement this method!
        try {
            this.connection = DriverManager.getConnection(url, username, password);
        } catch(SQLException se) {
            return false;
        }
        System.out.println("Connected to database");
        return true;
    }

    @Override
    public boolean disconnectDB() {
        // Implement this method!
    	try {
			this.connection.close();
		} catch (SQLException e) {
            System.out.println("Failed to disconnect database!");
            return false;
        }
    	System.out.println("Disconnected to database");
		return true;
    }
    
    public void test() {
    	try {
    		String sql = " SELECT * FROM parlgov.country ";
        	PreparedStatement ps = this.connection.prepareStatement(sql); 
        	ResultSet rs = ps.executeQuery();
        	while(rs.next()){
        		System.out.print(rs.getInt("id")+"        ");
        		System.out.print(rs.getString("name")+"       ");
        		System.out.print(rs.getString("abbreviation")+"     ");
        		System.out.println(rs.getDate("oecd_accession_date"));
        	}
            //Close the resultset
        	rs.close();
            ps.close();
		} catch (SQLException e) {
            e.printStackTrace();          
        }
    }

    @Override
    public ElectionCabinetResult electionSequence(String countryName) {
        // Implement this method!
    	try {
            String sqlText = " SELECT * " +
                      " FROM player " + 
                      " WHERE countryName= ? DESC";
            PreparedStatement ps = connection.prepareStatement(sqlText);
            ps.setString(1, countryName);
            ResultSet rs = ps.executeQuery();
            // code for return the list

            //Close the resultset
            rs.close();
            ps.close();
		} catch (SQLException e) {
            System.out.println("DisconnectDB failed!");
            return false;
        }
		return true;
    }

     @Override
     public List<Integer> findSimilarPoliticians(Integer politicianName, Float threshold) {
         // Implement this method!
         return null;
     }

    public static void main(String[] args) {
        // You can put testing code in here. It will not affect our autotester.
        System.out.println("Hello");
        try {
        	Assignment2 a2instance = new Assignment2();
        	a2instance.connectDB("jdbc:postgresql://localhost:5432/CSC343", "postgres", "****");
        	a2instance.test();
        	a2instance.disconnectDB();
        }
        catch(ClassNotFoundException e) {
        	e.printStackTrace();
        }
    }

}

