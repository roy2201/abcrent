package Controllers;

import Models.CreditCard;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.control.Label;
import javafx.scene.control.TextField;
import javafx.scene.paint.Color;

import java.text.ParseException;
import java.text.SimpleDateFormat;

import static com.microsoft.sqlserver.jdbc.StringUtils.isNumeric;

public class CreditCardController extends Navigation{

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
                    infoLabel.setText("Success");
                    infoLabel.setTextFill(Color.GREEN);
                    break;
                case 1:
                    infoLabel.setText("Fail");
                    infoLabel.setTextFill(Color.RED);
                    break;
            }
        } else {
            infoLabel.setText("Invalid Information");
            infoLabel.setTextFill(Color.RED);
        }
    }

    @FXML
    void back(ActionEvent event) {
        goToPage(event, "Profile.fxml", "Profile");
    }


    boolean isValidDate(String dateStr) {
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        try {
            dateFormat.parse(dateStr);
            return true;
        } catch (ParseException e) {
            return false;
        }
    }


    boolean validDetails(TextField a, TextField b, TextField c, TextField d) {
        return  !a.getText().isEmpty() &&
                isNumeric(b.getText()) &&
                isNumeric(c.getText()) &&
                isValidDate(d.getText());
    }

}
