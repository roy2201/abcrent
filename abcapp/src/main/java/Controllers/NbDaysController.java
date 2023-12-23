package Controllers;

import Models.NbDays;
import Models.UserMetaData;
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
import java.util.regex.Pattern;

public class NbDaysController {

    UserMetaData userMetaData = new UserMetaData();

    NbDays nd = new NbDays();

    @FXML
    private TextField nbDays;

    @FXML
    private Label infoLabel;

    @FXML
    private ListView<String> receipt;

    @FXML
    void back(ActionEvent event) {
        goToPage(event, "Customer.fxml", "Select Your Favorite Car");
    }

    @FXML
    void nextPage(ActionEvent event) {
        goToPage(event, "Payment.fxml", "Payment");
    }

    @FXML
    void viewReceipt() {
        String daysText = nbDays.getText();
        if (isValidPosInt(daysText)) {
            clearLabel(infoLabel);
            int numberOfDays = Integer.parseInt(daysText);
            float subTotal   = calculateSubTotal(numberOfDays);
            float discount   = calculateDiscount(subTotal);
            float total      = calculateTotal(subTotal, discount);
            updateReceipt(subTotal, discount, total);
        } else {
            infoLabel.setText("Invalid Input");
        }
    }

    private float calculateSubTotal(int numberOfDays) {
        return nd.calcSubTotal(numberOfDays);
    }

    private float calculateDiscount(float subTotal) {
        if (userMetaData.getPremium()) {
            return 0.15f * subTotal;
        }
        return 0; // No discount for non-premium users
    }

    private float calculateTotal(float subTotal, float discount) {
        if (userMetaData.getPremium()) {
            return subTotal - discount;
        }
        return subTotal;
    }

    private void updateReceipt(float subTotal, float discount, float total) {
        receipt.getItems().clear();
        receipt.getItems().add("Sub Total = " + subTotal);
        if (userMetaData.getPremium()) {
            receipt.getItems().add("Premium Discount (15 %) = " + discount);
        } else {
            receipt.getItems().add("Not Premium : 0 % discount");
        }
        receipt.getItems().add("Total = " + total);
    }


    private void clearLabel(Label label) {
        label.setText("");
    }

    private boolean isValidPosInt(String input) {
        //handle very large numbers
        String regex = "^[1-9]\\d*$";
        return Pattern.matches(regex,input);
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