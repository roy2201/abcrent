package Controllers;

import Models.SignUp;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.control.Label;
import javafx.scene.control.TextField;

public class SignUpController extends Navigation implements Drawing, Validation {

    @FXML
    private Label SignUpResultLabel;

    @FXML
    private TextField address;

    @FXML
    private TextField age;

    @FXML
    private TextField email;

    @FXML
    private TextField firstName;

    @FXML
    private TextField lastName;

    @FXML
    private TextField password;
    SignUp signUp = new SignUp();

    @FXML
    void BackToHome(ActionEvent event) {
        goToPage(event, "login.fxml", "Login");
    }

    @FXML
    void SignUp() throws Exception {

        if (isNonBlank(address, email, password, firstName, lastName) && isPosInt(age)) {

            boolean res = signUp.addCustomer(firstName.getText(), lastName.getText(), age.getText(), address.getText(), email.getText(), password.getText());
            if(!res) {
                showSuccessMsg(SignUpResultLabel, "You are Signed Up !");
            } else {
                showErrorMsg(SignUpResultLabel, "Email Taken");
            }
        } else {
            showErrorMsg(SignUpResultLabel, "Invalid or Missing Info");
        }
    }
}