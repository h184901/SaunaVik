package no.vik.sauna.booking;

import no.vik.sauna.common.TimeSlot;
import no.vik.sauna.common.ValidationException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeParseException;
import java.util.List;

@Controller
public class BookingController {

    private final BookingService service;

    public BookingController(BookingService service) {
        this.service = service;
    }

    @GetMapping("/")
    public String index() {
        return "index";
    }

    @GetMapping("/booking")
    public String booking(@RequestParam(required = false) String date, Model model) {
        LocalDate d = parseDateOrToday(date);
        List<TimeSlot> slots = service.getSlotsFor(d);

        model.addAttribute("date", d.toString());
        model.addAttribute("slots", slots);

        return "booking";
    }

    @PostMapping("/booking")
    public String createBooking(
            @RequestParam String date,
            @RequestParam String time,
            @RequestParam String name,
            @RequestParam String phone,
            @RequestParam int peopleCount,
            Model model
    ) {
        try {
            LocalDate d = LocalDate.parse(date);
            LocalTime t = LocalTime.parse(time);

            service.createBooking(d, t, name, phone, peopleCount);

            return "redirect:/booking?date=" + d; // tilbake til samme dato

        } catch (ValidationException ve) {
            // Vis feilmelding på siden
            LocalDate d = parseDateOrToday(date);
            model.addAttribute("date", d.toString());
            model.addAttribute("slots", service.getSlotsFor(d));
            model.addAttribute("error", ve.getMessage());
            return "booking";
        } catch (Exception e) {
            LocalDate d = parseDateOrToday(date);
            model.addAttribute("date", d.toString());
            model.addAttribute("slots", service.getSlotsFor(d));
            model.addAttribute("error", "Noe gikk galt. Prøv igjen.");
            return "booking";
        }
    }

    private LocalDate parseDateOrToday(String date) {
        if (date == null || date.isBlank()) return LocalDate.now();
        try {
            return LocalDate.parse(date);
        } catch (DateTimeParseException e) {
            return LocalDate.now();
        }
    }
}
