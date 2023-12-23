package Models;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;

public class Payment {

    Connection con;

    UserMetaData userMetaData = new UserMetaData();

    public Payment() {
        try {
            Database db = Database.getInstance();
            con = db.connect();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public void addVisa(String name, String cvv, String cardNumber, String expDate) {
        String query = "exec spAddVisa ?, ?, ?, ?, ?";
        try {
            CallableStatement cst = con.prepareCall(query);
            cst.setInt(1, userMetaData.getCustomerId());
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

}
