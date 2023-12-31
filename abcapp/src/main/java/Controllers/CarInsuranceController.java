package Controllers;

import Models.CarInsurance;
import Models.SharedAdminData;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.control.Label;
import javafx.scene.control.SelectionMode;
import javafx.scene.control.TableView;

import java.sql.ResultSet;
import java.util.List;

public class CarInsuranceController extends ASideBar implements Drawing {

    @FXML
    private TableView<?> cars;

    @FXML
    private Label infoLabel;

    CarInsurance ins = new CarInsurance();

    SharedAdminData sad = new SharedAdminData();

    @FXML
    void AddInsurance(ActionEvent event) {
        cars.getSelectionModel().setSelectionMode(SelectionMode.SINGLE);
        Object selectedItem = cars.getSelectionModel().getSelectedItem();
        if(selectedItem != null) {
            if (selectedItem instanceof List<?> selectedItems) {
                int selectedID = Integer.parseInt((String) selectedItems.getFirst());
                System.out.println("Car selected " + selectedID);
                sad.setSelectedCarID(selectedID);
                goToPage(event, "AddInsurance.fxml", "Add new Insurance");
            }
        } else {
            showErrorMsg(infoLabel,"Please select car");
        }
    }

    @FXML
    void AllCars() {
        ResultSet rs = ins.getAllCars();
        drawTable(rs, cars);
    }

    @FXML
    void Renew() {

        cars.getSelectionModel().setSelectionMode(SelectionMode.SINGLE);
        Object selectedItem = cars.getSelectionModel().getSelectedItem();
        if(selectedItem != null) {
            if (selectedItem instanceof List<?> selectedItems) {
                int SelectedCarID = Integer.parseInt((String) selectedItems.getFirst());
                switch (ins.RenewInsurance(SelectedCarID)) {
                    case 0:
                        showSuccessMsg(infoLabel, "Insurance Renewed");
                        break;
                    case 1:
                        showErrorMsg(infoLabel, "Insurance Not Expired yet");
                        break;
                }
            }
        } else {
            showErrorMsg(infoLabel, "Please select car");
        }
    }

    @FXML
    void ViewExpired() {
        ResultSet rs = ins.getExpiredInsurance();
        drawTable(rs, cars);
    }

    @FXML
    void AllInsurance(ActionEvent event) {
        ResultSet rs = ins.getAllInsurance();
        drawTable(rs, cars);
    }
}

