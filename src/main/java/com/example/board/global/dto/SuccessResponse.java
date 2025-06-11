package com.example.board.global.dto;

import lombok.Builder;

@Builder
public record SuccessResponse(String message, Object value) {
	public static SuccessResponse of(String message, Object value) {
		return SuccessResponse.builder().message(message).value(value).build();
	}
}
