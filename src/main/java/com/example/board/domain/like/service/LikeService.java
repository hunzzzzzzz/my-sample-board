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
	
	public boolean hasLike(long postId, UUID userId) {
		return likeMapper.hasLike(postId, userId) == 1;
	}
	
	public void like(long postId, UUID userId) {
		likeMapper.like(postId, userId);
		
		postMapper.incrementLikeCount(postId);
	}
	
	public void cancelLike(long postId, UUID userId) {
		likeMapper.cancelLike(postId, userId);
		
		postMapper.decrementLikeCount(postId);
	}

	@Transactional
	public void toggleLike(long postId, UUID userId) {
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
