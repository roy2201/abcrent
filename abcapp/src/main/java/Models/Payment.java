package Models;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Types;

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

    public boolean isValidCard(String name, String number, String cvv, String expDate) {
        String query = "exec spValidateCard ?, ?, ?, ?, ?, ?";
        try {
            CallableStatement cst = con.prepareCall(query);
            cst.setInt(1, userMetaData.getCustomerId());
            cst.setString(2, name);
            cst.setString(3, number);
            cst.setString(4, cvv);
            cst.setString(5, expDate);
            cst.registerOutParameter(6, Types.BOOLEAN);
            cst.execute();
            return cst.getBoolean(6);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public int pay(String cardNumber) {
        String query = "exec spRentCar ?, ?, ?, ?, ?";
        try {
            CallableStatement cst = con.prepareCall(query);
            cst.setInt(1, userMetaData.getCustomerId());
            cst.setInt(2, userMetaData.getCarId());
            cst.setInt(3, userMetaData.getNbDays());
            cst.setString(4, cardNumber);
            cst.registerOutParameter(5, Types.INTEGER);
            cst.execute();
            return cst.getInt(5);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }


}
