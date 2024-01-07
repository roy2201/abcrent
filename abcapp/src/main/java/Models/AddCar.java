package Models;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;

public class AddCar {

    Connection con;

    public AddCar() {
        try {
            Database db = Database.getInstance();
            con = db.connect();
        } catch (SQLException e) {
            throw new RuntimeException("Failed connecting to database from class AddCar",e);
        }
    }

    public void addCar(String license, String color, String make, String model, String type, int mileage) {

        String query = "exec spAddCar ?,?,?,?,?,?";
        try {
            CallableStatement cst = con.prepareCall(query);
            cst.setString(1, license);
            cst.setString(2, color);
            cst.setString(3, make);
            cst.setString(4, model);
            cst.setString(5, type);
            cst.setInt(6, mileage);
            cst.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Failed executing stored procedure spAddCar",e);
        }
    }
}