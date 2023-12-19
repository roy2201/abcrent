package Models;

import java.sql.Connection;
import java.sql.PreparedStatement;
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

    public void signOut() {
        String query = "exec spSignOut ?";
        try {
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, userMetaData.getCustomerId());
            ps.execute();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
}
