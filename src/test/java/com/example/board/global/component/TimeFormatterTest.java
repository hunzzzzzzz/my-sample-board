package com.example.board.global.component;

import static org.junit.jupiter.api.Assertions.assertEquals;

import java.time.LocalDateTime;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.junit.jupiter.MockitoExtension;

@ExtendWith(MockitoExtension.class)
class TimeFormatterTest {
	@InjectMocks
	private TimeFormatter timeFormatter;
	
	@Test
	void formatTime_ShouldReturn방금_WhenLessThanOneMinute() {
		// given
		LocalDateTime now = LocalDateTime.now();
		LocalDateTime time = now.minusSeconds(30);
		
		// when
		String result = timeFormatter.formatTime(time);
		
		// then
		assertEquals("방금", result);
	}
	
	@Test
	void formatTime_ShouldReturn30분전_WhenLessThanOneHour() {
		// given
		LocalDateTime now = LocalDateTime.now();
		LocalDateTime time = now.minusMinutes(30);
		
		// when
		String result = timeFormatter.formatTime(time);
		
		// then
		assertEquals("30분 전", result);
	}

	@Test
	void formatTime_ShouldReturn6시간전_WhenLessThanOneDay() { 
		// given
		LocalDateTime now = LocalDateTime.now();
		LocalDateTime time = now.minusHours(6);
		
		// when
		String result = timeFormatter.formatTime(time);
		
		// then
		assertEquals("6시간 전", result);
	}
	
	@Test
	void formatTime_ShouldReturn3일전_WhenMoreThanOneDay() {
		// given
		LocalDateTime now = LocalDateTime.now();
		LocalDateTime time = now.minusDays(3);
		
		// when
		String result = timeFormatter.formatTime(time);
		
		// then
		assertEquals("3일 전", result);
	}
	
	@Test
	void formatTimeIntoYyyyMmDd_ShouldReturnFormattedString() {
		// given
		LocalDateTime time = LocalDateTime.of(2025, 1, 1, 16, 0);
		String expectedFomrattedString = "2025년 1월 1일 16:00";
		
		// when
		String result = timeFormatter.formatTimeIntoYyyyMmDd(time);
		
		// then
		assertEquals(expectedFomrattedString, result);
	}
}
