package Controllers;

import Models.Customer;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;

public class CSideBar extends Navigation{

    Customer customer = new Customer();

    @FXML
    void BrowsePage(ActionEvent event) {
        goToPage(event, "Customer.fxml", "Browse Cars");
    }

    @FXML
    void CheckRentPage(ActionEvent event) {
        goToPage(event, "CheckRent.fxml", "Check Your Rent Here");
    }

    @FXML
    void Profile(ActionEvent event) {
        goToPage(event, "Profile.fxml", "Profile");
    }

    @FXML
    void RefundPage(ActionEvent event) {
        goToPage(event, "Refund.fxml", "Refund Here");
    }

    @FXML
    void SignOut(ActionEvent event) {
        customer.signOut();
        goToPage(event, "login.fxml", "Login");
    }
}
