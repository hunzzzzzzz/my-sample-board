package com.example.board.domain.user.dto.response;

import java.util.UUID;

import lombok.Builder;

@Builder
public record UserResponse(UUID userId, String email, String name, String createdAt, String updatedAt) {

}
