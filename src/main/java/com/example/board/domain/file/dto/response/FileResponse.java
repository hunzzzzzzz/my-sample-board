package com.example.board.domain.file.dto.response;

import java.util.UUID;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class FileResponse {
	private UUID fileId;
	private String originalFileName;
	private long fileSize;
	private String fileType;
}
