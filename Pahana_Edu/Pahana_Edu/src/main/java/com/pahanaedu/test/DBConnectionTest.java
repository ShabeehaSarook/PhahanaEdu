package com.pahanaedu.test;
import com.pahanaedu.dao.DBConnection;
import java.sql.Connection;

public class DBConnectionTest {
    public static void main(String[] args) {
        try {
            Connection conn = DBConnection.getConnection();
            System.out.println("✅ Connected to MySQL successfully!");
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
