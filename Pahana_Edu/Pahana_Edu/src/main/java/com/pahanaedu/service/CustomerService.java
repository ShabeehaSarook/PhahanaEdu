package com.pahanaedu.service;

import com.pahanaedu.dao.CustomerDAO;
import com.pahanaedu.model.Customer;
import java.util.List;

public class CustomerService {
    private final CustomerDAO customerDAO = new CustomerDAO();

    public void addCustomer(Customer c) { customerDAO.addCustomer(c); }
    public List<Customer> getAllCustomers() { return customerDAO.getAllCustomers(); }

    // NEW
    public Customer getCustomerById(int id) { return customerDAO.getById(id); }
    public boolean updateCustomer(Customer c) { return customerDAO.updateCustomer(c); }
    public boolean deleteCustomer(int id) { return customerDAO.deleteCustomer(id); }
}
