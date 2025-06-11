package com.example.board.global.dto;

import java.util.Map;

import lombok.Builder;

@Builder
public record ErrorResponse(String message, Map<String, String> errors) {
}
