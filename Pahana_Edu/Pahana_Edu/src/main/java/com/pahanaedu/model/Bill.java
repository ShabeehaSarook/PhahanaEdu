package com.pahanaedu.model;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class Bill {
    private int id;
    private int customerId;
    private String customerName; // convenience for views
    private BigDecimal total;
    private Timestamp createdAt;
    private List<Line> lines = new ArrayList<>();

    // Line item (kept inside to avoid another file)
    public static class Line {
        private int itemId;
        private String itemName; // convenience for views
        private int quantity;
        private BigDecimal price;    // snapshot of item price
        private BigDecimal subtotal; // price * quantity

        public int getItemId() { return itemId; }
        public void setItemId(int itemId) { this.itemId = itemId; }
        public String getItemName() { return itemName; }
        public void setItemName(String itemName) { this.itemName = itemName; }
        public int getQuantity() { return quantity; }
        public void setQuantity(int quantity) { this.quantity = quantity; }
        public BigDecimal getPrice() { return price; }
        public void setPrice(BigDecimal price) { this.price = price; }
        public BigDecimal getSubtotal() { return subtotal; }
        public void setSubtotal(BigDecimal subtotal) { this.subtotal = subtotal; }
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getCustomerId() { return customerId; }
    public void setCustomerId(int customerId) { this.customerId = customerId; }
    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }
    public BigDecimal getTotal() { return total; }
    public void setTotal(BigDecimal total) { this.total = total; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    public List<Line> getLines() { return lines; }
    public void setLines(List<Line> lines) { this.lines = lines; }
}
