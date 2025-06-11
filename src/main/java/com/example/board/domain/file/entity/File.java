package com.example.board.domain.file.entity;

import java.util.UUID;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class File {
	private UUID fileId;
	private long postId;
	private String originalFileName;
	private String savedFileName;
	private String path;

	public File(UUID fileId, long postId, String originalFileName, String savedFileName, String path) {
		this.fileId = fileId;
		this.postId = postId;
		this.originalFileName = originalFileName;
		this.savedFileName = savedFileName;
		this.path = path;
	}

}
