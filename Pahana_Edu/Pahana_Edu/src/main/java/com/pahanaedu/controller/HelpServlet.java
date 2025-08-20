package com.pahanaedu.controller;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.ServletException;

import java.io.IOException;

/** Simple controller that forwards to help.jsp */
@WebServlet(name = "HelpServlet", urlPatterns = {"/help"})
public class HelpServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // Optional: pass a small hint or version if you like
        req.setAttribute("appVersion", "1.0");
        req.getRequestDispatcher("/help.jsp").forward(req, resp);
    }
}
