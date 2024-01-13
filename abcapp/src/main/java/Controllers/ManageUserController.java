package Controllers;

import Models.ManageUser;
import javafx.fxml.FXML;
import javafx.scene.control.TableView;

import java.sql.ResultSet;
import java.sql.SQLException;


public class ManageUserController extends ASideBar implements Drawing{

    ManageUser mu = new ManageUser();

    @FXML
    TableView<?> users;

    @FXML
    void loggedIn() {
        try (ResultSet rs = mu.getLoggedIn()){
            drawTable(rs,users);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @FXML
    void loginHistory() {
        try (ResultSet rs = mu.getLoginHistory()){
            drawTable(rs,users);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
}
