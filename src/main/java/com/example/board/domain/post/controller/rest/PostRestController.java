package com.example.board.domain.post.controller.rest;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.board.domain.post.dto.request.PostAddRequest;
import com.example.board.domain.post.dto.response.PostDetailResponse;
import com.example.board.domain.post.dto.response.PostResponse;
import com.example.board.domain.post.service.PostAddService;
import com.example.board.domain.post.service.PostDeleteService;
import com.example.board.domain.post.service.PostGetService;
import com.example.board.domain.post.service.PostListService;

@RestController
@RequestMapping("/rest/posts")
public class PostRestController {
	private final PostAddService postAddService;
	private final PostDeleteService postDeleteService;
	private final PostGetService postGetService;
	private final PostListService postListService;

	public PostRestController(PostAddService postAddService, PostDeleteService postDeleteService,
			PostGetService postGetService, PostListService postListService) {
		this.postAddService = postAddService;
		this.postDeleteService = postDeleteService;
		this.postGetService = postGetService;
		this.postListService = postListService;
	}

	@GetMapping
	ResponseEntity<List<PostResponse>> getAll(@RequestParam(required = false, defaultValue = "1") int page,
			@RequestParam(required = false) String keyword) {
		List<PostResponse> posts = postListService.getAll(page, keyword);

		return ResponseEntity.ok(posts);
	}

	@GetMapping("/{postId}")
	ResponseEntity<PostDetailResponse> get(@PathVariable long postId) {
		PostDetailResponse post = postGetService.get(postId);

		return ResponseEntity.ok(post);
	}

	@PostMapping
	ResponseEntity<Object> add(@RequestBody PostAddRequest request) {
		postAddService.add(request);

		return ResponseEntity.status(HttpStatus.CREATED).build();
	}

	@DeleteMapping("/{postId}")
	ResponseEntity<Object> delete(@PathVariable long postId) {
		postDeleteService.delete(postId);

		return ResponseEntity.noContent().build();
	}

}
