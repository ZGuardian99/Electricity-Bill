/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package elec_bill_java;

/**
 *
 * @author Admin
 */
public class Customer {
    public int C_ID;
    public String Name;
    public String Phone_No;
    public String Email;
    public int City_ID;
    
    public Customer(int C_ID, String Name, String Phone_No, String Email, int City_ID) {
        this.C_ID = C_ID;
        this.Name = Name;
        this.Phone_No = Phone_No;
        this.Email = Email;
        this.City_ID = City_ID;
    }
}
