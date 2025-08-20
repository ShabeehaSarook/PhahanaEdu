<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.pahanaedu.model.Customer, com.pahanaedu.service.CustomerService" %>
<%
    Customer customer = (Customer) request.getAttribute("customer");
    if (customer == null) {
        String idParam = request.getParameter("id");
        if (idParam != null) {
            try { customer = new CustomerService().getCustomerById(Integer.parseInt(idParam)); } catch (Exception ignore) {}
        }
    }
    if (customer == null) { response.sendRedirect(request.getContextPath() + "/view_customers.jsp?error=notfound"); return; }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Customer</title>
    <style>
        body{font-family:system-ui,-apple-system,"Segoe UI";margin:0;min-height:100vh;display:flex;align-items:center;justify-content:center;background:#0b1220;color:#e5e7eb;padding:24px}
        .card{width:min(760px,100%);background:#111827;border:1px solid #1f2937;border-radius:18px;padding:22px;box-shadow:0 20px 50px rgba(0,0,0,.4)}
        h2{margin:0 0 12px}
        label{color:#cbd5e1}
        input[type="text"], input[type="number"], textarea{width:100%;padding:12px;border:1px solid #1f2937;border-radius:12px;background:#0b1220;color:#e5e7eb}
        textarea{min-height:96px}
        .row{display:grid;grid-template-columns:1fr 1fr;gap:16px}
        @media(max-width:720px){.row{grid-template-columns:1fr}}
        .actions{display:flex;gap:10px;justify-content:flex-end;margin-top:12px}
        .btn{padding:12px 16px;border-radius:12px;border:1px solid #1f2937;background:#0b1220;color:#e5e7eb;text-decoration:none;cursor:pointer}
        .btn.primary{background:linear-gradient(180deg,#22c55e,#16a34a);border:0;color:#fff}
    </style>
</head>
<body>
<div class="card">
    <h2>✏️ Edit Customer</h2>

    <form action="${pageContext.request.contextPath}/CustomerServlet" method="post" autocomplete="off">
        <input type="hidden" name="id" value="<%= customer.getId() %>">

        <div class="row">
            <div>
                <label>Account Number</label>
                <input type="text" name="accountNumber" required value="<%= customer.getAccountNumber() %>">
            </div>
            <div>
                <label>Name</label>
                <input type="text" name="name" required value="<%= customer.getName() %>">
            </div>
        </div>

        <div>
            <label>Address</label>
            <textarea name="address" required><%= customer.getAddress() %></textarea>
        </div>

        <div class="row">
            <div>
                <label>Telephone</label>
                <input type="text" name="telephone" required value="<%= customer.getTelephone() %>">
            </div>
            <div>
                <label>Units Consumed</label>
                <input type="number" name="unitsConsumed" min="0" required value="<%= customer.getUnitsConsumed() %>">
            </div>
        </div>

        <div class="actions">
            <a class="btn" href="${pageContext.request.contextPath}/view_customers.jsp">Cancel</a>
            <button class="btn primary" type="submit">Update</button>
        </div>
    </form>
</div>
</body>
</html>
