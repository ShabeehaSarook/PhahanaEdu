package com.pahanaedu.dao;

import com.pahanaedu.model.Customer;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CustomerDAO {

    public void addCustomer(Customer customer) {
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "INSERT INTO customers (account_number, name, address, telephone, units_consumed) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, customer.getAccountNumber());
            stmt.setString(2, customer.getName());
            stmt.setString(3, customer.getAddress());
            stmt.setString(4, customer.getTelephone());
            stmt.setInt(5, customer.getUnitsConsumed());
            stmt.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    public List<Customer> getAllCustomers() {
        List<Customer> customers = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT * FROM customers";
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Customer c = new Customer();
                c.setId(rs.getInt("id"));
                c.setAccountNumber(rs.getString("account_number"));
                c.setName(rs.getString("name"));
                c.setAddress(rs.getString("address"));
                c.setTelephone(rs.getString("telephone"));
                c.setUnitsConsumed(rs.getInt("units_consumed"));
                customers.add(c);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return customers;
    }

    // NEW: read one
    public Customer getById(int id) {
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT * FROM customers WHERE id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                Customer c = new Customer();
                c.setId(rs.getInt("id"));
                c.setAccountNumber(rs.getString("account_number"));
                c.setName(rs.getString("name"));
                c.setAddress(rs.getString("address"));
                c.setTelephone(rs.getString("telephone"));
                c.setUnitsConsumed(rs.getInt("units_consumed"));
                return c;
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    // NEW: update
    public boolean updateCustomer(Customer customer) {
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "UPDATE customers SET account_number=?, name=?, address=?, telephone=?, units_consumed=? WHERE id=?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, customer.getAccountNumber());
            stmt.setString(2, customer.getName());
            stmt.setString(3, customer.getAddress());
            stmt.setString(4, customer.getTelephone());
            stmt.setInt(5, customer.getUnitsConsumed());
            stmt.setInt(6, customer.getId());
            return stmt.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    // NEW: delete
    public boolean deleteCustomer(int id) {
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "DELETE FROM customers WHERE id=?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }
}
