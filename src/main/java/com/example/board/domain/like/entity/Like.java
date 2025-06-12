package com.example.board.domain.like.entity;

import java.time.LocalDateTime;
import java.util.UUID;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Like {
	private long likeId;
	private long postId;
	private UUID userId;
	private LocalDateTime createdAt;
}
