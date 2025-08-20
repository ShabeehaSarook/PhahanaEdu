<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Pahana Edu — Help</title>
  <style>
    :root{--bg:#0b1220;--card:#111827;--border:#1f2937;--text:#e5e7eb;--muted:#94a3b8;--link:#93c5fd;--accent:#22c55e;--accent2:#16a34a}
    *{box-sizing:border-box}
    body{margin:0;min-height:100vh;padding:28px;font-family:system-ui,-apple-system,"Segoe UI";color:var(--text);background:radial-gradient(1200px 800px at 10% -10%, #1e293b 0%, #0b1220 40%, #060a13 100%);display:flex;justify-content:center}
    .wrap{width:min(1100px,100%)}
    .card{background:rgba(17,24,39,.9);border:1px solid var(--border);border-radius:18px;padding:22px;box-shadow:0 20px 50px rgba(0,0,0,.4)}
    h1{margin:0 0 8px}
    p.sub{color:var(--muted);margin:0 0 16px}
    .grid{display:grid;grid-template-columns:1fr 1fr;gap:16px}
    @media(max-width:900px){.grid{grid-template-columns:1fr}}
    .section{background:#0b1220;border:1px solid var(--border);border-radius:14px;padding:16px}
    .section h2{margin:0 0 8px;font-size:1.1rem}
    ul{margin:8px 0 0 18px}
    code{background:#0e1a2c;border:1px solid var(--border);border-radius:8px;padding:2px 6px}
    .btn{display:inline-block;margin-top:14px;padding:10px 14px;border-radius:12px;border:1px solid var(--border);background:#0b1220;color:#fff;text-decoration:none}
    .btn.primary{background:linear-gradient(180deg,var(--accent),var(--accent2));border:0}
  </style>
</head>
<body>
<div class="wrap">
  <div class="card">
    <h1>Help &amp; Usage Guide</h1>
    <p class="sub">Quick steps to use the Pahana Edu Billing System.</p>

    <div class="grid">
      <div class="section">
        <h2>Customers</h2>
        <ul>
          <li><a style="color:var(--link)" href="${pageContext.request.contextPath}/add_customer.jsp">Add Customer</a>: fill the form and click <em>Save</em>.</li>
          <li><a style="color:var(--link)" href="${pageContext.request.contextPath}/view_customers.jsp">View Customers</a>:
            search, <em>Edit</em> to update, or <em>Delete</em> to remove.</li>
        </ul>
      </div>

      <div class="section">
        <h2>Items</h2>
        <ul>
          <li><a style="color:var(--link)" href="${pageContext.request.contextPath}/add_item.jsp">Add Item</a>: enter name, price, stock.</li>
          <li><a style="color:var(--link)" href="${pageContext.request.contextPath}/view_items.jsp">View Items</a>: edit or delete as needed.</li>
        </ul>
      </div>

      <div class="section">
        <h2>Bills</h2>
        <ul>
          <li><a style="color:var(--link)" href="${pageContext.request.contextPath}/calculate_bill.jsp">Create Bill</a>: select a customer, add items and quantities, then <em>Save Bill</em>.</li>
          <li><a style="color:var(--link)" href="${pageContext.request.contextPath}/view_bills.jsp">View Bills</a>: open any bill, print, or download PDF.</li>
        </ul>
      </div>

      <div class="section">
        <h2>Troubleshooting</h2>
        <ul>
          <li><strong>404 / 405:</strong> check servlet URLs and Tomcat version (Tomcat 10 ⇒ use <code>jakarta.servlet.*</code>).</li>
          <li><strong>DB errors:</strong> confirm <code>DBConnection</code> credentials and that tables exist (<code>schema.sql</code>).</li>
          <li><strong>CSS not loading:</strong> clear browser cache or hard-refresh (<code>Ctrl+F5</code>).</li>
        </ul>
      </div>
    </div>

    <a class="btn" href="${pageContext.request.contextPath}/dashboard.jsp">⬅ Back to Dashboard</a>
  </div>
</div>
</body>
</html>
