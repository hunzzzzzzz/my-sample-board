<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %> <%-- JSTL Core 태그 라이브러리 추가 --%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>게시글 등록</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: flex-start;
            min-height: 100vh;
            margin: 0;
            background-color: #f4f4f4;
        }
        .container {
            width: 80%;
            max-width: 800px;
            background-color: #fff;
            padding: 30px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            border-radius: 8px;
            margin-top: 50px;
        }
        h1 {
            text-align: center;
            color: #333;
            margin-bottom: 30px;
        }
        form div {
            margin-bottom: 15px;
        }
        form label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #555;
        }
        form input[type="text"],
        form textarea,
        form input[type="file"] {
            width: calc(100% - 22px);
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 16px;
        }
        form textarea {
            resize: vertical;
            min-height: 150px;
        }
        .button-group {
            text-align: right;
            margin-top: 20px;
        }
        .submit-button, .cancel-button {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            transition: background-color 0.3s ease;
        }
        .submit-button {
            background-color: #28a745;
            color: white;
            margin-left: 10px;
        }
        .submit-button:hover {
            background-color: #218838;
        }
        .cancel-button {
            background-color: #6c757d;
            color: white;
        }
        .cancel-button:hover {
            background-color: #5a6268;
        }
        /* 에러 메시지 스타일 */
        .error-message {
            color: #dc3545; /* 빨간색 */
            font-size: 0.9em;
            margin-top: 5px;
            margin-bottom: 10px;
        }
        .message-error { /* 컨트롤러에서 던지는 일반 에러 메시지 */
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
        <h1>게시글 등록</h1>

        <%-- 일반 에러 메시지 (컨트롤러 try-catch 블록 및 유효성 검사 실패 시 공통 메시지) --%>
        <c:if test="${not empty error}">
            <div class="message-error">
                <p>${error}</p>
            </div>
        </c:if>

        <%-- PostAddRequest 객체를 사용하여 입력 값 유지 --%>
        <form action="/posts" method="post" enctype="multipart/form-data">
            <div>
                <label for="title">제목:</label>
                <input type="text" id="title" name="title" required value="${request.title}">
                <%-- 제목 유효성 검사 에러 메시지 (개별적으로 처리) --%>
                <c:if test="${not empty titleError}">
                    <div class="error-message">
                        ${titleError}
                    </div>
                </c:if>
            </div>
            <div>
                <label for="author">작성자:</label>
                <input type="text" id="author" name="author" required value="${request.author}">
            </div>
            <div>
                <label for="content">내용:</label>
                <textarea id="content" name="content" required>${request.content}</textarea>
            </div>

            <div>
                <label for="attachments">첨부파일:</label>
                <input type="file" id="attachments" name="attachments" multiple>
            </div>

            <div class="button-group">
                <button type="button" class="cancel-button" onclick="location.href='/posts'">취소</button>
                <button type="submit" class="submit-button">등록</button>
            </div>
        </form>
    </div>
</body>
</html>