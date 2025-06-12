package com.example.board.domain.post.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.board.domain.post.dto.response.PostResponse;
import com.example.board.domain.post.entity.SortCondition;
import com.example.board.domain.post.service.PostListService;

@Controller
public class PostListController {
	private final PostListService postListService;

	public PostListController(PostListService postListService) {
		this.postListService = postListService;
	}

	@GetMapping({"/", "/posts"})
	String getAll(
			Model model, 
			@RequestParam(required = false, defaultValue = "1") int page,
			@RequestParam(required = false) String keyword,
			@RequestParam(required = false, defaultValue = "LATEST") String sort
	) {
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
