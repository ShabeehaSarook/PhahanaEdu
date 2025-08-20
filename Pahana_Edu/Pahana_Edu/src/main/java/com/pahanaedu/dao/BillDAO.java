package com.pahanaedu.dao;

import com.pahanaedu.model.Bill;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data access for bills and bill_items.
 * Requires tables:
 *  - bills(id PK, customer_id FK, total DECIMAL, created_at, updated_at)
 *  - bill_items(id PK, bill_id FK, item_id FK, quantity INT, price DECIMAL, subtotal DECIMAL)
 *  - items(id PK, name, price)
 *  - customers(id PK, name, ...)
 *
 * Foreign keys recommended:
 *  bill_items.bill_id  -> bills.id       (ON DELETE CASCADE)
 *  bill_items.item_id  -> items.id       (RESTRICT)
 *  bills.customer_id   -> customers.id   (RESTRICT)
 */
public class BillDAO {

    /**
     * Creates a bill with its line items in a single transaction.
     * @param customerId customer id (must exist)
     * @param itemIds    array of item ids (length > 0)
     * @param qtys       array of quantities (same length as itemIds, each > 0)
     * @return new bill id
     * @throws Exception on validation/SQL errors (caller should handle and show a friendly message)
     */
    public int createBill(int customerId, int[] itemIds, int[] qtys) throws Exception {
        if (itemIds == null || qtys == null || itemIds.length == 0 || itemIds.length != qtys.length) {
            throw new IllegalArgumentException("Invalid items/quantities");
        }
        for (int q : qtys) {
            if (q <= 0) throw new IllegalArgumentException("Quantity must be > 0");
        }

        final String SQL_INSERT_BILL =
                "INSERT INTO bills (customer_id, total) VALUES (?, ?)";
        final String SQL_INSERT_LINE =
                "INSERT INTO bill_items (bill_id, item_id, quantity, price, subtotal) VALUES (?, ?, ?, ?, ?)";
        final String SQL_SELECT_ITEM =
                "SELECT price FROM items WHERE id = ?";
        final String SQL_UPDATE_BILL_TOTAL =
                "UPDATE bills SET total = ? WHERE id = ?";

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement billPs = conn.prepareStatement(SQL_INSERT_BILL, Statement.RETURN_GENERATED_KEYS)) {

                // 1) Insert bill header (temporary total = 0)
                billPs.setInt(1, customerId);
                billPs.setBigDecimal(2, BigDecimal.ZERO);
                billPs.executeUpdate();

                int billId;
                try (ResultSet keys = billPs.getGeneratedKeys()) {
                    if (!keys.next()) throw new SQLException("Failed to retrieve generated bill id");
                    billId = keys.getInt(1);
                }

                // 2) Insert lines and compute grand total
                BigDecimal grand = BigDecimal.ZERO;

                try (PreparedStatement selItem = conn.prepareStatement(SQL_SELECT_ITEM);
                     PreparedStatement linePs = conn.prepareStatement(SQL_INSERT_LINE)) {

                    for (int i = 0; i < itemIds.length; i++) {
                        int itemId = itemIds[i];
                        int qty = qtys[i];

                        // Fetch current item price (snapshot)
                        selItem.setInt(1, itemId);
                        BigDecimal price;
                        try (ResultSet rs = selItem.executeQuery()) {
                            if (!rs.next()) throw new SQLException("Item not found: " + itemId);
                            price = rs.getBigDecimal("price");
                            if (price == null) price = BigDecimal.ZERO;
                        }

                        BigDecimal subtotal = price.multiply(BigDecimal.valueOf(qty))
                                .setScale(2, RoundingMode.HALF_UP);
                        grand = grand.add(subtotal);

                        linePs.setInt(1, billId);
                        linePs.setInt(2, itemId);
                        linePs.setInt(3, qty);
                        linePs.setBigDecimal(4, price.setScale(2, RoundingMode.HALF_UP));
                        linePs.setBigDecimal(5, subtotal);
                        linePs.executeUpdate();
                    }
                }

                // 3) Update bill total
                grand = grand.setScale(2, RoundingMode.HALF_UP);
                try (PreparedStatement upd = conn.prepareStatement(SQL_UPDATE_BILL_TOTAL)) {
                    upd.setBigDecimal(1, grand);
                    upd.setInt(2, billId);
                    upd.executeUpdate();
                }

                conn.commit();
                return billId;

            } catch (Exception ex) {
                conn.rollback();
                throw ex;
            } finally {
                conn.setAutoCommit(true);
            }
        }
    }

    /**
     * Returns a bill with header + line items (joins customers and items for display names).
     */
    public Bill getBillById(int billId) {
        final String SQL_BILL =
                "SELECT b.id, b.customer_id, b.total, b.created_at, c.name AS customer_name " +
                        "FROM bills b JOIN customers c ON b.customer_id = c.id WHERE b.id = ?";
        final String SQL_LINES =
                "SELECT bi.item_id, bi.quantity, bi.price, bi.subtotal, i.name AS item_name " +
                        "FROM bill_items bi JOIN items i ON bi.item_id = i.id WHERE bi.bill_id = ? ORDER BY bi.id ASC";

        try (Connection conn = DBConnection.getConnection()) {
            Bill bill = null;

            // header
            try (PreparedStatement ps = conn.prepareStatement(SQL_BILL)) {
                ps.setInt(1, billId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        bill = new Bill();
                        bill.setId(rs.getInt("id"));
                        bill.setCustomerId(rs.getInt("customer_id"));
                        bill.setCustomerName(rs.getString("customer_name"));
                        bill.setTotal(rs.getBigDecimal("total"));
                        bill.setCreatedAt(rs.getTimestamp("created_at"));
                        bill.setLines(new ArrayList<>());
                    }
                }
            }
            if (bill == null) return null;

            // lines
            try (PreparedStatement ps = conn.prepareStatement(SQL_LINES)) {
                ps.setInt(1, billId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Bill.Line ln = new Bill.Line();
                        ln.setItemId(rs.getInt("item_id"));
                        ln.setItemName(rs.getString("item_name"));
                        ln.setQuantity(rs.getInt("quantity"));
                        ln.setPrice(rs.getBigDecimal("price"));
                        ln.setSubtotal(rs.getBigDecimal("subtotal"));
                        bill.getLines().add(ln);
                    }
                }
            }

            return bill;

        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     * Returns a simple list of bill headers (for index pages).
     */
    public List<Bill> listBills() {
        final String SQL =
                "SELECT b.id, b.customer_id, b.total, b.created_at, c.name AS customer_name " +
                        "FROM bills b JOIN customers c ON b.customer_id = c.id " +
                        "ORDER BY b.id DESC";
        List<Bill> out = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Bill b = new Bill();
                b.setId(rs.getInt("id"));
                b.setCustomerId(rs.getInt("customer_id"));
                b.setCustomerName(rs.getString("customer_name"));
                b.setTotal(rs.getBigDecimal("total"));
                b.setCreatedAt(rs.getTimestamp("created_at"));
                out.add(b);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return out;
    }

    /**
     * Deletes a bill. If FK is set to ON DELETE CASCADE for bill_items, lines are removed automatically.
     * @return true if a bill row was deleted.
     */
    public boolean deleteBill(int billId) {
        final String SQL = "DELETE FROM bills WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL)) {
            ps.setInt(1, billId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
