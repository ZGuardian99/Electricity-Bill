/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package elec_bill_java;

/**
 *
 * @author Arin
 */
public final class BillCalculator {
    private BillCalculator() {}
    public static double total(int units, double rate, int days) {
        if (days <= 30) return units * rate * days;
        return units * rate * 30 + units * rate * (days - 30);
    }
}