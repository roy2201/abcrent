package Controllers;

import Models.Profile;
import javafx.beans.property.SimpleStringProperty;
import javafx.beans.value.ObservableValue;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.util.Callback;

import java.sql.ResultSet;
import java.sql.SQLException;

public class ProfileController extends CSideBar implements Drawing{

    Profile profile = new Profile();

    @FXML
    private TableView<?> profileTable;

    @FXML
    void AddCard(ActionEvent event) {
        goToPage(event,"CreditCard.fxml", "Add New Credit Card");
    }

    @FXML
    void ChangePassword(ActionEvent event) {
        goToPage(event, "ChangePassword.fxml", "Change Your Password");
    }

    @FXML

    void MyCards(ActionEvent event) {
        try (ResultSet rs = profile.viewCards()){
            drawTable(rs,profileTable);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @FXML
    void MyRents(ActionEvent event) {
        try (ResultSet rs = profile.viewMyRents()){
            drawTable(rs,profileTable);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @FXML
    void MyRequests(ActionEvent event) {
        try (ResultSet rs = profile.viewMyRequests()){
            drawTable(rs,profileTable);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @FXML
    void Subscribe(ActionEvent event) {

    }


}
