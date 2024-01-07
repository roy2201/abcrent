package Models;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class Customer {

    Connection con;

    UserMetaData userMetaData = new UserMetaData();

    public Customer() {
        try {
            Database db = Database.getInstance();
            con = db.connect();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public ResultSet loadTypes() {
        String query = "exec spLoadTypes";
        try {
            PreparedStatement ps = con.prepareStatement(query);
            return ps.executeQuery();
        } catch (SQLException e) {
            throw new RuntimeException("Error executing stored procedure for spAddVisa",e);
        }
    }

    public ResultSet loadMake() {
        String query = "exec spLoadManufacturer";
        try {
            PreparedStatement ps = con.prepareStatement(query);
            return ps.executeQuery();
        } catch (SQLException e) {
            throw new RuntimeException("Error executing stored procedure for spLoadManufacturer",e);
        }
    }

    public ResultSet filteredSearchAction(String type, String make) {
        String query = "exec spViewMatches ?, ?";
        try {
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, type);
            ps.setString(2, make);
            return ps.executeQuery();
        } catch (SQLException e) {
            throw new RuntimeException("Error executing stored procedure for spViewMatches",e);
        }
    }

    public void signOut() {
        String query = "exec spSignOut ?";
        try {
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, userMetaData.getCustomerId());
            ps.execute();
        } catch (SQLException e) {
            throw new RuntimeException("Error executing stored procedure for spSignOut",e);
        }
    }
}
