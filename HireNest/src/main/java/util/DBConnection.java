package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static final String URL      = "jdbc:mysql://localhost:3306/hirenest_db";
    private static final String USERNAME = "root";
    private static final String PASSWORD = "Aliva2005@"; // TODO: rotate this + move to config

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.err.println("MySQL JDBC Driver not found!");
            e.printStackTrace();
        }
    }

    /**
     * Returns a FRESH connection every call.
     * Never share Connection objects across threads — that was the old bug.
     */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USERNAME, PASSWORD);
    }

    /**
     * Kept for backward compatibility with any code that calls it.
     * Does nothing now — each getConnection() hands out a fresh connection
     * that the caller closes via try-with-resources.
     */
    public static void closeConnection() {
        // no-op on purpose
    }
}