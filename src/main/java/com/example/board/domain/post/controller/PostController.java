package com.example.board.domain.post.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.board.domain.post.dto.response.PostDetailResponse;
import com.example.board.domain.post.service.PostDeleteService;
import com.example.board.domain.post.service.PostGetService;
import com.example.board.domain.post.service.PostListService;
import com.example.board.domain.post.service.PostUpdateService;
import com.example.board.global.dto.SuccessResponse;
import com.example.board.global.exception.PostException;

@Controller
@RequestMapping("/posts")
public class PostController {
	private final PostDeleteService postDeleteService;
	private final PostGetService postGetService;

	private static final String SUCCESS_MESSAGE_WHEN_DELETE_POST = "게시글이 성공적으로 삭제되었습니다!";

	public PostController(PostDeleteService postDeleteService, PostGetService postGetService,
			PostListService postListService, PostUpdateService postUpdateService) {
		this.postDeleteService = postDeleteService;
		this.postGetService = postGetService;
	}

	private SuccessResponse getSuccessResponse(String message, Object value) {
		return SuccessResponse.builder().message(message).value(value).build();
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

	@DeleteMapping("/{postId}")
	ResponseEntity<SuccessResponse> delete(@PathVariable long postId) {
		postDeleteService.delete(postId);
		SuccessResponse successResponse = getSuccessResponse(SUCCESS_MESSAGE_WHEN_DELETE_POST, null);

		return ResponseEntity.ok().body(successResponse);
	}

}