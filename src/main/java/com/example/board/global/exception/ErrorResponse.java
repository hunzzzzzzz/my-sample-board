package com.example.board.global.exception;

import java.time.LocalDateTime;

import org.springframework.http.HttpStatus;

import lombok.Builder;

@Builder
public record ErrorResponse(HttpStatus status, String message, LocalDateTime time) {

}
