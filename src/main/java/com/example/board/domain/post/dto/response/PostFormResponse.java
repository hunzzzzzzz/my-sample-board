package com.example.board.domain.post.dto.response;

import java.util.List;

import com.example.board.domain.file.dto.response.FileResponse;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class PostFormResponse {
	private long postId;
	private String title;
	private String content;
	private String author;
	private List<FileResponse> files;
}
