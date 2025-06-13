package com.example.board.domain.post.service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.board.domain.file.service.FileDeleteService;
import com.example.board.domain.file.service.FileSaveService;
import com.example.board.domain.post.dto.request.PostUpdateRequest;
import com.example.board.domain.post.mapper.PostMapper;

import lombok.AllArgsConstructor;

@AllArgsConstructor
@Service
public class PostUpdateService {
	private final FileDeleteService fileDeleteService;
	private final FileSaveService fileSaveService;
	private final PostMapper postMapper;

	/**
	 * 특정 게시글의 정보를 업데이트하는 메서드
	 *
	 * @param postId  수정할 게시글의 고유 ID.
	 * @param request 게시글 수정 요청 데이터 (제목, 내용, 작성자, 새로운 파일 목록, 삭제할 파일 ID 목록)
	 */
	@Transactional
	public void update(long postId, PostUpdateRequest request) {
		// 게시글 기본 정보 수정
		postMapper.update(postId, request);

		// 새로운 첨부파일 저장
		fileSaveService.save(postId, request.getFiles());

		// 제거된 첨부파일 삭제
		if (request.getDeletedFileIds().size() > 0)
			fileDeleteService.delete(request.getDeletedFileIds());
	}
}
