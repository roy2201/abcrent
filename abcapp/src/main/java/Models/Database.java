package Models;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class Database {
    private static volatile Database databaseInstance;
    private static final Logger logger = Logger.getLogger(Database.class.getName());
    private static final String USERNAME = "sa";
    private static final String PASSWORD = "root123123";
    private static final String CONN_STR = "jdbc:sqlserver://localhost\\sqlExpress:1433;databaseName=abcRent;"+ "encrypt=true;trustServerCertificate=true";

    public static Database getInstance() throws SQLException {
        if (databaseInstance == null) {
            synchronized (Database.class) {
                if (databaseInstance == null) {
                    databaseInstance = new Database();
                }
            }
        }
        return databaseInstance;
    }

    public Connection connect() throws SQLException {
        Connection connection;
        try {
            logger.info("\u001B[32m" + "Connecting" + "\u001B[0m");
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            connection = DriverManager.getConnection(CONN_STR, USERNAME, PASSWORD);
            logger.info("\u001B[32m" + "Connected" + "\u001B[0m");
        } catch (ClassNotFoundException | SQLException e) {
            logger.log(Level.SEVERE, "Connection failed: " + e.getMessage(), e);
            throw new SQLException("Connection failed", e);
        }
        return connection;
    }
    
}
