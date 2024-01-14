package Controllers;

import javafx.beans.property.SimpleStringProperty;
import javafx.beans.value.ObservableValue;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.scene.control.Label;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.TextField;
import javafx.scene.paint.Color;
import javafx.util.Callback;

import java.sql.ResultSet;

public interface Drawing {

    @SuppressWarnings({"rawtypes","unchecked"})
    default void drawTable(ResultSet rs, TableView tableView) {

        tableView.getColumns().clear();
        tableView.getItems().clear();

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
            System.out.println(e.getMessage());
        }
    }


    default void showErrorMsg(Label label, String msg) {
        label.setText("");
        label.setText(msg);
        label.setTextFill(Color.RED);
    }

    default void showSuccessMsg(Label label, String msg) {
        label.setText("");
        label.setText(msg);
        label.setTextFill(Color.GREEN);
    }

    default void clearTextField(TextField... tf) {
        for (TextField textField : tf) {
            textField.setText("");
        }
    }

}
