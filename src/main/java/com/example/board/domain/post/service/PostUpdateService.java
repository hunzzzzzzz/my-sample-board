package com.example.board.domain.post.service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.board.domain.post.dto.request.PostUpdateRequest;
import com.example.board.domain.post.mapper.PostMapper;

@Service
public class PostUpdateService {
	private final PostMapper postMapper;

	public PostUpdateService(PostMapper postMapper) {
		this.postMapper = postMapper;
	}

	@Transactional
	public void update(long postId, PostUpdateRequest request) {
		postMapper.update(postId, request);
	}
}
