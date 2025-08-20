<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.pahanaedu.model.Bill" %>
<%@ page import="com.pahanaedu.service.BillService" %>

<%
    List<Bill> bills = new BillService().getAllBills();
    int total = (bills == null) ? 0 : bills.size();
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Pahana Edu — Bills</title>
    <style>
        :root{--bg:#0b1220;--card:#111827;--muted:#94a3b8;--text:#e5e7eb;--border:#1f2937;--accent:#22c55e;--accent2:#16a34a;--odd:#0e1626;--even:#0b1220}
        *{box-sizing:border-box}
        body{margin:0;min-height:100vh;padding:28px;font-family:system-ui,-apple-system,"Segoe UI";color:var(--text);background:radial-gradient(1200px 800px at 10% -10%, #1e293b 0%, #0b1220 40%, #060a13 100%);display:flex;justify-content:center}
        .wrap{width:min(1100px,100%)}
        .card{background:rgba(17,24,39,.9);border:1px solid var(--border);border-radius:18px;padding:22px;box-shadow:0 20px 50px rgba(0,0,0,.4)}
        h2{margin:0 0 6px}
        .subtitle{color:var(--muted);margin-bottom:16px}
        .pill{display:inline-block;padding:4px 8px;border-radius:999px;background:#0e1a2c;border:1px solid var(--border);color:#cbd5e1;font-size:.85rem}
        .toolbar{display:flex;gap:12px;flex-wrap:wrap;align-items:center;margin:10px 0 16px}
        .btn{display:inline-flex;align-items:center;gap:8px;padding:10px 14px;border-radius:12px;color:#fff;text-decoration:none;border:1px solid var(--border);background:#0b1220}
        .btn:hover{background:#0e1626}
        .btn.primary{background:linear-gradient(180deg,var(--accent),var(--accent2));border:0;box-shadow:0 10px 20px rgba(34,197,94,.25)}
        .search{display:flex;align-items:center;gap:10px;padding:10px 12px;border-radius:12px;border:1px solid var(--border);background:#0b1220;color:var(--text);margin-left:auto}
        .search input{border:0;outline:0;background:transparent;color:inherit;width:220px}
        .alert{margin:8px 0 14px;padding:10px 12px;border-radius:12px;border:1px solid rgba(239,68,68,.35);background:rgba(239,68,68,.12);color:#fecaca}
        .table-wrap{overflow:auto;border-radius:14px;border:1px solid var(--border)}
        table{width:100%;border-collapse:separate;border-spacing:0;min-width:880px}
        thead th{position:sticky;top:0;background:#0f172a;color:#d1d5db;font-weight:600;text-align:left;padding:12px 14px;border-bottom:1px solid var(--border)}
        tbody td{padding:12px 14px;border-bottom:1px solid var(--border)}
        tbody tr:nth-child(odd){background:var(--odd)}
        tbody tr:nth-child(even){background:var(--even)}
        tbody tr:hover{outline:1px solid rgba(34,197,94,.25);background:#111a2b}
        .actions{display:flex;gap:8px;align-items:center}
    </style>
</head>
<body>
<div class="wrap">
    <div class="card">
        <h2>Bills <span class="pill"><%= total %> total</span></h2>
        <div class="subtitle">Browse and export bills.</div>

        <% if (error != null) { %><div class="alert">⚠️ <%= error %></div><% } %>

        <div class="toolbar">
            <a class="btn primary" href="<%= request.getContextPath() %>/calculate_bill.jsp">➕ Create Bill</a>
            <a class="btn" href="<%= request.getContextPath() %>/dashboard.jsp">🏠 Dashboard</a>
            <label class="search">🔎 <input id="search" type="text" placeholder="Search customer, total…"></label>
        </div>

        <% if (bills == null || bills.isEmpty()) { %>
        <div class="alert" style="background:transparent;border-color:var(--border);color:#94a3b8">
            No bills yet. Create your first one.
        </div>
        <% } else { %>
        <div class="table-wrap">
            <table id="billsTable">
                <thead>
                <tr>
                    <th style="width:80px">ID</th>
                    <th>Customer</th>
                    <th style="width:180px">Date</th>
                    <th style="width:140px">Total (LKR)</th>
                    <th style="width:220px">Actions</th>
                </tr>
                </thead>
                <tbody>
                <% for (Bill b : bills) { %>
                <tr>
                    <td><%= b.getId() %></td>
                    <td><%= b.getCustomerName() %></td>
                    <td><%= b.getCreatedAt() %></td>
                    <td><span class="pill"><%= b.getTotal() %></span></td>
                    <td>
                        <div class="actions">
                            <a class="btn" href="<%= request.getContextPath() %>/BillServlet?action=view&id=<%= b.getId() %>">🔍 View</a>
                            <a class="btn" href="<%= request.getContextPath() %>/BillPdfServlet?id=<%= b.getId() %>">⬇️ PDF</a>
                        </div>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
        <% } %>
    </div>
</div>

<script>
    (function(){
        var input = document.getElementById('search');
        var table = document.getElementById('billsTable');
        if (!input || !table) return;
        input.addEventListener('input', function(){
            var q = (input.value || '').toLowerCase();
            var tb = table.tBodies[0];
            for (var i=0;i<tb.rows.length;i++){
                var row = tb.rows[i];
                var text = (row.textContent || row.innerText || '').toLowerCase();
                row.style.display = text.indexOf(q) !== -1 ? '' : 'none';
            }
        });
    })();
</script>
</body>
</html>
