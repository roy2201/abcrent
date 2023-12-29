package Controllers;

import Models.AdminSharedData;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.control.Label;
import javafx.scene.control.TextField;

public class SetMileageController extends Navigation{

    @FXML
    private TextField mile;

    @FXML
    private Label infoLabel;

    AdminSharedData asd = new AdminSharedData();

    @FXML
    public void SetMile(ActionEvent event) {
    }

    @FXML
    void back(ActionEvent event) {
        goToPage(event, "Admin.fxml", "Manage Cars");
    }

}
