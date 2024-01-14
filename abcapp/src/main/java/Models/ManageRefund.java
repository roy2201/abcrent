package Models;

import java.sql.*;

public class ManageRefund {

    Connection con;

    public ManageRefund() {
        try {
            Database db = Database.getInstance();
            con = db.connect();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public ResultSet getPendingRequests() {
        String query = "select * from vwPendingRequests";
        try {
            PreparedStatement ps = con.prepareStatement(query);
            return ps.executeQuery();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public ResultSet getAllRefunds(){
        String query="select * from vwRefundRequests";
        try {
            PreparedStatement ps = con.prepareStatement(query);
            return ps.executeQuery();
        } catch (SQLException e){
            throw new RuntimeException("could not find vwRefundRequests", e);
        }
    }

    public int DoRefund(int reqID, int percentage) {

        String query = "exec spRefund ?,?,?,?";
        try {
            CallableStatement cst = con.prepareCall(query);
            cst.setInt(1, reqID);
            cst.setInt(2, percentage);
            cst.registerOutParameter(3, Types.DECIMAL);
            cst.registerOutParameter(4, Types.INTEGER);
            cst.executeUpdate();
            System.out.printf("%f", cst.getBigDecimal(3));
            return cst.getInt(3);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
}
