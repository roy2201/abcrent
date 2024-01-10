package Controllers;

import Models.AddCar;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.control.Label;
import javafx.scene.control.TextField;

public class AddCarController extends Navigation implements Drawing, Validation {

    @FXML
    private TextField color;

    @FXML
    private TextField license;

    @FXML
    private TextField make;

    @FXML
    private TextField mile;

    @FXML
    private TextField model;

    @FXML
    private TextField type;

    @FXML
    private Label infoLabel;

    AddCar ac = new AddCar();

    @FXML
    void AddCar() {

        if(validateInputs()) {

            ac.addCar(
                    license.getText(),
                    color.getText(),
                    make.getText(),
                    model.getText(),
                    type.getText(),
                    Integer.parseInt(mile.getText())
            );
            showSuccessMsg(infoLabel, "Success");
        } else {
            showErrorMsg(infoLabel, "Invalid Input");
        }
    }

    public boolean validateInputs() {
        return isNonBlank(color, license, make, model, type) && isPosInt(mile);
    }

    @FXML
    void back(ActionEvent event) {
        goToPage(event, "Admin.fxml", "Manage Cars");
    }

}
