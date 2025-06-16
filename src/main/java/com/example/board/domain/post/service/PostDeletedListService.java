package com.example.board.domain.post.service;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import com.example.board.domain.post.dto.response.PostResponse;
import com.example.board.domain.post.mapper.PostMapper;
import com.example.board.global.component.TimeFormatter;

import lombok.AllArgsConstructor;

@AllArgsConstructor
@Service
public class PostDeletedListService {
	private final PostMapper postMapper;
	private final TimeFormatter timeFormatter;

	public List<PostResponse> getAllDeleted() {
		List<PostResponse> posts = postMapper.getAllDeleted();

		return posts.stream().map((post) -> {
			String formatted = timeFormatter.formatTimeIntoYyyyMmDd(post.getCreatedAt());
			post.setFormattedCreatedAt(formatted);

			return post;
		}).collect(Collectors.toList());

	}
}
