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
<link rel="icon" href="/icons/favicon.ico" type="image/x-icon">
<body>
	<!-- 제목 -->
	<h1 class="page-title">
		<a href="/api/posts" class="logo-link">게시글 목록</a>
	</h1>

	<div class="container">
		<!-- 검색창 -->
		<div class="search-container">
			<input type="text" id="searchKeyword" class="search-input"
				placeholder="검색..."
				value="${param.keyword != null ? fn:escapeXml(param.keyword) : ''}">
			<button type="button" class="search-button"
				onclick="applySortAndSearch()">검색</button>
		</div>

		<!-- 정렬 박스 -->
		<div class="sort-container">
			<label for="sort">정렬:</label> <select id="sort"
				onchange="applySortAndSearch()">
				<option value="LATEST" ${param.sort == 'LATEST' ? 'selected' : ''}>최신순</option>
				<option value="OLDEST" ${param.sort == 'OLDEST' ? 'selected' : ''}>오래된순</option>
				<option value="MOST_VIEWED"
					${param.sort == 'MOST_VIEWED' ? 'selected' : ''}>조회수순</option>
				<option value="MOST_LIKED"
					${param.sort == 'MOST_LIKED' ? 'selected' : ''}>좋아요순</option>
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
					<th id="title-header">제목</th>
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
									<a href="/api/posts/${post.postId}" class="post-title-link">${post.title}</a>
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
					href="/api/posts?page=${currentPage - 1}&keyword=${param.keyword}&sort=${param.sort}">이전</a>
			</c:if>
			<a
				href="/api/posts?page=${currentPage}&keyword=${param.keyword}&sort=${param.sort}"
				class="active">${currentPage}</a>
			<c:if test="${currentPage < totalPages}">
				<a
					href="/api/posts?page=${currentPage + 1}&keyword=${param.keyword}&sort=${param.sort}">다음</a>
			</c:if>
		</div>

		<!-- 등록하기 버튼 -->
		<div class="button-container">
			<a href="/posts/register" class="register-button"
				onclick='handleRegisterButton(event);'>등록하기</a>
		</div>
	</div>

	<script>
		// ***** 검색 버튼을 눌렀을 때 *****
		function applySortAndSearch() {
			const keyword = document.getElementById('searchKeyword').value;
			const sort = document.getElementById('sort').value;
			
			// API 호출
			const url = '/api/posts?page=1&keyword=' + keyword + '&sort=' + sort;
			window.location.href = url;
		}
		
		// ***** 어드민 페이지로 이동 *****
		let adminClickCount = 0;
		let adminClickTimer = null; // 클릭 간격 타이머 ID 저장
		const TITLE_CLICK_THRESHOLD = 5; // 어드민 페이지로 이동하기 위한 클릭 횟수
		const CLICK_INTERVAL_MS = 1000; // 연속 클릭으로 인정되는 최대 시간 간격 (1초)

		// '제목' 헤더를 클릭한 경우
		document.addEventListener('DOMContentLoaded', function() {
			const titleHeader = document.getElementById('title-header');

			if (titleHeader) {
				titleHeader.addEventListener('click', function(event) {
					event.preventDefault(); 

					// 클릭 횟수 증가
					adminClickCount++; 

					// 기존 타이머가 있다면 초기화 (새로운 클릭이 발생했으므로)
					clearTimeout(adminClickTimer);

					// 일정 시간(1초) 내에 다음 클릭이 없으면 횟수 초기화
					adminClickTimer = setTimeout(() => {
						adminClickCount = 0; 
					}, CLICK_INTERVAL_MS);

					// 5번을 클릭한 경우
					if (adminClickCount === TITLE_CLICK_THRESHOLD) {
						clearTimeout(adminClickTimer); // 타이머 초기화
						adminClickCount = 0; // 횟수 초기화

						alert("관리자 페이지로 이동합니다.");
						window.location.href = '/admin'; // 관리자 페이지로 이동
					}
				});
			}
		});
		
		// ***** '등록하기' 버튼을 눌렀을 때 *****
		async function handleRegisterButton(event) {
			event.preventDefault();
			
			try {
				// 로그인 여부 확인
				const response = await fetch('/api/auth/check', {
					method: 'GET',
					headers: {
						'Accept': 'application/json'
					}
				});
				
				// 로그인 여부가 확인된 경우에만 등록 폼으로 이동
				if (response.ok) {
					window.location.href = '/posts/register';
				} else if (response.status === 401) {
					const result = await response.json();
					alert(result.message);
					
					setTimeout(() => {
						window.location.href = '/login';
					}, 1500);
				}
					
			} catch (error) {
				alert("네트워크 오류가 발생했습니다.");
			}
        }
	</script>
</body>
</html>