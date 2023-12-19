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

import static com.microsoft.sqlserver.jdbc.StringUtils.isNumeric;

public class SignUpController {

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
        try {
            Stage currentStage = (Stage) ((Node) event.getSource()).getScene().getWindow();
            currentStage.close();
            Stage newStage = new Stage();
            FXMLLoader fxmlLoader = new FXMLLoader(AbcRenting.class.getResource("login.fxml"));
            Scene scene = new Scene(fxmlLoader.load());
            newStage.setTitle("Sign In");
            newStage.setScene(scene);
            newStage.show();
        } catch (IOException e) {
            System.out.println(e.getMessage());
        }
    }

    @FXML
    void SignUp() throws Exception {
        if (!address.getText().isEmpty() && !email.getText().isEmpty() && !password.getText().isEmpty() && !firstName.getText().isEmpty() && !lastName.getText().isEmpty() && isNumeric(age.getText())) {
            boolean res = signUp.addCustomer(firstName.getText(), lastName.getText(), age.getText(), address.getText(), email.getText(), password.getText());
            if(!res) {
                SignUpResultLabel.setText("You are Signed Up !");
                SignUpResultLabel.setTextFill(Color.GREEN);
            } else {
                SignUpResultLabel.setText("Email Taken");
                SignUpResultLabel.setTextFill(Color.RED);
            }
        } else {
            SignUpResultLabel.setText("Invalid or Missing Info");
            SignUpResultLabel.setTextFill(Color.RED);
        }
    }
}