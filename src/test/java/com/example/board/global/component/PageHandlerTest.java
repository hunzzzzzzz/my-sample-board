package com.example.board.global.component;

import static org.junit.jupiter.api.Assertions.*;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;
import org.mockito.InjectMocks;
import org.mockito.junit.jupiter.MockitoExtension;

@ExtendWith(MockitoExtension.class)
class PageHandlerTest {
	@InjectMocks
	private PageHandler pageHandler;

	@Test
	void calculateOffset_whenFirstPage() {
		// given
		int currentPage = 1;
		int pageSize = 10;

		// when
		int offset = pageHandler.calculateOffset(currentPage, pageSize);

		// then
		assertEquals(0, offset);
	}

	@ParameterizedTest
	@CsvSource({ "2, 10, 10", "3, 5, 10", "5, 15, 60", "10, 20, 180" })
	void calculateOffset_whenOtherPage(int currentPage, int pageSize, int expected) {
		// when
		int offset = pageHandler.calculateOffset(currentPage, pageSize);

		// then
		assertEquals(expected, offset);
	}

	@Test
	void calculateTotalPages_whenNoContents() {
		// given
		int total = 0;
		int pageSize = 10;

		// when
		int totalPages = pageHandler.calculateTotalPages(total, pageSize);

		// then
		assertEquals(0, totalPages);
	}

	@ParameterizedTest
	@CsvSource({ "100, 10, 10", "101, 10, 11", "99, 10, 10", "1, 5, 1" })
	void calculateTotalPages_whenContentsExist(int total, int pageSize, int expected) {
		// when
		int totalPages = pageHandler.calculateTotalPages(total, pageSize);

		// then
		assertEquals(expected, totalPages);
	}
}
