<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <title>Pahana Edu - Dashboard</title>
    <style>
        :root{
            --bg:#0b1220; --panel:#111827; --border:#1f2937; --text:#e5e7eb; --muted:#94a3b8;
            --accent:#22c55e; --accent-2:#16a34a; --link:#93c5fd;
        }
        *{box-sizing:border-box}
        body{
            margin:0; min-height:100vh; padding:32px;
            font-family:system-ui,-apple-system,"Segoe UI",Roboto,Helvetica,Arial;
            color:var(--text);
            background: radial-gradient(1200px 800px at 10% -10%, #1e293b 0%, #0b1220 40%, #060a13 100%);
            display:flex; justify-content:center;
        }
        .wrap{width:min(1100px,100%)}
        .header{
            display:flex; align-items:center; justify-content:space-between; gap:16px;
            margin-bottom:18px;
        }
        .hello{
            background:rgba(17,24,39,.9); border:1px solid var(--border);
            padding:18px 20px; border-radius:16px; box-shadow:0 10px 30px rgba(0,0,0,.35);
            backdrop-filter:blur(6px);
        }
        .hello h1{margin:0; font-size:1.6rem}
        .hello p{margin:6px 0 0; color:var(--muted)}

        .grid{
            display:grid; grid-template-columns:repeat(3,1fr); gap:16px;
        }
        @media (max-width:900px){ .grid{ grid-template-columns:repeat(2,1fr);} }
        @media (max-width:620px){ .grid{ grid-template-columns:1fr; } }

        .card{
            display:block; text-decoration:none; color:inherit;
            background:rgba(17,24,39,.9); border:1px solid var(--border);
            padding:18px; border-radius:16px;
            box-shadow:0 10px 30px rgba(0,0,0,.35);
            transition:transform .08s ease, box-shadow .15s ease, border-color .15s ease;
        }
        .card:hover{
            transform:translateY(-3px);
            box-shadow:0 16px 36px rgba(0,0,0,.45);
            border-color:rgba(34,197,94,.45);
        }
        .card .icon{font-size:28px; line-height:1; margin-bottom:8px}
        .card h3{margin:6px 0 6px; font-size:1.05rem}
        .card p{margin:0; color:var(--muted); font-size:.93rem}

        .footer{
            margin-top:18px; text-align:center; color:var(--muted);
        }
        .footer a{color:var(--link); text-decoration:none}
    </style>
</head>
<body>
<div class="wrap">
    <div class="header">
        <div class="hello">
            <h1>Welcome, <%= username %> 👋</h1>
            <p>Pahana Edu Billing System · Quick actions below</p>
        </div>
    </div>

    <div class="grid">
        <a class="card" href="${pageContext.request.contextPath}/add_customer.jsp">
            <div class="icon">➕</div>
            <h3>Add Customer</h3>
            <p>Create a new customer account.</p>
        </a>

        <a class="card" href="${pageContext.request.contextPath}/view_customers.jsp">
            <div class="icon">👥</div>
            <h3>View Customers</h3>
            <p>Browse, search, and manage customers.</p>
        </a>

        <a class="card" href="${pageContext.request.contextPath}/add_item.jsp">
            <div class="icon">📦</div>
            <h3>Add Item</h3>
            <p>Add inventory items and pricing.</p>
        </a>

        <a class="card" href="${pageContext.request.contextPath}/view_items.jsp">
            <div class="icon">📋</div>
            <h3>View Items</h3>
            <p>See all items in stock.</p>
        </a>

        <a class="card" href="${pageContext.request.contextPath}/calculate_bill.jsp">
            <div class="icon">🧾</div>
            <h3>Calculate &amp; Print Bill</h3>
            <p>Generate customer bills quickly.</p>
        </a>

        <!-- NEW: View Bills -->
        <a class="card" href="${pageContext.request.contextPath}/view_bills.jsp">
            <div class="icon">📑</div>
            <h3>View Bills</h3>
            <p>Browse past bills and download PDFs.</p>
        </a>

        <a class="card" href="${pageContext.request.contextPath}/help.jsp">
            <div class="icon">❓</div>
            <h3>Help</h3>
            <p>Usage guide and FAQs.</p>
        </a>

        <a class="card" href="${pageContext.request.contextPath}/logout.jsp">
            <div class="icon">🚪</div>
            <h3>Logout</h3>
            <p>End your session securely.</p>
        </a>
    </div>

    <div class="footer">
        Tip: Hello.... Cashier...
    </div>
</div>
</body>
</html>
