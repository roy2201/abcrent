package Controllers;

import com.example.demo.AbcRenting;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.Node;
import javafx.scene.Scene;
import javafx.stage.Stage;

import java.io.IOException;

public class CheckRentController {

    @FXML
    void BrowsePage(ActionEvent event) {
        goToPage(event, "Customer.fxml", "Browse Cars");
    }

    @FXML
    void CheckRentPage(ActionEvent event) {
        goToPage(event, "CheckRent.fxml", "Check Your Rent Here");
    }

    @FXML
    void Profile(ActionEvent event) {
        goToPage(event, "Profile.fxml", "Profile");
    }

    @FXML
    void RefundPage(ActionEvent event) {
        goToPage(event, "Refund.fxml", "Refund Here");
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
