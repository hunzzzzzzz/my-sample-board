package com.example.board.domain.like.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

@Controller
public class LikeController {
	@GetMapping("/posts/{postId}/like")
	public String like(@PathVariable long postId) {
		
		return "";
	}

}
