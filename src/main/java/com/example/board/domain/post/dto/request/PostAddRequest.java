package com.example.board.domain.post.dto.request;

import com.example.board.domain.post.entity.Post;

public record PostAddRequest(String title, String content, String author) {

	public Post toEntity() {
		return new Post(title, content, author);
	}
}
