package com.example.board.domain.user.service;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.board.domain.user.dto.response.UserResponse;
import com.example.board.domain.user.entity.User;
import com.example.board.domain.user.mapper.UserMapper;
import com.example.board.global.component.TimeFormatter;

import lombok.AllArgsConstructor;

@AllArgsConstructor
@Service
public class UserListService {
	private final TimeFormatter timeFormatter;
	private final UserMapper userMapper;

	@Transactional(readOnly = true)
	public List<UserResponse> getAll() {
		List<User> users = userMapper.getAll();

		return users.stream()
				.map((user) -> user.toResponse(timeFormatter))
				.collect(Collectors.toList());
	}
}
