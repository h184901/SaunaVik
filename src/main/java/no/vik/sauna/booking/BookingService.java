package no.vik.sauna.booking;

import no.vik.sauna.common.TimeSlot;
import no.vik.sauna.common.ValidationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

@Service
public class BookingService {

    private final BookingRepository repo;

    // Åpningstider
    private static final LocalTime OPEN = LocalTime.of(7, 0);
    private static final LocalTime CLOSE = LocalTime.of(22, 0);

    // Varighet per booking (1 time)
    private static final int DURATION_MINUTES = 60;

    // Kapasitet per time-slot
    private static final int CAPACITY = 5;

    public BookingService(BookingRepository repo) {
        this.repo = repo;
    }

    /**
     * Genererer alle starttider som er lov (hele timer) mellom 07:00 og 21:00.
     * (21:00 er siste start fordi booking varer 1 time og CLOSE er 22:00)
     */
    public List<LocalTime> getAllowedStartTimes() {
        List<LocalTime> times = new ArrayList<>();
        LocalTime t = OPEN;
        LocalTime lastStart = CLOSE.minusMinutes(DURATION_MINUTES);

        while (!t.isAfter(lastStart)) {
            times.add(t);
            t = t.plusHours(1); // hele timer
        }
        return times;
    }

    /**
     * Returnerer slots med kapasitet/bestilt/ledige for en dato.
     * Krever repo-metode: sumPeopleCountByDateAndStartTime(date, startTime)
     */
    public List<TimeSlot> getSlotsFor(LocalDate date) {
        if (date == null) date = LocalDate.now();

        List<TimeSlot> slots = new ArrayList<>();
        for (LocalTime t : getAllowedStartTimes()) {
            int booked = repo.sumPeopleCountByDateAndStartTime(date, t);
            slots.add(new TimeSlot(date, t, CAPACITY, booked));
        }
        return slots;
    }

    @Transactional
    public Booking createBooking(LocalDate date, LocalTime startTime, String name, String phone, int peopleCount) {
        validateBookingInput(date, startTime, name, phone, peopleCount);

        int booked = repo.sumPeopleCountByDateAndStartTime(date, startTime);
        int available = CAPACITY - booked;

        if (available <= 0) {
            throw new ValidationException("Denne timen er fullbooket.");
        }
        if (peopleCount > available) {
            throw new ValidationException("Det er kun " + available + " plass(ar) igjen på denne timen.");
        }

        Booking booking = new Booking(date, startTime, name.trim(), phone.trim(), peopleCount);
        return repo.save(booking);
    }

    public List<Booking> getAllBookings() {
        return repo.findAllByOrderByDateAscStartTimeAsc();
    }

    public void deleteBooking(Long id) {
        if (id == null) return;
        repo.deleteById(id);
    }

    public int getCapacity() {
        return CAPACITY;
    }

    private void validateBookingInput(LocalDate date, LocalTime startTime, String name, String phone, int peopleCount) {
        if (date == null) throw new ValidationException("Dato manglar.");
        if (name == null || name.trim().length() < 2) throw new ValidationException("Navn må være minst 2 tegn.");
        if (phone == null || !phone.matches("\\d{8}")) throw new ValidationException("Telefonnummer må vera 8 siffer.");

        if (peopleCount < 1 || peopleCount > CAPACITY) {
            throw new ValidationException("Antall må vera mellom 1 og " + CAPACITY + ".");
        }

        // Ikke i fortid
        if (date.isBefore(LocalDate.now())) {
            throw new ValidationException("Du kan ikkje booke dato i fortid.");
        }

        // Må være en lovlig starttid (hele timer mellom OPEN og lastStart)
        List<LocalTime> allowed = getAllowedStartTimes();
        if (startTime == null || !allowed.contains(startTime)) {
            throw new ValidationException("Ugyldig tidspunkt. Velg ein heil time mellom 07:00 og 21:00.");
        }
    }
}