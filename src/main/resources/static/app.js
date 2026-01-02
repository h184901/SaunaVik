console.log("app.js lastet på", window.location.pathname);

/* =========================
   Helpers
========================= */
function toIntOrNull(s) {
    const v = parseInt(s, 10);
    return Number.isNaN(v) ? null : v;
}

function clamp(value, min, max) {
    if (value < min) return min;
    if (value > max) return max;
    return value;
}

/* ISO date helpers (unngå timezone-krøll) */
function parseISODate(iso) {
    // iso: "yyyy-MM-dd"
    const [y, m, d] = iso.split("-").map(Number);
    return new Date(y, m - 1, d); // lokal midnatt
}

function formatISODate(dt) {
    const pad = (n) => String(n).padStart(2, "0");
    return `${dt.getFullYear()}-${pad(dt.getMonth() + 1)}-${pad(dt.getDate())}`;
}

function addDaysISO(iso, delta) {
    const dt = parseISODate(iso);
    dt.setDate(dt.getDate() + delta);
    return formatISODate(dt);
}

function clampToMinISO(inputEl, iso) {
    const min = inputEl.min; // "yyyy-MM-dd" eller tom
    if (!min) return iso;
    return (iso < min) ? min : iso;
}

/* =========================
   Booking: peopleCount (mobilvennlig)
   - Tillat fri typing
   - Clamp på blur + submit
========================= */
function getMinMax(input) {
    const min = parseInt(input.min || "1", 10);
    const max = parseInt(input.dataset.max || input.max || "1", 10);
    return { min, max };
}

function clampPeopleCountOnBlurOrSubmit(input) {
    const { min, max } = getMinMax(input);

    const v = toIntOrNull(input.value);
    const fixed = v === null ? min : clamp(v, min, max);

    input.value = String(fixed);
}

// INPUT: ikkje clamp aggressivt
document.addEventListener("input", (e) => {
    const el = e.target;

    // phone: bare siffer, maks 8
    if (el instanceof HTMLInputElement && el.name === "phone") {
        const digits = el.value.replace(/\D/g, "").slice(0, 8);
        if (digits !== el.value) el.value = digits;
    }
});

// BLUR: clamp når du går ut
document.addEventListener(
    "blur",
    (e) => {
        const el = e.target;

        if (el instanceof HTMLInputElement && el.classList.contains("peopleCount")) {
            clampPeopleCountOnBlurOrSubmit(el);
        }

        if (el instanceof HTMLInputElement && el.name === "phone") {
            el.value = el.value.replace(/\D/g, "").slice(0, 8);
        }
    },
    true
);

// SUBMIT: clamp før request
document.addEventListener("submit", (e) => {
    const form = e.target;
    if (!(form instanceof HTMLFormElement)) return;

    const pc = form.querySelector("input.peopleCount");
    if (pc instanceof HTMLInputElement) {
        clampPeopleCountOnBlurOrSubmit(pc);
    }

    const phone = form.querySelector("input[name='phone']");
    if (phone instanceof HTMLInputElement) {
        phone.value = phone.value.replace(/\D/g, "").slice(0, 8);
    }
});

/* =========================
   Gallery modal (index)
========================= */
(function setupGalleryModal() {
    const modal = document.getElementById("imgModal");
    const modalImg = document.getElementById("modalImg");
    if (!modal || !modalImg) return;

    function openModal(src, alt) {
        modalImg.src = src;
        modalImg.alt = alt || "";
        modal.setAttribute("aria-hidden", "false");
        document.body.style.overflow = "hidden";
    }

    function closeModal() {
        modal.setAttribute("aria-hidden", "true");
        modalImg.src = "";
        modalImg.alt = "";
        document.body.style.overflow = "";
    }

    document.querySelectorAll(".gallery-img").forEach((img) => {
        img.addEventListener("click", () => openModal(img.src, img.alt));
    });

    modal.addEventListener("click", (e) => {
        const t = e.target;
        if (t instanceof HTMLElement && t.dataset.close === "true") closeModal();
    });

    document.addEventListener("keydown", (e) => {
        if (e.key === "Escape" && modal.getAttribute("aria-hidden") === "false") {
            closeModal();
        }
    });
})();

/* =========================
   Date navigation
   - Booking: auto-submit
   - Admin (steng tid): ikkje auto-submit
========================= */
document.addEventListener("DOMContentLoaded", () => {
    // BOOKING
    const bookingForm = document.getElementById("dateForm");
    const bookingDateInput = document.getElementById("dateInput");
    const bookingPrevBtn = document.getElementById("prevDayBtn");
    const bookingNextBtn = document.getElementById("nextDayBtn");

    if (bookingForm && bookingDateInput) {
        // Auto-submit når dato velges manuelt
        bookingDateInput.addEventListener("change", () => {
            if (bookingDateInput.value) bookingForm.submit();
        });

        const shiftBooking = (delta) => {
            if (!bookingDateInput.value) return;

            let newVal = addDaysISO(bookingDateInput.value, delta);
            newVal = clampToMinISO(bookingDateInput, newVal);

            bookingDateInput.value = newVal;
            bookingForm.submit();
        };

        if (bookingPrevBtn) bookingPrevBtn.addEventListener("click", () => shiftBooking(-1));
        if (bookingNextBtn) bookingNextBtn.addEventListener("click", () => shiftBooking(1));
    }

    // ADMIN (steng tid) — berre endre dato, ikkje submit
    const adminDateInput = document.getElementById("adminDateInput");
    const adminPrevBtn = document.getElementById("adminPrevDayBtn");
    const adminNextBtn = document.getElementById("adminNextDayBtn");

    if (adminDateInput) {
        const shiftAdmin = (delta) => {
            if (!adminDateInput.value) return;

            const newVal = addDaysISO(adminDateInput.value, delta);
            adminDateInput.value = newVal;
        };

        if (adminPrevBtn) adminPrevBtn.addEventListener("click", () => shiftAdmin(-1));
        if (adminNextBtn) adminNextBtn.addEventListener("click", () => shiftAdmin(1));
    }
});