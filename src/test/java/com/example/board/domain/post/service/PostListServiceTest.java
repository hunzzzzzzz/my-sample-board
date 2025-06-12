package com.example.board.domain.post.service;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import static com.example.board.domain.post.service.PostListService.POST_PAGE_SIZE;

import java.time.LocalDateTime;
import java.util.List;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import com.example.board.domain.post.dto.response.PostResponse;
import com.example.board.domain.post.entity.SortCondition;
import com.example.board.domain.post.mapper.PostMapper;
import com.example.board.global.component.PageHandler;
import com.example.board.global.component.TimeFormatter;

@ExtendWith(MockitoExtension.class)
class PostListServiceTest {
	@InjectMocks
	private PostListService postListService;

	@Mock
	private PageHandler pageHandler;

	@Mock
	private PostMapper postMapper;

	@Mock
	private TimeFormatter timeFormatter;

	private PostResponse post1;
	private PostResponse post2;
	private List<PostResponse> expectedPosts;

	@BeforeEach
	void init() {
		post1 = new PostResponse(1L, "first_post", LocalDateTime.now());
		post2 = new PostResponse(2L, "second_post", LocalDateTime.now().minusHours(1));

		expectedPosts = List.of(post1, post2);
	}

	@Test
	void getAll_WhenThereArePosts_ShouldReturnPosts() {
		// given
		int page = 1;
		String keyword = "test";
		SortCondition sort = SortCondition.LATEST;

		when(pageHandler.calculateOffset(page, POST_PAGE_SIZE)).thenReturn(0);
		when(postMapper.getAll(POST_PAGE_SIZE, 0, keyword, sort)).thenReturn(expectedPosts);
		when(timeFormatter.formatTime(post1.getCreatedAt())).thenReturn("방금");
		when(timeFormatter.formatTime(post2.getCreatedAt())).thenReturn("1시간 전");

		// when
		List<PostResponse> result = postListService.getAll(page, keyword, sort);

		// then
		assertEquals(2, result.size());
		assertEquals("first_post", result.get(0).getTitle());
		assertEquals("second_post", result.get(1).getTitle());
		assertTrue(result.get(0).getCreatedAt().isAfter(result.get(1).getCreatedAt()));
	}

	@Test
	void getAll_WhenThereAreNoPosts_ShouldReturnEmptyList() {
		// given
		int page = 1;
		String keyword = "test";
		SortCondition sort = SortCondition.LATEST;

		when(pageHandler.calculateOffset(page, POST_PAGE_SIZE)).thenReturn(0);
		when(postMapper.getAll(POST_PAGE_SIZE, 0, keyword, sort)).thenReturn(List.of());

		// when
		List<PostResponse> result = postListService.getAll(page, keyword, sort);

		// then
		assertTrue(result.isEmpty());
		verify(timeFormatter, never()).formatTime(any());
	}
	
	@ParameterizedTest
	@CsvSource({"100, 10", "101, 11", "109, 11", "110, 11", "200, 20", "201, 21", "1111, 112"})
	void getTotalPages_WhenThereArePosts_ShouldReturnTotalPages(int totalPosts, int expected) {
		// given
		String keyword = "test";
		
		when(postMapper.countAllPosts(keyword)).thenReturn(totalPosts);
		when(pageHandler.calculateTotalPages(totalPosts, POST_PAGE_SIZE)).thenReturn(expected);
		
		// when
		int result = postListService.getTotalPages(keyword);
		
		// then
		assertEquals(expected, result);
	}
	
	@Test
	void getTotalPages_WhenThereAreNoPosts_ShouldReturnZero() {
		// given
		String keyword = "test";
		int totalPosts = 0;
		
		when(postMapper.countAllPosts(keyword)).thenReturn(totalPosts);
		when(pageHandler.calculateTotalPages(totalPosts, POST_PAGE_SIZE)).thenReturn(0);
		
		// when
		int result = postListService.getTotalPages(keyword);
		
		// then
		assertEquals(0, result);
	}

}
