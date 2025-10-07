/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package database;
import java.time.LocalDate;

/**
 *
 * @author Admin
 */
public class AdminShow {
    public String name;
    public String type;
    public LocalDate date;
    
    public AdminShow(String name, String type, LocalDate date){
        this.name = name;
        this.type = type;
        this.date = date;
    }
    
    public String getName(){
        return this.name;
    }
    public String getType(){
        return this.type;
    }
    public LocalDate getBillDate(){
        return this.date;
    }
}
