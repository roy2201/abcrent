package Models;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;

public class AddInsurance {

    Connection con;

    public AddInsurance() {
        try {
            Database db = Database.getInstance();
            con = db.connect();
        } catch (SQLException e) {
            throw new RuntimeException("Failed connecting to database from class AddInsurance",e);
        }
    }

    public boolean addInsurance(int carID, String startDate, String endDate, int insNum, String insProvider) {

        String query = "exec spAddInsurance ?,?,?,?,?";
        try {
            CallableStatement cst = con.prepareCall(query);
            cst.setInt(1, carID);
            cst.setString(2, insProvider);
            cst.setInt(3, insNum);
            cst.setString(4, startDate);
            cst.setString(5, endDate);
            cst.executeUpdate();
            return true;
        } catch (SQLException e) {
            throw new RuntimeException("Failed executing stored procedure spAddInsurance",e);
        }
    }
}
