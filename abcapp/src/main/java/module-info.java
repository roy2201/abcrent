module com.example.demo {
    requires javafx.controls;
    requires javafx.fxml;
    requires java.sql;
    requires com.microsoft.sqlserver.jdbc;

    opens com.example.demo to javafx.fxml;
    exports com.example.demo;
    exports Models;
    opens Models to javafx.fxml;
    exports Controllers;
    opens Controllers to javafx.fxml;
}