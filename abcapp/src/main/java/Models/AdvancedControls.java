package Models;

import java.sql.*;

public class AdvancedControls {

    Connection con;

    public AdvancedControls() {
        try {
            Database db = Database.getInstance();
            con = db.connect();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public ResultSet RentedBetween(String date1, String date2) {

        String query = "exec spRentedBetween ?, ?";
        try {
            CallableStatement cst = con.prepareCall(query);
            cst.setString(1, date1);
            cst.setString(2, date2);
            return cst.executeQuery();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public ResultSet ArrivedBetween(String date1, String date2) {

        String query = "exec spArrivedBetween ?, ?";
        try {
            CallableStatement cst = con.prepareCall(query);
            cst.setString(1, date1);
            cst.setString(2, date2);
            return cst.executeQuery();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public ResultSet CarRevenue(int greater, int less) {

        String query = "exec spCarRevenue ?, ?";
        try {
            CallableStatement cst = con.prepareCall(query);
            cst.setInt(1, greater);
            cst.setInt(2, less);
            return cst.executeQuery();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
}
