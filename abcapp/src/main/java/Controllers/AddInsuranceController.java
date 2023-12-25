package Controllers;

import javafx.event.ActionEvent;
import javafx.fxml.FXML;

public class AddInsuranceController extends Navigation{


    @FXML
    void back(ActionEvent event) {
        goToPage(event, "CarInsurance.fxml", "Car Insurance");
    }

}