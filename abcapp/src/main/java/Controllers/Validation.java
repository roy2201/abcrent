package Controllers;

import javafx.scene.control.TextField;
import org.w3c.dom.Text;

import java.text.ParseException;
import java.text.SimpleDateFormat;

public interface Validation {

    default boolean isPosInt(TextField tf) {
        String mileInput = tf.getText().trim();
        try {
            int mileValue = Integer.parseInt(mileInput);
            return mileValue > 0;
        } catch (NumberFormatException e) {
            return false;
        }
    }

    default boolean isValidDate(TextField tf) {
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        try {
            dateFormat.parse(tf.getText());
            return true;
        } catch (ParseException e) {
            return false;
        }
    }

    default boolean isNonBlank(TextField ... tf) {
        for (TextField textField : tf) {
            if (textField == null || textField.getText().trim().isEmpty()) {
                return false; // Found a blank TextField
            }
        }
        return true;
    }

}
