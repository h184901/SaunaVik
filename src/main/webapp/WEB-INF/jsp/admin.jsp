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
            <a class="btn btn-ghost" href="/">Tilbake</a>
        </nav>
    </div>
</header>

<main class="section">
    <div class="container">

        <div class="card">
            <h1 style="margin-top:0;">Admin</h1>
            <p class="muted" style="margin:6px 0 0;">Oversikt over alle bookinger.</p>
        </div>

        <c:choose>
            <c:when test="${empty bookings}">
                <div class="card" style="margin-top:16px;">
                    Ingen bookinger enda.
                </div>
            </c:when>

            <c:otherwise>
                <div class="card" style="margin-top:16px;">
                    <div style="display:flex; align-items:center; justify-content:space-between; gap:12px; margin-bottom:12px;">
                        <div><b>Bookinger</b> <span class="muted">• ${bookings.size()} stk</span></div>
                    </div>

                    <div class="admin-table-wrap">
                        <table class="admin-table">
                            <thead>
                            <tr>
                                <th>Dato</th>
                                <th>Tid</th>
                                <th>Namn</th>
                                <th>Tlf</th>
                                <th>Antall</th>
                                <th>Handling</th>
                            </tr>
                            </thead>

                            <tbody>
                            <c:forEach var="b" items="${bookings}">
                                <tr>
                                    <td>${b.date}</td>
                                    <td><b>${b.startTime}</b></td>
                                    <td>${b.name}</td>
                                    <td>${b.phone}</td>
                                    <td>${b.peopleCount}</td>
                                    <td>
                                        <form method="post" action="/admin/delete" style="margin:0;">
                                            <input type="hidden" name="id" value="${b.id}">
                                            <input type="hidden" name="key" value="${key}">
                                            <button type="submit" class="btn btn-danger">Slett</button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>

                </div>
            </c:otherwise>
        </c:choose>

    </div>
</main>

</body>
</html>