package Controllers;

import Models.AddInsurance;
import Models.SharedAdminData;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.control.Label;
import javafx.scene.control.TextField;


public class AddInsuranceController extends Navigation
        implements Drawing, Validation
{

    @FXML
    private TextField expDate;

    @FXML
    private Label infoLabel;

    @FXML
    private TextField insNum;

    @FXML
    private TextField insProvider;

    @FXML
    private TextField startDate;

    AddInsurance ai = new AddInsurance();

    SharedAdminData sad = new SharedAdminData();

    @FXML
    void AddInsurance() {

        if (validateInputs()) {

            if (ai.addInsurance(sad.getSelectedCarID(),
                                startDate.getText(),
                                expDate.getText(),
                                Integer.parseInt(insNum.getText()),
                                insProvider.getText()
            )) {
                showSuccessMsg(infoLabel, "Added");
            } else {
                showErrorMsg(infoLabel, "Error Adding");
            }
        } else {
            showErrorMsg(infoLabel, "Invalid input");
        }

    }


    @FXML
    void back(ActionEvent event) {
        goToPage(event, "CarInsurance.fxml", "Car Insurance");
    }


    public boolean validateInputs() {
        return isValidDate(expDate) &&
                isValidDate(startDate) &&
                isNonBlank(insProvider) &&
                isPosInt(insNum);
    }

}
