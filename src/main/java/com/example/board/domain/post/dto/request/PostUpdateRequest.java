package com.example.board.domain.post.dto.request;

import java.util.List;
import java.util.UUID;

import org.springframework.web.multipart.MultipartFile;

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
	private String title;

	private String content;

	@Size(max = 10, message = "작성자 이름은 10자를 초과할 수 없습니다.")
	private String author;

	private List<MultipartFile> newFiles;

	private List<UUID> deletedFileIds;

	public Post toEntity() {
		return new Post(title, content, author);
	}
}