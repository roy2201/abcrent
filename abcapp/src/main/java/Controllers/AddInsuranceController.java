package Controllers;

import Models.AddInsurance;
import Models.SharedAdminData;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.control.Label;
import javafx.scene.control.TextField;

import java.text.ParseException;
import java.text.SimpleDateFormat;

public class AddInsuranceController extends Navigation implements Drawing{

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

        if(validateInputs()) {
            if ((ai.addInsurance(
                    sad.getSelectedCarID(),
                    startDate.getText(),
                    expDate.getText(),
                    Integer.parseInt(insNum.getText()),
                    insProvider.getText()
            ))) {
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

    boolean isValidDate(String dateStr) {
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        try {
            dateFormat.parse(dateStr);
            return true;
        } catch (ParseException e) {
            return false;
        }
    }

    public boolean validateInputs() {
        return isValidDate(expDate.getText()) &&
                isValidDate(startDate.getText()) &&
                isValidInput(insProvider) &&
                isValidInsNum();
    }

    private boolean isValidInput(TextField textField) {
        return !textField.getText().isBlank();
    }

    private boolean isValidInsNum() {
        String insNumInput = insNum.getText().trim();

        try {
            int insNumValue = Integer.parseInt(insNumInput);
            return insNumValue > 0;
        } catch (NumberFormatException e) {
            return false;
        }
    }

}
