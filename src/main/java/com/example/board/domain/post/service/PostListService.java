package com.example.board.domain.post.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.board.domain.post.dto.response.PostResponse;
import com.example.board.domain.post.entity.SortCondition;
import com.example.board.domain.post.mapper.PostMapper;
import com.example.board.global.component.TimeFormatter;

@Service
public class PostListService {
	private final PostMapper postMapper;
	private final TimeFormatter timeFormatter;
	private static final int POST_PAGE_SIZE = 10;

	public PostListService(PostMapper postMapper, TimeFormatter timeFormatter) {
		this.postMapper = postMapper;
		this.timeFormatter = timeFormatter;
	}

	/**
	 * 오프셋을 계산하는 메서드
	 * @param 페이지 번호
	 * @return 오프셋
	 */
	private int calculateOffset(int page) {
		return (page - 1) * POST_PAGE_SIZE;
	}
	
	/**
	 * DB에서 게시글 목록을 조회하는 메서드
	 * @param 페이지 번호
	 * @param 오프셋
	 * @param 키워드
	 * @return 게시글 목록
	 */
	private List<PostResponse> getPosts(int page, int offset, String keyword, SortCondition sort) {
		return postMapper.getAll(POST_PAGE_SIZE, offset, keyword, sort);
	}

	/**
	 * 게시글 목록의 생성 시간을 (현재 시간 기준) 상대 시간으로 변환하는 메서드
	 * @param 게시글 목록
	 */
	private void formatPostTimes(List<PostResponse> posts) {
		posts.forEach(post -> post.setFormattedCreatedAt(timeFormatter.formatTime(post.getCreatedAt())));
	}

	private int calculateTotalPages(String keyword) {
		int totalPosts = postMapper.countAllPosts(keyword);

		return (int) ((double) totalPosts / POST_PAGE_SIZE) + 1;
	}

	@Transactional(readOnly = true)
	public List<PostResponse> getAll(int page, String keyword, SortCondition sort) {
		// 게시글 목록 조회
		int offset = calculateOffset(page);
		List<PostResponse> posts = getPosts(page, offset, keyword, sort);

		// 상대 시간으로 변환
		formatPostTimes(posts);

		return posts;
	}

	@Transactional(readOnly = true)
	public int getTotalPages(String keyword) {
		return calculateTotalPages(keyword);
	}

}
