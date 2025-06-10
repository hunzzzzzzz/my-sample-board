package com.example.board.domain.post.service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.board.domain.post.dto.request.PostAddRequest;
import com.example.board.domain.post.entity.Post;
import com.example.board.domain.post.mapper.PostMapper;
import com.example.board.global.exception.PostException;

@Service
public class PostAddService {
	private PostMapper postMapper;

	public PostAddService(PostMapper postMapper) {
		this.postMapper = postMapper;
	}

	void validateRequest(PostAddRequest request) {
		if (request.title() == null || request.title().isBlank())
			throw new PostException("게시글 제목은 필수 입력 항목입니다.");
		if (request.content() == null || request.content().isBlank())
			throw new PostException("게시글 내용은 필수 입력 항목입니다.");
		if (request.author() == null || request.author().isBlank())
			throw new PostException("게시글 작성자는 필수 입력 항목입니다.");
	}

	void save(Post post) {
		postMapper.add(post);
	}

	@Transactional
	public void add(PostAddRequest request) {
		// 입력값 검증
		validateRequest(request);

		// 저장
		Post post = request.toEntity();
		save(post);
	}
}
