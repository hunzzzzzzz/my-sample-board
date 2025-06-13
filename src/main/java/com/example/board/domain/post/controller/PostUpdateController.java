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
import com.example.board.domain.post.dto.response.PostFormResponse;
import com.example.board.domain.post.service.PostGetService;
import com.example.board.domain.post.service.PostUpdateService;
import com.example.board.global.dto.ErrorResponse;
import com.example.board.global.dto.SuccessResponse;

import jakarta.validation.Valid;
import lombok.AllArgsConstructor;

@AllArgsConstructor
@Controller
public class PostUpdateController {
	private final PostGetService postGetService;
	private final PostUpdateService postUpdateService;
	private static final String VALIDATION_FAILED_MESSAGE = "게시글 수정에 실패했습니다. 입력값을 확인해주세요.";
	private static final String SUCCESS_MESSAGE = "게시글이 성공적으로 수정되었습니다!";

	/**
	 * 게시글 정보를 조회하여 수정 폼에 미리 채워주는 메서드
	 *
	 * @param model  뷰로 데이터를 전달하는 데 사용되는 Spring UI Model
	 * @param postId 수정할 게시글의 고유 ID
	 * @return       게시글 수정 폼을 보여줄 뷰 이름 ("post-form.jsp")
	 */
	@GetMapping("/posts/edit/{postId}")
	String showEditForm(Model model, @PathVariable long postId) {
		PostFormResponse post = postGetService.get(postId);

		model.addAttribute("post", post);
		model.addAttribute("isEditMode", true);

		return "post-form";
	}

	/**
	 * 클라이언트로부터 받은 입력값의 유효성을 검사하고, 유효성 검사 통과 시 게시글을 수정하는 메서드
	 *
	 * @param request       게시글 수정에 필요한 데이터를 담은 DTO.
	 * @param postId        수정할 게시글의 고유 ID
	 * @param bindingResult 요청 데이터 유효성 검사 결과를 담는 객체
	 * @return              처리 결과에 따른 HTTP 응답 (성공 시 200 OK, 실패 시 400 Bad Request)
	 */
	@PutMapping("/posts/{postId}")
	ResponseEntity<?> update(
			@Valid @ModelAttribute PostUpdateRequest request, 
			@PathVariable long postId,
			BindingResult bindingResult
	) {
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
