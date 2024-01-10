package Controllers;

import Models.Customer;
import Models.UserMetaData;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.ComboBox;
import javafx.scene.control.Label;
import javafx.scene.control.SelectionMode;
import javafx.scene.control.TableView;

import java.net.URL;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.ResourceBundle;

public class CustomerController extends CSideBar implements Initializable , Drawing{

    @FXML
    ComboBox<String> make;

    @FXML
    ComboBox<String> type;

    @FXML
    private TableView<?> cars;

    @FXML
    private Label infoLabel;

    Customer customer = new Customer();

    UserMetaData userMetaData = new UserMetaData();

    private boolean typesLoaded = false, makesLoaded = false;



    @FXML
    public void loadTypes() {
        if(!typesLoaded) {
            ArrayList<String> models = new ArrayList<>();
            type.getItems().add("any");
            try (ResultSet rs = customer.loadTypes()) {
                while (rs.next()) {
                    models.add(rs.getString("TYPE"));
                }
            } catch (SQLException e) {
                throw new RuntimeException(e);
            }
            type.getItems().addAll(models);
            typesLoaded = true;
        }
    }


    @FXML
    public void loadMake() {
        if(!makesLoaded) {
            make.getItems().add("any");
            ArrayList<String> makes = new ArrayList<>();
            try (ResultSet rs = customer.loadMake()) {
                while (rs.next()) {
                    makes.add(rs.getString("MANUFACTURER"));
                }
            } catch (SQLException e) {
                throw new RuntimeException(e);
            }
            make.getItems().addAll(makes);
            makesLoaded = true;
        }
    }


    @FXML
    public void viewMatches() {
        try (ResultSet rs = customer.filteredSearchAction(type.getValue(),make.getValue())) {
            drawTable(rs,cars);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    Object getSelectedItem(TableView<?> tv) {
        tv.getSelectionModel().setSelectionMode(SelectionMode.SINGLE);
        return tv.getSelectionModel().getSelectedItem();
    }

    @FXML
    void NextPage(ActionEvent event) {
        Object selectedItem = getSelectedItem(cars);
        if(selectedItem != null) {
           if (selectedItem instanceof List<?> selectedItems) {
                userMetaData.setCarId(Integer.parseInt((String) selectedItems.getFirst()));
                System.out.println(userMetaData.getCarId());
            }
        } else {
            showErrorMsg(infoLabel, "Please Select Car");
            return ;
        }
        goToPage(event, "NbDays.fxml", "How Many Days ?");
    }

    @Override
    public void initialize(URL url, ResourceBundle resourceBundle) {
        loadTypes();
        loadMake();
    }
}
