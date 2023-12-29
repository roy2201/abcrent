package Models;

import java.sql.*;

public class Admin {

    Connection con;

    AdminSharedData asd = new AdminSharedData();

    public Admin() {
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

    public ResultSet getCarHistory() {
        String query = "Select * From vwCarsHistory";
        try {
            PreparedStatement ps = con.prepareStatement(query);
            return ps.executeQuery();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public ResultSet getOverDue() {
        String query = "Select * From vwCarsOverDue";
        try {
            PreparedStatement ps = con.prepareStatement(query);
            return ps.executeQuery();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public void deleteCar(int cid) {
        String query = "exec spDeleteCar ?";
        try {
            CallableStatement cst = con.prepareCall(query);
            cst.setInt(1,cid);
            cst.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public ResultSet getRentsInfo() {
        String query = "select * from vwRentsInfo";
        try {
            PreparedStatement ps = con.prepareStatement(query);
            return ps.executeQuery();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public ResultSet getRented() {
        String query = "select * from vwRented";
        try {
            PreparedStatement ps = con.prepareStatement(query);
            return ps.executeQuery();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public int ConfirmCarArrival(int carID, int asdMile) {

        String query = "Exec spConfirmArrival ?,?,?";
        try {
            CallableStatement cst = con.prepareCall(query);
            cst.setInt(1, carID);
            cst.setInt(2, asdMile);
            cst.registerOutParameter(3, Types.INTEGER);
            cst.executeUpdate();
            return cst.getInt(3);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

    }

}
