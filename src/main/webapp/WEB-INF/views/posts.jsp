<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시글 목록</title>
<style>
/* (이전과 동일한 스타일) */
body {
	font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
	display: flex;
	justify-content: center;
	align-items: flex-start;
	min-height: 100vh;
	margin: 0;
	background-color: #f0f2f5;
	color: #333;
}

.container {
	width: 90%;
	max-width: 1100px;
	background-color: #ffffff;
	padding: 30px;
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
	border-radius: 10px;
	margin-top: 60px;
	box-sizing: border-box;
}

h1 {
	text-align: center;
	color: #2c3e50;
	margin-bottom: 40px;
	font-size: 2.2em;
	font-weight: 600;
}

h1 a {
	text-decoration: none;
	color: inherit;
	cursor: pointer;
}

h1 a:hover {
	color: #007bff;
}

table {
	width: 100%;
	border-collapse: collapse;
	margin-bottom: 30px;
	background-color: #ffffff;
}

th, td {
	border: 1px solid #e0e0e0;
	padding: 15px;
	text-align: left;
	vertical-align: middle;
}

th {
	background-color: #e9ecef;
	color: #495057;
	font-weight: bold;
	text-transform: uppercase;
	font-size: 0.95em;
}

td {
	font-size: 0.9em;
	color: #555;
}

tr:nth-child(even) {
	background-color: #f8f9fa;
}

tr:hover {
	background-color: #f1f3f5;
	cursor: pointer;
}

/* 게시글 제목 링크 스타일 */
td a {
	color: inherit;
	text-decoration: underline;
	cursor: pointer;
}

td a:hover {
	color: #007bff;
	text-decoration: underline;
}

/* 삭제된 게시글 제목 스타일 (취소선) */
.deleted-post-title {
	text-decoration: line-through;
	color: #888;
	cursor: default;
}

.deleted-post-title a {
	pointer-events: none;
	text-decoration: none;
	color: inherit;
}

.pagination {
	text-align: center;
	margin-top: 30px;
	font-size: 1.1em;
}

.pagination a {
	display: inline-block;
	padding: 10px 18px;
	text-decoration: none;
	color: #007bff;
	border: 1px solid #007bff;
	margin: 0 5px;
	border-radius: 5px;
	transition: all 0.3s ease;
	min-width: 30px;
	text-align: center;
}

.pagination a:hover {
	background-color: #007bff;
	color: white;
	box-shadow: 0 2px 6px rgba(0, 123, 255, 0.2);
}

.pagination a.active {
	background-color: #0056b3;
	color: white;
	border: 1px solid #0056b3;
	font-weight: bold;
	box-shadow: 0 2px 6px rgba(0, 86, 179, 0.3);
}

.button-container {
	text-align: right;
	margin-top: 25px;
}

.register-button {
	background-color: #28a745;
	color: white;
	padding: 12px 25px;
	border: none;
	border-radius: 5px;
	cursor: pointer;
	text-decoration: none;
	font-size: 1em;
	font-weight: 500;
	transition: background-color 0.3s ease, transform 0.2s ease;
	box-shadow: 0 2px 6px rgba(40, 167, 69, 0.2);
}

.register-button:hover {
	background-color: #218838;
	transform: translateY(-2px);
}

.register-button:active {
	transform: translateY(0);
}

/* 메시지 스타일 제거 */
.message-success, .message-error {
	display: none; /* 스타일 규칙을 유지하더라도 화면에 보이지 않도록 숨김 */
}

.search-container {
	margin-bottom: 20px;
	display: flex;
	gap: 10px;
	justify-content: flex-end;
}

.search-input {
	flex-grow: 1;
	padding: 10px 15px;
	border: 1px solid #ced4da;
	border-radius: 5px;
	font-size: 1em;
	max-width: 300px;
}

.search-button {
	background-color: #6c757d;
	color: white;
	padding: 10px 20px;
	border: none;
	border-radius: 5px;
	cursor: pointer;
	font-size: 1em;
	transition: background-color 0.3s ease;
}

.search-button:hover {
	background-color: #5a6268;
}
</style>
</head>
<body>
	<div class="container">
		<h1>
			<a href="/posts">게시글 목록</a>
		</h1>

		<div class="search-container">
			<input type="text" id="searchKeyword" name="searchKeyword"
				class="search-input" placeholder="검색..."
				value="${param.keyword != null ? param.keyword : ''}">
			<button type="button" class="search-button" onclick="searchPosts()">검색</button>
		</div>

		<table>
			<thead>
				<tr>
					<th>ID</th>
					<th>제목</th>
					<th>작성자</th>
					<th>조회수</th>
					<th>작성일</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="post" items="${posts}">
					<tr>
						<td>${post.postId}</td>
						<td><c:choose>
								<c:when test="${post.status eq 'DELETED'}">
									<span class="deleted-post-title">${post.title}</span>
								</c:when>
								<c:otherwise>
									<a href="/posts/${post.postId}">${post.title}</a>
								</c:otherwise>
							</c:choose></td>
						<td>${post.author}</td>
						<td>${post.viewCount}</td>
						<td>${post.formattedCreatedAt}</td>
					</tr>
				</c:forEach>
				<c:if test="${empty posts}">
					<tr>
						<td colspan="5"
							style="text-align: center; padding: 20px; color: #777;">게시글이
							없습니다.</td>
					</tr>
				</c:if>
			</tbody>
		</table>

		<div class="pagination">
			<c:if test="${currentPage > 1}">
				<a
					href="/posts?page=${currentPage - 1}<c:if test="${not empty param.keyword}">&keyword=${param.keyword}</c:if>">이전</a>
			</c:if>
			<a
				href="/posts?page=${currentPage}<c:if test="${not empty param.keyword}">&keyword=${param.keyword}</c:if>"
				class="active">${currentPage}</a>
			<c:if test="${currentPage < totalPages}">
				<a
					href="/posts?page=${currentPage + 1}<c:if test="${not empty param.keyword}">&keyword=${param.keyword}</c:if>">다음</a>
			</c:if>
		</div>

		<div class="button-container">
			<a href="/posts/register" class="register-button">등록하기</a>
		</div>
	</div>

	<script>
		function searchPosts() {
			const keyword = document.getElementById('searchKeyword').value;
			window.location.href = '/posts?page=1&keyword='
					+ encodeURIComponent(keyword);
		}

		<c:if test="${not empty error}">
		alert("${error}");
		</c:if>
	</script>
</body>
</html>