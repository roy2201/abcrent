package Controllers;

import javafx.event.ActionEvent;
import javafx.fxml.FXML;

public class AddCarController extends Navigation{

    @FXML
    void back(ActionEvent event) {
        goToPage(event, "Admin.fxml", "Admin Page");
    }

}