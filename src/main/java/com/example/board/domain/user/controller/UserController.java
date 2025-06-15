package com.example.board.domain.user.controller;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.board.domain.user.dto.response.UserResponse;
import com.example.board.domain.user.service.UserListService;

import lombok.AllArgsConstructor;

@AllArgsConstructor
@Controller
public class UserController {
	private final UserListService userListService;

	@GetMapping("/admin/users")
	String showUserListPage() {
		return "users";
	}

	@GetMapping("/api/admin/users")
	@ResponseBody
	ResponseEntity<List<UserResponse>> getAll() {
		List<UserResponse> users = userListService.getAll();

		return ResponseEntity.ok().body(users);
	}
}
