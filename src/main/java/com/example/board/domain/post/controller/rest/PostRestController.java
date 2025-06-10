package com.example.board.domain.post.controller.rest;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.board.domain.post.dto.request.PostAddRequest;
import com.example.board.domain.post.dto.response.PostResponse;
import com.example.board.domain.post.service.PostAddService;
import com.example.board.domain.post.service.PostListService;

@RestController
@RequestMapping("/rest/posts")
public class PostRestController {
	private final PostAddService postAddService;
	private final PostListService postListService;

	public PostRestController(PostAddService postAddService, PostListService postListService) {
		this.postAddService = postAddService;
		this.postListService = postListService;
	}

	@GetMapping
	ResponseEntity<List<PostResponse>> getAll(@RequestParam(required = false, defaultValue = "1") int page) {
		List<PostResponse> posts = postListService.getAll(page);

		return ResponseEntity.ok(posts);
	}

	@PostMapping
	ResponseEntity<Object> add(@RequestBody PostAddRequest request) {
		postAddService.add(request);

		return ResponseEntity.status(HttpStatus.CREATED).build();
	}

}
