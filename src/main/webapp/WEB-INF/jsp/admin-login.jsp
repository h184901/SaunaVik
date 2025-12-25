<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!doctype html>
<html lang="no">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Admin</title>
    <link rel="stylesheet" href="/styles.css">
</head>
<body>

<header class="site-header">
    <div class="container header-row">
        <div class="brand">
            <div class="logo-dot"></div>
            <span>Sauna i Vik</span>
        </div>
        <nav class="nav">
            <a href="/" class="btn btn-ghost">Heim</a>
        </nav>
    </div>
</header>

<main class="section">
    <div class="container">

        <div class="card">
            <h1 style="margin-top:0;">Admin</h1>
            <p class="muted" style="margin-top:6px;">Skriv inn admin-nøkkel for å opne admin-sida.</p>

            <form method="post" action="/admin/login" class="form-row" style="margin-top:14px;">
                <label>
                    Nøkkel
                    <input type="password" name="key" required placeholder="ADMIN_KEY">
                </label>
                <button type="submit" class="btn btn-primary">Logg inn</button>
            </form>

            <c:if test="${not empty error}">
                <div class="card" style="margin-top:14px; border-color: rgba(251,113,133,.35); background: rgba(251,113,133,.08);">
                    <b>Obs:</b> ${error}
                </div>
            </c:if>
        </div>

    </div>
</main>

</body>
</html>