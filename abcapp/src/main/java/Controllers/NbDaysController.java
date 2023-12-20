package Controllers;

import Models.NbDays;
import com.example.demo.AbcRenting;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.Node;
import javafx.scene.Scene;
import javafx.scene.control.Label;
import javafx.scene.control.ListView;
import javafx.scene.control.TextField;
import javafx.stage.Stage;

import java.io.IOException;

import static com.microsoft.sqlserver.jdbc.StringUtils.isNumeric;

public class NbDaysController {

    NbDays nd = new NbDays();

    @FXML
    private TextField nbDays;

    @FXML
    private Label infoLabel;

    @FXML
    private ListView<?> receipt;

    @FXML
    void back(ActionEvent event) {
        try {
            Stage currentStage = (Stage) ((Node) event.getSource()).getScene().getWindow();
            currentStage.close();
            Stage newStage = new Stage();
            FXMLLoader fxmlLoader = new FXMLLoader(AbcRenting.class.getResource("Customer.fxml"));
            Scene scene = new Scene(fxmlLoader.load());
            newStage.setTitle("Select Your Favorite Car");
            newStage.setScene(scene);
            newStage.show();
        } catch (IOException e) {
            System.out.println(e.getMessage());
        }
    }

    @FXML
    void nextPage(ActionEvent event) {
        try {
            Stage currentStage = (Stage) ((Node) event.getSource()).getScene().getWindow();
            currentStage.close();
            Stage newStage = new Stage();
            FXMLLoader fxmlLoader = new FXMLLoader(AbcRenting.class.getResource("Payment.fxml"));
            Scene scene = new Scene(fxmlLoader.load());
            newStage.setTitle("Select Your Favorite Car");
            newStage.setScene(scene);
            newStage.show();
        } catch (IOException e) {
            System.out.println(e.getMessage());
        }
    }

    @FXML
    void viewReceipt(ActionEvent event) {
        receipt.getItems().clear();
        if(isNumeric(nbDays.getText())) {
        } else {
            infoLabel.setText("Input a Number");
        }
    }

}