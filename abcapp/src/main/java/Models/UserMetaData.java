package Models;

public class UserMetaData {

    private static int customerId;

    private static int carId;

    private static int nbDays;

    private static boolean isPremium;

    private static float amountToPay;

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

    public void setPremium(boolean prem) {
        isPremium = prem;
    }

    public float AmountToPay() {
        return amountToPay;
    }

    public void setAmountToPay(float amt) {
        amountToPay = amt;
    }
}
