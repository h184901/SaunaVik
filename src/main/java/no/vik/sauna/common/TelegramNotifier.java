package no.vik.sauna.common;

import no.vik.sauna.booking.Booking;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

import java.time.format.DateTimeFormatter;
import java.util.Map;

@Component
public class TelegramNotifier {

    private final RestTemplate rest = new RestTemplate();

    @Value("${telegram.bot.token:}")
    private String token;

    @Value("${telegram.chat.id:}")
    private String chatId;

    private static final DateTimeFormatter TIME =
            DateTimeFormatter.ofPattern("HH:mm");

    public void notifyNewBooking(Booking b) {


        if (token == null || token.isBlank()) return;
        if (chatId == null || chatId.isBlank()) return;

        String message =
                "Ny booking\n\n" +
                        "Dato: " + b.getDate() + "\n" +
                        "Tid: " + b.getStartTime().format(TIME) + "\n" +
                        "Namn: " + b.getName() + "\n" +
                        "Tlf: " + b.getPhone() + "\n" +
                        "Antall: " + b.getPeopleCount();

        try {
            String url = "https://api.telegram.org/bot" + token + "/sendMessage";

            rest.postForObject(
                    url,
                    Map.of(
                            "chat_id", chatId,
                            "text", message
                    ),
                    String.class
            );
        } catch (Exception e) {

        }
    }
}