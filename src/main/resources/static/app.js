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

function pad2(n) {
    return String(n).padStart(2, "0");
}

function toYmd(d) {
    return `${d.getFullYear()}-${pad2(d.getMonth() + 1)}-${pad2(d.getDate())}`;
}

/* =========================
   Booking: peopleCount (mobilvennlig)
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

document.addEventListener("input", (e) => {
    const el = e.target;

    if (el instanceof HTMLInputElement && el.name === "phone") {
        const digits = el.value.replace(/\D/g, "").slice(0, 8);
        if (digits !== el.value) el.value = digits;
    }
});

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
   Date navigation (booking + admin)
========================= */
function wireDateNav(opts) {
    const {
        formId,
        inputId,
        prevBtnId,
        nextBtnId,
        minToday = false,   // true for booking, false for admin (admin kan bla bakover om du vil)
        autoSubmit = true
    } = opts;

    const dateInput = document.getElementById(inputId);
    if (!(dateInput instanceof HTMLInputElement)) return;

    // Finn form robust
    let form = document.getElementById(formId);
    if (!(form instanceof HTMLFormElement)) {
        const maybeForm = dateInput.closest("form");
        if (maybeForm instanceof HTMLFormElement) form = maybeForm;
    }
    if (!(form instanceof HTMLFormElement)) return;

    const prevBtn = document.getElementById(prevBtnId);
    const nextBtn = document.getElementById(nextBtnId);

    const today = new Date();
    const todayStr = toYmd(today);

    if (minToday) {
        dateInput.min = todayStr;
        if (!dateInput.value || dateInput.value < todayStr) {
            dateInput.value = todayStr;
        }
    } else {
        // admin: om tomt, set til i dag for å ha noko å bla frå
        if (!dateInput.value) dateInput.value = todayStr;
    }

    if (autoSubmit) {
        dateInput.addEventListener("change", () => {
            if (dateInput.value) form.submit();
        });
    }

    const shiftDays = (delta) => {
        // Om tomt: start frå i dag
        const baseStr = dateInput.value || todayStr;

        const d = new Date(baseStr + "T00:00:00");
        d.setDate(d.getDate() + delta);

        const newStr = toYmd(d);

        if (minToday && newStr < todayStr) return;

        dateInput.value = newStr;
        form.submit();
    };

    if (prevBtn instanceof HTMLButtonElement) prevBtn.addEventListener("click", () => shiftDays(-1));
    if (nextBtn instanceof HTMLButtonElement) nextBtn.addEventListener("click", () => shiftDays(1));
}

document.addEventListener("DOMContentLoaded", () => {
    // Booking
    wireDateNav({
        formId: "dateForm",
        inputId: "dateInput",
        prevBtnId: "prevDayBtn",
        nextBtnId: "nextDayBtn",
        minToday: true,
        autoSubmit: true
    });

    // Admin
    wireDateNav({
        formId: "adminDateForm",
        inputId: "adminDateInput",
        prevBtnId: "adminPrevDayBtn",
        nextBtnId: "adminNextDayBtn",
        minToday: false,
        autoSubmit: true
    });
});