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

    // Constructor
    public Assignment2() throws ClassNotFoundException {

        Class.forName("org.postgresql.Driver");
    }

     /**
     * Connects and sets the search path.
     * 
     * Return true if connecting is successful, false otherwise.
     */
    public boolean connectDB(String url, String username, String password) {
        try {
			this.connection = DriverManager.getConnection(url, username, password); 
		} catch (SQLException e) {
			System.out.println("Failed to connect to database!");
			return false;
		}

		if (this.connection == null) {
			return false;
		}

		return true;
    }

    /**
     * Closes the database connection.
     * 
     * Return true if the closing was successful, false otherwise.
     */
    public boolean disconnectDB() {
        try {
			this.connection.close();
		} catch (SQLException e) {
            System.out.println("Failed to disconnect database!");
            return false;
        }
		return true;	   
    }
    
    /**
     * Returns the list of elections over the years in descending order of years
     * and the cabinets that have formed after each election.
     */
    public ElectionCabinetResult electionSequence(String countryName) {
        try {
            sqlText = " SELECT count(*) AS rownum " +
                      " FROM player " + 
                      " WHERE countryName= ?" DESC;
            ps = connection.prepareStatement(sqlText);
            ps.setInt(1, countryName);
            rs = ps.executeQuery();
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
    }

}

