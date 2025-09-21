/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
package elec_bill_java;

import database.DBUtil;
import java.sql.Connection;
import java.sql.SQLException;
import javax.swing.JOptionPane;

/**
 *
 * @author Admin
 */
public class Main {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        try (Connection conn = DBUtil.getConnection()) {
            System.out.println("Successfully connected to the database!");

            // Connection successful: open LoginPage
            java.awt.EventQueue.invokeLater(() -> {
                new LoginPage().setVisible(true);
            });

        } catch (SQLException e) {
            e.printStackTrace();
            javax.swing.SwingUtilities.invokeLater(() -> {
                JOptionPane.showMessageDialog(null,
                    "Database connection failed!\nPlease check your settings.",
                    "Connection Error",
                    JOptionPane.ERROR_MESSAGE);
            });
        }
    }
    
}
