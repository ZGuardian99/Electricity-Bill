/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package elec_bill_java;

import java.security.SecureRandom;
import java.security.spec.KeySpec;
import java.util.Base64;
import java.util.Scanner;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;

/**
 *
 * @author Admin
 */
public class AdminHashGenerator {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);

        System.out.print("Enter admin email: ");
        String email = sc.nextLine().trim();

        System.out.print("Enter admin password: ");
        String password = sc.nextLine();

        try {
            // Generate 16-byte random salt
            SecureRandom random = new SecureRandom();
            byte[] salt = new byte[16];
            random.nextBytes(salt);

            // Hash password with PBKDF2 (same as typical DBUtil logic)
            KeySpec spec = new PBEKeySpec(password.toCharArray(), salt, 10000, 256);
            SecretKeyFactory factory = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256");
            byte[] hash = factory.generateSecret(spec).getEncoded();

            // Convert to Base64 for DB storage
            String saltBase64 = Base64.getEncoder().encodeToString(salt);
            String hashBase64 = Base64.getEncoder().encodeToString(hash);

            System.out.println("\n✅ Generated Admin Credentials:\n");
            System.out.println("Email: " + email);
            System.out.println("Salt: " + saltBase64);
            System.out.println("Hash: " + hashBase64);

            System.out.println("\n📋 SQL Insert Statement:");
            System.out.println("INSERT INTO admin (email, password, Salt) VALUES (");
            System.out.println("  '" + email + "',");
            System.out.println("  '" + hashBase64 + "',");
            System.out.println("  '" + saltBase64 + "');");

        } catch (Exception e) {
            System.err.println("Error generating hash: " + e.getMessage());
        } finally {
            sc.close();
        }
    }
}
