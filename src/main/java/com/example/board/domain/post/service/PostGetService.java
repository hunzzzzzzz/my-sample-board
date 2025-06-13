package com.example.board.domain.post.service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.board.domain.post.dto.response.PostDetailResponse;
import com.example.board.domain.post.dto.response.PostFormResponse;
import com.example.board.domain.post.entity.PostStatus;
import com.example.board.domain.post.mapper.PostMapper;
import com.example.board.global.component.TimeFormatter;
import com.example.board.global.exception.post.PostAccessException;
import com.example.board.global.exception.post.PostNotFoundException;

import lombok.AllArgsConstructor;

@AllArgsConstructor
@Service
public class PostGetService {
	private PostMapper postMapper;
	private TimeFormatter timeFormatter;

	/**
	 * 조회된 게시글의 유효성을 검사하는 메서드
	 *
	 * @param post 검사할 게시글 상세 응답 객체
	 * @throws PostNotFoundException 게시글이 존재하지 않을 경우 발생
	 * @throws PostAccessException   게시글이 삭제되어 접근 불가능한 상태일 경우 발생
	 */
	private void validate(PostDetailResponse post) {
		if (post == null)
			throw new PostNotFoundException("존재하지 않는 게시글입니다.");

		if (post.getStatus().equals(PostStatus.DELETED))
			throw new PostAccessException("접근이 불가능합니다.");
	}

	/**
	 * 게시글의 작성일 및 수정일 정보를 지정된 형식 (YYYY-MM-DD)으로 포매팅하는 메서드
	 *
	 * @param post 포매팅할 게시글 상세 응답 객체
	 */
	private void formatDateTime(PostDetailResponse post) {
		post.setFormattedCreatedAt(timeFormatter.formatTimeIntoYyyyMmDd(post.getCreatedAt()));

		if (post.getIsUpdated() != null)
			post.setFormattedUpdatedAt(timeFormatter.formatTimeIntoYyyyMmDd(post.getUpdatedAt()));
	}

	/**
	 * 특정 ID에 해당하는 게시글의 상세 정보를 조회하고, 필요에 따라 조회수를 증가시키는 메서드
	 *
	 * @param postId                  조회할 게시글의 고유 ID
	 * @param shouldIncrementPostView 조회수를 증가시킬지 여부를 나타내는 플래그.
	 * @return 조회된 게시글의 상세 정보가 담긴 객체
	 * @throws PostNotFoundException 게시글이 존재하지 않을 경우 발생
	 * @throws PostAccessException   게시글이 삭제되어 접근 불가능한 상태일 경우 발생
	 */
	@Transactional
	public PostDetailResponse get(long postId, boolean shouldIncrementPostView) {
		// 게시글 조회
		PostDetailResponse post = postMapper.get(postId);

		// 검증
		validate(post);

		// 작성일 및 수정일 포매팅
		formatDateTime(post);

		// 조회수 증가
		if (shouldIncrementPostView)
			postMapper.incrementViewCount(postId);

		return post;
	}
	
	/**
	 * 특정 ID에 해당하는 게시글의 수정 시 필요한 상세 정보를 조회하는 메서드
	 * @param postId 조회할 게시글의 고유 ID
	 * @return       수정 시 필요한 게시글의 상세 정보가 담긴 객체
	 */
	@Transactional(readOnly = true)
	public PostFormResponse get(long postId) {
		return postMapper.getWhenUpdate(postId);
	}
}
