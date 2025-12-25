package no.vik.sauna.admin;

import jakarta.persistence.*;

import java.time.LocalDate;
import java.time.LocalTime;

@Entity
@Table(name = "closure",
        uniqueConstraints = @UniqueConstraint(columnNames = {"date", "startTime"}))
public class Closure {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private LocalDate date;

    /**
     * null = heile dagen er stengt
     * ikkje-null = berre denne timen er stengt
     */
    private LocalTime startTime;

    public Closure() {}

    public Closure(LocalDate date, LocalTime startTime) {
        this.date = date;
        this.startTime = startTime;
    }

    public Long getId() {
        return id;
    }

    public LocalDate getDate() {
        return date;
    }

    public LocalTime getStartTime() {
        return startTime;
    }
}