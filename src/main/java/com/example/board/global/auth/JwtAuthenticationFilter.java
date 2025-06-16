package com.example.board.global.auth;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.http.HttpHeaders;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.util.AntPathMatcher;
import org.springframework.web.filter.OncePerRequestFilter;

import com.example.board.global.component.JwtProvider;

import io.jsonwebtoken.Claims;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class JwtAuthenticationFilter extends OncePerRequestFilter {
	private final JwtProvider jwtProvider;
	private static final List<String> EXCLUDE_URL_PATTERN = Arrays.asList(
            "/",
            "/api/posts/**",
            "/css/**",
            "/icons/**",
            "/favicon.ico",
            "/WEB-INF/views/**",
            "/.well-known/**"
	);

	@Override
	protected boolean shouldNotFilter(HttpServletRequest request) throws ServletException {
		AntPathMatcher antPathMatcher = new AntPathMatcher();

		return EXCLUDE_URL_PATTERN.stream().anyMatch(pattern -> antPathMatcher.match(pattern, request.getRequestURI()));
	}

	@Override
	protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
			throws ServletException, IOException {
		System.out.println("######" + request.getRequestURI());
		
		String authorizationHeaderValue = request.getHeader(HttpHeaders.AUTHORIZATION);

		// Authorization 헤더 검증
		if (authorizationHeaderValue == null || !authorizationHeaderValue.startsWith("Bearer ")) {
			throw new RuntimeException("JWT 토큰 오류"); // TODO
		}

		// ATK 추출
		String atk = jwtProvider.substringToken(authorizationHeaderValue);

		// 유저 정보 획득
		Claims claims = jwtProvider.getUserInfoFromToken(atk);
		String userId = claims.getSubject();
		List<String> roles = (List<String>) claims.get("roles");

		// 권한 목록 설정
		List<SimpleGrantedAuthority> authorities = roles.stream().map(SimpleGrantedAuthority::new)
				.collect(Collectors.toList());

		// Authentication 생성
		Authentication authentication = new UsernamePasswordAuthenticationToken(userId, null, authorities);
		SecurityContextHolder.getContext().setAuthentication(authentication);

		filterChain.doFilter(request, response);
	}

}
