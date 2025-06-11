package com.example.board.domain.post.dto.request;

import com.example.board.domain.post.entity.Post;

import jakarta.validation.constraints.Size;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Builder
@Getter
@Setter
public class PostUpdateRequest {
	@Size(max = 255, message = "제목은 255자를 초과할 수 없습니다.")
	String title;

	String content;

	String author;

	public Post toEntity() {
		return new Post(title, content, author);
	}
}