package com.example.board.domain.post.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.board.domain.post.dto.request.PostUpdateRequest;
import com.example.board.domain.post.dto.response.PostDetailResponse;
import com.example.board.domain.post.service.PostDeleteService;
import com.example.board.domain.post.service.PostGetService;
import com.example.board.domain.post.service.PostListService;
import com.example.board.domain.post.service.PostUpdateService;
import com.example.board.global.dto.ErrorResponse;
import com.example.board.global.dto.SuccessResponse;
import com.example.board.global.exception.PostException;

import jakarta.validation.Valid;

@Controller
@RequestMapping("/posts")
public class PostController {
	private final PostDeleteService postDeleteService;
	private final PostGetService postGetService;
	private final PostUpdateService postUpdateService;

	private static final String SUCCESS_MESSAGE_WHEN_UPDATE_POST = "게시글이 성공적으로 수정되었습니다!";
	private static final String SUCCESS_MESSAGE_WHEN_DELETE_POST = "게시글이 성공적으로 삭제되었습니다!";

	public PostController(PostDeleteService postDeleteService, PostGetService postGetService,
			PostListService postListService, PostUpdateService postUpdateService) {
		this.postDeleteService = postDeleteService;
		this.postGetService = postGetService;
		this.postUpdateService = postUpdateService;
	}

	private SuccessResponse getSuccessResponse(String message, Object value) {
		return SuccessResponse.builder().message(message).value(value).build();
	}

	private ErrorResponse getErrorResponse(String message, Map<String, String> errors) {
		return ErrorResponse.builder().message(message).errors(errors).build();
	}

	@GetMapping("/{postId}")
	String get(Model model, RedirectAttributes redirectAttributes, @PathVariable long postId) {
		try {
			PostDetailResponse post = postGetService.get(postId);

			model.addAttribute("post", post);

			return "post";
		}
		// 사용자가 '삭제된 게시글'에 조회하려는 경우
		catch (PostException e) {
			System.out.println(e.getMessage()); // TODO: 추후 로깅 처리

			redirectAttributes.addFlashAttribute("error", "접근이 불가능합니다.");

			return "redirect:/posts";
		}
	}

	@GetMapping("/edit/{postId}")
	String showEditForm(Model model, @PathVariable long postId) {
		// postId를 활용해서 기존 게시글 정보 조회
		PostDetailResponse post = postGetService.get(postId);
		PostUpdateRequest request = PostUpdateRequest.builder().title(post.getTitle()).content(post.getContent())
				.author(post.getAuthor()).build();

		model.addAttribute("postId", postId);
		model.addAttribute("request", request);
		model.addAttribute("isEditMode", true);

		return "post-form";
	}

	@PutMapping("/{postId}")
	ResponseEntity<?> update(@Valid @ModelAttribute PostUpdateRequest request, @PathVariable long postId,
			BindingResult bindingResult) {
		// 입력값에 오류가 발생한 경우
		if (bindingResult.hasErrors()) {
			Map<String, String> errors = new HashMap<>();

			for (FieldError error : bindingResult.getFieldErrors()) {
				System.out.println(error.getField() + " " + error.getDefaultMessage()); // TODO : 추후 로깅 처리

				errors.put(error.getField(), error.getDefaultMessage());
			}

			ErrorResponse errorResponse = getErrorResponse("", errors);

			return ResponseEntity.badRequest().body(errorResponse);
		} else {
			postUpdateService.update(postId, request);
			SuccessResponse successResponse = getSuccessResponse(SUCCESS_MESSAGE_WHEN_UPDATE_POST, null);

			return ResponseEntity.ok().body(successResponse);
		}
	}

	@DeleteMapping("/{postId}")
	ResponseEntity<SuccessResponse> delete(@PathVariable long postId) {
		postDeleteService.delete(postId);
		SuccessResponse successResponse = getSuccessResponse(SUCCESS_MESSAGE_WHEN_DELETE_POST, null);

		return ResponseEntity.ok().body(successResponse);
	}

}