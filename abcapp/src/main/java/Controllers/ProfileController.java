package Controllers;

import Models.Customer;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;

public class ProfileController extends CSideBar {

    @FXML
    void AddCard(ActionEvent event) {
        goToPage(event,"CreditCard.fxml", "Add New Credit Card");
    }

}
