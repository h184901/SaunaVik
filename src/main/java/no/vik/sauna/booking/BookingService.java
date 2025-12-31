package no.vik.sauna.booking;

import no.vik.sauna.admin.ClosureRepository;
import no.vik.sauna.common.TimeSlot;
import no.vik.sauna.common.ValidationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalTime;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.List;

@Service
public class BookingService {

    private final BookingRepository repo;
    private final ClosureRepository closures;

    private static final ZoneId OSLO = ZoneId.of("Europe/Oslo");

    // Åpningstider
    private static final LocalTime OPEN = LocalTime.of(7, 0);
    private static final LocalTime CLOSE = LocalTime.of(22, 0);

    // 90 min per økt
    private static final int DURATION_MINUTES = 90;

    private static final int CAPACITY = 4;

    public BookingService(BookingRepository repo, ClosureRepository closures) {
        this.repo = repo;
        this.closures = closures;
    }

    private LocalDate today() {
        return LocalDate.now(OSLO);
    }

    public List<LocalTime> getAllowedStartTimes() {
        List<LocalTime> times = new ArrayList<>();
        LocalTime t = OPEN;
        LocalTime lastStart = CLOSE.minusMinutes(DURATION_MINUTES);

        while (!t.isAfter(lastStart)) {
            times.add(t);
            t = t.plusMinutes(DURATION_MINUTES);
        }
        return times;
    }

    /**
     * Snapper vilkårleg klokkeslett (08:23) ned til nærmaste gyldige starttid.
     * (Største starttid <= input)
     */
    public LocalTime normalizeStartTime(LocalTime input) {
        if (input == null) return null;

        List<LocalTime> allowed = getAllowedStartTimes();
        if (allowed.isEmpty()) return input;

        LocalTime first = allowed.get(0);
        LocalTime last = allowed.get(allowed.size() - 1);

        if (input.isBefore(first)) return first;
        if (input.isAfter(last)) return last;

        LocalTime candidate = first;
        for (LocalTime t : allowed) {
            if (!t.isAfter(input)) candidate = t;
            else break;
        }
        return candidate;
    }

    public List<TimeSlot> getSlotsFor(LocalDate date) {
        if (date == null) date = today();

        boolean wholeDayClosed = closures.existsByDateAndStartTimeIsNull(date);

        List<TimeSlot> slots = new ArrayList<>();
        for (LocalTime t : getAllowedStartTimes()) {

            boolean slotClosed = wholeDayClosed || closures.existsByDateAndStartTime(date, t);

            if (slotClosed) {
                slots.add(new TimeSlot(date, t, DURATION_MINUTES, 0, 0));
                continue;
            }

            int booked = repo.sumPeopleCountByDateAndStartTime(date, t);
            slots.add(new TimeSlot(date, t, DURATION_MINUTES, CAPACITY, booked));
        }

        return slots;
    }

    @Transactional
    public Booking createBooking(LocalDate date, LocalTime startTime, String name, String phone, int peopleCount) {
        validateBookingInput(date, startTime, name, phone, peopleCount);

        int booked = repo.sumPeopleCountByDateAndStartTime(date, startTime);
        int available = CAPACITY - booked;

        if (available <= 0) throw new ValidationException("Denne økta er fullbooka.");
        if (peopleCount > available) throw new ValidationException("Det er berre " + available + " plass(ar) igjen på denne økta.");

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
        if (name == null || name.trim().length() < 2) throw new ValidationException("Navn må vera minst 2 teikn.");
        if (phone == null || !phone.matches("\\d{8}")) throw new ValidationException("Telefonnummer må vera 8 siffer.");

        if (peopleCount < 1 || peopleCount > CAPACITY) {
            throw new ValidationException("Antall må vera mellom 1 og " + CAPACITY + ".");
        }

        if (date.isBefore(today())) {
            throw new ValidationException("Du kan ikkje booke dato i fortid.");
        }

        List<LocalTime> allowed = getAllowedStartTimes();
        if (startTime == null || !allowed.contains(startTime)) {
            throw new ValidationException("Ugyldig tidspunkt.");
        }

        if (closures.existsByDateAndStartTimeIsNull(date) || closures.existsByDateAndStartTime(date, startTime)) {
            throw new ValidationException("Denne tida er stengt.");
        }
    }
}