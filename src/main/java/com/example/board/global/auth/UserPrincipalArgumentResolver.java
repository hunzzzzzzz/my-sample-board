package com.example.board.global.auth;

import org.springframework.core.MethodParameter;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.support.WebDataBinderFactory;
import org.springframework.web.context.request.NativeWebRequest;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.method.support.ModelAndViewContainer;

import io.jsonwebtoken.Claims;

@Component
public class UserPrincipalArgumentResolver implements HandlerMethodArgumentResolver {
	@Override
	public boolean supportsParameter(MethodParameter parameter) {
		// 파라미터에 @UserPrincipal 어노테이션이 붙어 있는지 확인
		boolean hasUserPrincipalAnnotation = parameter.hasParameterAnnotation(UserPrincipal.class);
		// 파라미터의 타입이 String 타입인지 확인
		boolean isStringType = String.class.isAssignableFrom(parameter.getParameterType());

		return hasUserPrincipalAnnotation && isStringType;
	}

	@Override
	public Object resolveArgument(
			MethodParameter parameter, 
			ModelAndViewContainer mavContainer,
			NativeWebRequest webRequest, 
			WebDataBinderFactory binderFactory
	) throws Exception {
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		
		if (authentication == null) {
			return null;
		} else {
			return ((Claims) authentication.getPrincipal()).getSubject();
		}
	}

}
