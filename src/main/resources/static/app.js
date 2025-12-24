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

    // Tillat tomt felt mens man redigerer, men på blur/submit må det bli gyldig
    const v = toIntOrNull(input.value);
    const fixed = v === null ? min : clamp(v, min, max);

    input.value = String(fixed);
}

// INPUT: ikke clamp aggressivt (så du kan skrive "3" uten at den blir til max)
document.addEventListener("input", (e) => {
    const el = e.target;

    // phone: bare siffer, maks 8 (mens du skriver er det ok)
    if (el instanceof HTMLInputElement && el.name === "phone") {
        const digits = el.value.replace(/\D/g, "").slice(0, 8);
        if (digits !== el.value) el.value = digits;
    }

    // peopleCount: la brukeren skrive, men hvis de skriver noe helt vilt (f.eks. 999)
    // kan vi eventuelt *mykt* begrense ved å stoppe på max-lengde.
    // (vi gjør ingen clamp her)
});

// BLUR: clamp når du går ut av feltet
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

// SUBMIT: clamp før browser-validering og før request går til server
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