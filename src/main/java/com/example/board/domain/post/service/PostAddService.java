package com.example.board.domain.post.service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.board.domain.file.service.FileSaveService;
import com.example.board.domain.post.dto.request.PostAddRequest;
import com.example.board.domain.post.entity.Post;
import com.example.board.domain.post.mapper.PostMapper;

import lombok.AllArgsConstructor;

@AllArgsConstructor
@Service
public class PostAddService {
	private FileSaveService fileSaveService;
	private PostMapper postMapper;

	/**
	 * 새로운 게시글과 해당 첨부 파일을 저장하는 메서드
	 *
	 * @param request 게시글 등록 요청 데이터 (제목, 내용, 작성자, 첨부 파일 목록 포함)
	 */
	@Transactional
	public void add(PostAddRequest request) {
		// 저장
		Post post = request.toEntity();
		postMapper.add(post);

		// 파일 저장
		fileSaveService.save(post.getPostId(), request.getFiles());
	}
}
