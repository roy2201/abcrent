package Models;

public class AdminSharedData {

    private static int mile;

    private static int selectedCarID;

    public int getMile() {
        return mile;
    }

    public void setMile(int newMile) {
        mile = newMile;
    }

    public int getSelectedCarID() {
        return selectedCarID;
    }

    public void setSelectedCarID(int cid) {
        selectedCarID = cid;
    }
}
