package Controllers;

import Models.SignUp;
import com.example.demo.AbcRenting;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.Node;
import javafx.scene.Scene;
import javafx.scene.control.Label;
import javafx.scene.control.TextField;
import javafx.scene.paint.Color;
import javafx.stage.Stage;

import java.io.IOException;
import java.sql.Time;
import java.util.Timer;
import java.util.TimerTask;

import static com.microsoft.sqlserver.jdbc.StringUtils.isNumeric;

public class SignUpController extends Navigation implements Drawing{

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
    void SignUp(ActionEvent event) throws Exception {
        if (!address.getText().isEmpty() && !email.getText().isEmpty() && !password.getText().isEmpty() && !firstName.getText().isEmpty() && !lastName.getText().isEmpty() && isNumeric(age.getText())) {
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