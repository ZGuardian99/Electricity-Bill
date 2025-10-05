package database;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;
import java.util.LinkedHashMap;
import java.util.Map;
import java.security.SecureRandom;
import java.security.spec.InvalidKeySpecException;
import javax.crypto.spec.PBEKeySpec;
import javax.crypto.SecretKeyFactory;
import java.util.Base64;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.time.LocalDate;
import java.sql.CallableStatement;
import java.sql.Types;

public class DBUtil {
    
    public static enum UserType { ADMIN, CUSTOMER }

    private static String url;
    private static String user;
    private static String password;
    private static final int SALT_LENGTH = 16;
    private static final int HASH_ITERATIONS = 10000;
    private static final int KEY_LENGTH = 256;

    static {
        loadDatabaseConfig();
    }
    
    private static void loadDatabaseConfig() {
        try (FileInputStream fis = new FileInputStream("config.properties")) {
            Properties prop = new Properties();
            prop.load(fis);
            url = prop.getProperty("db.url");
            user = prop.getProperty("db.user");
            password = prop.getProperty("db.password");
        } catch (IOException e) {
            System.err.println("Failed to load database configuration: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public static Connection getConnection() throws SQLException {
        if (url == null || user == null || password == null) {
            throw new SQLException("Database credentials not set in config.properties");
        }
        return DriverManager.getConnection(url, user, password);
    }

    // FIXED: Proper resource management with try-with-resources
    public static List<Map<String, Object>> executeQuery(String query, Object... params) throws SQLException {
        List<Map<String, Object>> results = new ArrayList<>();
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            setParameters(stmt, params);
            
            try (ResultSet rs = stmt.executeQuery()) {
                int columnCount = rs.getMetaData().getColumnCount();
                
                while (rs.next()) {
                    Map<String, Object> row = new LinkedHashMap<>();
                    for (int i = 1; i <= columnCount; i++) {
                        String columnName = rs.getMetaData().getColumnName(i);
                        Object value = rs.getObject(i);
                        row.put(columnName, value);
                    }
                    results.add(row);
                }
            }
        }
        return results;
    }

    public static int executeUpdate(String query, Object... params) throws SQLException {
        try (Connection conn = getConnection(); 
             PreparedStatement stmt = conn.prepareStatement(query)) {
            setParameters(stmt, params);
            return stmt.executeUpdate();
        }
    }

    private static void setParameters(PreparedStatement stmt, Object... params) throws SQLException {
        if (params != null) {
            for (int i = 0; i < params.length; i++) {
                stmt.setObject(i + 1, params[i]);
            }
        }
    }

    // SECURITY FIX: Use PBKDF2 instead of MD5
    public static String generateSalt() {
        SecureRandom random = new SecureRandom();
        byte[] salt = new byte[SALT_LENGTH];
        random.nextBytes(salt);
        return Base64.getEncoder().encodeToString(salt);
    }
    
    public static String hashPassword(String password, String salt) {
        try {
            byte[] saltBytes = Base64.getDecoder().decode(salt);
            PBEKeySpec spec = new PBEKeySpec(password.toCharArray(), saltBytes, HASH_ITERATIONS, KEY_LENGTH);
            SecretKeyFactory skf = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256");
            byte[] hash = skf.generateSecret(spec).getEncoded();
            return Base64.getEncoder().encodeToString(hash);
        } catch (NoSuchAlgorithmException | InvalidKeySpecException e) {
            throw new RuntimeException("Error hashing password", e);
        }
    }
    
    // SECURITY FIX: Proper password verification with salt
    public static boolean checkPassword(String email, String password) throws SQLException, UserNotFoundException {
        String query = "SELECT Password, Salt FROM customer WHERE EmailID = ?";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setString(1, email);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    String storedHash = rs.getString("Password");
                    String salt = rs.getString("Salt");
                    
                    // Handle legacy MD5 passwords (migration scenario)
                    if (salt == null) {
                        // Legacy MD5 verification - should be migrated
                        String inputHash = md5(password);
                        return storedHash.equals(inputHash);
                    } else {
                        // New secure password verification
                        String inputHash = hashPassword(password, salt);
                        return storedHash.equals(inputHash);
                    }
                } else {
                    throw new UserNotFoundException("Email not found: " + email);
                }
            }
        }
    }
    
    public static List<String> getAllStates() throws SQLException {
        List<String> states = new ArrayList<>();
        String query = "SELECT stateName FROM state ORDER BY stateName";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                states.add(rs.getString("stateName"));
            }
        }
        return states;
    }
    
    public static Map<String, Integer> getStatesAsMap() throws SQLException {
        Map<String, Integer> stateMap = new LinkedHashMap<>();
        String query = "SELECT stateId, stateName FROM state ORDER BY stateName";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                stateMap.put(rs.getString("stateName"), rs.getInt("stateId"));
            }
        }
        return stateMap;
    }

    public static List<String> getCitiesByStateId(int stateId) throws SQLException {
        List<String> cities = new ArrayList<>();
        String query = "SELECT cityName FROM city WHERE stateId = ? ORDER BY cityName";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, stateId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    cities.add(rs.getString("cityName"));
                }
            }
        }
        return cities;
    }
    
    public static List<String> getAllTypes() throws SQLException{
        List<String> types = new ArrayList<>();
        String query = "SELECT Type FROM rate ORDER BY RatePerUnit";
        
        try(Connection conn = getConnection();
                PreparedStatement pstmt = conn.prepareStatement(query);
                ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                types.add(rs.getString("Type"));
            }
        }
        return types;
    }
    
    public static String md5(String input) {
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            byte[] bytes = md.digest(input.getBytes(StandardCharsets.UTF_8));

            // Convert to hex string
            StringBuilder sb = new StringBuilder();
            for (byte b : bytes) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();

        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("MD5 algorithm not available", e);
        }
    }
    
    // SECURITY FIX: Secure login method with proper password hashing

    /**
     *
     * @param email
     * @param password
     * @return
     */
    public static UserType checkLoginAndGetType(String email, String password) {
        try (Connection conn = getConnection()) {

            // Check Admin table first
            String adminQuery = "SELECT password, salt FROM admin WHERE email = ?";
            try (PreparedStatement pst = conn.prepareStatement(adminQuery)) {
                pst.setString(1, email);
                try (ResultSet rs = pst.executeQuery()) {
                    if (rs.next()) {
                        String storedHash = rs.getString("password");
                        String salt = rs.getString("salt");
                        
                        if (salt != null) {
                            // New secure verification
                            String inputHash = hashPassword(password, salt);
                            if (storedHash.equals(inputHash)) {
                                return UserType.ADMIN;
                            }
                        } else {
                            // Legacy MD5 verification (should be migrated)
                            String inputHash;
                            inputHash = md5(password);
                            if (storedHash.equals(inputHash)) {
                                return UserType.ADMIN;
                            }
                        }
                    }
                }
            }

            // Check Customer table
            try {
                if (checkPassword(email, password)) {
                    return UserType.CUSTOMER;
                }
            } catch (UserNotFoundException e) {
                // User not found in customer table, continue to return null
            }

        } catch (SQLException e) {
            System.err.println("Database error during login: " + e.getMessage());
            e.printStackTrace();
        }
        return null; // Invalid login
    }
    
    // Method to migrate existing MD5 passwords to PBKDF2
    public static void migratePasswordSecurity(String email, String plainTextPassword) throws SQLException {
        String salt = generateSalt();
        String newHash = hashPassword(plainTextPassword, salt);
        
        String updateQuery = "UPDATE customer SET Password = ?, Salt = ? WHERE EmailID = ?";
        executeUpdate(updateQuery, newHash, salt, email);
    }
    
    // Utility method for creating new user accounts with secure password storage

    /**
     *
     * @param email
     * @param password
     * @param otherParams
     * @throws SQLException
     */
    public static void createUserWithSecurePassword(String email, String password, String... otherParams) throws SQLException {
        String salt = generateSalt();
        String hashedPassword = hashPassword(password, salt);
        
        // Example for customer table - adjust fields as needed
        String insertQuery = "INSERT INTO customer (EmailID, Password, Salt, ConnectionDate, Gender, name, phoneno) " +
                           "VALUES (?, ?, ?, CURDATE(), ?, ?, ?)";
        
        Object[] params = new Object[6 + otherParams.length];
        params[0] = email;
        params[1] = hashedPassword;
        params[2] = salt;
        System.arraycopy(otherParams, 0, params, 3, otherParams.length);
        
        executeUpdate(insertQuery, params);
    }
    
    /**
     *
     * @param C_ID
     * @return
     * @throws SQLException
     */
    public static Details loadDetails1(int C_ID) throws SQLException {
        String query = "SELECT Name, PhoneNo, EmailID, Gender FROM customer WHERE C_ID = ?";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, C_ID);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) { // ✅ move to first row
                    return new Details(
                        rs.getString("Name"),
                        rs.getString("PhoneNo"),
                        rs.getString("EmailID"),
                        rs.getString("Gender")
                    );
                } else {
                    return null; // or throw an exception if C_ID not found
                }
            }
        }
    }

    
    public static Details2 loadDetails2(int C_ID) throws SQLException {
        String query = "SELECT AddressText, CityID FROM address WHERE C_ID = ?";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, C_ID);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) { // move to the first row
                    return new Details2(
                        rs.getString("AddressText"),
                        rs.getInt("CityID")
                    );
                } else {
                    return null; // or throw an exception if no address found
                }
            }
        }
    }

    
    public static int getCID(String name) throws SQLException {
        String query = "SELECT C_ID FROM customer WHERE Name = ?";
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setString(1, name);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("C_ID");
                } else {
                    // No customer found with that name
                    return -1; // or throw exception if you prefer
                }
            }
        }
    }
    
    public static String getName(int C_ID) throws SQLException {
        String query = "SELECT Name FROM customer WHERE C_ID = ?";
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, C_ID);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("Name");
                }
            }
        }
        return null;
    }
    
    public static boolean doesCIdExist(int C_ID) {
        String sql = "SELECT 1 FROM bill WHERE C_ID = ? LIMIT 1";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, C_ID);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public static boolean isUnitSet(int C_ID){
        String query = "Select 1 From units where C_ID = ? Limit 1";
        try (Connection conn = getConnection();
                PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, C_ID);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException ex) {
            System.getLogger(DBUtil.class.getName()).log(System.Logger.Level.ERROR, (String) null, ex);
            return false;
        }
    }
    
    public static int getDays(int C_ID) throws SQLException {
        String query;

        if (doesCIdExist(C_ID)) {
            query = "SELECT DATEDIFF(CURDATE(), BillDate) AS days_since_bill " +
                    "FROM bill " +
                    "WHERE C_ID = ? " +
                    "ORDER BY BillDate DESC LIMIT 1";
        } else {
            query = "SELECT DATEDIFF(CURDATE(), ConnectionDate) AS days_since_connection " +
                    "FROM customer WHERE C_ID = ?";
        }

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, C_ID);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1); // days_since_bill or days_since_connection
                } else {
                    return 0;
                }
            }
        }
    }
    
    public static void updateUnit(int units, int C_ID){
        String query = "Update units set units_used = ? where C_ID = ?";
        try (Connection conn = getConnection();
                PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, units);
            pstmt.setInt(2, C_ID);

        } catch (SQLException ex) {
            System.getLogger(DBUtil.class.getName()).log(System.Logger.Level.ERROR, (String) null, ex);
        }
    }
    
    public static void setUnit(int units, int C_ID){
        String query = "Insert units Values (?, ?)";
        try (Connection conn = getConnection();
                PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, C_ID);
            pstmt.setInt(2, units);

        } catch (SQLException ex) {
            System.getLogger(DBUtil.class.getName()).log(System.Logger.Level.ERROR, (String) null, ex);
        }
    }
    
    public static LocalDate getDate1(int C_ID) {
        String query = "SELECT BillDate FROM bill WHERE C_ID = ? ORDER BY BillDate DESC LIMIT 1";
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, C_ID);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    java.sql.Date sqlDate = rs.getDate("BillDate");
                    if (sqlDate != null) {
                        return sqlDate.toLocalDate();
                    }
                }
            }

        } catch (SQLException ex) {
            System.getLogger(DBUtil.class.getName()).log(System.Logger.Level.ERROR, (String) null, ex);
        }
        return null;
    }


    public static LocalDate getDate2(int C_ID) {
        String query = "SELECT ConnectionDate FROM customer WHERE C_ID = ?";
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, C_ID);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) { // Move to first row
                    java.sql.Date sqlDate = rs.getDate("ConnectionDate");
                    if (sqlDate != null) {
                        return sqlDate.toLocalDate();
                    }
                }
            }

        } catch (SQLException ex) {
            System.getLogger(DBUtil.class.getName()).log(System.Logger.Level.ERROR, (String) null, ex);
        }
        return null;
    }
    
    public static double getRate(int C_ID){
        String query = "SELECT r.RatePerUnit FROM meter m JOIN rate r ON m.RateID = r.RateID WHERE m.C_ID = ? ";
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, C_ID);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble("RatePerUnit");
                }
            }

        } catch (SQLException ex) {
            System.getLogger(DBUtil.class.getName()).log(System.Logger.Level.ERROR, (String) null, ex);
        }
        return 0;
    }
    
    public static void insertBillAndPayment(int C_ID, double amt, int modeID) {
        String insertBillSQL = "INSERT INTO bill (BillDate, TotalAmt, C_ID) VALUES (CURDATE(), ?, ?)";
        String insertPaymentSQL = "INSERT INTO payment (Date, ModeID, B_ID) VALUES (CURDATE(), ?, ?)";

        try (Connection conn = DBUtil.getConnection()) {
            conn.setAutoCommit(false);

            int billID;

            try (PreparedStatement billStmt = conn.prepareStatement(insertBillSQL, java.sql.Statement.RETURN_GENERATED_KEYS)) {
                billStmt.setDouble(1, amt);
                billStmt.setInt(2, C_ID);
                billStmt.executeUpdate();

                try (ResultSet rs = billStmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        billID = rs.getInt(1);
                    } else {
                        throw new SQLException("Failed to retrieve generated Bill ID.");
                    }
                }
            }

            try (PreparedStatement payStmt = conn.prepareStatement(insertPaymentSQL)) {
                payStmt.setInt(1, modeID);
                payStmt.setInt(2, billID);
                payStmt.executeUpdate();
            }

            conn.commit();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}