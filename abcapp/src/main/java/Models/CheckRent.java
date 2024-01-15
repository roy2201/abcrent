package Models;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Types;

public class CheckRent{

    Connection con;

    UserMetaData userMetaData = new UserMetaData();

    private int DaysLeft;

    private float Penalty;

    public CheckRent() {
        try {
            Database db = Database.getInstance();
            con = db.connect();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public int getDaysLeft() {
        return DaysLeft;
    }

    public float getPenalty() {
        return Penalty;
    }

    public int giveRentInfo(int RentID) {

        //TODO : if car is returned (confirm arrival) before its exp date, then display this information

        String query = "exec spCheckMyRent ?,?,?,?,?";

        try {
            CallableStatement cst = con.prepareCall(query);
            cst.setInt(1, userMetaData.getCustomerId());
            cst.setInt(2, RentID);
            cst.registerOutParameter(3, Types.INTEGER);
            cst.registerOutParameter(4, Types.FLOAT);
            cst.registerOutParameter(5, Types.INTEGER);
            cst.execute();
            DaysLeft = cst.getInt(3);
            Penalty  = cst.getFloat(4);
            return cst.getInt(5);
        } catch (SQLException e) {
            throw new RuntimeException("Error Executing Stored Procedure For Rent Info",e);
        }
    }

}
