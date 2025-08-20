package com.pahanaedu.controller;

import com.pahanaedu.model.Bill;
import com.pahanaedu.service.BillService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "BillServlet", urlPatterns = {"/BillServlet"})
public class BillServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final BillService billService = new BillService();

    // Show a bill result: /BillServlet?action=view&id=123
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("view".equalsIgnoreCase(action)) {
            try {
                int id = Integer.parseInt(req.getParameter("id"));
                Bill bill = billService.getBillById(id);
                if (bill == null) {
                    resp.sendRedirect(req.getContextPath() + "/calculate_bill.jsp?error=notfound");
                    return;
                }
                req.setAttribute("bill", bill);
                req.getRequestDispatcher("/calculate_bill.jsp").forward(req, resp);
                return;
            } catch (Exception e) {
                resp.sendRedirect(req.getContextPath() + "/calculate_bill.jsp?error=bad_id");
                return;
            }
        }
        resp.sendRedirect(req.getContextPath() + "/calculate_bill.jsp");
    }

    // Create a bill from posted arrays itemId[] and qty[]
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String ctx = req.getContextPath();

        try {
            int customerId = Integer.parseInt(req.getParameter("customerId"));
            String[] itemIdsStr = req.getParameterValues("itemId");
            String[] qtysStr = req.getParameterValues("qty");

            if (itemIdsStr == null || qtysStr == null || itemIdsStr.length == 0 || itemIdsStr.length != qtysStr.length) {
                resp.sendRedirect(ctx + "/calculate_bill.jsp?error=invalid_input");
                return;
            }

            int n = itemIdsStr.length;
            int[] itemIds = new int[n];
            int[] qtys = new int[n];
            for (int i = 0; i < n; i++) {
                itemIds[i] = Integer.parseInt(itemIdsStr[i]);
                qtys[i] = Integer.parseInt(qtysStr[i]);
            }

            int billId = billService.createBill(customerId, itemIds, qtys);
            resp.sendRedirect(ctx + "/BillServlet?action=view&id=" + billId);
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(ctx + "/calculate_bill.jsp?error=server");
        }
    }
}
