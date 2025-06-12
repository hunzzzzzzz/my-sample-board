package com.example.board.domain.post.service;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import com.example.board.domain.post.dto.response.PostDetailResponse;
import com.example.board.domain.post.entity.PostStatus;
import com.example.board.domain.post.mapper.PostMapper;
import com.example.board.global.component.TimeFormatter;
import com.example.board.global.exception.post.PostAccessException;
import com.example.board.global.exception.post.PostNotFoundException;

@ExtendWith(MockitoExtension.class)
class PostGetServiceTest {
	@InjectMocks
	private PostGetService postGetService;

	@Mock
	private PostMapper postMapper;

	@Mock
	private TimeFormatter timeFormatter;

	private PostDetailResponse validPost;
	private PostDetailResponse deletedPost;

	@BeforeEach
	void init() {
		validPost = new PostDetailResponse(1L, PostStatus.NORMAL, "valid_post", "valid_content");
		deletedPost = new PostDetailResponse(2L, PostStatus.DELETED, "deleted_post", "deleted_content");
	}

	@Test
	void get_WhenIncreaseViewCount_ShouldReturnPostDetailResponse() {
		// given
		when(postMapper.get(1L)).thenReturn(validPost);
		when(timeFormatter.formatTimeIntoYyyyMmDd(validPost.getCreatedAt())).thenReturn("2025-01-01");

		// when
		PostDetailResponse result = postGetService.get(1L, true);

		// then
		assertNotNull(result);
		assertEquals(validPost.getTitle(), result.getTitle());
		assertEquals(validPost.getContent(), result.getContent());
		verify(postMapper).incrementViewCount(1L);
	}

	@Test
	void get_WhenNotIncreaseViewCount_ShouldReturnPostDetailResponse() {
		// given
		when(postMapper.get(1L)).thenReturn(validPost);
		when(timeFormatter.formatTimeIntoYyyyMmDd(validPost.getCreatedAt())).thenReturn("2025-01-01");

		// when
		PostDetailResponse result = postGetService.get(1L, false);

		assertNotNull(result);
		assertEquals(validPost.getTitle(), result.getTitle());
		assertEquals(validPost.getContent(), result.getContent());
		assertEquals(validPost.getViewCount(), result.getViewCount());
		verify(postMapper, never()).incrementViewCount(1L);
	}

	@Test
	void get_WhenPostIdIsInvalid_ThrowPostNotFoundException() {
		// given
		when(postMapper.get(100L)).thenReturn(null);

		// expected
		assertThrows(PostNotFoundException.class, () -> postGetService.get(100L, true));
		verify(postMapper, never()).incrementViewCount(100L);
	}

	@Test
	void get_WhenPostWasDeleted_ThrowsPostAccessException() {
		// given
		when(postMapper.get(2L)).thenReturn(deletedPost);

		// expected
		assertThrows(PostAccessException.class, () -> postGetService.get(2L, true));
		verify(postMapper, never()).incrementViewCount(2L);
	}

}