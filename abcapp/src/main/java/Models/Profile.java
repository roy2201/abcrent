package Models;

import java.sql.*;

public class Profile {

    Connection con;

    UserMetaData userMetaData = new UserMetaData();

    public Profile() {
        try {
            Database db = Database.getInstance();
            con = db.connect();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public ResultSet viewCards() {

        String query = "exec spViewMyCards ?";
        try {
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, userMetaData.getCustomerId());
            return ps.executeQuery();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

    }

    public ResultSet viewMyRequests() {

        String query = "exec spViewMyRequests ?";
        try {
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, userMetaData.getCustomerId());
            return ps.executeQuery();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

    }

    public ResultSet viewMyRents() {

        String query = "exec spViewMyRents ?";
        try {
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, userMetaData.getCustomerId());
            return ps.executeQuery();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

    }
}
