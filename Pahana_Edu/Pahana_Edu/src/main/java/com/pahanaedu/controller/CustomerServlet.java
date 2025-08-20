package com.pahanaedu.controller;

import com.pahanaedu.model.Customer;
import com.pahanaedu.service.CustomerService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "CustomerServlet", urlPatterns = {"/CustomerServlet"})
public class CustomerServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final CustomerService customerService = new CustomerService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // Support "edit" via GET: /CustomerServlet?action=edit&id=123
        String action = req.getParameter("action");
        if ("edit".equalsIgnoreCase(action)) {
            String idStr = req.getParameter("id");
            try {
                int id = Integer.parseInt(idStr);
                Customer customer = customerService.getCustomerById(id);
                if (customer == null) {
                    resp.sendRedirect(req.getContextPath() + "/view_customers.jsp?error=notfound");
                    return;
                }
                req.setAttribute("customer", customer);
                req.getRequestDispatcher("/edit_customer.jsp").forward(req, resp);
                return;
            } catch (Exception ex) {
                resp.sendRedirect(req.getContextPath() + "/view_customers.jsp?error=bad_id");
                return;
            }
        }
        // Default: go back to list
        resp.sendRedirect(req.getContextPath() + "/view_customers.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String ctx = req.getContextPath();
        String action = req.getParameter("action");

        try {
            // DELETE
            if ("delete".equalsIgnoreCase(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                customerService.deleteCustomer(id);
                resp.sendRedirect(ctx + "/view_customers.jsp?msg=deleted");
                return;
            }

            // (Optional) EDIT via POST fallback (in case you use a POST button for Edit)
            if ("edit".equalsIgnoreCase(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                Customer c = customerService.getCustomerById(id);
                if (c == null) {
                    resp.sendRedirect(ctx + "/view_customers.jsp?error=notfound");
                    return;
                }
                req.setAttribute("customer", c);
                req.getRequestDispatcher("/edit_customer.jsp").forward(req, resp);
                return;
            }

            // ADD or UPDATE (distinguished by presence of "id")
            String accountNumber = req.getParameter("accountNumber");
            String name = req.getParameter("name");
            String address = req.getParameter("address");
            String telephone = req.getParameter("telephone");
            int unitsConsumed = Integer.parseInt(req.getParameter("unitsConsumed"));

            Customer customer = new Customer();
            customer.setAccountNumber(accountNumber);
            customer.setName(name);
            customer.setAddress(address);
            customer.setTelephone(telephone);
            customer.setUnitsConsumed(unitsConsumed);

            String idStr = req.getParameter("id");
            if (idStr != null && !idStr.isEmpty()) {
                customer.setId(Integer.parseInt(idStr));
                customerService.updateCustomer(customer);
                resp.sendRedirect(ctx + "/view_customers.jsp?msg=updated");
            } else {
                customerService.addCustomer(customer);
                resp.sendRedirect(ctx + "/view_customers.jsp?msg=created");
            }

        } catch (Exception ex) {
            ex.printStackTrace();
            resp.sendRedirect(ctx + "/view_customers.jsp?error=server");
        }
    }
}
