package com.example.board.global.exception.post;

import org.springframework.http.HttpStatus;

public class PostNotFoundException extends RuntimeException {
	private static final long serialVersionUID = 1L;
	public final int statusCode;
	public final String message;

	public PostNotFoundException(String message) {
		super(message);
		this.statusCode = HttpStatus.NOT_FOUND.value();
		this.message = message;
	}
}
