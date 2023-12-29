package Controllers;

import javafx.event.ActionEvent;
import javafx.fxml.FXML;
public class CarInsuranceController extends ASideBar{

    @FXML
    void AddInsurance(ActionEvent event) {
        goToPage(event, "AddInsurance.fxml", "Add New Car Insurance");
    }

}
