<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Add New Customer</title>
  <style>
    :root{
      --bg:#0b1220; --card:#111827; --border:#1f2937;
      --text:#e5e7eb; --muted:#94a3b8;
      --accent:#22c55e; --accent-hover:#16a34a;
    }
    *{box-sizing:border-box}
    body{
      margin:0; min-height:100vh; padding:24px;
      font-family:system-ui,-apple-system,"Segoe UI",Roboto,Helvetica,Arial;
      color:var(--text);
      display:flex; align-items:center; justify-content:center;
      background: radial-gradient(1200px 800px at 10% 0%, #1e293b 0%, #0b1220 40%, #060a13 100%);
    }
    .card{
      width:min(780px,100%);
      background:rgba(17,24,39,.9);
      border:1px solid var(--border);
      border-radius:18px;
      padding:24px;
      box-shadow:0 20px 50px rgba(0,0,0,.4);
      backdrop-filter:blur(6px);
    }
    h2{margin:0 0 8px; font-size:1.5rem}
    .subtitle{color:var(--muted); margin-bottom:20px}

    form{
      display:grid; grid-template-columns:1fr 1fr; gap:16px 20px;
    }
    @media (max-width:720px){ form{ grid-template-columns:1fr; } }

    .field{display:flex; flex-direction:column; gap:8px}
    label{font-size:.9rem; color:#cbd5e1}

    input[type="text"], input[type="number"], textarea{
      width:100%; padding:12px;
      border:1px solid var(--border);
      border-radius:12px; background:#0b1220; color:var(--text);
      outline:none; transition:border-color .15s, box-shadow .15s;
    }
    textarea{min-height:96px; resize:vertical}
    input:focus, textarea:focus{
      border-color:var(--accent);
      box-shadow:0 0 0 3px rgba(34,197,94,.15);
    }

    .actions{
      grid-column:1 / -1; display:flex; gap:12px; justify-content:flex-end; margin-top:8px;
    }
    .btn{
      appearance:none; border:0; cursor:pointer;
      padding:12px 16px; border-radius:12px; font-weight:600;
      transition:transform .04s, box-shadow .15s, background .15s;
    }
    .btn-primary{
      background:linear-gradient(180deg, var(--accent), var(--accent-hover)); color:#fff;
      box-shadow:0 10px 20px rgba(34,197,94,.25);
    }
    .btn-primary:hover{ transform:translateY(-1px); }
    .btn-secondary{ background:transparent; color:#e5e7eb; border:1px solid var(--border); }

    .footer{margin-top:14px}
    .footer a{color:#93c5fd; text-decoration:none}
  </style>
</head>
<body>
<div class="card">
  <h2>➕ Add New Customer</h2>
  <div class="subtitle">Enter customer details to create the account.</div>

  <form action="${pageContext.request.contextPath}/CustomerServlet" method="post" autocomplete="off">
    <div class="field">
      <label for="accountNumber">Account Number</label>
      <input id="accountNumber" name="accountNumber" type="text" required />
    </div>

    <div class="field">
      <label for="name">Name</label>
      <input id="name" name="name" type="text" required />
    </div>

    <div class="field" style="grid-column:1 / -1">
      <label for="address">Address</label>
      <textarea id="address" name="address" required></textarea>
    </div>

    <div class="field">
      <label for="telephone">Telephone</label>
      <input id="telephone" name="telephone" type="text"
             pattern="[0-9+ -]{7,15}" placeholder="e.g., 0771234567" required />
    </div>

    <div class="field">
      <label for="unitsConsumed">Units Consumed</label>
      <input id="unitsConsumed" name="unitsConsumed" type="number" min="0" step="1" required />
    </div>

    <div class="actions">
      <a class="btn btn-secondary" href="${pageContext.request.contextPath}/dashboard.jsp">Cancel</a>
      <button class="btn btn-primary" type="submit">Save Customer</button>
    </div>
  </form>

  <div class="footer">
    <a href="${pageContext.request.contextPath}/view_customers.jsp">View all customers</a>
  </div>
</div>
</body>
</html>
