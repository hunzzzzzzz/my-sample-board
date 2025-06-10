package com.example.board.domain.post.service;

import org.springframework.stereotype.Service;

import com.example.board.domain.post.dto.response.PostDetailResponse;
import com.example.board.domain.post.mapper.PostMapper;
import com.example.board.global.component.TimeFormatter;
import com.example.board.global.exception.PostException;

@Service
public class PostGetService {
	private PostMapper postMapper;
	private TimeFormatter timeFormatter;

	public PostGetService(PostMapper postMapper, TimeFormatter timeFormatter) {
		this.postMapper = postMapper;
		this.timeFormatter = timeFormatter;
	}

	private PostDetailResponse getPost(long postId) {
		PostDetailResponse post = postMapper.get(postId);

		if (post == null)
			throw new PostException("존재하지 않는 게시글입니다.");
		return post;
	}

	private void formatCreatedAt(PostDetailResponse post) {
		post.setFormattedCreatedAt(timeFormatter.formatTimeIntoYyyyMmDd(post.getCreatedAt()));
	}

	public PostDetailResponse get(long postId) {
		// 게시글 조회
		PostDetailResponse post = getPost(postId);

		// 작성일 포매팅
		formatCreatedAt(post);

		return post;
	}
}
