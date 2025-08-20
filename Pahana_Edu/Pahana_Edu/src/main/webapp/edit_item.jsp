<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.pahanaedu.model.Item, com.pahanaedu.service.ItemService" %>
<%
    Item item = (Item) request.getAttribute("item");
    if (item == null) {
        String idParam = request.getParameter("id");
        if (idParam != null) {
            try { item = new ItemService().getItemById(Integer.parseInt(idParam)); } catch (Exception ignore) {}
        }
    }
    if (item == null) { response.sendRedirect(request.getContextPath() + "/view_items.jsp?error=notfound"); return; }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Item</title>
    <style>
        :root{--bg:#0b1220;--card:#111827;--border:#1f2937;--text:#e5e7eb;--muted:#94a3b8;--accent:#22c55e;--accent2:#16a34a}
        *{box-sizing:border-box}
        body{margin:0;min-height:100vh;display:flex;align-items:center;justify-content:center;background:#0b1220;color:var(--text);font-family:system-ui,-apple-system,"Segoe UI";padding:24px}
        .card{width:min(760px,100%);background:#111827;border:1px solid var(--border);border-radius:18px;padding:22px;box-shadow:0 20px 50px rgba(0,0,0,.4)}
        h2{margin:0 0 8px}
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
    <h2>✏️ Edit Item</h2>
    <form action="${pageContext.request.contextPath}/ItemServlet" method="post" autocomplete="off">
        <input type="hidden" name="id" value="<%= item.getId() %>">

        <div>
            <label>SKU</label>
            <input name="sku" type="text" value="<%= item.getSku() == null ? "" : item.getSku() %>">
        </div>
        <div>
            <label>Name</label>
            <input name="name" type="text" required value="<%= item.getName() %>">
        </div>

        <div class="full">
            <label>Description</label>
            <textarea name="description"><%= item.getDescription() == null ? "" : item.getDescription() %></textarea>
        </div>

        <div>
            <label>Price (LKR)</label>
            <input name="price" type="number" step="0.01" min="0" required value="<%= item.getPrice() %>">
        </div>
        <div>
            <label>Stock</label>
            <input name="stock" type="number" step="1" min="0" required value="<%= item.getStock() %>">
        </div>

        <div class="actions">
            <a class="btn" href="${pageContext.request.contextPath}/view_items.jsp">Cancel</a>
            <button class="btn primary" type="submit">Update</button>
        </div>
    </form>
</div>
</body>
</html>
