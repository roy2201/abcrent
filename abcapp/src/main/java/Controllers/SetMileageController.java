package Controllers;

import Models.SetMileage;
import Models.SharedAdminData;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.control.Label;
import javafx.scene.control.TextField;

public class SetMileageController extends Navigation implements Drawing, Validation{

    @FXML
    private TextField mile;

    @FXML
    private Label infoLabel;

    SetMileage sm = new SetMileage();

    SharedAdminData sad = new SharedAdminData();
    @FXML
    public void ConfirmArrival() {

        if(isPosInt(mile)) {

            switch(sm.ConfirmArrival(
                    sad.getSelectedCarID(),
                    Integer.parseInt(mile.getText())
            ))
            {
                case 1:
                    showErrorMsg(infoLabel, "Car not rented");
                    break;
                case 0:
                    showSuccessMsg(infoLabel, "Success");
            }
        } else {
            showErrorMsg(infoLabel, "Failed");
        }
    }

    @FXML
    void back(ActionEvent event) {
        goToPage(event, "Admin.fxml", "Manage Cars");
    }

}
