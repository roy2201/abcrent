package Controllers;

import Models.CheckRent;
import javafx.fxml.FXML;
import javafx.scene.control.ListView;
import javafx.scene.control.TextField;

import static com.microsoft.sqlserver.jdbc.StringUtils.isNumeric;

public class CheckRentController extends CSideBar implements Validation{

    @FXML
    private TextField rentID;

    @FXML
    private ListView<String> rentInfo;

    CheckRent checkRent = new CheckRent();

    @FXML
    void checkRent() {

        if(isPosInt(rentID)) {

            rentInfo.getItems().clear();

            switch (checkRent.giveRentInfo(Integer.parseInt(rentID.getText()))) {

                case 1:
                    rentInfo.getItems().add("Invalid Rent ID");
                    break;
                case 2:
                    rentInfo.getItems().add(" " + checkRent.getDaysLeft() + " Days Left ");
                    break;
                case 3:
                    rentInfo.getItems().add("Rent Over Due !");
                    rentInfo.getItems().add("Exceeded By " + checkRent.getDaysLeft() + " Days ");
                    rentInfo.getItems().add("Penalty for OverDue : " + checkRent.getPenalty());
                    break;
            }

        }
    }

}

