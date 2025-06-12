package com.example.board.domain.post.dto.response;

import java.time.LocalDateTime;
import java.util.List;

import com.example.board.domain.file.dto.response.FileResponse;
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
	private int likeCount;
	private LocalDateTime createdAt;
	private String formattedCreatedAt;
	private LocalDateTime updatedAt;
	private Boolean isUpdated;
	private String formattedUpdatedAt;
	private List<FileResponse> files;
	
	public PostDetailResponse(long postId, PostStatus status, String title, String content) {
		this.postId = postId;
		this.status = status;
		this.title = title;
		this.content = content;
	}
	
}
