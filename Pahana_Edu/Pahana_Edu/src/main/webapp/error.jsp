<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  // Accept message via request attribute "error" or query param ?error=...
  String message = (String) request.getAttribute("error");
  if (message == null || message.isEmpty()) message = request.getParameter("error");
  if (message == null || message.isEmpty()) message = "Something went wrong.";
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Error — Pahana Edu</title>
  <style>
    :root{--bg:#0b1220;--card:#111827;--border:#1f2937;--text:#e5e7eb;--muted:#94a3b8}
    *{box-sizing:border-box}
    body{margin:0;min-height:100vh;display:flex;align-items:center;justify-content:center;background:#0b1220;font-family:system-ui,-apple-system,"Segoe UI";color:var(--text);padding:24px}
    .card{width:min(680px,100%);background:#111827;border:1px solid #1f2937;border-radius:18px;padding:22px;box-shadow:0 20px 50px rgba(0,0,0,.4)}
    h1{margin:0 0 8px}
    p{margin:0 0 12px;color:#fecaca}
    .muted{color:var(--muted)}
    .btn{display:inline-block;margin-top:10px;padding:10px 14px;border-radius:12px;border:1px solid var(--border);background:#0b1220;color:#fff;text-decoration:none}
  </style>
</head>
<body>
<div class="card">
  <h1>⚠️ Error</h1>
  <p><%= message %></p>
  <p class="muted">If this keeps happening, contact your administrator or check the server logs.</p>
  <div style="display:flex;gap:10px;margin-top:8px">
    <a class="btn" href="javascript:history.back()">⬅ Go Back</a>
    <a class="btn" href="${pageContext.request.contextPath}/dashboard.jsp">🏠 Dashboard</a>
  </div>
</div>
</body>
</html>
