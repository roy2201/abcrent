package Models;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;

public class CreditCard {


    UserMetaData userMetaData = new UserMetaData();

    Connection con;

    public CreditCard() {
        try {
            Database db = Database.getInstance();
            con = db.connect();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public void addCard(String name, String expDate, String cvv, String cardNum) {
        String query = "exec spAddVisa ?, ?, ?, ?, ?";
        try {
            CallableStatement cst = con.prepareCall(query);
            cst.setInt(1, userMetaData.getCustomerId());
            cst.setString(2, expDate);
            cst.setString(3, cvv);
            cst.setString(4, cardNum);
            cst.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

}
