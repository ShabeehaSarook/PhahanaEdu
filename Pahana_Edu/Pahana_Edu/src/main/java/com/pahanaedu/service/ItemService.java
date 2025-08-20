package com.pahanaedu.service;

import com.pahanaedu.dao.ItemDAO;
import com.pahanaedu.model.Item;
import java.util.List;

public class ItemService {
    private final ItemDAO itemDAO = new ItemDAO();

    public void addItem(Item i) { itemDAO.addItem(i); }
    public List<Item> getAllItems() { return itemDAO.getAllItems(); }
    public Item getItemById(int id) { return itemDAO.getById(id); }
    public boolean updateItem(Item i) { return itemDAO.updateItem(i); }
    public boolean deleteItem(int id) { return itemDAO.deleteItem(id); }
}
