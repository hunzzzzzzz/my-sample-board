package com.example.board.domain.post.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import com.example.board.domain.post.dto.response.PostDetailResponse;
import com.example.board.domain.post.service.PostGetService;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.AllArgsConstructor;

@AllArgsConstructor
@Controller
public class PostGetController {
	private PostGetService postGetService;
	private static final String POST_VIEW_COOKIE_NAME_PATTERN = "post-%s-view";

	/**
	 * 특정 게시글에 대한 조회수 쿠키를 생성하여 응답에 추가하는 메서드 쿠키는 24시간 동안 유효하며, 게시글 ID에 따라 고유한 이름을
	 * 가진다.
	 *
	 * @param postId   조회한 게시글의 ID
	 * @param response 쿠키를 추가하는 데 사용되는 HttpServletResponse 객체
	 */
	private void addCookie(long postId, HttpServletResponse response) {
		Cookie cookie = new Cookie(POST_VIEW_COOKIE_NAME_PATTERN.formatted(postId), "-");

		cookie.setPath("/");
		cookie.setMaxAge(24 * 60 * 60); // 24시간

		response.addCookie(cookie);
	}

	/**
	 * 주어진 게시글 ID에 대한 조회수 쿠키가 요청에 포함되어 있는지 확인하는 메서드
	 *
	 * @param postId  확인할 게시글의 ID
	 * @param request 요청 헤더의 쿠키를 가져오는 데 사용되는 HttpServletRequest 객체
	 * @return 해당 게시글에 대한 조회수 쿠키가 존재하면 true, 그렇지 않으면 false 리턴
	 */
	private boolean hasCookieOfPostView(long postId, HttpServletRequest request) {
		Cookie[] cookies = request.getCookies();

		if (cookies != null)
			for (Cookie cookie : cookies)
				if (cookie.getName().equals(POST_VIEW_COOKIE_NAME_PATTERN.formatted(postId)))
					return true;

		return false;
	}

	/**
	 * 특정 게시글의 상세 정보를 조회하고 뷰에 전달하는 메서드
     * '게시글 조회 시 조회수 증가' 로직과 '중복 조회 방지를 위한 쿠키 검증' 로직을 포함
	 *
	 * @param model    뷰로 데이터를 전달하는 데 사용되는 Spring UI Model
	 * @param postId   조회할 게시글의 고유 ID
	 * @param request  요청 헤더의 쿠키를 가져오는 데 사용되는 HttpServletRequest 객체
	 * @param response 쿠키를 추가하는 데 사용되는 HttpServletResponse 객체
	 * @return 게시글 상세 페이지의 뷰 이름 ("post")
	 */
	@GetMapping("/api/posts/{postId}")
	String get(Model model, @PathVariable long postId, HttpServletRequest request, HttpServletResponse response) {
		// 쿠키 존재 여부 확인
		boolean hasCookieOfPostView = hasCookieOfPostView(postId, request);
		// 쿠키가 없다면 추가
		if (!hasCookieOfPostView)
			addCookie(postId, response);

		PostDetailResponse post = postGetService.get(postId, !hasCookieOfPostView);
		model.addAttribute("post", post);

		return "post";
	}
}
