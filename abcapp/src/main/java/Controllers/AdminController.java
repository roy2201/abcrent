package Controllers;

import Models.Admin;
import Models.SharedAdminData;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.control.Label;
import javafx.scene.control.SelectionMode;
import javafx.scene.control.TableView;

import java.sql.ResultSet;
import java.util.List;

public class AdminController extends ASideBar implements Drawing, Validation{

    Admin admin = new Admin();


    @FXML
    private TableView<?> cars;

    @FXML
    Label infoLabel;

    SharedAdminData sad = new SharedAdminData();

    @FXML
    void AddCar(ActionEvent event) {
        goToPage(event, "AddCar.fxml", "Add New Car");
    }

    @FXML
    void AllCars() {
        ResultSet rs = admin.getAllCars();
        drawTable(rs, cars);
    }

    @FXML
    void CarHistory() {
        ResultSet rs = admin.getCarHistory();
        drawTable(rs, cars);
    }

    @FXML
    void CarsOverdue() {
        ResultSet rs = admin.getOverDue();
        drawTable(rs, cars);
    }

    @FXML
    void ConfirmArrival(ActionEvent event) {
        cars.getSelectionModel().setSelectionMode(SelectionMode.SINGLE);
        Object selectedItem = cars.getSelectionModel().getSelectedItem();
        if (selectedItem != null) {
            if (selectedItem instanceof List<?> selectedItems) {
                int SelectedCarID = Integer.parseInt((String) selectedItems.getFirst());
                sad.setSelectedCarID(SelectedCarID);
                goToPage(event, "SetMileage.fxml", "New Mileage");
            }
        } else {
            showErrorMsg(infoLabel, "Please Select a Car");
        }
    }

    @FXML
    void DeleteCar() {
        cars.getSelectionModel().setSelectionMode(SelectionMode.SINGLE);
        Object selectedItem = cars.getSelectionModel().getSelectedItem();
        if(selectedItem != null) {
            if (selectedItem instanceof List<?> selectedItems) {
                int SelectedCarID = Integer.parseInt((String) selectedItems.getFirst());
                admin.deleteCar(SelectedCarID);
                showSuccessMsg(infoLabel, "Success");
            }
        } else {
            showErrorMsg(infoLabel, "Please Select a Car");
        }
    }

    @FXML
    void Rented() {
        ResultSet rs = admin.getRented();
        drawTable(rs, cars);
    }

    @FXML
    void RentsInfo() {
        ResultSet rs = admin.getRentsInfo();
        drawTable(rs, cars);
    }

    @FXML
    void Logout(ActionEvent event) {
        goToPage(event,"login.fxml", "Login");
    }

}