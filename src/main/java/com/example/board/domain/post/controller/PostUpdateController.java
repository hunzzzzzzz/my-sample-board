package com.example.board.domain.post.controller;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;

import com.example.board.domain.post.dto.request.PostUpdateRequest;
import com.example.board.domain.post.dto.response.PostDetailResponse;
import com.example.board.domain.post.service.PostGetService;
import com.example.board.domain.post.service.PostUpdateService;
import com.example.board.global.dto.ErrorResponse;
import com.example.board.global.dto.SuccessResponse;

import jakarta.validation.Valid;

@Controller
public class PostUpdateController {
	private final PostGetService postGetService;
	private final PostUpdateService postUpdateService;
	private static final String VALIDATION_FAILED_MESSAGE = "게시글 수정에 실패했습니다. 입력값을 확인해주세요.";
	private static final String SUCCESS_MESSAGE = "게시글이 성공적으로 수정되었습니다!";

	public PostUpdateController(PostGetService postGetService, PostUpdateService postUpdateService) {
		this.postGetService = postGetService;
		this.postUpdateService = postUpdateService;
	}

	@GetMapping("/posts/edit/{postId}")
	String showEditForm(Model model, @PathVariable long postId) {
		// postId를 활용해서 기존 게시글 정보 조회
		PostDetailResponse post = postGetService.get(postId);

		model.addAttribute("postId", postId);
		model.addAttribute("post", post);
		model.addAttribute("isEditMode", true);

		return "post-form";
	}

	@PutMapping("/posts/{postId}")
	ResponseEntity<?> update(@Valid @ModelAttribute PostUpdateRequest request, @PathVariable long postId,
			BindingResult bindingResult) {
		// 입력값에 오류가 발생한 경우
		if (bindingResult.hasErrors()) {
			ErrorResponse errorResponse = ErrorResponse.of(VALIDATION_FAILED_MESSAGE, bindingResult);

			return ResponseEntity.badRequest().body(errorResponse);
		}
		// 정상적으로 수정이 완료된 경우
		else {
			postUpdateService.update(postId, request);

			SuccessResponse successResponse = SuccessResponse.of(SUCCESS_MESSAGE, null);

			return ResponseEntity.status(HttpStatus.CREATED).body(successResponse);
		}
	}
}
