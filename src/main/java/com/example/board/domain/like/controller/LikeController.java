package com.example.board.domain.like.controller;

import java.util.UUID;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;

import com.example.board.domain.like.service.LikeService;
import com.example.board.global.dto.SuccessResponse;

import lombok.AllArgsConstructor;

@AllArgsConstructor
@Controller
public class LikeController {
	private final LikeService likeService;

	@PostMapping("/posts/{postId}/like")
	public ResponseEntity<SuccessResponse> like(@PathVariable long postId) {
		UUID userId = UUID.fromString("3fd80784-3454-4ac1-bf71-82e247e13eb2"); // TODO : 추후 구현
		likeService.like(postId, userId);

		SuccessResponse response = SuccessResponse.of("좋아요가 추가되었습니다.", null);
		return ResponseEntity.ok().body(response);
	}

	@DeleteMapping("/posts/{postId}/like")
	public ResponseEntity<SuccessResponse> cancelLike(@PathVariable long postId) {
		UUID userId = UUID.fromString("3fd80784-3454-4ac1-bf71-82e247e13eb2"); // TODO : 추후 구현
		likeService.cancelLike(postId, userId);

		SuccessResponse response = SuccessResponse.of("좋아요가 취소되었습니다.", null);
		return ResponseEntity.ok().body(response);
	}

	@GetMapping("/posts/{postId}/like/check")
	public ResponseEntity<SuccessResponse> checkHasLike(@PathVariable long postId) {
		UUID userId = UUID.fromString("3fd80784-3454-4ac1-bf71-82e247e13eb2"); // TODO : 추후 구현
		boolean hasLike = likeService.hasLike(postId, userId);

		SuccessResponse response = SuccessResponse.of("좋아요가 취소되었습니다.", hasLike);
		return ResponseEntity.ok().body(response);
	}

}
