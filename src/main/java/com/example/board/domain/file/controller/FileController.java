package com.example.board.domain.file.controller;

import java.nio.charset.StandardCharsets;
import java.util.UUID;

import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import com.example.board.domain.file.dto.response.FileDownloadResponse;
import com.example.board.domain.file.service.FileDownloadService;

import lombok.AllArgsConstructor;

@AllArgsConstructor
@Controller
public class FileController {
	private final FileDownloadService fileDownloadService;

	@GetMapping("/files/{fileId}")
	ResponseEntity<Resource> download(@PathVariable UUID fileId) {
		FileDownloadResponse file = fileDownloadService.download(fileId);
		String encodedFileName = new String(file.getOriginalFileName().getBytes(StandardCharsets.UTF_8),
				StandardCharsets.ISO_8859_1);

		return ResponseEntity.ok().contentType(MediaType.parseMediaType(file.getFileType())) // 파일 타입 (MIME Type) 설정
				.header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + encodedFileName + "\"") // 다운로드 헤더
				.body(file.getResource());
	}
}
