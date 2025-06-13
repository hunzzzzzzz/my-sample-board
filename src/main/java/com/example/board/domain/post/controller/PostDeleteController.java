package com.example.board.domain.post.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;

import com.example.board.domain.post.service.PostDeleteService;
import com.example.board.global.dto.SuccessResponse;

import lombok.AllArgsConstructor;

@AllArgsConstructor
@Controller
public class PostDeleteController {
	private final PostDeleteService postDeleteService;

	private static final String SUCCESS_MESSAGE = "게시글이 성공적으로 삭제되었습니다!";

	@DeleteMapping("/posts/{postId}")
	ResponseEntity<SuccessResponse> delete(@PathVariable long postId) {
		postDeleteService.delete(postId);
		SuccessResponse successResponse = SuccessResponse.of(SUCCESS_MESSAGE, null);

		return ResponseEntity.ok().body(successResponse);
	}

}