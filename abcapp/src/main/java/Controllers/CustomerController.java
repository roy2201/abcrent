package Controllers;

import Models.Customer;
import Models.UserMetaData;
import com.example.demo.AbcRenting;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.Node;
import javafx.scene.Scene;
import javafx.stage.Stage;

import java.io.IOException;

public class CustomerController {

    Customer customer = new Customer();

    @FXML
    void SignOut(ActionEvent event) {
        customer.signOut();
        try {
            Stage currentStage = (Stage) ((Node) event.getSource()).getScene().getWindow();
            currentStage.close();
            Stage newStage = new Stage();
            FXMLLoader fxmlLoader = new FXMLLoader(AbcRenting.class.getResource("login.fxml"));
            Scene scene = new Scene(fxmlLoader.load());
            newStage.setTitle("Login");
            newStage.setScene(scene);
            newStage.show();
        } catch (IOException e) {
            System.out.println(e.getMessage());
        }
    }
}
