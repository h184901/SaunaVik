package no.vik.sauna.admin;

import no.vik.sauna.booking.Booking;
import no.vik.sauna.booking.BookingService;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeParseException;
import java.util.List;

@Controller
public class AdminController {

    private final BookingService service;
    private final ClosureRepository closureRepo;

    @Value("${admin.key}")
    private String adminKey;

    public AdminController(BookingService service, ClosureRepository closureRepo) {
        this.service = service;
        this.closureRepo = closureRepo;
    }

    private void requireKey(String key) {
        if (key == null || !key.equals(adminKey)) {
            // 404 så den ikkje røper at admin finst
            throw new ResponseStatusException(HttpStatus.NOT_FOUND);
        }
    }

    private String redirectAdminWithKey(String key) {
        String safeKey = URLEncoder.encode(key, StandardCharsets.UTF_8);
        return "redirect:/admin?key=" + safeKey;
    }

    /*
       Login-side (utan fast URL)
   */

    @GetMapping("/admin/login")
    public String loginPage() {
        return "admin-login"; // /WEB-INF/jsp/admin-login.jsp
    }

    @PostMapping("/admin/login")
    public String doLogin(@RequestParam String key, RedirectAttributes ra) {
        if (key == null || !key.equals(adminKey)) {
            ra.addFlashAttribute("error", "Feil nøkkel.");
            return "redirect:/admin/login";
        }
        return redirectAdminWithKey(key);
    }


    @GetMapping("/admin")
    public String admin(@RequestParam(required = false) String key, Model model) {
        requireKey(key);

        model.addAttribute("key", key);

        List<Booking> bookings = service.getAllBookings();
        model.addAttribute("bookings", bookings);

        List<Closure> closures = closureRepo.findAllByOrderByDateAscStartTimeAsc();
        model.addAttribute("closures", closures);

        return "admin";
    }

    @PostMapping("/admin/delete")
    public String delete(@RequestParam Long id,
                         @RequestParam(required = false) String key) {
        requireKey(key);
        service.deleteBooking(id);
        return redirectAdminWithKey(key);
    }

    @PostMapping("/admin/close")
    public String close(@RequestParam(required = false) String key,
                        @RequestParam String date,
                        @RequestParam(required = false) String time) {
        requireKey(key);

        LocalDate d;
        try {
            d = LocalDate.parse(date);
        } catch (DateTimeParseException e) {
            return redirectAdminWithKey(key);
        }

        // tom/blank = steng heile dagen
        if (time == null || time.isBlank()) {
            if (!closureRepo.existsByDateAndStartTimeIsNull(d)) {
                closureRepo.save(new Closure(d, null));
            }
            return redirectAdminWithKey(key);
        }

        // ellers steng enkel time
        try {
            LocalTime t = LocalTime.parse(time);
            if (!closureRepo.existsByDateAndStartTime(d, t)) {
                closureRepo.save(new Closure(d, t));
            }
        } catch (DateTimeParseException ignored) { }

        return redirectAdminWithKey(key);
    }

    @PostMapping("/admin/open")
    public String open(@RequestParam(required = false) String key,
                       @RequestParam Long id) {
        requireKey(key);
        closureRepo.deleteById(id);
        return redirectAdminWithKey(key);
    }
}