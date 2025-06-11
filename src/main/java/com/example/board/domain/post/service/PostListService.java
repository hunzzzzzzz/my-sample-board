package com.example.board.domain.post.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.board.domain.post.dto.response.PostResponse;
import com.example.board.domain.post.entity.SortCondition;
import com.example.board.domain.post.mapper.PostMapper;
import com.example.board.global.component.PageHandler;
import com.example.board.global.component.TimeFormatter;

import lombok.AllArgsConstructor;

@AllArgsConstructor
@Service
public class PostListService {
	private final PageHandler pageHandler;
	private final PostMapper postMapper;
	private final TimeFormatter timeFormatter;

	private static final int POST_PAGE_SIZE = 10;

	/**
	 * 데이터베이스에서 게시글 목록을 조회하는 메서드
	 * 
	 * @param page    현재 페이지 번호
	 * @param offset  데이터베이스에서 건너뛸 레코드 수
	 * @param keyword 검색어
	 * @param sort    게시글 정렬 조건
	 * @return 조회된 게시글 목록
	 */
	private List<PostResponse> getPosts(int page, int offset, String keyword, SortCondition sort) {
		return postMapper.getAll(POST_PAGE_SIZE, offset, keyword, sort);
	}

	/**
	 * 게시글 목록의 생성 시간을 '상대 시간' 형식으로 변환하는 메서드
	 * 
	 * @param posts 시간을 포맷팅할 게시글 목록
	 */
	private void formatPostTimes(List<PostResponse> posts) {
		posts.forEach(post -> post.setFormattedCreatedAt(timeFormatter.formatTime(post.getCreatedAt())));
	}

	/**
	 * 게시글 목록을 조회하는 메서드
	 * 
	 * @param page    조회할 페이지 번호
	 * @param keyword 검색어
	 * @param sort    정렬 조건
	 * @return 포맷팅된 시간 정보가 포함된 게시글 목록
	 */
	@Transactional(readOnly = true)
	public List<PostResponse> getAll(int page, String keyword, SortCondition sort) {
		// 게시글 목록 조회
		int offset = pageHandler.calculateOffset(page, POST_PAGE_SIZE);
		List<PostResponse> posts = getPosts(page, offset, keyword, sort);

		// 시간 포매팅
		formatPostTimes(posts);

		return posts;
	}

	/**
	 * 주어진 검색 키워드에 해당하는 총 페이지 수를 반환하는 메서드
	 * 
	 * @param keyword 검색어
	 * @return 계산된 총 페이지 수
	 */
	@Transactional(readOnly = true)
	public int getTotalPages(String keyword) {
		// 게시글의 총 개수 조회
		int totalPosts = postMapper.countAllPosts(keyword);
		int totalPages = pageHandler.calculateTotalPages(totalPosts, POST_PAGE_SIZE);

		return totalPages;
	}

}
