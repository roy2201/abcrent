package Models;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class ManageUser {

    Connection con;

    public ManageUser() {
        try {
            Database db = Database.getInstance();
            con = db.connect();
        } catch (SQLException e) {
            throw new RuntimeException("Failed connecting to database from class ManageUser",e);
        }
    }

    public ResultSet getLoggedIn() {
        String query="select * from vwLoggedUsers";
        try {
            PreparedStatement ps = con.prepareStatement(query);
            return ps.executeQuery();
        } catch (SQLException e){
            throw new RuntimeException("could not find vwLoggedUsers", e);
        }
    }

    public ResultSet getLoginHistory() {
        String query="select * from vwLoginHistory";
        try {
            PreparedStatement ps = con.prepareStatement(query);
            return ps.executeQuery();
        } catch (SQLException e){
            throw new RuntimeException("could not find vwLoggedUsers", e);
        }
    }

}
