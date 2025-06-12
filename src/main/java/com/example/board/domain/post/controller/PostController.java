package com.example.board.domain.post.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import com.example.board.domain.post.service.PostDeleteService;
import com.example.board.domain.post.service.PostListService;
import com.example.board.domain.post.service.PostUpdateService;
import com.example.board.global.dto.SuccessResponse;

@Controller
@RequestMapping("/posts")
public class PostController {
	private final PostDeleteService postDeleteService;

	private static final String SUCCESS_MESSAGE_WHEN_DELETE_POST = "게시글이 성공적으로 삭제되었습니다!";

	public PostController(PostDeleteService postDeleteService, PostListService postListService,
			PostUpdateService postUpdateService) {
		this.postDeleteService = postDeleteService;
	}

	private SuccessResponse getSuccessResponse(String message, Object value) {
		return SuccessResponse.builder().message(message).value(value).build();
	}

	@DeleteMapping("/{postId}")
	ResponseEntity<SuccessResponse> delete(@PathVariable long postId) {
		postDeleteService.delete(postId);
		SuccessResponse successResponse = getSuccessResponse(SUCCESS_MESSAGE_WHEN_DELETE_POST, null);

		return ResponseEntity.ok().body(successResponse);
	}

}