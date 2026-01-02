<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!doctype html>
<html lang="no">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Booking</title>
    <link rel="stylesheet" href="/styles.css">
    <script defer src="/app.js"></script>
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
            <h1 style="margin-top:0;">Book tid</h1>
            <p class="muted" style="margin-top:6px;">
                Velg dato og reserver ei ledig økt (90 min).
            </p>

            <!-- NY: Dato + pilar, auto-submit (ingen "Vis tider"-knapp) -->
            <form id="dateForm" method="get" action="/booking" class="form-row" style="margin-top:14px;">
                <label style="width:100%;">
                    Dato
                    <div style="display:flex; gap:10px; align-items:center; margin-top:6px; flex-wrap:wrap;">
                        <button id="prevDayBtn" type="button" class="btn btn-secondary">←</button>

                        <input id="dateInput"
                               type="date"
                               name="date"
                               value="${date}"
                               min="${today}"
                               required
                               style="flex:1; min-width: 220px;">

                        <button id="nextDayBtn" type="button" class="btn btn-secondary">→</button>
                    </div>

                   
                </label>
            </form>

            <c:if test="${not empty error}">
                <div class="card" style="margin-top:14px; border-color: rgba(251,113,133,.35); background: rgba(251,113,133,.08);">
                    <b>Obs:</b> ${error}
                </div>
            </c:if>
        </div>

        <div class="section" style="padding-top:18px;">
            <h2 style="margin:0 0 10px;">Tider for <span class="muted">${date}</span></h2>

            <c:forEach var="slot" items="${slots}">
                <c:set var="closed" value="${slot.capacity == 0}" />

                <div class="slot ${closed ? 'closed' :''}">
                    <div class="slot-left">
                        <div class="slot-time">
                                ${slot.startTime}–${slot.endTime}
                        </div>

                        <c:choose>
                            <c:when test="${closed}">
                                <span class="badge closed">Stengt</span>
                            </c:when>

                            <c:when test="${slot.available}">
                                <span class="badge ok">
                                    Ledig • ${slot.availableSpots} av ${slot.capacity} igjen
                                </span>
                            </c:when>

                            <c:otherwise>
                                <span class="badge no">Fullt</span>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div style="flex: 1;">
                        <c:choose>
                            <c:when test="${closed}">
                                <p class="muted" style="margin:0;">Stengt</p>
                            </c:when>

                            <c:when test="${slot.available}">
                                <form method="post" action="/booking">
                                    <input type="hidden" name="date" value="${slot.date}">
                                    <input type="hidden" name="time" value="${slot.startTime}">

                                    <div class="form-row" style="margin:0;">
                                        <label>
                                            Namn
                                            <input name="name" required minlength="2" placeholder="Ditt namn">
                                        </label>

                                        <label>
                                            Telefon
                                            <input name="phone"
                                                   required
                                                   inputmode="numeric"
                                                   pattern="[0-9]{8}"
                                                   maxlength="8"
                                                   placeholder="8 siffer">
                                        </label>

                                        <label>
                                            Antall
                                            <input class="peopleCount"
                                                   name="peopleCount"
                                                   type="number"
                                                   min="1"
                                                   max="${slot.availableSpots}"
                                                   data-max="${slot.availableSpots}"
                                                   value="1"
                                                   required>
                                        </label>

                                        <button type="submit" class="btn btn-primary">Reserver</button>
                                    </div>
                                </form>
                            </c:when>

                            <c:otherwise>
                                <p class="muted" style="margin:0;">Fullt</p>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </c:forEach>

            <div class="card" style="margin-top:18px;">
                <h2 style="margin-top:0;">Praktisk info</h2>
                <ul class="list">
                    <li>Kom presis</li>
                    <li>Ta med handkle og drikke.</li>
                    <li>Hald deg til tida du har booka (90 min).</li>
                    <li>La det sjå fint ut etterpå.</li>
                </ul>
            </div>
        </div>

    </div>
</main>

<footer class="footer">
    <div class="container footer-row">
        <span class="muted">© Sauna i Vik</span>
        <a class="muted" href="/">Tilbake til forsida</a>
    </div>
</footer>

</body>
</html>