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

    public void goToPage(ActionEvent event, String pageName, String pageTitle) {
        try {
            Stage currentStage = (Stage) ((Node) event.getSource()).getScene().getWindow();
            currentStage.close();
            Stage newStage = new Stage();
            FXMLLoader fxmlLoader = new FXMLLoader(AbcRenting.class.getResource(pageName));
            Scene scene = new Scene(fxmlLoader.load());
            newStage.setTitle(pageTitle);
            newStage.setScene(scene);
            newStage.show();
        } catch (IOException e) {
            System.out.println(e.getMessage());
        }
    }
}