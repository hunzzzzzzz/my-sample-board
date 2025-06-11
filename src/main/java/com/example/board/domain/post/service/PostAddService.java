package com.example.board.domain.post.service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.board.domain.file.service.FileSaveService;
import com.example.board.domain.post.dto.request.PostAddRequest;
import com.example.board.domain.post.entity.Post;
import com.example.board.domain.post.mapper.PostMapper;

@Service
public class PostAddService {
	private FileSaveService fileService;
	private PostMapper postMapper;

	public PostAddService(FileSaveService fileService, PostMapper postMapper) {
		this.fileService = fileService;
		this.postMapper = postMapper;
	}

	void save(Post post) {
		postMapper.add(post);
	}

	@Transactional
	public void add(PostAddRequest request) {
		// 저장
		Post post = request.toEntity();
		save(post);

		// 파일 저장
		if (request.getFiles() != null)
			fileService.add(post.getPostId(), request.getFiles());
	}
}
