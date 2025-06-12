package com.example.board.domain.post.service;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.example.board.domain.file.service.FileSaveService;
import com.example.board.domain.post.dto.request.PostAddRequest;
import com.example.board.domain.post.entity.Post;
import com.example.board.domain.post.mapper.PostMapper;

@Service
public class PostAddService {
	private FileSaveService fileSaveService;
	private PostMapper postMapper;

	public PostAddService(FileSaveService fileSaveService, PostMapper postMapper) {
		this.fileSaveService = fileSaveService;
		this.postMapper = postMapper;
	}

	void savePostInDb(Post post) {
		postMapper.add(post);
	}

	// 첨부파일이 없는 경우 브라우저가 빈 MultipartFile 객체를 생성해 전송
	boolean hasFiles(List<MultipartFile> files) {
		List<MultipartFile> actualFiles = files.stream().filter(file -> !file.isEmpty()).collect(Collectors.toList());

		return actualFiles.size() > 0;
	}

	@Transactional
	public void add(PostAddRequest request) {
		// 저장
		Post post = request.toEntity();
		savePostInDb(post);

		// 파일 저장
		if (hasFiles(request.getFiles()))
			fileSaveService.save(post.getPostId(), request.getFiles());
	}
}
