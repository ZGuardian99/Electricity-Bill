/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package elec_bill_java;

/**
 *
 * @author Arin
 */
public final class Validators {
    private Validators() {}
    public static boolean isValidEmail(String e) {
        return e != null && e.matches("^[a-zA-Z0-9_+&*-]+(?:\\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,7}$");
    }
    public static boolean isValidPhone(String p) { return p != null && p.matches("^[6-9]\\d{9}$"); }
    public static boolean isStrongPassword(String p) {
        if (p == null || p.length() < 8) return false;
        return p.chars().anyMatch(Character::isUpperCase) && p.chars().anyMatch(Character::isLowerCase)
            && p.chars().anyMatch(Character::isDigit)
            && p.chars().anyMatch(c -> "!@#$%^&*()_+-=[]{}|;:,.<>?".indexOf(c) >= 0);
    }
}