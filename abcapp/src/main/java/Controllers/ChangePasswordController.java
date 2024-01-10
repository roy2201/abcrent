package Controllers;

import Models.ChangePassword;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.control.Label;
import javafx.scene.control.TextField;

public class ChangePasswordController extends CSideBar implements Drawing, Validation{

    @FXML
    private TextField pass;

    @FXML
    private Label infoLabel;

    ChangePassword cp = new ChangePassword();

    @FXML
    void SetPass() {

        if(isNonBlank(pass)) {
            switch (cp.PasswordChange(pass.getText())) {
                case 0:
                    showSuccessMsg(infoLabel, "Success");
                    break;
                case 1:
                    showErrorMsg(infoLabel, "Fail");
                    break;
                case 2:
                    showErrorMsg(infoLabel, "System Error");
                    break;
            }
        } else {
            showErrorMsg(infoLabel, "Invalid Input");
        }
    }

    @FXML
    void back(ActionEvent event) {
        goToPage(event, "Profile.fxml", "Profile");
    }
}
