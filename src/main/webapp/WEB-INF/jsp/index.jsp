<%@ page contentType="text/html; charset=UTF-8" %>
<!doctype html>
<html lang="no">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Sauna i Vik</title>
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

        <nav class="nav nav-right">
            <a href="/booking" class="btn btn-primary">Book tid</a>

            <!-- Diskret admin-knapp -->
            <a href="/admin/login" class="icon-btn" title="Admin" aria-label="Admin">⚙︎</a>
        </nav>
    </div>
</header>

<main>

    <!-- HERO -->
    <section class="hero hero--clean" style="--hero-img: url('/img/Vik.jpg')">
        <div class="container hero-inner hero-inner--clean">
            <div class="hero-content">
                <p class="hero-kicker">Badstova ved fjorden</p>
                <h1 class="hero-title">Ekta utsikt. Enkelt å booke.</h1>
                <p class="hero-sub">
                    Open kvar dag 07:00–22:00 · Velg tid og tal plassar.
                </p>

                <div class="hero-actions hero-actions--clean">
                    <a class="btn btn-primary" href="/booking">Book tid</a>
                    <a class="btn btn-secondary" href="#info">Praktisk</a>
                </div>

                <div class="hero-note">
                    <span class="hero-note-dot"></span>
                    <span>Ta med handkle · Kom presis · Rydd etter deg</span>
                </div>
            </div>
        </div>
        <div class="hero-overlay hero-overlay--clean"></div>
    </section>

    <section id="info" class="section section-anchor">
        <div class="container grid-2">
            <div class="card">
                <h2>Praktisk</h2>
                <ul class="list">
                    <li>Ta med handkle og drikke.</li>
                    <li>Respekter tidene – kom presis.</li>
                    <li>Rydd etter deg før du går.</li>
                </ul>
            </div>

            <div class="card">
                <h2>Booking</h2>
                <p>Velg tid og tal plassar. Du får bekreftelse med ein gong.</p>
                <a class="btn btn-primary" href="/booking">Gå til booking</a>
            </div>
        </div>
    </section>

    <section class="section">
        <div class="container">
            <h2>Bilder</h2>
            <div class="gallery">
                <img src="/img/Innside.JPG" alt="Inne i sauna" class="gallery-img">
                <img src="/img/UtsideFin.JPG" alt="Sauna ute" class="gallery-img">
                <img src="/img/utside2.jpg" alt="Sauna ved fjorden" class="gallery-img">
            </div>
            <p class="muted">Trykk for fullskjerm.</p>
        </div>
    </section>

</main>

<footer class="footer footer-pro">
    <div class="container footer-grid">
        <div>
            <div class="footer-title">Sauna i Vik</div>
            <div class="muted">Badstova ved fjorden.</div>
        </div>

        <div>
            <div class="footer-title">Kontakt</div>
            <div class="muted">Telefon: <span class="muted">—</span></div>
            <div class="muted">E-post: <span class="muted">—</span></div>
        </div>

        <div>
            <div class="footer-title">Lenker</div>
            <a class="footer-link" href="/booking">Booking</a>
            <a class="footer-link" href="#info">Praktisk</a>
            <a class="footer-link footer-link-admin" href="/admin/login">Admin</a>
        </div>
    </div>

    <div class="container footer-bottom">
        <span class="muted">© Sauna i Vik</span>
        <span class="muted">Laga av Erlend Moheim</span>
    </div>
</footer>

<!-- modal -->
<div id="imgModal" class="modal" aria-hidden="true">
    <div class="modal-backdrop" data-close="true"></div>
    <div class="modal-content" role="dialog" aria-modal="true">
        <button class="modal-close" data-close="true" aria-label="Lukk">×</button>
        <img id="modalImg" alt="">
    </div>
</div>

</body>
</html>