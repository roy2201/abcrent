package Models;

import java.sql.*;

public class SignUp {

    Connection con;

    public SignUp() {
        try {
            Database db = Database.getInstance();
            con = db.connect();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public boolean addCustomer(String fName, String lName, String age, String address, String email, String password) throws Exception {
        String query = "exec spSignUp ?,?,?,?,?,?,?";
        CallableStatement cst = con.prepareCall(query);
        cst.setString(1, fName);
        cst.setString(2, lName);
        cst.setString(3, String.valueOf(Integer.parseInt(age)));
        cst.setString(4, address);
        cst.setString(5, email);
        cst.setString(6, password);
        cst.registerOutParameter(7, Types.BOOLEAN);
        cst.executeUpdate();
        return cst.getBoolean(7);
    }


}
