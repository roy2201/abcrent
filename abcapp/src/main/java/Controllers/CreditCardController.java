package Controllers;

import Models.CreditCard;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.control.Label;
import javafx.scene.control.TextField;

import java.text.ParseException;
import java.text.SimpleDateFormat;

public class CreditCardController extends Navigation implements Drawing, Validation{

    CreditCard cr = new CreditCard();

    @FXML
    private TextField cardNum;

    @FXML
    private TextField cvv;

    @FXML
    private TextField expDate;

    @FXML
    private TextField name;

    @FXML
    private Label infoLabel;



    @FXML
    void addCard() {
        if (validDetails(name, cardNum, cvv, expDate)) {
            switch (cr.addCard(name.getText(), expDate.getText(), cvv.getText(), cardNum.getText())) {
                case 0:
                    showSuccessMsg(infoLabel, "Success");
                    break;
                case 1:
                    showErrorMsg(infoLabel, "FAIL");
                    break;
                case 2:
                    showErrorMsg(infoLabel, "Invalid Expiry Date");
                    break;

            }
        } else {
            showErrorMsg(infoLabel, "Invalid Input");
        }
    }

    @FXML
    void back(ActionEvent event) {
        goToPage(event, "Profile.fxml", "Profile");
    }


    boolean validDetails(TextField a, TextField b, TextField c, TextField d) {
        return isNonBlank(a, d) && isPosInt(b) && isPosInt(c);
    }

}
