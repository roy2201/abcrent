package Models;

public class UserMetaData {

    private static int customerId;

    private static int carId;

    private static int nbDays;

    private static boolean isPremium;

    private static float amountToPay;

    public static void setIsPremium(boolean isPremium) {
        UserMetaData.isPremium = isPremium;
    }

    public void setCustomerId(int cid) {
        customerId = cid;
    }

    public int getCustomerId() {
        return customerId;
    }

    public void setCarId(int carID) {
        carId = carID;
    }

    public int getCarId() {
        return carId;
    }

    public void setNbDays(int numDays) {
        nbDays = numDays;
    }

    public int getNbDays() {
        return nbDays;
    }

    public boolean getPremium() {
        return isPremium;
    }

    public float getAmountToPay() {
        return amountToPay;
    }

    public void setAmountToPay(float amt) {
        amountToPay = amt;
    }
}
