package no.vik.sauna.common;

import java.time.LocalDate;
import java.time.LocalTime;

public class TimeSlot {
    private final LocalDate date;
    private final LocalTime startTime;
    private final int capacity;
    private final int booked;
    private final int availableSpots;

    public TimeSlot(LocalDate date, LocalTime startTime, int capacity, int booked) {
        this.date = date;
        this.startTime = startTime;
        this.capacity = capacity;
        this.booked = booked;
        this.availableSpots = Math.max(0, capacity - booked);
    }

    public LocalDate getDate() { return date; }
    public LocalTime getStartTime() { return startTime; }
    public int getCapacity() { return capacity; }
    public int getBooked() { return booked; }
    public int getAvailableSpots() { return availableSpots; }

    public boolean isAvailable() { return availableSpots > 0; }
}