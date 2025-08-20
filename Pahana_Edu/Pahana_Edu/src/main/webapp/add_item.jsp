<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Add Item</title>
  <style>
    :root{--bg:#0b1220;--card:#111827;--border:#1f2937;--text:#e5e7eb;--muted:#94a3b8;--accent:#22c55e;--accent2:#16a34a}
    *{box-sizing:border-box}
    body{margin:0;min-height:100vh;display:flex;align-items:center;justify-content:center;background:#0b1220;color:var(--text);font-family:system-ui,-apple-system,"Segoe UI";padding:24px}
    .card{width:min(760px,100%);background:#111827;border:1px solid var(--border);border-radius:18px;padding:22px;box-shadow:0 20px 50px rgba(0,0,0,.4)}
    h2{margin:0 0 8px}
    .sub{color:var(--muted);margin-bottom:16px}
    form{display:grid;grid-template-columns:1fr 1fr;gap:16px}
    @media(max-width:720px){form{grid-template-columns:1fr}}
    label{color:#cbd5e1}
    input[type="text"], input[type="number"], textarea{width:100%;padding:12px;border:1px solid var(--border);border-radius:12px;background:#0b1220;color:var(--text)}
    textarea{min-height:96px}
    .full{grid-column:1/-1}
    .actions{grid-column:1/-1;display:flex;gap:12px;justify-content:flex-end;margin-top:8px}
    .btn{padding:12px 16px;border-radius:12px;border:1px solid var(--border);background:#0b1220;color:#fff;text-decoration:none;cursor:pointer}
    .btn.primary{background:linear-gradient(180deg,var(--accent),var(--accent2));border:0}
  </style>
</head>
<body>
<div class="card">
  <h2>📦 Add Item</h2>
  <div class="sub">Enter item details to add to inventory.</div>

  <form action="${pageContext.request.contextPath}/ItemServlet" method="post" autocomplete="off">
    <div>
      <label for="sku">SKU (optional)</label>
      <input id="sku" name="sku" type="text" placeholder="e.g., BK-001">
    </div>
    <div>
      <label for="name">Name</label>
      <input id="name" name="name" type="text" required placeholder="Book title">
    </div>

    <div class="full">
      <label for="description">Description</label>
      <textarea id="description" name="description" placeholder="Short description"></textarea>
    </div>

    <div>
      <label for="price">Price (LKR)</label>
      <input id="price" name="price" type="number" step="0.01" min="0" required>
    </div>
    <div>
      <label for="stock">Stock</label>
      <input id="stock" name="stock" type="number" step="1" min="0" required>
    </div>

    <div class="actions">
      <a class="btn" href="${pageContext.request.contextPath}/view_items.jsp">Cancel</a>
      <button class="btn primary" type="submit">Save Item</button>
    </div>
  </form>
</div>
</body>
</html>
