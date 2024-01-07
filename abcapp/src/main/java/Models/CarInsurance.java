package Models;

import java.sql.*;

public class CarInsurance {

    Connection con;


    public CarInsurance() {
        try {
            Database db = Database.getInstance();
            con = db.connect();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }


    public ResultSet getAllCars() {
        String query = "Select * From vwAllCars";
        try {
            PreparedStatement ps = con.prepareStatement(query);
            return ps.executeQuery();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }


    public ResultSet getAllInsurance() {
        String query = "select * from vwAllInsurance";
        try {
            PreparedStatement ps = con.prepareStatement(query);
            return ps.executeQuery();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

    }

    public ResultSet getExpiredInsurance() {
        String query = "select * from vwExpiredInsurance";
        try {
            PreparedStatement ps = con.prepareStatement(query);
            return ps.executeQuery();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public int RenewInsurance(int cid) {
        String query = "exec spRenewInsurance ?,?";
        try {
            CallableStatement cst = con.prepareCall(query);
            cst.setInt(1, cid);
            cst.registerOutParameter(2,Types.INTEGER);
            cst.executeUpdate();
            return cst.getInt(2);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
}
