/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package za.ac.utility;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 *
 * @author user
 */
public class DBConnection {
    
    public static Connection getConnection() throws SQLException {
        String host = System.getenv("PGHOST");
        String port = System.getenv("PGPORT");
        String dbName = System.getenv("PGDATABASE");
        String user = System.getenv("PGUSER");
        String password = System.getenv("PGPASSWORD");

        String jdbcUrl = String.format("jdbc:postgresql://%s:%s/%s", host, port, dbName);
        
        return DriverManager.getConnection(jdbcUrl, user, password);
    }
}