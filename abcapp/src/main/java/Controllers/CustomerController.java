package Controllers;

import Models.Customer;
import Models.UserMetaData;
import com.example.demo.AbcRenting;
import javafx.beans.property.SimpleStringProperty;
import javafx.beans.value.ObservableValue;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.fxml.Initializable;
import javafx.scene.Node;
import javafx.scene.Scene;
import javafx.scene.control.ComboBox;
import javafx.scene.control.SelectionMode;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.stage.Stage;
import javafx.util.Callback;

import java.io.IOException;
import java.net.URL;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.ResourceBundle;

public class CustomerController implements Initializable {

    @FXML
    ComboBox<String> make;

    @FXML
    ComboBox<String> type;

    @FXML
    private TableView<?> cars;


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

    @SuppressWarnings("all")
    void drawTable(ResultSet rs, TableView tableView) {
        tableView.getColumns().clear();
        ObservableList<ObservableList<String>> data = FXCollections.observableArrayList();
        try {
            for (int i = 0; i < rs.getMetaData().getColumnCount(); i++) {
                final int j = i;
                TableColumn col = new TableColumn(rs.getMetaData().getColumnName(i + 1));
                col.setCellValueFactory((Callback<TableColumn.CellDataFeatures<ObservableList, String>, ObservableValue<String>>) param -> new SimpleStringProperty(param.getValue().get(j).toString()));
                tableView.getColumns().addAll(col);
                System.out.println("Column [" + i + "] ");
            }
            while (rs.next()) {
                ObservableList<String> row = FXCollections.observableArrayList();
                for (int i = 1; i <= rs.getMetaData().getColumnCount(); i++) {
                    row.add(rs.getString(i));
                }
                System.out.println("Row [1] added " + row);
                data.add(row);
                tableView.setItems(data);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @FXML
    void SignOut(ActionEvent event) {
        customer.signOut();
        try {
            Stage currentStage = (Stage) ((Node) event.getSource()).getScene().getWindow();
            currentStage.close();
            Stage newStage = new Stage();
            FXMLLoader fxmlLoader = new FXMLLoader(AbcRenting.class.getResource("login.fxml"));
            Scene scene = new Scene(fxmlLoader.load());
            newStage.setTitle("Login");
            newStage.setScene(scene);
            newStage.show();
        } catch (IOException e) {
            System.out.println(e.getMessage());
        }
    }

    @FXML
    void NextPage(ActionEvent event) {
        //getting the car id from selected row and setting it to user metadata
        cars.getSelectionModel().setSelectionMode(SelectionMode.SINGLE);
        Object selectedItem = cars.getSelectionModel().getSelectedItem();
        if(selectedItem != null) {
            if (selectedItem instanceof List<?> selectedItems) {
                userMetaData.setCarId(Integer.parseInt((String) selectedItems.getFirst()));
                System.out.println(userMetaData.getCarId());
            }
        } else {
            System.out.println("ewww");
            return ;
        }
        //loading the new page (number of days page)
        try {
            Stage currentStage = (Stage) ((Node) event.getSource()).getScene().getWindow();
            currentStage.close();
            Stage newStage = new Stage();
            FXMLLoader fxmlLoader = new FXMLLoader(AbcRenting.class.getResource("nbDays.fxml"));
            Scene scene = new Scene(fxmlLoader.load());
            newStage.setTitle("How Many Days ?");
            newStage.setScene(scene);
            newStage.show();
        } catch (IOException e) {
            System.out.println(e.getMessage());
        }
    }

    @Override
    public void initialize(URL url, ResourceBundle resourceBundle) {
        loadTypes();
        loadMake();
    }
}
