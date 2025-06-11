package com.example.board.domain.post.dto.response;

import java.time.LocalDateTime;

import com.example.board.domain.post.entity.PostStatus;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class PostDetailResponse {
	private long postId;
	private PostStatus status;
	private String title;
	private String content;
	private String author;
	private int viewCount;
	private LocalDateTime createdAt;
	private String formattedCreatedAt;
	private LocalDateTime updatedAt;
	private String formattedUpdatedAt;
	private Boolean isUpdated;
}
