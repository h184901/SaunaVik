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
            <p class="muted" style="margin:6px 0 0;">Oversikt over alle bookinger + stenging av tider.</p>
        </div>

        <!-- NYTT: steng tider -->
        <div class="card" style="margin-top:16px;">
            <h2 style="margin-top:0;">Steng tid</h2>
            <p class="muted" style="margin:6px 0 12px;">
                Velg dato og eventuelt klokkeslett. Tomt klokkeslett = steng heile dagen.
            </p>

            <form method="post" action="/admin/close" style="display:flex; gap:10px; flex-wrap:wrap; align-items:end;">
                <input type="hidden" name="key" value="${key}">

                <div>
                    <label class="muted" style="display:block; font-size:12px; margin-bottom:6px;">Dato</label>
                    <input class="input" type="date" name="date" required>
                </div>

                <div>
                    <label class="muted" style="display:block; font-size:12px; margin-bottom:6px;">Klokkeslett (valfritt)</label>
                    <input class="input" type="time" name="time" step="3600" placeholder="07:00">
                </div>

                <button type="submit" class="btn btn-danger">Steng</button>
            </form>
        </div>

        <!-- NYTT: liste over stengingar -->
        <div class="card" style="margin-top:16px;">
            <div style="display:flex; align-items:center; justify-content:space-between; gap:12px; margin-bottom:12px;">
                <div><b>Stengte tider</b>
                    <span class="muted">• <c:out value="${closures.size()}"/> stk</span>
                </div>
            </div>

            <c:choose>
                <c:when test="${empty closures}">
                    <div class="muted">Ingen stengingar.</div>
                </c:when>
                <c:otherwise>
                    <div class="admin-table-wrap">
                        <table class="admin-table">
                            <thead>
                            <tr>
                                <th>Dato</th>
                                <th>Tid</th>
                                <th>Handling</th>
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
                                                <b>${c1.startTime}</b>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <form method="post" action="/admin/open" style="margin:0;">
                                            <input type="hidden" name="id" value="${c1.id}">
                                            <input type="hidden" name="key" value="${key}">
                                            <button type="submit" class="btn">Opne</button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Bookinger -->
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