<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %> <%-- JSTL Core 태그 라이브러리 (조건문, 반복문 등) --%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>게시글 목록</title>
    <style>
        /* 기본 HTML 요소 스타일 */
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            display: flex; /* Flexbox를 사용하여 자식 요소 정렬 */
            justify-content: center; /* 수평 중앙 정렬 */
            align-items: flex-start; /* 수직 상단 정렬 (컨테이너가 페이지 상단에 위치) */
            min-height: 100vh; /* 뷰포트 높이만큼 최소 높이 설정하여 중앙 정렬이 잘 보이게 함 */
            margin: 0;
            background-color: #f0f2f5; /* 부드러운 배경색 */
            color: #333;
        }

        /* 메인 콘텐츠를 감싸는 컨테이너 스타일 */
        .container {
            width: 90%; /* 컨테이너 너비 */
            max-width: 1100px; /* 최대 너비 제한 */
            background-color: #ffffff;
            padding: 30px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08); /* 부드러운 그림자 */
            border-radius: 10px; /* 둥근 모서리 */
            margin-top: 60px; /* 상단 여백 */
            box-sizing: border-box; /* 패딩이 너비에 포함되도록 */
        }

        /* 제목 스타일 */
        h1 {
            text-align: center;
            color: #2c3e50;
            margin-bottom: 40px;
            font-size: 2.2em;
            font-weight: 600;
        }

        /* 게시글 목록 제목 링크 스타일 추가 */
        h1 a {
            text-decoration: none; /* 링크 기본 밑줄 제거 */
            color: inherit; /* 부모 요소(h1)의 색상 상속 */
            cursor: pointer;
        }
        h1 a:hover {
            color: #007bff; /* 호버 시 색상 변경 (선택 사항) */
        }


        /* 테이블 스타일 */
        table {
            width: 100%;
            border-collapse: collapse; /* 테이블 셀 경계 병합 */
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
        tr:nth-child(even) { /* 짝수 행 배경색 */
            background-color: #f8f9fa;
        }
        tr:hover { /* 마우스 오버 시 행 배경색 변경 */
            background-color: #f1f3f5;
            cursor: pointer;
        }

        /* 게시글 제목 링크 스타일 */
        td a {
            color: inherit; /* 부모 요소(td)의 색상 상속 (일반 텍스트 색상) */
            text-decoration: underline; /* 밑줄 유지 */
            cursor: pointer;
        }
        td a:hover {
            color: #007bff; /* 호버 시 파란색으로 변경 (선택 사항) */
            text-decoration: underline; /* 호버 시 밑줄 유지 */
        }


        /* 페이징 스타일 */
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
            min-width: 30px; /* 버튼 최소 너비 */
            text-align: center;
        }
        .pagination a:hover {
            background-color: #007bff;
            color: white;
            box-shadow: 0 2px 6px rgba(0, 123, 255, 0.2);
        }
        .pagination a.active {
            background-color: #0056b3; /* 활성 페이지 버튼 색상 */
            color: white;
            border: 1px solid #0056b3;
            font-weight: bold;
            box-shadow: 0 2px 6px rgba(0, 86, 179, 0.3);
        }

        /* '등록하기' 버튼 컨테이너 및 버튼 스타일 */
        .button-container {
            text-align: right; /* 우측 정렬 */
            margin-top: 25px; /* 상단 여백 */
        }
        .register-button {
            background-color: #28a745; /* 초록색 배경 */
            color: white;
            padding: 12px 25px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none; /* 링크 밑줄 제거 */
            font-size: 1em;
            font-weight: 500;
            transition: background-color 0.3s ease, transform 0.2s ease;
            box-shadow: 0 2px 6px rgba(40, 167, 69, 0.2);
        }
        .register-button:hover {
            background-color: #218838;
            transform: translateY(-2px); /* 호버 시 살짝 위로 */
        }
        .register-button:active {
            transform: translateY(0); /* 클릭 시 원위치 */
        }

        /* 메시지 (성공/실패) 스타일 */
        .message-success {
            color: #155724; /* 진한 초록색 텍스트 */
            background-color: #d4edda; /* 연한 초록색 배경 */
            border: 1px solid #c3e6cb; /* 초록색 테두리 */
            padding: 12px 20px;
            margin-bottom: 25px;
            border-radius: 6px;
            text-align: center;
            font-weight: 500;
            font-size: 0.95em;
        }
        .message-error {
            color: #721c24; /* 진한 빨간색 텍스트 */
            background-color: #f8d7da; /* 연한 빨간색 배경 */
            border: 1px solid #f5c6cb; /* 빨간색 테두리 */
            padding: 12px 20px;
            margin-bottom: 25px;
            border-radius: 6px;
            text-align: center;
            font-weight: 500;
            font-size: 0.95em;
        }

        /* 검색창 스타일 */
        .search-container {
            margin-bottom: 20px;
            display: flex; /* Flexbox 사용하여 입력창과 버튼 정렬 */
            gap: 10px; /* 요소들 사이 간격 */
            justify-content: flex-end; /* 우측 정렬 */
        }
        .search-input {
            flex-grow: 1; /* 최대한 넓게 늘어남 */
            padding: 10px 15px;
            border: 1px solid #ced4da;
            border-radius: 5px;
            font-size: 1em;
            max-width: 300px; /* 검색창 최대 너비 */
        }
        .search-button {
            background-color: #6c757d; /* 회색 버튼 */
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
            <a href="/posts">게시글 목록</a> <%-- h1 태그를 링크로 감싸서 클릭 시 새로고침 --%>
        </h1>

        <c:if test="${not empty message}">
            <div class="message-success">
                <p>${message}</p>
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="message-error">
                <p>${error}</p>
            </div>
        </c:if>

        <div class="search-container">
            <input type="text" id="searchKeyword" name="searchKeyword" class="search-input" placeholder="검색..."
                   value="${param.keyword != null ? param.keyword : ''}"> <%-- 현재 검색어 유지 --%>
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
                        <%-- 게시글 제목에 상세 페이지 링크 추가 --%>
                        <td><a href="/posts/${post.postId}">${post.title}</a></td>
                        <td>${post.author}</td>
                        <td>${post.viewCount}</td>
                        <td>${post.formattedCreatedAt}</td>
                    </tr>
                </c:forEach>
                <c:if test="${empty posts}">
                    <tr>
                        <td colspan="5" style="text-align: center; padding: 20px; color: #777;">게시글이 없습니다.</td>
                    </tr>
                </c:if>
            </tbody>
        </table>

        <div class="pagination">
            <%-- '이전' 버튼 --%>
            <c:if test="${currentPage > 1}">
                <a href="/posts?page=${currentPage - 1}<c:if test="${not empty param.keyword}">&keyword=${param.keyword}</c:if>">이전</a>
            </c:if>
            <%-- 현재 페이지 번호 --%>
            <a href="/posts?page=${currentPage}<c:if test="${not empty param.keyword}">&keyword=${param.keyword}</c:if>"
               class="active">${currentPage}</a>
            <%-- '다음' 버튼 (totalPages를 사용하여 정확히 제어) --%>
            <c:if test="${currentPage < totalPages}">
                <a href="/posts?page=${currentPage + 1}<c:if test="${not empty param.keyword}">&keyword=${param.keyword}</c:if>">다음</a>
            </c:if>
        </div>

        <div class="button-container">
            <a href="/posts/register" class="register-button">등록하기</a>
        </div>
    </div>

    <script>
        // 검색 버튼 클릭 시 호출될 JavaScript 함수
        function searchPosts() {
            const keyword = document.getElementById('searchKeyword').value;
            // 검색어를 쿼리 파라미터로 포함하여 게시글 목록 페이지로 이동
            // 검색 시 항상 첫 페이지로 이동합니다.
            window.location.href = '/posts?page=1&keyword=' + encodeURIComponent(keyword);
        }
    </script>
</body>
</html>