/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package elec_bill_java;
import static org.junit.jupiter.api.Assertions.*;
import database.DBUtil;
import org.junit.jupiter.api.Test;

/**
 *
 * @author Arin
 */
class ElecBillUnitTests {
    static final double D = 0.001;
    @Test void UT01() { String s = DBUtil.generateSalt(); assertEquals(DBUtil.hashPassword("Test@123", s), DBUtil.hashPassword("Test@123", s)); }
    @Test void UT02() { String a = DBUtil.generateSalt(), b = DBUtil.generateSalt(); assertEquals(24, a.length()); assertNotEquals(DBUtil.hashPassword("Test@123", a), DBUtil.hashPassword("Test@123", b)); }
    @Test void UT03() { String s = DBUtil.generateSalt(); assertNotEquals(DBUtil.hashPassword("Test@123", s), DBUtil.hashPassword("Test@124", s)); }
    @Test void UT04() { assertTrue(Validators.isValidEmail("user@example.com")); assertFalse(Validators.isValidEmail("user@")); assertFalse(Validators.isValidEmail("a@b")); }
    @Test void UT05() { assertTrue(Validators.isValidPhone("9321478453")); assertFalse(Validators.isValidPhone("5123456789")); }
    @Test void UT06() { assertTrue(Validators.isStrongPassword("Abcd@123")); assertFalse(Validators.isStrongPassword("abcd@123")); assertFalse(Validators.isStrongPassword("Abcdefg1")); }
    @Test void UT07() { assertEquals(900.00, BillCalculator.total(10, 4.50, 20), D); }
    @Test void UT08() { assertEquals(1230.00, BillCalculator.total(5, 8.20, 30), D); }
    @Test void UT09() { assertEquals(0.00, BillCalculator.total(10, 4.50, 0), D); }
    @Test void UT10() { assertFalse(Validators.isValidPhone("932147845")); assertTrue(Validators.isValidPhone("9321478453")); assertFalse(Validators.isValidPhone("93214784531")); }
    @Test void UT11() { assertFalse(Validators.isStrongPassword("Abc@123")); }
    @Test void UT12() { assertTrue(Validators.isStrongPassword("Abcd@123")); }
    @Test void UT13() { assertEquals(1305.00, BillCalculator.total(10, 4.50, 29), D); }
    @Test void UT14() { assertEquals(1350.00, BillCalculator.total(10, 4.50, 30), D); }
    @Test void UT15() { assertEquals(1395.00, BillCalculator.total(10, 4.50, 31), D); }
}