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
	<!-- 제목 -->
	<h1 class="page-title">
		<a href="/posts" class="logo-link">게시글 목록</a>
	</h1>

	<div class="container">
		<!-- 검색창 -->
		<div class="search-container">
			<input type="text" id="searchKeyword" class="search-input" placeholder="검색..."
				value="${param.keyword != null ? fn:escapeXml(param.keyword) : ''}">
			<button type="button" class="search-button" onclick="applySortAndSearch()">검색</button>
		</div>

		<!-- 정렬 박스 -->
		<div class="sort-container">
			<label for="sort">정렬:</label> 
			<select id="sort" onchange="applySortAndSearch()">
				<option value="LATEST" ${param.sort == 'LATEST' ? 'selected' : ''}>최신순</option>
				<option value="OLDEST" ${param.sort == 'OLDEST' ? 'selected' : ''}>오래된순</option>
				<option value="MOST_VIEWED" ${param.sort == 'MOST_VIEWED' ? 'selected' : ''}>조회수순</option>
				<option value="MOST_LIKED" ${param.sort == 'MOST_LIKED' ? 'selected' : ''}>좋아요순</option>
			</select>
		</div>

		<!-- 게시판 -->
		<table>
			<colgroup>
				<col style="width: 50px;">
				<col style="width: 40%;">
				<col style="width: 125px;">
				<col style="width: 100px;">
				<col style="width: 100px;">
				<col style="width: 120px;">
			</colgroup>
			<thead>
				<tr>
					<th>ID</th>
					<th>제목</th>
					<th>작성자</th>
					<th class="centered-header">조회수</th>
					<th class="centered-header">좋아요</th>
					<th>작성일</th>
				</tr>
			</thead>
			<tbody>
				<!-- 테이블 내용 출력 -->
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
						<td class="centered-cell">${post.viewCount}</td>
						<td class="centered-cell">${post.likeCount}</td>
						<td>${post.formattedCreatedAt}</td>
					</tr>
				</c:forEach>
				<!-- 테이블에 내용이 존재하지 않는 경우 -->
				<c:if test="${empty posts}">
					<tr>
						<td colspan="6" class="no-posts">게시글이 없습니다.</td>
					</tr>
				</c:if>
			</tbody>
		</table>

		<!-- 페이지 번호 -->
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

		<!-- 등록하기 버튼 -->
		<div class="button-container">
			<a href="/posts/register" class="register-button">등록하기</a>
		</div>
	</div>

	<script>
		// '검색' 버튼을 눌렀을 때 발생하는 이벤트
		function applySortAndSearch() {
			const keyword = document.getElementById('searchKeyword').value;
			const sort = document.getElementById('sort').value;
			
			// API 호출
			const url = '/posts?page=1&keyword=' + keyword + '&sort=' + sort;
			window.location.href = url;
		}
	</script>
</body>
</html>