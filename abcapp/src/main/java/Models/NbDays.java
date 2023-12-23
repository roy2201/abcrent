package Models;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Types;

public class NbDays {

    Connection con;

    UserMetaData userMetaData = new UserMetaData();

    public NbDays() {
        try {
            Database db = Database.getInstance();
            con = db.connect();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public float calcSubTotal(int nbDays) {
        String query = "{ ? = call fnCalculateTotalPayment(?, ?) }";
        try (CallableStatement cst = con.prepareCall(query)) {
            cst.registerOutParameter(1, Types.INTEGER);
            cst.setInt(2, userMetaData.getCarId());
            cst.setInt(3, nbDays);
            cst.execute();
            return cst.getFloat(1);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

}
