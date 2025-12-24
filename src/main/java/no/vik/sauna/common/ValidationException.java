package no.vik.sauna.common;

public class ValidationException extends RuntimeException {
    public ValidationException(String message) {
        super(message);
    }
}