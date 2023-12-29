package Controllers;

import Models.Payment;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.control.Label;
import javafx.scene.control.TextField;
import javafx.scene.paint.Color;

public class PaymentController extends Navigation implements Drawing{


    @FXML
    private TextField cvv;

    @FXML
    private TextField expDate;

    @FXML
    private TextField name;

    @FXML
    private TextField number;

    @FXML
    private Label cardLabel;

    @FXML
    private Label payLabel;


    Payment payment = new Payment();

    @FXML
    void back(ActionEvent event) {
        goToPage(event, "NbDays.fxml", "How Many Days ?");
    }


    @FXML
    void Pay() {
        if(payment.isValidCard(name.getText(), number.getText(), cvv.getText(), expDate.getText())) {

            showSuccessMsg(cardLabel, "Valid Card");

            switch (payment.pay(number.getText())) {
                case 2:
                    showErrorMsg(payLabel, "Not Enough Balance ...Aborting");
                    break;
                case 99:
                    showErrorMsg(payLabel, "Error Occurred ... Aborting");
                default:
                    showSuccessMsg(payLabel, "Success");

            }

        } else {
            showErrorMsg(cardLabel, "Invalid Card Information");
        }
    }

}
