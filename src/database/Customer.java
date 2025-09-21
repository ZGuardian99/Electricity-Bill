import java.sql.ResultSet;
import java.sql.SQLException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.nio.charset.StandardCharsets;
import java.util.Random;

public class Customer {
    private int C_ID;
    private String name;
    private String email;
    private String phone;
    private String password; // stored hashed in DB

    // Constructor assigns unique random C_ID for new customer objects
    public Customer() {
        this.C_ID = generateUniqueCID();
    }

    public Customer(String name, String email, String phone, String password) {
        this.C_ID = generateUniqueCID();
        this.name = name;
        this.email = email;
        this.phone = phone;
        this.password = password;
    }

    // Generate unique random C_ID by checking database for duplicates
    private int generateUniqueCID() {
        Random random = new Random();
        int cid;
        while (true) {
            cid = 10000 + random.nextInt(90000); // 5-digit random ID
            try {
                ResultSet rs = DBUtil.executeQuery("SELECT C_ID FROM customer WHERE C_ID=?", cid);
                if (!rs.next()) break; // unique ID found
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return cid;
    }

    // Secure password hashing using SHA-256
    public static String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashedBytes = md.digest(password.getBytes(StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder();
            for (byte b : hashedBytes) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Error hashing password", e);
        }
    }

    // ------------------- CRUD METHODS -------------------

    // Insert new customer using Customer object
    public boolean insertCustomer() {
        String query = "INSERT INTO customer (C_ID, Name, EmailID, Password) VALUES (?, ?, ?, ?)";
        try {
            String hashedPassword = hashPassword(this.password);
            int result = DBUtil.executeUpdate(query, this.C_ID, this.name, this.email, hashedPassword);
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Insert phone numbers for given customer
    public boolean insertPhone(String phone1, String phone2) {
        String query = "INSERT INTO phoneno (C_ID, Phone_1, Phone_2) VALUES (?, ?, ?)";
        try {
            int result = DBUtil.executeUpdate(query, this.C_ID, phone1, phone2);
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Insert only one phone number (second will be NULL)
    public boolean insertPhone(String phone1) {
        String query = "INSERT INTO phoneno (C_ID, Phone_1, Phone_2) VALUES (?, ?, NULL)";
        try {
            int result = DBUtil.executeUpdate(query, this.C_ID, phone1);
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Delete customer
    public boolean deleteCustomer() {
        String query = "DELETE FROM customer WHERE C_ID=?";
        try {
            int result = DBUtil.executeUpdate(query, this.C_ID);
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Get C_ID for given customer name
    public static int getC_ID(String name) {
        String query = "SELECT C_ID FROM customer WHERE Name=?";
        try {
            ResultSet rs = DBUtil.executeQuery(query, name);
            if (rs.next()) {
                return rs.getInt("C_ID");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1; // Not found
    }

    // ------------------- AUTHENTICATION -------------------

    // Sign up new customer
    public boolean signUp() {
        return insertCustomer();
    }

    // Sign in existing customer using email & password
    public boolean signIn() {
        String query = "SELECT * FROM customer WHERE EmailID=? AND Password=?";
        try {
            String hashedPassword = hashPassword(this.password);
            ResultSet rs = DBUtil.executeQuery(query, this.email, hashedPassword);
            if (rs.next()) {
                this.C_ID = rs.getInt("C_ID");
                this.name = rs.getString("Name");
                this.email = rs.getString("EmailID");
                this.phone = rs.getString("PhoneNo");
                System.out.println("Login successful for: " + email);
                return true;
            } else {
                System.out.println("Invalid email or password!");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // ------------------- PROFILE & BILLS -------------------

    // View customer profile
    public void viewProfile() {
        String query = "SELECT * FROM customer WHERE C_ID=?";
        try {
            ResultSet rs = DBUtil.executeQuery(query, this.C_ID);
            if (rs.next()) {
                System.out.println("Customer ID: " + rs.getInt("C_ID"));
                System.out.println("Name: " + rs.getString("Name"));
                System.out.println("Email: " + rs.getString("EmailID"));
                System.out.println("Phone: " + rs.getString("PhoneNo"));
            } else {
                System.out.println("Profile not found!");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // List unpaid bills
    public void listUnpaidBills() {
        String query = "SELECT * FROM bill WHERE C_ID=? AND Status='Unpaid'";
        try {
            ResultSet rs = DBUtil.executeQuery(query, this.C_ID);
            System.out.println("Unpaid Bills:");
            while (rs.next()) {
                System.out.println("Bill ID: " + rs.getInt("B_ID") +
                                   ", Amount: " + rs.getDouble("TotalAmt") +
                                   ", Due Date: " + rs.getDate("DueDate"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Pay bill and update status
    public void payBill(int billId, String mode) {
        try {
            DBUtil.executeUpdate("INSERT INTO payment (B_ID, PaymentDate, Mode) VALUES (?, NOW(), ?)", billId, mode);
            DBUtil.executeUpdate("UPDATE bill SET Status='Paid' WHERE B_ID=?", billId);
            System.out.println("Bill " + billId + " paid successfully via " + mode);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // View previous transactions
    public void viewTransactions() {
        String query = "SELECT p.PaymentID, p.B_ID, p.PaymentDate, p.Mode, b.TotalAmt " +
                       "FROM payment p JOIN bill b ON p.B_ID=b.B_ID WHERE b.C_ID=?";
        try {
            ResultSet rs = DBUtil.executeQuery(query, this.C_ID);
            System.out.println("Transaction History:");
            while (rs.next()) {
                System.out.println("Payment ID: " + rs.getInt("PaymentID") +
                                   ", Bill ID: " + rs.getInt("B_ID") +
                                   ", Amount: " + rs.getDouble("TotalAmt") +
                                   ", Date: " + rs.getDate("PaymentDate") +
                                   ", Mode: " + rs.getString("Mode"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // ------------------- GETTERS & SETTERS -------------------

    public int getC_ID() { return C_ID; }
    public String getName() { return name; }
    public String getEmail() { return email; }
    public String getPhone() { return phone; }
    public String getPassword() { return password; }

    public void setName(String name) { this.name = name; }
    public void setEmail(String email) { this.email = email; }
    public void setPhone(String phone) { this.phone = phone; }
    public void setPassword(String password) { this.password = password; }
}
