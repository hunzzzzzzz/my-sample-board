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

	/**
	 * 특정 게시글을 삭제 처리하는 트랜잭션 메서드
	 * 실제 데이터베이스에서 게시글을 물리적으로 삭제하는 대신, 게시글의 title/status만 변경
	 *
	 * @param postId 삭제 처리할 게시글의 고유 ID
	 */
	@Transactional
	public void delete(long postId) {
		postMapper.delete(postId, DELETED_POST_TITLE);
	}

}
