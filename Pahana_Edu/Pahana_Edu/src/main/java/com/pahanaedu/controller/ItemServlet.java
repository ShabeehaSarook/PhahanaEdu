package com.pahanaedu.controller;

import com.pahanaedu.model.Item;
import com.pahanaedu.service.ItemService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;

@WebServlet(name = "ItemServlet", urlPatterns = {"/ItemServlet"})
public class ItemServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final ItemService itemService = new ItemService();

    // GET: show edit form
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("edit".equalsIgnoreCase(action)) {
            try {
                int id = Integer.parseInt(req.getParameter("id"));
                Item item = itemService.getItemById(id);
                if (item == null) {
                    resp.sendRedirect(req.getContextPath() + "/view_items.jsp?error=notfound");
                    return;
                }
                req.setAttribute("item", item);
                req.getRequestDispatcher("/edit_item.jsp").forward(req, resp);
                return;
            } catch (Exception e) {
                resp.sendRedirect(req.getContextPath() + "/view_items.jsp?error=bad_id");
                return;
            }
        }
        resp.sendRedirect(req.getContextPath() + "/view_items.jsp");
    }

    // POST: create / update / delete
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String ctx = req.getContextPath();
        String action = req.getParameter("action");

        try {
            if ("delete".equalsIgnoreCase(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                itemService.deleteItem(id);
                resp.sendRedirect(ctx + "/view_items.jsp?msg=deleted");
                return;
            }

            // common fields
            String sku = req.getParameter("sku");
            String name = req.getParameter("name");
            String description = req.getParameter("description");
            BigDecimal price = new BigDecimal(req.getParameter("price"));
            int stock = Integer.parseInt(req.getParameter("stock"));

            Item item = new Item();
            item.setSku(sku);
            item.setName(name);
            item.setDescription(description);
            item.setPrice(price);
            item.setStock(stock);

            String idStr = req.getParameter("id");
            if (idStr != null && !idStr.isEmpty()) {
                item.setId(Integer.parseInt(idStr));
                itemService.updateItem(item);
                resp.sendRedirect(ctx + "/view_items.jsp?msg=updated");
            } else {
                itemService.addItem(item);
                resp.sendRedirect(ctx + "/view_items.jsp?msg=created");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(ctx + "/view_items.jsp?error=server");
        }
    }
}
