<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>오류 발생</title>
<style>
/* error-page.css 내용을 여기에 직접 포함하거나, 별도 파일로 분리하여 링크할 수 있습니다. */
body {
	font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
	display: flex;
	flex-direction: column; /* 추가: flex 아이템들을 세로로 배치 */
	justify-content: center; /* 수직 중앙 정렬 */
	align-items: center; /* 수평 중앙 정렬 */
	min-height: 100vh;
	margin: 0;
	background-color: #f8f9fa;
	color: #343a40;
	line-height: 1.6;
}

.error-container {
	background-color: #ffffff;
	padding: 40px 60px;
	border-radius: 12px;
	box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1); /* 더 깊은 그림자 효과 */
	text-align: center;
	max-width: 600px;
	width: 90%;
	border: 1px solid #e0e0e0;
}

h1 {
	color: #dc3545; /* 오류를 나타내는 강렬한 빨간색 */
	font-size: 3em; /* 더 큰 제목 */
	margin-bottom: 20px;
	font-weight: 700;
}

.error-code {
	font-size: 0.8em; /* 상태 코드 크기 조절 */
	color: #6c757d; /* 회색으로 강조 */
	display: block; /* 줄바꿈 */
	margin-bottom: 10px;
}

.error-container h1 {
	margin-top: 0;
}

.error-message {
	color: #495057; /* 오류 메시지 색상 */
	font-size: 1.2em; /* 메시지 크기 키움 */
	margin-bottom: 30px;
	line-height: 1.5;
}

.back-button, .home-button {
	display: inline-block;
	padding: 12px 25px;
	margin: 0 10px;
	border: none;
	border-radius: 8px; /* 둥근 버튼 */
	cursor: pointer;
	font-size: 1.1em;
	font-weight: 600;
	text-decoration: none;
	transition: background-color 0.3s ease, transform 0.2s ease, box-shadow
		0.2s ease;
	box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1); /* 버튼 그림자 */
}

.back-button {
	background-color: #6c757d; /* 회색 버튼 */
	color: white;
}

.back-button:hover {
	background-color: #5a6268;
	transform: translateY(-2px);
	box-shadow: 0 6px 15px rgba(0, 0, 0, 0.15);
}

.home-button {
	background-color: #007bff; /* 파란색 버튼 */
	color: white;
}

.home-button:hover {
	background-color: #0056b3;
	transform: translateY(-2px);
	box-shadow: 0 6px 15px rgba(0, 0, 0, 0.15);
}
</style>
</head>
<body>
	<div class="error-container">
		<h1>
			<span class="error-code">${error.errorPageStatusCode()}</span> ${error.errorPageTitle()}
		</h1>
		<p class="error-message">${error.message()}</p>
		<button class="back-button" onclick="window.history.back()">뒤로가기</button>
		<a href="/" class="home-button">메인 페이지로</a>
	</div>
</body>
</html>