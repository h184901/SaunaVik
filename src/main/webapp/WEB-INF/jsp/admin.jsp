<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!doctype html>
<html lang="no">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Admin</title>
    <link rel="stylesheet" href="/styles.css">

    <!-- cache-bust -->
    <script defer src="/app.js?v=<%= System.currentTimeMillis() %>"></script>
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
            <p class="muted" style="margin:6px 0 0;">Oversikt over bookinger og stenging av tider.</p>
        </div>

        <!-- Dato-navigasjon -->
        <div class="card" style="margin-top:16px;">
            <h2>Vis dato</h2>

            <form id="adminDateForm" method="get" action="/admin"
                  style="display:flex; gap:10px; flex-wrap:wrap; align-items:end;">

                <input type="hidden" name="key" value="${key}">

                <button id="adminPrevDayBtn" type="button" class="btn btn-secondary">←</button>

                <div>
                    <label class="muted" style="font-size:12px;">Dato</label>
                    <input id="adminDateInput"
                           class="input"
                           type="date"
                           name="date"
                           value="${date}">
                </div>

                <button id="adminNextDayBtn" type="button" class="btn btn-secondary">→</button>

                <button type="submit" class="btn btn-ghost">Vis</button>
            </form>
        </div>

        <!-- STENG TID -->
        <div class="card" style="margin-top:16px;">
            <h2>Steng tid</h2>
            <p class="muted">
                Velg dato. Klokkeslett valfritt. Tomt klokkeslett = steng heile dagen.
            </p>

            <form method="post" action="/admin/close"
                  style="display:flex; gap:10px; flex-wrap:wrap; align-items:end;">

                <input type="hidden" name="key" value="${key}">

                <div>
                    <label class="muted" style="font-size:12px;">Dato</label>
                    <input class="input"
                           type="date"
                           name="date"
                           required
                           value="${date}">
                </div>

                <div>
                    <label class="muted" style="font-size:12px;">Klokkeslett (valfritt)</label>
                    <input class="input"
                           type="time"
                           name="time"
                           placeholder="08:23">
                </div>

                <button type="submit" class="btn btn-danger">Steng</button>
            </form>
        </div>

        <!-- STENGTE TIDER -->
        <div class="card" style="margin-top:16px;">
            <h2>Stengte tider</h2>

            <c:choose>
                <c:when test="${empty closures}">
                    <p class="muted">Ingen stengingar.</p>
                </c:when>
                <c:otherwise>
                    <table class="admin-table">
                        <thead>
                        <tr>
                            <th>Dato</th>
                            <th>Tid</th>
                            <th></th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="c1" items="${closures}">
                            <tr>
                                <td>${c1.date}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${empty c1.startTime}">
                                            <b>Heile dagen</b>
                                        </c:when>
                                        <c:otherwise>
                                            ${c1.startTime}
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <form method="post" action="/admin/open">
                                        <input type="hidden" name="id" value="${c1.id}">
                                        <input type="hidden" name="key" value="${key}">
                                        <button class="btn">Opne</button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- BOOKINGER -->
        <div class="card" style="margin-top:16px;">
            <h2>Bookinger for ${date}</h2>

            <c:choose>
                <c:when test="${empty bookings}">
                    <p class="muted">Ingen bookinger.</p>
                </c:when>
                <c:otherwise>
                    <table class="admin-table">
                        <thead>
                        <tr>
                            <th>Tid</th>
                            <th>Namn</th>
                            <th>Tlf</th>
                            <th>Antall</th>
                            <th></th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="b" items="${bookings}">
                            <tr>
                                <td>${b.startTime}</td>
                                <td>${b.name}</td>
                                <td>${b.phone}</td>
                                <td>${b.peopleCount}</td>
                                <td>
                                    <form method="post" action="/admin/delete">
                                        <input type="hidden" name="id" value="${b.id}">
                                        <input type="hidden" name="key" value="${key}">
                                        <input type="hidden" name="date" value="${date}">
                                        <button class="btn btn-danger">Slett</button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
        </div>

    </div>
</main>

</body>
</html>