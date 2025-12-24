package no.vik.sauna.admin;

import no.vik.sauna.booking.Booking;
import no.vik.sauna.booking.BookingService;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;

@Controller
public class AdminController {

    private final BookingService service;

    @Value("${admin.key}")
    private String adminKey;

    public AdminController(BookingService service) {
        this.service = service;
    }

    private void requireKey(String key) {
        if (key == null || !key.equals(adminKey)) {
            // 404 så den ikkje røper at admin finst
            throw new ResponseStatusException(HttpStatus.NOT_FOUND);
        }
    }

    @GetMapping("/admin")
    public String admin(@RequestParam(required = false) String key, Model model) {
        requireKey(key);

        model.addAttribute("key", key);

        List<Booking> bookings = service.getAllBookings();
        model.addAttribute("bookings", bookings);

        return "admin";
    }

    @PostMapping("/admin/delete")
    public String delete(@RequestParam Long id,
                         @RequestParam(required = false) String key) {

        requireKey(key);

        service.deleteBooking(id);

        // redirect tilbake MED key
        String safeKey = URLEncoder.encode(key, StandardCharsets.UTF_8);
        return "redirect:/admin?key=" + safeKey;
    }
}