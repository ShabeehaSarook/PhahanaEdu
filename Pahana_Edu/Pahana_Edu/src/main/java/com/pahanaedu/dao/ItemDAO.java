package com.pahanaedu.dao;

import com.pahanaedu.model.Item;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.math.BigDecimal;

public class ItemDAO {

    public void addItem(Item item) {
        String sql = "INSERT INTO items (sku, name, description, price, stock) VALUES (?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, item.getSku());
            ps.setString(2, item.getName());
            ps.setString(3, item.getDescription());
            ps.setBigDecimal(4, item.getPrice());
            ps.setInt(5, item.getStock());
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    public List<Item> getAllItems() {
        List<Item> items = new ArrayList<>();
        String sql = "SELECT * FROM items ORDER BY id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                items.add(map(rs));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return items;
    }

    public Item getById(int id) {
        String sql = "SELECT * FROM items WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    public boolean updateItem(Item item) {
        String sql = "UPDATE items SET sku=?, name=?, description=?, price=?, stock=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, item.getSku());
            ps.setString(2, item.getName());
            ps.setString(3, item.getDescription());
            ps.setBigDecimal(4, item.getPrice());
            ps.setInt(5, item.getStock());
            ps.setInt(6, item.getId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    public boolean deleteItem(int id) {
        String sql = "DELETE FROM items WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    private Item map(ResultSet rs) throws SQLException {
        Item i = new Item();
        i.setId(rs.getInt("id"));
        i.setSku(rs.getString("sku"));
        i.setName(rs.getString("name"));
        i.setDescription(rs.getString("description"));
        i.setPrice(rs.getBigDecimal("price"));
        i.setStock(rs.getInt("stock"));
        return i;
    }
}
