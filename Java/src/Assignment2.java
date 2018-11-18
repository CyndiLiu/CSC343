import java.sql.*;
import java.util.List;

// If you are looking for Java data structures, these are highly useful.
// Remember that an important part of your mark is for doing as much in SQL (not Java) as you can.
// Solutions that use only or mostly Java will not receive a high mark.
import java.util.ArrayList;
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
    
    public void test(String countryName) {
    	List<Integer> elections = new ArrayList<>();
		List<Integer> cabinets = new ArrayList<>();
		ElectionCabinetResult e_result;
    	try {
    		
    		
            String sql = "SELECT elec.id, cab.id" +
            		" FROM parlgov.election AS elec, parlgov.country AS coun, parlgov.cabinet AS cab" +
            		" WHERE cab.election_id = elec.id AND elec.country_id = coun.id AND coun.name = ?" +
            		" ORDER BY elec.e_date";
    		
        	PreparedStatement ps = this.connection.prepareStatement(sql); 
        	ps.setString(1, countryName);
        	ResultSet rs = ps.executeQuery();
        	while(rs.next()){
        		int e_id = rs.getInt(1);
        		int c_id = rs.getInt(2);
        		elections.add(e_id);
        		cabinets.add(c_id);
        	}
        	e_result = new ElectionCabinetResult(elections, cabinets);
		} catch (SQLException e) {
            e.printStackTrace();          
        }
    }

    @Override
    public ElectionCabinetResult electionSequence(String countryName) {
        // Implement this method!
    	List<Integer> elections = new ArrayList<>();
		List<Integer> cabinets = new ArrayList<>();
		ElectionCabinetResult e_result;
    	try {
    		
    		
            String sql = "SELECT elec.id, cab.id" +
            		" FROM parlgov.election AS elec, parlgov.country AS coun, parlgov.cabinet AS cab" +
            		" WHERE cab.election_id = elec.id AND elec.country_id = coun.id AND coun.name = ?" +
            		" ORDER BY elec.e_date";
    		
        	PreparedStatement ps = this.connection.prepareStatement(sql); 
        	ps.setString(1, countryName);
        	ResultSet rs = ps.executeQuery();
        	while(rs.next()){
        		int e_id = rs.getInt(1);
        		int c_id = rs.getInt(2);
        		elections.add(e_id);
        		cabinets.add(c_id);
        	}
		} catch (SQLException e) {
            e.printStackTrace();          
        }
    	e_result = new ElectionCabinetResult(elections, cabinets);
		return e_result;
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
        	// a2instance.test("Japan");
        	a2instance.electionSequence("Japan");
        	a2instance.disconnectDB();
        }
        catch(ClassNotFoundException e) {
        	e.printStackTrace();
        }
    }

}

