package com.pahanaedu.service;
import com.pahanaedu.dao.UserDAO;
import com.pahanaedu.model.User;

public class UserService {
    private UserDAO userDAO = new UserDAO();

    public boolean login(String username, String password) {
        User user = new User(username, password);
        return userDAO.validateUser(user);
    }
}
