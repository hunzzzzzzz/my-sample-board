package com.example.board.domain.post.service;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.anyList;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.Mockito.doThrow;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.util.List;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.web.multipart.MultipartFile;

import com.example.board.domain.file.service.FileSaveService;
import com.example.board.domain.post.dto.request.PostAddRequest;
import com.example.board.domain.post.entity.Post;
import com.example.board.domain.post.mapper.PostMapper;

@ExtendWith(MockitoExtension.class)
class PostAddServiceTest {

	@InjectMocks
	private PostAddService postAddService;

	@Mock
	private PostMapper postMapper;

	@Mock
	private FileSaveService fileSaveService;

	private PostAddRequest postAddRequest;
	private Post post;

	@BeforeEach
	void init() {
		postAddRequest = mock(PostAddRequest.class);
		post = mock(Post.class);

		when(postAddRequest.toEntity()).thenReturn(post);
	}

	@Test
	void add_whenFileDoNotExists() {
		// given
		when(post.getPostId()).thenReturn(1L);
		when(postAddRequest.getFiles()).thenReturn(null);

		// when
		postAddService.add(postAddRequest);

		// then
		verify(postMapper).add(post);
		verify(fileSaveService, never()).save(anyLong(), anyList());
	}

	@Test
	void add_whenFilesExist() {
		// given
		MultipartFile multipartFile = mock(MultipartFile.class);
		List<MultipartFile> files = List.of(multipartFile);

		when(post.getPostId()).thenReturn(1L);
		when(postAddRequest.getFiles()).thenReturn(files);

		// when
		postAddService.add(postAddRequest);

		// then
		verify(postMapper).add(post);
		verify(fileSaveService).save(1L, files);
	}

	@Test
	void add_shouldRollback_whenMapperFails() {
		// given
		doThrow(new RuntimeException("DB 오류")).when(postMapper).add(post);

		// expected
		assertThrows(RuntimeException.class, () -> postAddService.add(postAddRequest));
		verify(fileSaveService, never()).save(anyLong(), anyList());
	}

}
