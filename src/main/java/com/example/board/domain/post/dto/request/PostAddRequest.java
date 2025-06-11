package com.example.board.domain.post.dto.request;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import com.example.board.domain.post.entity.Post;

import jakarta.validation.constraints.Size;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Builder
@Getter
@Setter
public class PostAddRequest {
	@Size(max = 255, message = "제목은 255자를 초과할 수 없습니다.")
	String title;

	String content;

	@Size(max = 10, message = "작성자 이름은 10자를 초과할 수 없습니다.")
	String author;

	public Post toEntity() {
		return new Post(title, content, author);
	}

	private List<MultipartFile> files;
}