package Controllers;

import Models.ManageRefund;
import javafx.fxml.FXML;
import javafx.scene.control.Label;
import javafx.scene.control.SelectionMode;
import javafx.scene.control.TableView;
import javafx.scene.control.TextField;

import java.sql.ResultSet;
import java.util.List;

public class ManageRefundController extends ASideBar implements Drawing, Validation{

    @FXML
    private TextField percentage;

    @FXML
    private TableView<?> refunds;

    @FXML
    private Label infoLabel;

    ManageRefund mr = new ManageRefund();

    @FXML
    void PendingRequests() {
        ResultSet rs = mr.getPendingRequests();
        drawTable(rs, refunds);
    }

    @FXML
    void Refund() {
        if(validPercentage()) {
            refunds.getSelectionModel().setSelectionMode(SelectionMode.SINGLE);
            Object selectedItem = refunds.getSelectionModel().getSelectedItem();
            if (selectedItem != null) {
                if (selectedItem instanceof List<?> selectedItems) {
                    int selectedID = Integer.parseInt((String) selectedItems.getFirst());
                    switch (mr.DoRefund(selectedID, Integer.parseInt(percentage.getText())))
                    {
                        case 0:
                            showSuccessMsg(infoLabel, "Success");
                            break;
                        case 1:
                            showErrorMsg(infoLabel, "Already Refunded");
                            break;
                        case 2:
                            showErrorMsg(infoLabel, "percentage between 99 and 11");
                    }
                }
            } else {
                showErrorMsg(infoLabel, "Please select request");
            }
        } else {
            showErrorMsg(infoLabel, "Invalid Input");
        }
    }

    public boolean validPercentage() {
        return isPosInt(percentage);
    }
}
