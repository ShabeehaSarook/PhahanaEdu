package com.pahanaedu.dao;
import com.pahanaedu.model.User;
import java.sql.*;

public class UserDAO {

    public boolean validateUser(User user) {
        boolean status = false;

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT * FROM users WHERE username = ? AND password = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getPassword());

            System.out.println("🔎 Checking login for: " + user.getUsername());

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                System.out.println("✅ User found in DB.");
                status = true;
            } else {
                System.out.println("❌ No matching user found.");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return status;
    }
}
