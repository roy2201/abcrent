package Controllers;

import Models.SignIn;
import com.example.demo.AbcRenting;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.Node;
import javafx.scene.Scene;
import javafx.scene.control.Label;
import javafx.scene.control.PasswordField;
import javafx.scene.control.TextField;
import javafx.scene.paint.Color;
import javafx.stage.Stage;

import java.io.IOException;
import java.sql.SQLException;

public class LoginController {

    @FXML
    private TextField email;

    @FXML
    private Label infoLabel;

    @FXML
    private PasswordField password;

    SignIn signIn = new SignIn();

    @FXML
    void Login(ActionEvent event) {
        if(!email.getText().isEmpty() && !password.getText().isEmpty()) {
            try {
                int code = signIn.Login(email.getText(), password.getText());
                if(code == 0) {
                    Stage currentStage = (Stage) ((Node) event.getSource()).getScene().getWindow();
                    currentStage.close();
                    Stage newStage = new Stage();
                    FXMLLoader fxmlLoader = new FXMLLoader(AbcRenting.class.getResource("Customer.fxml"));
                    Scene scene = new Scene(fxmlLoader.load());
                    newStage.setTitle("Create New Account");
                    newStage.setScene(scene);
                    newStage.show();
                } else if(code == 1) {
                    infoLabel.setText("Wrong Email");
                    infoLabel.setTextFill(Color.RED);
                } else if(code == 2) {
                    infoLabel.setText("Wrong Pass");
                    infoLabel.setTextFill(Color.RED);
                } else {
                    infoLabel.setText("Something Went Wrong");
                    infoLabel.setTextFill(Color.RED);
                }

            } catch (SQLException | IOException e) {
                throw new RuntimeException(e);
            }
        }
    }

    @FXML
    void SignUp(ActionEvent event) {
        try {
            Stage currentStage = (Stage) ((Node) event.getSource()).getScene().getWindow();
            currentStage.close();
            Stage newStage = new Stage();
            FXMLLoader fxmlLoader = new FXMLLoader(AbcRenting.class.getResource("SignUp.fxml"));
            Scene scene = new Scene(fxmlLoader.load());
            newStage.setTitle("Create New Account");
            newStage.setScene(scene);
            newStage.show();
        } catch (IOException e) {
            System.out.println(e.getMessage());
        }
    }
}