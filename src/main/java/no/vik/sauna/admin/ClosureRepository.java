package no.vik.sauna.admin;

import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

public interface ClosureRepository extends JpaRepository<Closure, Long> {

    boolean existsByDateAndStartTimeIsNull(LocalDate date);

    boolean existsByDateAndStartTime(LocalDate date, LocalTime startTime);

    List<Closure> findAllByOrderByDateAscStartTimeAsc();
}