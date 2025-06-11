package com.example.board.global.dto;

import java.util.HashMap;
import java.util.Map;

import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;

import lombok.Builder;

@Builder
public record ErrorResponse(String message, Map<String, String> errors) {
	public static ErrorResponse of(String message, BindingResult bindingResult) {
		Map<String, String> errors = new HashMap<>();

		for (FieldError error : bindingResult.getFieldErrors())
			errors.put(error.getField(), error.getDefaultMessage());

		return ErrorResponse.builder().message(message).errors(errors).build();
	}

	public static ErrorResponse of(String message) {
		return ErrorResponse.builder().message(message).errors(Map.of()).build();
	}
}
