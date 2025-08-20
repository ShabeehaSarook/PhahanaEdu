<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.pahanaedu.model.Customer" %>
<%@ page import="com.pahanaedu.service.CustomerService" %>

<%
  CustomerService customerService = new CustomerService();
  List<Customer> customers = customerService.getAllCustomers();
  int total = (customers == null) ? 0 : customers.size();
  String msg = request.getParameter("msg");     // created | updated | deleted
  String error = request.getParameter("error"); // notfound | server | bad_id
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Pahana Edu — Customers</title>
  <style>
    :root{
      --bg:#0b1220; --card:#111827; --muted:#94a3b8; --text:#e5e7eb;
      --border:#1f2937; --accent:#22c55e; --accent2:#16a34a; --link:#93c5fd;
      --odd:#0e1626; --even:#0b1220;
    }
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
    .btn.danger{background:#7f1d1d;border-color:#991b1b}
    .search{display:flex;align-items:center;gap:10px;padding:10px 12px;border-radius:12px;border:1px solid var(--border);background:#0b1220;color:var(--text);margin-left:auto}
    .search input{border:0;outline:0;background:transparent;color:inherit;width:220px}
    .alert{margin:8px 0 14px;padding:10px 12px;border-radius:12px;border:1px solid;font-size:.95rem}
    .ok{background:rgba(16,185,129,.12);border-color:rgba(16,185,129,.35);color:#bbf7d0}
    .err{background:rgba(239,68,68,.12);border-color:rgba(239,68,68,.35);color:#fecaca}
    .table-wrap{overflow:auto;border-radius:14px;border:1px solid var(--border)}
    table{width:100%;border-collapse:separate;border-spacing:0;min-width:880px}
    thead th{position:sticky;top:0;z-index:1;background:#0f172a;color:#d1d5db;font-weight:600;text-align:left;padding:12px 14px;border-bottom:1px solid var(--border)}
    tbody td{padding:12px 14px;border-bottom:1px solid var(--border)}
    tbody tr:nth-child(odd){background:var(--odd)}
    tbody tr:nth-child(even){background:var(--even)}
    tbody tr:hover{outline:1px solid rgba(34,197,94,.25);background:#111a2b}
    .actions{display:flex;gap:8px;align-items:center}
    .inline{display:inline}
  </style>
</head>
<body>
<div class="wrap">
  <div class="card">
    <h2>Customer Accounts <span class="pill"><%= total %> total</span></h2>
    <div class="subtitle">View, search, edit, and delete customer records.</div>

    <% if ("created".equals(msg)) { %><div class="alert ok">✅ Customer created successfully.</div><% } %>
    <% if ("updated".equals(msg)) { %><div class="alert ok">✅ Customer updated successfully.</div><% } %>
    <% if ("deleted".equals(msg)) { %><div class="alert ok">✅ Customer deleted successfully.</div><% } %>
    <% if (error != null) { %><div class="alert err">⚠️ <%= error %></div><% } %>

    <div class="toolbar">
      <a class="btn primary" href="<%= request.getContextPath() %>/add_customer.jsp">➕ Add New Customer</a>
      <a class="btn" href="<%= request.getContextPath() %>/dashboard.jsp">🏠 Dashboard</a>
      <label class="search" title="Type to filter table">🔎
        <input id="search" type="text" placeholder="Search name, account, phone…">
      </label>
    </div>

    <% if (customers == null || customers.isEmpty()) { %>
    <div class="alert" style="background:transparent;border-color:var(--border);color:var(--muted)">
      No customers found. Click
      <a class="btn primary" style="padding:6px 10px;margin-left:8px" href="<%= request.getContextPath() %>/add_customer.jsp">Add New</a>
    </div>
    <% } else { %>
    <div class="table-wrap">
      <table id="customersTable">
        <thead>
        <tr>
          <th style="width:80px">ID</th>
          <th>Account No</th>
          <th>Name</th>
          <th>Address</th>
          <th>Telephone</th>
          <th style="width:120px">Units</th>
          <th style="width:220px">Actions</th>
        </tr>
        </thead>
        <tbody>
        <% for (Customer c : customers) { %>
        <tr>
          <td><%= c.getId() %></td>
          <td><%= c.getAccountNumber() %></td>
          <td><%= c.getName() %></td>
          <td><%= c.getAddress() %></td>
          <td><%= c.getTelephone() %></td>
          <td><span class="pill"><%= c.getUnitsConsumed() %></span></td>
          <td>
            <div class="actions">
              <!-- Edit via GET (handled in doGet) -->
              <a class="btn" href="<%= request.getContextPath() %>/CustomerServlet?action=edit&id=<%= c.getId() %>">✏️ Edit</a>

              <!-- Delete via POST -->
              <form class="inline" action="<%= request.getContextPath() %>/CustomerServlet" method="post"
                    onsubmit="return confirm('Delete this customer?');">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" name="id" value="<%= c.getId() %>">
                <button class="btn danger" type="submit">🗑️ Delete</button>
              </form>
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
  (function () {
    var input = document.getElementById('search');
    var table = document.getElementById('customersTable');
    if (!input || !table) return;
    input.addEventListener('input', function () {
      var q = (input.value || '').toLowerCase();
      var tb = table.tBodies[0];
      for (var i = 0; i < tb.rows.length; i++) {
        var row = tb.rows[i];
        var text = (row.textContent || row.innerText || '').toLowerCase();
        row.style.display = text.indexOf(q) !== -1 ? '' : 'none';
      }
    });
  })();
</script>
</body>
</html>
