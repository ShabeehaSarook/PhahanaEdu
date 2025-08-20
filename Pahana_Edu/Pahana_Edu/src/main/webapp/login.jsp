<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login - Pahana Edu</title>
    <style>
        :root{
            --bg:#0b1220; --card:#111827; --border:#1f2937;
            --text:#e5e7eb; --muted:#94a3b8;
            --accent:#22c55e; --accent-2:#16a34a; --link:#93c5fd;
        }
        *{box-sizing:border-box}
        body{
            margin:0; min-height:100vh; display:grid; place-items:center;
            font-family:system-ui,-apple-system,"Segoe UI",Roboto,Helvetica,Arial;
            color:var(--text);
            background: radial-gradient(1200px 800px at 10% -10%, #1e293b 0%, #0b1220 40%, #060a13 100%);
            padding:24px;
        }
        .card{
            width:min(420px,100%);
            background:rgba(17,24,39,.92);
            border:1px solid var(--border);
            border-radius:18px;
            padding:26px 22px;
            box-shadow:0 20px 50px rgba(0,0,0,.45);
            backdrop-filter:blur(6px);
        }
        .brand{display:flex; align-items:center; gap:10px; margin-bottom:14px}
        .brand .logo{font-size:28px}
        h2{margin:0; font-size:1.4rem}
        p.sub{margin:6px 0 18px; color:var(--muted)}

        form{display:grid; gap:14px}
        label{font-size:.92rem; color:#cbd5e1}
        input[type="text"], input[type="password"]{
            width:100%; padding:12px 12px;
            border:1px solid var(--border); border-radius:12px;
            background:#0b1220; color:var(--text);
            outline:0; transition:border-color .15s, box-shadow .15s;
        }
        input:focus{
            border-color:var(--accent);
            box-shadow:0 0 0 3px rgba(34,197,94,.15);
        }

        .btn{
            appearance:none; border:0; cursor:pointer;
            padding:12px 16px; border-radius:12px; font-weight:600; color:#fff;
            background:linear-gradient(180deg, var(--accent), var(--accent-2));
            box-shadow:0 10px 20px rgba(34,197,94,.25);
            transition:transform .05s ease, box-shadow .15s ease;
        }
        .btn:hover{ transform:translateY(-1px); }

        .row{display:flex; justify-content:space-between; align-items:center; gap:12px}
        .link{color:var(--link); text-decoration:none; font-size:.92rem}

        .alert{
            margin-top:10px; padding:10px 12px; border-radius:12px;
            background:rgba(239,68,68,.12); border:1px solid rgba(239,68,68,.35);
            color:#fecaca; font-size:.95rem;
        }
    </style>
</head>
<body>
<div class="card">
    <div class="brand">
        <div class="logo">📚</div>
        <div>
            <h2>Pahana Edu</h2>
            <p class="sub">Sign in to your dashboard</p>
        </div>
    </div>

    <form action="${pageContext.request.contextPath}/login" method="post" autocomplete="off">
        <div>
            <label for="username">Username</label>
            <input id="username" name="username" type="text" required placeholder="Enter your username">
        </div>

        <div>
            <label for="password">Password</label>
            <input id="password" name="password" type="password" required placeholder="••••••••">
        </div>

        <button class="btn" type="submit">Login</button>

        <div class="row">
            <a class="link" href="${pageContext.request.contextPath}/help.jsp">Need help?</a>
        </div>
    </form>

    <% if (request.getParameter("error") != null) { %>
    <div class="alert">Invalid username or password.</div>
    <% } %>
</div>
</body>
</html>
