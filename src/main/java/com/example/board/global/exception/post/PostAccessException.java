package com.example.board.global.exception.post;

import org.springframework.http.HttpStatus;

public class PostAccessException extends RuntimeException {
	private static final long serialVersionUID = 1L;
	public final int statusCode;
	public final String message;

	public PostAccessException(String message) {
		super(message);
		this.statusCode = HttpStatus.FORBIDDEN.value();
		this.message = message;
	}

}
