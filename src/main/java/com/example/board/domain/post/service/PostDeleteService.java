package com.example.board.domain.post.service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.board.domain.post.mapper.PostMapper;

import lombok.AllArgsConstructor;

@AllArgsConstructor
@Service
public class PostDeleteService {
	private PostMapper postMapper;
	private static final String DELETED_POST_TITLE = "삭제된 게시글입니다.";

	@Transactional
	public void delete(long postId) {
		postMapper.delete(postId, DELETED_POST_TITLE);
	}

}
