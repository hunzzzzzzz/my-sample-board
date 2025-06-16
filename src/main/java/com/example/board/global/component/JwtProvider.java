package com.example.board.global.component;

import java.util.Base64;

import javax.crypto.SecretKey;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;

@Component
public class JwtProvider {
	private SecretKey secretKey;

	public JwtProvider(@Value("${jwt.secret.key}") String secretKey) {
		this.secretKey = Keys.hmacShaKeyFor(Base64.getDecoder().decode(secretKey));
	}

	public String substringToken(String authorizationHeaderValue) {
		return authorizationHeaderValue.substring("Bearer ".length());
	}

	public Claims getUserInfoFromToken(String token) {
		return Jwts.parser().verifyWith(secretKey).build().parseSignedClaims(token).getPayload();
	}
}
