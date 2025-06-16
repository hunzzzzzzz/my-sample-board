package com.example.board.global.auth;

import java.io.IOException;

import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.AuthenticationEntryPoint;
import org.springframework.stereotype.Component;

import com.example.board.global.dto.ErrorResponse;
import com.fasterxml.jackson.databind.ObjectMapper;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class JwtAuthenticationEntryPoint implements AuthenticationEntryPoint {

    private final ObjectMapper objectMapper; // ObjectMapper 주입

    /**
     * 인증되지 않은 사용자가 보호된 리소스에 접근을 시도할 때 호출됩니다.
     * HTTP 401 Unauthorized 응답과 함께 일관된 ErrorResponse DTO를 JSON 형태로 반환합니다.
     *
     * @param request 요청 객체
     * @param response 응답 객체
     * @param authException 발생한 인증 예외
     * @throws IOException
     * @throws ServletException
     */
    @Override
    public void commence(
    		HttpServletRequest request, 
    		HttpServletResponse response,
    		AuthenticationException authException
	) throws IOException, ServletException {
        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED); 
        response.setContentType("application/json;charset=UTF-8"); 
        
        ErrorResponse error = ErrorResponse.of("접근 권한이 없습니다. 로그인이 필요합니다.");
        
        response.getWriter().write(objectMapper.writeValueAsString(error));
    }
}
