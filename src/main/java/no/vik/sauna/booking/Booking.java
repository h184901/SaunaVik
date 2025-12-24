package no.vik.sauna.booking;

import jakarta.persistence.*;
import java.time.Instant;
import java.time.LocalDate;
import java.time.LocalTime;

@Entity
@Table(
        name = "booking"
)
public class Booking {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private LocalDate date;

    @Column(name = "start_time", nullable = false)
    private LocalTime startTime;

    @Column(nullable = false, length = 80)
    private String name;

    @Column(nullable = false, length = 20)
    private String phone;

    @Column(nullable = false)
    private int peopleCount;

    @Column(nullable = false)
    private Instant createdAt = Instant.now();

    protected Booking() {}

    public Booking(LocalDate date, LocalTime startTime, String name, String phone, int peopleCount) {
        this.date = date;
        this.startTime = startTime;
        this.name = name;
        this.phone = phone;
        this.peopleCount = peopleCount;
    }

    public Long getId() { return id; }
    public LocalDate getDate() { return date; }
    public LocalTime getStartTime() { return startTime; }
    public String getName() { return name; }
    public String getPhone() { return phone; }
    public int getPeopleCount() { return peopleCount; }
    public Instant getCreatedAt() { return createdAt; }
}