package com.example.board.domain.post.service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.board.domain.post.mapper.PostMapper;

@Service
public class PostDeleteService {
	private PostMapper postMapper;
	private static final String DELETED_POST_TITLE = "삭제된 게시글입니다.";

	public PostDeleteService(PostMapper postMapper) {
		this.postMapper = postMapper;
	}

	@Transactional
	public void delete(long postId) {
		postMapper.delete(postId, DELETED_POST_TITLE);
	}

}
