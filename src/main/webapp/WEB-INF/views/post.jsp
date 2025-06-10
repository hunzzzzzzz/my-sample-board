<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>게시글 상세 보기</title>
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
            max-width: 900px; /* 상세 페이지는 목록보다 약간 좁게 */
            background-color: #ffffff;
            padding: 40px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            border-radius: 10px;
            margin-top: 60px;
            box-sizing: border-box;
        }

        h1 {
            text-align: center;
            color: #2c3e50;
            margin-bottom: 30px;
            font-size: 2.5em;
            font-weight: 700;
            border-bottom: 2px solid #e0e0e0;
            padding-bottom: 15px;
        }

        .post-info {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 1px solid #e9ecef;
            color: #6c757d;
            font-size: 0.95em;
        }

        .post-info span {
            margin-right: 20px;
        }

        .post-content {
            background-color: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 8px;
            padding: 25px;
            margin-bottom: 30px;
            line-height: 1.8;
            color: #495057;
            min-height: 200px; /* 내용 영역 최소 높이 */
            white-space: pre-wrap; /* 줄 바꿈 유지 */
            word-wrap: break-word; /* 긴 단어 강제 줄 바꿈 */
        }

        .button-group {
            text-align: center;
            margin-top: 30px;
        }

        .action-button {
            display: inline-block;
            padding: 12px 25px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            font-size: 1em;
            font-weight: 500;
            transition: all 0.3s ease;
            margin: 0 8px;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
        }

        .edit-button {
            background-color: #007bff; /* 파란색 */
            color: white;
        }
        .edit-button:hover {
            background-color: #0056b3;
            transform: translateY(-2px);
        }

        .delete-button {
            background-color: #dc3545; /* 빨간색 */
            color: white;
        }
        .delete-button:hover {
            background-color: #c82333;
            transform: translateY(-2px);
        }

        .back-button {
            background-color: #6c757d; /* 회색 */
            color: white;
        }
        .back-button:hover {
            background-color: #5a6268;
            transform: translateY(-2px);
        }

        .message-success {
            color: #155724;
            background-color: #d4edda;
            border: 1px solid #c3e6cb;
            padding: 12px 20px;
            margin-bottom: 25px;
            border-radius: 6px;
            text-align: center;
            font-weight: 500;
            font-size: 0.95em;
        }
        .message-error {
            color: #721c24;
            background-color: #f8d7da;
            border: 1px solid #f5c6cb;
            padding: 12px 20px;
            margin-bottom: 25px;
            border-radius: 6px;
            text-align: center;
            font-weight: 500;
            font-size: 0.95em;
        }
    </style>
</head>
<body>
    <div class="container">
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

        <h1>${post.title}</h1>

        <div class="post-info">
            <span>작성자: ${post.author}</span>
            <span>조회수: ${post.viewCount}</span>
            <span>작성일: ${post.formattedCreatedAt}</span>
            <c:if test="${post.isUpdated}">
                <span>(수정됨: ${post.updatedAt})</span>
            </c:if>
        </div>

        <div class="post-content">${post.content}</div>

        <div class="button-group">
            <a href="/posts/edit/${post.postId}" class="action-button edit-button">수정</a>
            <button type="button" class="action-button delete-button" onclick="deletePost(${post.postId})">삭제</button>
            <a href="/posts" class="action-button back-button">목록으로</a>
        </div>
    </div>

    <script>
        function deletePost(postId) {
            if (confirm('정말로 이 게시글을 삭제하시겠습니까?')) {
                // DELETE 요청을 보내기 위한 폼 생성 및 제출
                const form = document.createElement('form');
                form.action = '/posts/' + postId; // 예: /posts/123
                form.method = 'post';
                form.style.display = 'none';

                // HTTP DELETE 메서드를 위한 Hidden 필드 추가 (Spring MVC에서 _method=DELETE 인식)
                const methodField = document.createElement('input');
                methodField.setAttribute('type', 'hidden');
                methodField.setAttribute('name', '_method');
                methodField.setAttribute('value', 'DELETE');
                form.appendChild(methodField);

                document.body.appendChild(form);
                form.submit();
            }
        }
    </script>
</body>
</html>