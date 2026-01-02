package no.vik.sauna.booking;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

public interface BookingRepository extends JpaRepository<Booking, Long> {

    @Query("""
        select coalesce(sum(b.peopleCount), 0)
        from Booking b
        where b.date = :date and b.startTime = :startTime
    """)
    int sumPeopleCountByDateAndStartTime(@Param("date") LocalDate date,
                                         @Param("startTime") LocalTime startTime);

    // Brukt i admin-filter (ein dag om gongen)
    List<Booking> findAllByDateOrderByStartTimeAsc(LocalDate date);
    List<Booking> findAllByOrderByDateAscStartTimeAsc();
}