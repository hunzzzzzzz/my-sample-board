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
import lombok.AllArgsConstructor;

@AllArgsConstructor
@Controller
public class PostAddController {
	private final PostAddService postAddService;
	private static final String VALIDATION_FAILED_MESSAGE = "게시글 등록에 실패했습니다. 입력값을 확인해주세요.";
	private static final String SUCCESS_MESSAGE = "게시글이 성공적으로 등록되었습니다!";

	/**
	 * 새로운 게시글을 등록하는 폼 페이지를 반환하는 메서드
	 *
	 * @param model 뷰로 데이터를 전달하는 데 사용되는 Spring UI Model
	 * @return 게시글 등록/수정 폼의 뷰 이름 ("post-form")
	 */
	@GetMapping("/posts/register")
	String showPostForm(Model model) {
		model.addAttribute("isEditMode", false);

		return "post-form";
	}

	/**
	 * 클라이언트로부터 제출된 게시글 등록 요청을 처리하는 메서드
	 *
	 * @param request       클라이언트로부터 받은 게시글 등록 데이터 (제목, 내용, 작성자, 파일 등)
	 * @param bindingResult 요청 데이터 유효성 검사 결과를 담는 객체
	 * @return 처리 결과에 따른 HTTP 응답 (성공 시 201 Created, 실패 시 400 Bad Request)
	 */
	@PostMapping("/posts")
	ResponseEntity<?> add(@Valid @ModelAttribute PostAddRequest request, BindingResult bindingResult) {
		// 입력값에 오류가 발생한 경우
		if (bindingResult.hasErrors()) {
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
