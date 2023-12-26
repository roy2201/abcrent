package Controllers;

import Models.ChangePassword;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.control.Label;
import javafx.scene.control.TextField;
import javafx.scene.paint.Color;

public class ChangePasswordController extends CSideBar{

    @FXML
    private TextField pass;

    @FXML
    private Label infoLabel;

    ChangePassword cp = new ChangePassword();

    @FXML
    void SetPass() {

        if(!pass.getText().isEmpty()) {
            switch (cp.PasswordChange(pass.getText())) {
                case 0:
                    infoLabel.setText("Success");
                    infoLabel.setTextFill(Color.GREEN);
                    break;
                case 1:
                    infoLabel.setText("Fail");
                    infoLabel.setTextFill(Color.RED);
                    break;
                case 2:
                    infoLabel.setText("Error while changing");
                    infoLabel.setTextFill(Color.ORANGE);
                    break;
            }
        } else {
            infoLabel.setText("Invalid input");
            infoLabel.setTextFill(Color.RED);
        }
    }

    @FXML
    void back(ActionEvent event) {
        goToPage(event, "Profile.fxml", "Profile");
    }
}
