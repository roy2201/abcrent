package Controllers;

import javafx.event.ActionEvent;
import javafx.fxml.FXML;

public class ASideBar extends Navigation{

    @FXML
    void CarInsurancePage(ActionEvent event) {
        goToPage(event, "CarInsurance.fxml", "Car Insurance");
    }
    @FXML
    void ManageUsersPage(ActionEvent event) {
        goToPage(event, "ManageUser.fxml", "Manage Users");
    }

    @FXML
    void MoreCarControlsPage(ActionEvent event) {
        goToPage(event, "AdvancedControls.fxml", "Advanced Car Controls");
    }

    @FXML
    void ManageRefundsPage(ActionEvent event) {
        goToPage(event, "ManageRefund.fxml", "Advanced Car Controls");
    }
    @FXML
    void ManageCarsPage(ActionEvent event) {
        goToPage(event, "ManageCars.fxml", "Advanced Car Controls");
    }
}
