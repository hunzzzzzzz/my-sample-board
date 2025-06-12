package com.example.board.domain.like.service;

import java.util.UUID;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.board.domain.like.mapper.LikeMapper;
import com.example.board.domain.post.mapper.PostMapper;

import lombok.AllArgsConstructor;

@AllArgsConstructor
@Service
public class LikeService {
	private LikeMapper likeMapper;
	private PostMapper postMapper;

	@Transactional
	void toggleLike(long postId, UUID userId) {
		boolean hasLike = likeMapper.hasLike(postId, userId) == 1;

		if (hasLike) {
			likeMapper.cancelLike(postId, userId);
			postMapper.decrementLikeCount(postId);
		} else {
			likeMapper.like(postId, userId);
			postMapper.incrementLikeCount(postId);
		}
	}
}
