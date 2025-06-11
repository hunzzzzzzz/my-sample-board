package com.example.board.domain.post.controller;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;

import com.example.board.domain.post.dto.request.PostAddRequest;
import com.example.board.domain.post.service.PostAddService;
import com.example.board.global.dto.ErrorResponse;
import com.example.board.global.dto.SuccessResponse;

import jakarta.validation.Valid;

@Controller
public class PostAddController {
	private final PostAddService postAddService;
	private static final String VALIDATION_FAILED_MESSAGE = "게시글 등록에 실패했습니다. 입력값을 확인해주세요.";
	private static final String SUCCESS_MESSAGE = "게시글이 성공적으로 등록되었습니다!";

	public PostAddController(PostAddService postAddService) {
		this.postAddService = postAddService;
	}

	@GetMapping("/posts/register")
	String showPostForm(Model model) {
		model.addAttribute("isEditMode", false);

		return "post-form";
	}

	@PostMapping("/posts")
	ResponseEntity<?> add(@Valid @ModelAttribute PostAddRequest request, BindingResult bindingResult) {
		// 입력값에 오류가 발생한 경우
		if (bindingResult.hasErrors()) {
			System.out.println("들어오는지 확인");
			ErrorResponse errorResponse = ErrorResponse.of(VALIDATION_FAILED_MESSAGE, bindingResult);

			return ResponseEntity.badRequest().body(errorResponse);
		}
		// 정상적으로 등록이 완료된 경우
		else {
			postAddService.add(request);

			SuccessResponse successResponse = SuccessResponse.of(SUCCESS_MESSAGE, null);

			return ResponseEntity.status(HttpStatus.CREATED).body(successResponse);
		}
	}
}
