package Models;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Types;

public class ChangePassword {

    Connection con;

    UserMetaData userMetaData = new UserMetaData();

    public ChangePassword() {
        try {
            Database db = Database.getInstance();
            con = db.connect();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }


    public int PasswordChange(String newPassword) {

        String query = "exec spChangePassword ?,?,?";
        try {
            CallableStatement cst = con.prepareCall(query);
            cst.setString(1, newPassword);
            cst.setInt(2, userMetaData.getCustomerId());
            cst.registerOutParameter(3, Types.INTEGER);
            cst.executeUpdate();
            return cst.getInt(3);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

}
