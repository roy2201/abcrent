package Controllers;

import com.example.demo.AbcRenting;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.Node;
import javafx.scene.Scene;
import javafx.stage.Stage;

import java.io.IOException;

public class ManageRefundController {

    @FXML
    void CarInsurancePage(ActionEvent event) {
        goToPage(event, "CarInsurance.fxml", "Car Insurance");
    }

    @FXML
    void ManageCarsPage(ActionEvent event) {
        goToPage(event, "Admin.fxml", "Manage Cars");
    }

    @FXML
    void ManageRefundsPage(ActionEvent event) {
        goToPage(event, "ManageRefund.fxml", "Manage Refunds");
    }

    @FXML
    void ManageUsersPage(ActionEvent event) {
        goToPage(event, "ManageUser.fxml", "Manage Users");
    }

    @FXML
    void MoreCarControlsPage(ActionEvent event) {
        goToPage(event, "AdvancedControls.fxml", "Advanced Car Controls");
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
