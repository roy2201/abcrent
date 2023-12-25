package Controllers;

import Models.SignIn;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.control.Label;
import javafx.scene.control.PasswordField;
import javafx.scene.control.TextField;
import javafx.scene.paint.Color;

import java.sql.SQLException;

public class LoginController extends Navigation{

    @FXML
    private TextField email;

    @FXML
    private Label infoLabel;

    @FXML
    private PasswordField password;

    SignIn signIn = new SignIn();

    @FXML
    void Login(ActionEvent event) {
        String enteredEmail = email.getText();
        String enteredPassword = password.getText();

        if (!enteredEmail.isEmpty() && !enteredPassword.isEmpty()) {
            try {
                int loginResultCode = signIn.Login(enteredEmail, enteredPassword);

                switch (loginResultCode) {
                    case 0:
                        goToPage(event, "Customer.fxml","Select Your Favorite Car");
                        break;
                    case 1:
                        showErrorMessage("Wrong Email");
                        break;
                    case 2:
                        showErrorMessage("Wrong Password");
                        break;
                    default:
                        showErrorMessage("Something Went Wrong");
                }

            } catch (SQLException e) {
                throw new RuntimeException(e);
            }
        }
    }

    private void showErrorMessage(String message) {
        infoLabel.setText(message);
        infoLabel.setTextFill(Color.RED);
    }

    @FXML
    void SignUp(ActionEvent event) {
        goToPage(event, "SignUp.fxml", "Create New Account");
    }

    @FXML
    void SuperAdmin(ActionEvent event) {
        goToPage(event, "Admin.fxml", "Manage Cars");
    }

    @FXML
    void UserPage(ActionEvent event) {
        goToPage(event, "login.fxml", "Login as User");
    }

    @FXML
    void Admin(ActionEvent event) {
        goToPage(event, "Admin.fxml", "ManageCars");
    }

}