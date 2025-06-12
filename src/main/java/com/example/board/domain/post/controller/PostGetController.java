package com.example.board.domain.post.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import com.example.board.domain.post.dto.response.PostDetailResponse;
import com.example.board.domain.post.service.PostGetService;
import com.example.board.global.exception.post.PostAccessException;
import com.example.board.global.exception.post.PostNotFoundException;

import lombok.AllArgsConstructor;

@AllArgsConstructor
@Controller
public class PostGetController {
	private PostGetService postGetService;

	@GetMapping("/posts/{postId}")
	String get(Model model, @PathVariable long postId) {
		try {
			PostDetailResponse post = postGetService.get(postId);
			model.addAttribute("post", post);

			return "post";
		}
		// 사용자가 '존재하지 않는 게시글'에 접근하는 경우
		catch (PostNotFoundException e) {
			model.addAttribute("statusCode", e.statusCode);
			model.addAttribute("errorTitle", "페이지를 찾을 수 없습니다.");
			model.addAttribute("errorMessage", e.message);

			return "error-page";
		}
		// 사용자가 '삭제된 게시글'에 접근하는 경우
		catch (PostAccessException e) {
			model.addAttribute("statusCode", e.statusCode);
			model.addAttribute("errorTitle", "접근 권한이 없습니다.");
			model.addAttribute("errorMessage", e.message);

			return "error-page";
		}
	}
}
