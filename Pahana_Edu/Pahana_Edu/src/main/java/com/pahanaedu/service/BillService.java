package com.pahanaedu.service;

import com.pahanaedu.dao.BillDAO;
import com.pahanaedu.model.Bill;

import java.util.List;

/**
 * Business logic for bills: basic validation and DAO delegation.
 */
public class BillService {

    private final BillDAO billDAO = new BillDAO();

    /**
     * Create a bill (with line items) for a customer.
     * @param customerId existing customer ID
     * @param itemIds    item IDs (same length as qtys, > 0)
     * @param qtys       quantities (each > 0)
     * @return new bill ID
     * @throws Exception if validation fails or DAO throws
     */
    public int createBill(int customerId, int[] itemIds, int[] qtys) throws Exception {
        if (customerId <= 0) throw new IllegalArgumentException("Invalid customerId");
        if (itemIds == null || qtys == null || itemIds.length == 0 || itemIds.length != qtys.length) {
            throw new IllegalArgumentException("Invalid items/quantities");
        }
        for (int q : qtys) {
            if (q <= 0) throw new IllegalArgumentException("Quantity must be > 0");
        }
        return billDAO.createBill(customerId, itemIds, qtys);
    }

    /** Fetch a single bill (header + lines). */
    public Bill getBillById(int id) {
        if (id <= 0) return null;
        return billDAO.getBillById(id);
    }

    /** List bill headers for index pages. */
    public List<Bill> getAllBills() {
        return billDAO.listBills();
    }

    /** Delete a bill (lines removed via FK cascade). */
    public boolean deleteBill(int id) {
        if (id <= 0) return false;
        return billDAO.deleteBill(id);
    }
}
