package Models;

public class SharedAdminData {

    private static int selectedCarID;

    public void setSelectedCarID(int sci) {
        selectedCarID = sci;
    }

    public int getSelectedCarID() {
        System.out.println(selectedCarID);
        return selectedCarID;
    }

}
