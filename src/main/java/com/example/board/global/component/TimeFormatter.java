package com.example.board.global.component;

import java.time.Duration;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import org.springframework.stereotype.Component;

@Component
public class TimeFormatter {
	public String formatTime(LocalDateTime time) {
		LocalDateTime now = LocalDateTime.now();
		Duration differenceOfDays = Duration.between(time, now);

		if (now.minusDays(1).isAfter(time))
			return "%s일 전".formatted(differenceOfDays.toDays());

		else if (now.minusHours(1).isAfter(time))
			return "%s시간 전".formatted(differenceOfDays.toHours());

		else if (now.minusMinutes(1).isAfter(time))
			return "%s분 전".formatted(differenceOfDays.toMinutes());

		else
			return "방금";
	}

	public String formatTimeIntoYyyyMmDd(LocalDateTime time) {
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy년 M월 dd일 HH:mm");

		return time.format(formatter);
	}
}
