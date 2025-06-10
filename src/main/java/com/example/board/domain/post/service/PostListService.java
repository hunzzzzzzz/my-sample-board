package com.example.board.domain.post.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.board.domain.post.dto.response.PostResponse;
import com.example.board.domain.post.mapper.PostMapper;
import com.example.board.global.component.TimeFormatter;

@Service
public class PostListService {
	private final PostMapper postMapper;
	private final TimeFormatter timeFormatter;
	private static final int POST_PAGE_SIZE = 10; // 게시판에 보여줄 게시글 개수

	public PostListService(PostMapper postMapper, TimeFormatter timeFormatter) {
		this.postMapper = postMapper;
		this.timeFormatter = timeFormatter;
	}

	private int getOffset(int page) {
		return (page - 1) * POST_PAGE_SIZE;
	}

	private List<PostResponse> getPosts(int page, int offset) {
		return postMapper.getAll(POST_PAGE_SIZE, offset);
	}

	private void convertToRelativeTime(List<PostResponse> posts) {
		for (PostResponse post : posts)
			post.setFormattedCreatedAt(timeFormatter.format(post.getCreatedAt()));
	}

	private int calculateTotalPages() {
		int totalPosts = postMapper.countAllPosts();

		return (int) ((double) totalPosts / POST_PAGE_SIZE) + 1;
	}

	@Transactional(readOnly = true)
	public List<PostResponse> getAll(int page) {
		// offset 계산
		int offset = getOffset(page);

		// 게시글 목록 조회
		List<PostResponse> posts = getPosts(page, offset);

		// 상대 시간으로 변환
		convertToRelativeTime(posts);

		// 페이지 정보를 추가
		return posts;
	}

	@Transactional(readOnly = true)
	public int getTotalPages() {
		return calculateTotalPages();
	}
}
