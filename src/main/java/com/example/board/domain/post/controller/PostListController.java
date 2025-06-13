package com.example.board.domain.post.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.board.domain.post.dto.response.PostResponse;
import com.example.board.domain.post.entity.SortCondition;
import com.example.board.domain.post.service.PostListService;

import lombok.AllArgsConstructor;

@AllArgsConstructor
@Controller
public class PostListController {
	private final PostListService postListService;

	/**
	 * 모든 게시글 목록을 조회하여 뷰에 전달하는 메서드
	 * 페이징, 검색, 정렬 기능을 지원
	 *
	 * @param model   뷰로 데이터를 전달하는 데 사용되는 Spring UI Model
	 * @param page    현재 페이지 번호 (기본값 1)
	 * @param keyword 검색어
	 * @param sort    정렬 조건 (기본값 LATEST)
	 * @return        게시글 목록 뷰 이름 ("posts.jsp")
	 */
	@GetMapping({ "/", "/posts" })
	String getAll(Model model, @RequestParam(required = false, defaultValue = "1") int page,
			@RequestParam(required = false) String keyword,
			@RequestParam(required = false, defaultValue = "LATEST") String sort) {
		List<PostResponse> posts = postListService.getAll(page, keyword, SortCondition.valueOf(sort));
		int totalPages = postListService.getTotalPages(keyword);

		model.addAttribute("posts", posts);
		model.addAttribute("currentPage", page);
		model.addAttribute("totalPages", totalPages);
		if (keyword != null)
			model.addAttribute("keyword", keyword);

		return "posts";
	}
}
