package com.example.board.domain.like.mapper;

import java.util.UUID;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LikeMapper {
	int hasLike(long postId, UUID userId);

	void like(long postId, UUID userId);

	void cancelLike(long postId, UUID userId);
}
