import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class DBUtil {
    private static final String URL = "jdbc:mysql://localhost:3306/elec_bill";
    private static final String USER = "root";
    private static final String PASSWORD = "Arin@0212";

    // Get database connection
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }

    // Execute SELECT queries (returns ResultSet)
    public static ResultSet executeQuery(String query, Object... params) throws SQLException {
        Connection conn = getConnection();
        PreparedStatement stmt = conn.prepareStatement(query);
        setParameters(stmt, params);
        return stmt.executeQuery();
    }

    // Execute INSERT/UPDATE/DELETE queries (returns affected rows)
    public static int executeUpdate(String query, Object... params) throws SQLException {
        try (Connection conn = getConnection(); 
             PreparedStatement stmt = conn.prepareStatement(query)) {
            setParameters(stmt, params);
            return stmt.executeUpdate();
        }
    }

    // Helper method to set parameters safely
    private static void setParameters(PreparedStatement stmt, Object... params) throws SQLException {
        if (params != null) {
            for (int i = 0; i < params.length; i++) {
                stmt.setObject(i + 1, params[i]);
            }
        }
    }

    // Optional: close connection for ResultSet manually when done
    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }
}
