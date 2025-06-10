package com.example.board.domain.post.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.board.domain.post.dto.request.PostAddRequest;
import com.example.board.domain.post.dto.response.PostDetailResponse;
import com.example.board.domain.post.dto.response.PostResponse;
import com.example.board.domain.post.service.PostAddService;
import com.example.board.domain.post.service.PostGetService;
import com.example.board.domain.post.service.PostListService;

import jakarta.validation.Valid;

@Controller
@RequestMapping("/posts")
public class PostController {
	private final PostAddService postAddService;
	private final PostGetService postGetService;
	private final PostListService postListService;
	private static final String VALIDATION_FAILED_MESSAGE = "게시글 등록에 실패했습니다. 입력값을 확인해주세요.";
	private static final String SYSTEM_ERROR_MESSAGE = "게시글 등록 도중 오류가 발생했습니다.";

	public PostController(PostAddService postAddService, PostGetService postGetService,
			PostListService postListService) {
		this.postAddService = postAddService;
		this.postGetService = postGetService;
		this.postListService = postListService;
	}

	@GetMapping
	String getAll(Model model, @RequestParam(required = false, defaultValue = "1") int page,
			@RequestParam(required = false) String keyword) {
		List<PostResponse> posts = postListService.getAll(page, keyword);
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

	@GetMapping("/{postId}")
	String get(Model model, @PathVariable long postId) {
		PostDetailResponse post = postGetService.get(postId);

		model.addAttribute("post", post);

		return "post";
	}

	@PostMapping
	String add(Model model, @ModelAttribute @Valid PostAddRequest request, BindingResult bindingResult) {
		if (bindingResult.hasErrors()) {
			for (FieldError error : bindingResult.getFieldErrors())
				System.out.println(error.getField() + " " + error.getDefaultMessage()); // TODO : 추후 로깅 처리

			FieldError titleError = bindingResult.getFieldError("title");

			if (titleError != null)
				model.addAttribute("titleError", titleError.getDefaultMessage());

			model.addAttribute("request", request);
			model.addAttribute("error", VALIDATION_FAILED_MESSAGE);

			return "post-form";
		}

		try {
			postAddService.add(request);

			return "redirect:/posts";
		} catch (Exception e) {
			System.out.println(e.getMessage()); // TODO: 추후 로깅 처리

			model.addAttribute("error", SYSTEM_ERROR_MESSAGE);

			return "redirect:/posts/register";
		}
	}

}