package Controllers;

import Models.Payment;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.control.Label;
import javafx.scene.control.TextField;
import javafx.scene.paint.Color;

public class PaymentController extends Navigation{


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

            cardLabel.setText("Card Is Valid");
            cardLabel.setTextFill(Color.GREEN);

            switch (payment.pay(number.getText())) {
                case 2:
                    payLabel.setText("Not Enough Balance ...Aborting");
                    payLabel.setTextFill(Color.RED);
                    break;
                case 99:
                    payLabel.setText("Error Occurred ... Aborting");
                    payLabel.setTextFill(Color.RED);
                default:
                    payLabel.setText("Success");
                    payLabel.setTextFill(Color.GREEN);

            }

        } else {
            cardLabel.setText("Invalid Card Information");
            cardLabel.setTextFill(Color.RED);
        }
    }

}
