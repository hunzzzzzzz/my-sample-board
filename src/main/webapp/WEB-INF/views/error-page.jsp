<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>오류 발생</title>
<link rel="stylesheet" href="/css/error-page.css">
</head>
<body>
	<div class="error-container">
		<h1>
			<span class="error-code">${error.errorPageStatusCode}</span>
			${error.errorPageTitle}
		</h1>
		<p class="error-message">${error.message}</p>
		<button class="back-button" onclick="window.history.back()">뒤로가기</button>
		<a href="/" class="home-button">메인 페이지로</a>
	</div>
</body>
</html>