package com.example.board.global.exception;

import org.springframework.http.ResponseEntity;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.multipart.MaxUploadSizeExceededException;

import com.example.board.global.dto.ErrorResponse;
import com.example.board.global.exception.post.PostAccessException;
import com.example.board.global.exception.post.PostNotFoundException;

@ControllerAdvice
public class GlobalExceptionHandler {
	@ExceptionHandler(MaxUploadSizeExceededException.class)
	ResponseEntity<ErrorResponse> handleMaxUploadSizeExceededException() {
		ErrorResponse error = ErrorResponse.of("업로드 가능한 파일의 최대 크기는 10MB입니다.");

		return ResponseEntity.badRequest().body(error);
	}
	
	@ExceptionHandler(PostAccessException.class)
	String handlePostAccessException(Model model, PostAccessException e) {
		ErrorResponse error = ErrorResponse.of(e.message, "접근 권한이 없습니다", e.statusCode);
		
		model.addAttribute("error", error);
		
		return "error-page";
	}
	
	@ExceptionHandler(PostNotFoundException.class)
	String handlePostNotFoundException(Model model, PostNotFoundException e) {
		ErrorResponse error = ErrorResponse.of(e.message, "페이지를 찾을 수 없습니다", e.statusCode);
		
		model.addAttribute("error", error);
		
		return "error-page";
	}
}
