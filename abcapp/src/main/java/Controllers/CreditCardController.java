package Controllers;

import Models.CreditCard;
import com.example.demo.AbcRenting;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.Node;
import javafx.scene.Scene;
import javafx.scene.control.Label;
import javafx.scene.control.TextField;
import javafx.stage.Stage;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;

import static com.microsoft.sqlserver.jdbc.StringUtils.isNumeric;

public class CreditCardController {

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
            cr.addCard(name.getText(), expDate.getText(), cvv.getText(), cardNum.getText());
        } else {
            infoLabel.setText("Invalid Information");
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
