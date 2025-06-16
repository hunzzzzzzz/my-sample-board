package com.example.board.domain.post.controller;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import com.example.board.domain.post.dto.response.PostResponse;
import com.example.board.domain.post.service.PostDeletedListService;

import lombok.AllArgsConstructor;

@AllArgsConstructor
@Controller
public class PostListDeletedController {
	private PostDeletedListService postDeletedListService;

	@GetMapping("/admin/posts/deleted")
	String showDeletedPostListPage() {
		return "deleted-posts";
	}

	@GetMapping("/api/admin/posts/deleted")
	ResponseEntity<List<PostResponse>> getAllDeleted() {
		List<PostResponse> posts = postDeletedListService.getAllDeleted();

		return ResponseEntity.ok(posts);
	}
}
