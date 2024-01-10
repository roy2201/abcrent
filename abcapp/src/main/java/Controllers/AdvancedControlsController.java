package Controllers;

import Models.AdvancedControls;
import javafx.fxml.FXML;
import javafx.scene.control.Label;
import javafx.scene.control.TableView;
import javafx.scene.control.TextField;


public class AdvancedControlsController extends ASideBar implements Drawing, Validation{

    @FXML
    private TextField end1;

    @FXML
    private TextField end2;

    @FXML
    private TextField greater;

    @FXML
    private TextField less;

    @FXML
    private TextField start1;

    @FXML
    private TextField start2;


    @FXML
    private Label infoLabel;

    @FXML
    private TableView<?> cars;

    AdvancedControls ac = new AdvancedControls();


    @FXML
    void CheckMadeInTotal() {

        if (isPosInt(greater) || isPosInt(less)) {

            Integer n1 = (!greater.getText().isBlank()) ? Integer.parseInt(greater.getText()) : null;
            Integer n2 = (!less.getText().isBlank()) ? Integer.parseInt(less.getText()) : null;

            if (n1 != null || n2 != null) {

                int intValueN1 = (n1 != null) ? n1 : 0;
                int intValueN2 = (n2 != null) ? n2 : 0;

                System.out.println("n1 : " + intValueN1);
                System.out.println("n2 : " + intValueN2);

                //todo: review better way for solving this issue

                if(intValueN2 == 0) {
                    intValueN2 = Integer.MAX_VALUE;
                }

                drawTable(ac.CarRevenue(intValueN1, intValueN2), cars);

            } else {
                showErrorMsg(infoLabel, "Invalid number");
            }
        } else {
            showErrorMsg(infoLabel, "Invalid number");
        }
    }


    @FXML
    void CheckRentedBetween() {

        if(isValidDate(start1) && isValidDate(end1)) {

            drawTable(
                    ac.RentedBetween(start1.getText(), end1.getText()),
                    cars
            );
        } else {
            showErrorMsg(infoLabel, "invalid date format");
        }
    }

    @FXML
    void CheckArrivedBetween() {

        if(isValidDate(start2) && isValidDate(end2)) {

            drawTable(
                    ac.ArrivedBetween(start2.getText(), end2.getText()),
                    cars
            );
        } else {
            showErrorMsg(infoLabel, "invalid date format");
        }

    }

}
