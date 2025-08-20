package com.pahanaedu.controller;

import com.pahanaedu.model.Bill;
import com.pahanaedu.service.BillService;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDPage;
import org.apache.pdfbox.pdmodel.common.PDRectangle;
import org.apache.pdfbox.pdmodel.PDPageContentStream;
import org.apache.pdfbox.pdmodel.font.PDType1Font;

import java.io.IOException;
import java.text.SimpleDateFormat;

@WebServlet(name = "BillPdfServlet", urlPatterns = {"/BillPdfServlet"})
public class BillPdfServlet extends HttpServlet {
    private final BillService billService = new BillService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int id;
        try {
            id = Integer.parseInt(req.getParameter("id"));
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/view_bills.jsp?error=bad_id");
            return;
        }

        Bill bill = billService.getBillById(id);
        if (bill == null) {
            resp.sendRedirect(req.getContextPath() + "/view_bills.jsp?error=notfound");
            return;
        }

        resp.setContentType("application/pdf");
        resp.setHeader("Content-Disposition", "attachment; filename=bill-" + id + ".pdf");

        PDDocument doc = new PDDocument();
        try {
            PDPage page = new PDPage(PDRectangle.A4);
            doc.addPage(page);

            float x = 50f;
            float y = page.getMediaBox().getHeight() - 60f;
            PDPageContentStream cs = new PDPageContentStream(doc, page);

            try {
                // Title
                cs.beginText();
                cs.setFont(PDType1Font.HELVETICA_BOLD, 18);
                cs.newLineAtOffset(x, y);
                cs.showText("Pahana Edu - Bill #" + bill.getId());
                cs.endText();

                // Subhead
                y -= 22;
                cs.beginText();
                cs.setFont(PDType1Font.HELVETICA, 12);
                cs.newLineAtOffset(x, y);
                String date = new SimpleDateFormat("yyyy-MM-dd HH:mm").format(bill.getCreatedAt());
                cs.showText("Customer: " + bill.getCustomerName() + "    Date: " + date);
                cs.endText();

                // Table header
                y -= 30;
                cs.beginText();
                cs.setFont(PDType1Font.COURIER_BOLD, 12); // monospaced for alignment
                cs.newLineAtOffset(x, y);
                cs.showText(col("Item", 48) + col("Qty", 6) + col("Price", 12) + col("Subtotal", 12));
                cs.endText();

                // Rows
                y -= 16;
                for (Bill.Line ln : bill.getLines()) {
                    if (y < 80) {
                        // new page
                        cs.close();
                        page = new PDPage(PDRectangle.A4);
                        doc.addPage(page);
                        cs = new PDPageContentStream(doc, page);
                        y = page.getMediaBox().getHeight() - 60f;

                        // repeat header on new page
                        cs.beginText();
                        cs.setFont(PDType1Font.COURIER_BOLD, 12);
                        cs.newLineAtOffset(x, y);
                        cs.showText(col("Item", 48) + col("Qty", 6) + col("Price", 12) + col("Subtotal", 12));
                        cs.endText();
                        y -= 16;
                    }

                    cs.beginText();
                    cs.setFont(PDType1Font.COURIER, 12);
                    cs.newLineAtOffset(x, y);
                    String itemName = truncate(ln.getItemName(), 48);
                    cs.showText(col(itemName, 48)
                            + col(String.valueOf(ln.getQuantity()), 6)
                            + col(String.valueOf(ln.getPrice()), 12)
                            + col(String.valueOf(ln.getSubtotal()), 12));
                    cs.endText();
                    y -= 16;
                }

                // Total
                y -= 10;
                cs.beginText();
                cs.setFont(PDType1Font.HELVETICA_BOLD, 12);
                cs.newLineAtOffset(x, y);
                cs.showText("Grand Total: LKR " + bill.getTotal());
                cs.endText();

            } finally {
                cs.close();
            }

            doc.save(resp.getOutputStream());
        } finally {
            doc.close();
        }
    }

    // --- helpers -------------------------------------------------------------

    private static String truncate(String s, int n) {
        if (s == null) return "";
        return (s.length() <= n) ? s : s.substring(0, n);
    }

    /** Pad text to a fixed width for monospaced columns. */
    private static String col(String s, int width) {
        if (s == null) s = "";
        if (s.length() > width) return s.substring(0, width);
        StringBuilder b = new StringBuilder(s);
        while (b.length() < width) b.append(' ');
        return b.toString();
    }
}
