<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, java.math.BigDecimal" %>
<%@ page import="com.pahanaedu.service.CustomerService, com.pahanaedu.service.ItemService" %>
<%@ page import="com.pahanaedu.model.Customer, com.pahanaedu.model.Item" %>
<%@ page import="com.pahanaedu.model.Bill" %>

<%
    // data for the form
    List<Customer> customers = new CustomerService().getAllCustomers();
    List<Item> items = new ItemService().getAllItems();

    // bill result (if forwarded by BillServlet?action=view)
    Bill bill = (Bill) request.getAttribute("bill");

    String error = request.getParameter("error"); // optional error message code
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Calculate & Print Bill</title>
    <style>
        :root{--bg:#0b1220;--card:#111827;--border:#1f2937;--text:#e5e7eb;--muted:#94a3b8;--accent:#22c55e;--accent2:#16a34a}
        *{box-sizing:border-box}
        body{margin:0;min-height:100vh;padding:28px;font-family:system-ui,-apple-system,"Segoe UI";color:var(--text);background:radial-gradient(1200px 800px at 10% -10%, #1e293b 0%, #0b1220 40%, #060a13 100%);display:flex;justify-content:center}
        .wrap{width:min(1100px,100%)}
        .card{background:rgba(17,24,39,.9);border:1px solid var(--border);border-radius:18px;padding:22px;box-shadow:0 20px 50px rgba(0,0,0,.4);margin-bottom:18px}
        h2{margin:0 0 10px}
        .subtitle{color:var(--muted);margin-bottom:16px}
        .row{display:grid;grid-template-columns:1fr 1fr;gap:14px}
        @media(max-width:800px){.row{grid-template-columns:1fr}}
        label{color:#cbd5e1}
        select,input{width:100%;padding:12px;border:1px solid var(--border);border-radius:12px;background:#0b1220;color:var(--text)}
        table{width:100%;border-collapse:separate;border-spacing:0}
        th,td{padding:10px 12px;border-bottom:1px solid var(--border);text-align:left}
        thead th{position:sticky;top:0;background:#0f172a}
        .btn{padding:10px 14px;border-radius:12px;border:1px solid var(--border);background:#0b1220;color:#fff;text-decoration:none;cursor:pointer}
        .btn.primary{background:linear-gradient(180deg,var(--accent),var(--accent2));border:0}
        .btn.danger{background:#7f1d1d;border-color:#991b1b}
        .right{display:flex;gap:10px;justify-content:flex-end}
        .alert{margin:8px 0 14px;padding:10px 12px;border-radius:12px;border:1px solid rgba(239,68,68,.35);background:rgba(239,68,68,.12);color:#fecaca}
        .total{font-weight:700;font-size:1.1rem}
        @media print {.no-print{display:none}}
    </style>
</head>
<body>
<div class="wrap">

    <% if (bill != null) { %>
    <!-- Result block -->
    <div class="card">
        <h2>🧾 Bill #<%= bill.getId() %></h2>
        <div class="subtitle">Customer: <strong><%= bill.getCustomerName() %></strong> · Date: <%= bill.getCreatedAt() %></div>
        <div class="table-wrap">
            <table>
                <thead>
                <tr>
                    <th>Item</th><th style="width:90px">Qty</th><th style="width:140px">Price</th><th style="width:160px">Subtotal</th>
                </tr>
                </thead>
                <tbody>
                <% for (Bill.Line ln : bill.getLines()) { %>
                <tr>
                    <td><%= ln.getItemName() %></td>
                    <td><%= ln.getQuantity() %></td>
                    <td>LKR <%= ln.getPrice() %></td>
                    <td>LKR <%= ln.getSubtotal() %></td>
                </tr>
                <% } %>
                </tbody>
                <tfoot>
                <tr>
                    <td colspan="3" class="total">Grand Total</td>
                    <td class="total">LKR <%= bill.getTotal() %></td>
                </tr>
                </tfoot>
            </table>
        </div>
        <div class="right no-print" style="margin-top:12px">
            <a class="btn" href="<%= request.getContextPath() %>/calculate_bill.jsp">Create another</a>
            <button class="btn primary" onclick="window.print()">Print</button>
        </div>
    </div>
    <% } %>

    <!-- Form block -->
    <div class="card no-print">
        <h2>Create Bill</h2>
        <div class="subtitle">Select a customer and add items to the bill.</div>

        <% if (error != null) { %>
        <div class="alert">⚠️ <%= error %></div>
        <% } %>

        <form id="billForm" action="${pageContext.request.contextPath}/BillServlet" method="post" autocomplete="off">
            <div class="row">
                <div>
                    <label for="customerId">Customer</label>
                    <select id="customerId" name="customerId" required>
                        <option value="">-- Select customer --</option>
                        <% for (Customer c : customers) { %>
                        <option value="<%= c.getId() %>"><%= c.getName() %></option>
                        <% } %>
                    </select>
                </div>
                <div></div>
            </div>

            <div style="margin-top:14px; border:1px solid var(--border); border-radius:14px; overflow:auto">
                <table id="linesTable">
                    <thead>
                    <tr>
                        <th style="width:40%">Item</th>
                        <th style="width:100px">Qty</th>
                        <th style="width:140px">Price</th>
                        <th style="width:160px">Subtotal</th>
                        <th style="width:140px" class="no-print">Actions</th>
                    </tr>
                    </thead>
                    <tbody id="tbody">
                    <!-- one default row -->
                    <tr>
                        <td>
                            <select name="itemId" class="itemSel" required>
                                <option value="">-- Select item --</option>
                                <% for (Item it : items) { %>
                                <option value="<%= it.getId() %>"><%= it.getName() %></option>
                                <% } %>
                            </select>
                        </td>
                        <td><input type="number" name="qty" class="qty" min="1" value="1" required></td>
                        <td class="price">LKR 0.00</td>
                        <td class="subtotal">LKR 0.00</td>
                        <td class="no-print">
                            <button type="button" class="btn" onclick="addRow()">Add</button>
                            <button type="button" class="btn danger" onclick="removeRow(this)">Remove</button>
                        </td>
                    </tr>
                    </tbody>
                    <tfoot>
                    <tr>
                        <td colspan="3" class="total">Grand Total</td>
                        <td id="grandTotal" class="total">LKR 0.00</td>
                        <td></td>
                    </tr>
                    </tfoot>
                </table>
            </div>

            <div class="right" style="margin-top:12px">
                <button class="btn primary" type="submit">Save Bill</button>
            </div>
        </form>
    </div>
</div>

<script>
    // Price map from items
    const PRICE_MAP = {
        <% for (int i=0;i<items.size();i++) { Item it = items.get(i); %>
        "<%= it.getId() %>": <%= it.getPrice() %><%= (i<items.size()-1) ? "," : "" %>
        <% } %>
    };

    function format(v){ return "LKR " + Number(v).toFixed(2); }

    function recalcRow(tr){
        const sel = tr.querySelector('.itemSel');
        const qty = Number(tr.querySelector('.qty').value || 0);
        const price = sel && PRICE_MAP[sel.value] ? Number(PRICE_MAP[sel.value]) : 0;
        tr.querySelector('.price').textContent = format(price);
        tr.querySelector('.subtotal').textContent = format(price * qty);
    }

    function recalcAll(){
        let total = 0;
        document.querySelectorAll('#tbody tr').forEach(tr=>{
            recalcRow(tr);
            const st = tr.querySelector('.subtotal').textContent.replace('LKR','') || "0";
            total += Number(st);
        });
        document.getElementById('grandTotal').textContent = format(total);
    }

    function addRow(){
        const tr = document.querySelector('#tbody tr').cloneNode(true);
        tr.querySelector('.itemSel').value = "";
        tr.querySelector('.qty').value = 1;
        document.getElementById('tbody').appendChild(tr);
        bindRow(tr);
        recalcAll();
    }
    function removeRow(btn){
        const rows = document.querySelectorAll('#tbody tr');
        if (rows.length > 1) btn.closest('tr').remove();
        recalcAll();
    }
    function bindRow(tr){
        tr.querySelector('.itemSel').addEventListener('change', recalcAll);
        tr.querySelector('.qty').addEventListener('input', recalcAll);
    }
    document.querySelectorAll('#tbody tr').forEach(bindRow);
    recalcAll();
</script>
</body>
</html>
