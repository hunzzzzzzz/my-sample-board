package com.example.board.domain.post.dto.response;

import java.time.LocalDateTime;

import com.example.board.domain.post.entity.PostStatus;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class PostResponse {
	private long postId;
	private PostStatus status;
	private String title;
	private String author;
	private int viewCount;
	private int likeCount;
	private LocalDateTime createdAt;
	private String formattedCreatedAt;

	public PostResponse(long postId, String title, LocalDateTime createdAt) {
		this.postId = postId;
		this.title = title;
		this.createdAt = createdAt;
	}

}
