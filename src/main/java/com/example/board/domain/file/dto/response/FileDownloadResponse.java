package com.example.board.domain.file.dto.response;

import java.util.UUID;

import org.springframework.core.io.Resource;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class FileDownloadResponse {
	private UUID fileId;
	private String originalFileName;
	private String savedFileName;
	private String fileType;
	private Resource resource;
}
