package com.example.board.global.dto;

import lombok.Builder;

@Builder
public record SuccessResponse(String message, Object value) {

}
