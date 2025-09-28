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
}