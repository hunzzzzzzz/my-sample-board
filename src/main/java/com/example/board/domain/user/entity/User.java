package com.example.board.domain.user.entity;

import java.time.LocalDateTime;
import java.util.UUID;

import com.example.board.domain.user.dto.response.UserResponse;
import com.example.board.global.component.TimeFormatter;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class User {
	private UUID userId;
	private String email;
	private String name;
	private LocalDateTime createdAt;
	private LocalDateTime updatedAt;
	
	public UserResponse toResponse(TimeFormatter timeFormatter) {
		return UserResponse.builder()
				.userId(userId)
				.email(email)
				.name(name)
				.createdAt(timeFormatter.formatTimeIntoYyyyMmDd(createdAt))
				.updatedAt(timeFormatter.formatTimeIntoYyyyMmDd(updatedAt))
				.build();
	}
}
