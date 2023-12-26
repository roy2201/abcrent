package Controllers;

import Models.Refund;
import javafx.fxml.FXML;
import javafx.scene.control.Label;
import javafx.scene.control.TextField;
import javafx.scene.paint.Color;

public class RefundController extends CSideBar{

    @FXML
    private TextField email;

    @FXML
    private TextField number;

    @FXML
    private TextField reason;

    @FXML
    private TextField rentID;

    @FXML
    private Label infoLabel;

    Refund refund = new Refund();

    @FXML
    void PlaceRequest() {

        if(isValidInput(email.getText() ,number.getText() , reason.getText() ,rentID.getText())) {

            switch(refund.initRefundRequest(Integer.parseInt(rentID.getText()), reason.getText(), email.getText(), number.getText())) {
                case 1:
                    infoLabel.setText("Invalid Rent ID");
                    infoLabel.setTextFill(Color.RED);
                    break;
                case 2:
                    infoLabel.setText("Rent already refunded");
                    infoLabel.setTextFill(Color.ORANGE);
                    break;
                case 3:
                    infoLabel.setText("Invalid card number");
                    infoLabel.setTextFill(Color.RED);
                    break;
                case 0:
                    infoLabel.setText("Refund Request Initiated");
                    infoLabel.setTextFill(Color.GREEN);
                    break;
            }
        }

    }

    private boolean isValidInput(String email, String number, String reason, String rentID) {

        if (email == null || email.trim().isEmpty() ||
                number == null || number.trim().isEmpty() ||
                reason == null || reason.trim().isEmpty() ||
                rentID == null || rentID.trim().isEmpty()) {
            return false;
        }

        try {
            Long.parseLong(rentID);
        } catch (NumberFormatException e) {
            return false;
        }
        return true;
    }

}
