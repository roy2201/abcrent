package Models;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Types;

public class SetMileage {

    Connection con;


    public SetMileage() {
        try {
            Database db = Database.getInstance();
            con = db.connect();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }


    public int ConfirmArrival(int carID, int mile) {
        String query = "Exec spConfirmArrival ?,?,?";
        try {
            CallableStatement cst = con.prepareCall(query);
            cst.setInt(1, carID);
            cst.setInt(2, mile);
            cst.registerOutParameter(3, Types.INTEGER);
            cst.executeUpdate();
            return cst.getInt(3);
        } catch (
                SQLException e) {
            throw new RuntimeException(e);
        }
    }

}
