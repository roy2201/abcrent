package Models;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Types;

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

    public int addCard(String name, String expDate, String cvv, String cardNum) {
        String query = "exec spAddVisa ?, ?, ?, ?, ?, ?";
        try {
            CallableStatement cst = con.prepareCall(query);
            cst.setInt(1, userMetaData.getCustomerId());
            cst.setString(2, name);
            cst.setString(3, expDate);
            cst.setString(4, cvv);
            cst.setString(5, cardNum);
            cst.registerOutParameter(6, Types.INTEGER);
            cst.executeUpdate();
            return cst.getInt(6);
        } catch (SQLException e) {
            throw new RuntimeException("Error executing stored procedure for spAddVisa",e);
        }
    }


}
