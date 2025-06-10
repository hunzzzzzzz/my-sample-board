package com.example.board.domain.post.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.board.domain.post.dto.request.PostAddRequest;
import com.example.board.domain.post.dto.response.PostResponse;
import com.example.board.domain.post.service.PostAddService;
import com.example.board.domain.post.service.PostListService;

@Controller
@RequestMapping("/posts")
public class PostController {
	private final PostAddService postAddService;
	private final PostListService postListService;

	public PostController(PostAddService postAddService, PostListService postListService) {
		this.postAddService = postAddService;
		this.postListService = postListService;
	}

	@GetMapping
	String getAll(Model model, @RequestParam(required = false, defaultValue = "1") int page) {
		List<PostResponse> posts = postListService.getAll(page);
		int totalPages = postListService.getTotalPages();

		model.addAttribute("posts", posts);
		model.addAttribute("currentPage", page);
		model.addAttribute("totalPages", totalPages);

		return "posts";
	}

	@GetMapping("/register")
	String showPostForm() {
		return "post-form";
	}

	@PostMapping
	String add(@ModelAttribute PostAddRequest request, RedirectAttributes redirectAttirbutes) {
		try {
			postAddService.add(request);
			redirectAttirbutes.addFlashAttribute("message", "게시글이 성공적으로 등록되었습니다.");

			return "redirect:/posts";
		} catch (Exception e) {
			redirectAttirbutes.addFlashAttribute("error", "게시글 등록 도중 오류가 발생했습니다.");
			// TODO: 로깅 추가
			return "redirect:/posts/register";
		}
	}

}
