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

	/**
	 * 특정 게시글을 삭제하는 요청을 처리하는 메서드
	 * 
	 * @param postId  삭제할 게시글의 고유 ID (경로 변수 {@code /{postId}}에서 추출).
	 * @return        처리 결과에 따른 HTTP 응답 (성공 시 200 OK)
	 */
	@DeleteMapping("/posts/{postId}")
	ResponseEntity<SuccessResponse> delete(@PathVariable long postId) {
		postDeleteService.delete(postId);
		SuccessResponse successResponse = SuccessResponse.of(SUCCESS_MESSAGE, null);

		return ResponseEntity.ok().body(successResponse);
	}

}