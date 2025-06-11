<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시글 목록</title>
<link rel="stylesheet" href="/css/posts.css">
</head>
<body>
	<h1 class="page-title">
		<a href="/posts" class="logo-link">게시글 목록</a>
	</h1>

	<div class="container">
		<div class="search-container">
			<input type="text" id="searchKeyword" class="search-input"
				placeholder="검색..."
				value="${param.keyword != null ? fn:escapeXml(param.keyword) : ''}">
			<button type="button" class="search-button"
				onclick="applySortAndSearch()">검색</button>
		</div>

		<div class="sort-container">
			<label for="sort">정렬:</label> <select id="sort"
				onchange="applySortAndSearch()">
				<option value="LATEST" ${param.sort == 'LATEST' ? 'selected' : ''}>최신순</option>
				<option value="OLDEST" ${param.sort == 'OLDEST' ? 'selected' : ''}>오래된순</option>
				<option value="MOST_VIEWED"
					${param.sort == 'MOST_VIEWED' ? 'selected' : ''}>조회수순</option>
			</select>
		</div>

		<table>
			<colgroup>
				<col style="width: 50px;">
				<col style="width: auto;">
				<col style="width: 100px;">
				<col style="width: 70px;">
				<col style="width: 120px;">
			</colgroup>
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
									<a href="/posts/${post.postId}" class="post-title-link">${post.title}</a>
								</c:otherwise>
							</c:choose></td>
						<td>${post.author}</td>
						<td>${post.viewCount}</td>
						<td>${post.formattedCreatedAt}</td>
					</tr>
				</c:forEach>
				<c:if test="${empty posts}">
					<tr>
						<td colspan="5" class="no-posts">게시글이 없습니다.</td>
					</tr>
				</c:if>
			</tbody>
		</table>

		<div class="pagination">
			<c:if test="${currentPage > 1}">
				<a
					href="/posts?page=${currentPage - 1}&keyword=${param.keyword}&sort=${param.sort}">이전</a>
			</c:if>
			<a
				href="/posts?page=${currentPage}&keyword=${param.keyword}&sort=${param.sort}"
				class="active">${currentPage}</a>
			<c:if test="${currentPage < totalPages}">
				<a
					href="/posts?page=${currentPage + 1}&keyword=${param.keyword}&sort=${param.sort}">다음</a>
			</c:if>
		</div>

		<div class="button-container">
			<a href="/posts/register" class="register-button">등록하기</a>
		</div>
	</div>

	<script>
		function applySortAndSearch() {
			const keyword = document.getElementById('searchKeyword').value;
			const sort = document.getElementById('sort').value;

			const url = '/posts?page=1&keyword=' + keyword + '&sort=' + sort;
			window.location.href = url;
		}
	</script>
</body>
</html>