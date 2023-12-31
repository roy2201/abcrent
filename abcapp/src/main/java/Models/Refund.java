package Models;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Types;

public class Refund {


    Connection con;

    UserMetaData userMetaData = new UserMetaData();

    public Refund() {
        try {
            Database db = Database.getInstance();
            con = db.connect();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public int initRefundRequest(int RentID, String reason, String email, String cardNumber) {

        String query = "exec spInitRefundRequest ?,?,?,?,?,?";
        try {
            CallableStatement cst = con.prepareCall(query);
            cst.setInt(1, RentID);
            cst.setInt(2, userMetaData.getCustomerId());
            cst.setString(3, reason);
            cst.setString(4, email);
            cst.setString(5, cardNumber);
            cst.registerOutParameter(6, Types.INTEGER);
            cst.executeUpdate();
            return cst.getInt(6);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

}
