package Models;

import java.sql.*;

public class SignIn {

    Connection con;

    UserMetaData userMetaData = new UserMetaData();

    public SignIn() {
        try {
            Database db = Database.getInstance();
            con = db.connect();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public int Login(String user, String pass) throws SQLException {
        String query = "exec spSignIn ?, ?, ?, ?";
        CallableStatement cst = con.prepareCall(query);
        cst.setString(1, user);
        cst.setString(2, pass);
        cst.registerOutParameter(3, Types.INTEGER);
        cst.registerOutParameter(4, Types.INTEGER);
        cst.execute();
        userMetaData.setCustomerId(cst.getInt(4));
        return cst.getInt(3);
    }

}
