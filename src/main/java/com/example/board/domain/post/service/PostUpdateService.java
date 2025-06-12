package com.example.board.domain.post.service;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.example.board.domain.file.service.FileDeleteService;
import com.example.board.domain.file.service.FileSaveService;
import com.example.board.domain.post.dto.request.PostUpdateRequest;
import com.example.board.domain.post.mapper.PostMapper;

@Service
public class PostUpdateService {
	private final FileDeleteService fileDeleteService;
	private final FileSaveService fileSaveService;
	private final PostMapper postMapper;

	public PostUpdateService(FileDeleteService fileDeleteService, FileSaveService fileSaveService,
			PostMapper postMapper) {
		this.fileDeleteService = fileDeleteService;
		this.fileSaveService = fileSaveService;
		this.postMapper = postMapper;
	}

	boolean hasFiles(List<MultipartFile> files) {
		List<MultipartFile> actualFiles = files.stream().filter(file -> !file.isEmpty()).collect(Collectors.toList());

		return actualFiles.size() > 0;
	}

	@Transactional
	public void update(long postId, PostUpdateRequest request) {
		// 게시글 기본 정보 수정
		postMapper.update(postId, request);

		// 새로운 첨부파일 저장
		if (hasFiles(request.getNewFiles()))
			fileSaveService.save(postId, request.getNewFiles());

		// 제거된 첨부파일 삭제
		if (request.getDeletedFileIds().size() > 0)
			fileDeleteService.delete(request.getDeletedFileIds());
	}
}
