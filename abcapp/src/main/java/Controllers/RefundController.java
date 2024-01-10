package Controllers;

import Models.Refund;
import javafx.fxml.FXML;
import javafx.scene.control.Label;
import javafx.scene.control.TextField;

public class RefundController extends CSideBar implements Drawing, Validation{

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

        if(isValidInput()) {

            switch(refund.initRefundRequest(Integer.parseInt(rentID.getText()), reason.getText(), email.getText(), number.getText())) {
                case 1:
                    showErrorMsg(infoLabel, "Invalid Rent ID");
                    break;
                case 2:
                    showErrorMsg(infoLabel, "Rent Already Refunded");
                    break;
                case 3:
                    showErrorMsg(infoLabel, "Invalid Card Number");
                    break;
                case 0:
                    showSuccessMsg(infoLabel, "Refund Request Initiated");
                    break;
            }
        }

    }

    private boolean isValidInput() {
        return isNonBlank(email, reason) && isPosInt(number) && isPosInt(rentID);
    }

}
