<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>게시글 <c:if test="${isEditMode}">수정</c:if><c:if test="${not isEditMode}">등록</c:if></title>
    <style>
        /* (스타일은 이전과 동일) */
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
        .message-success {
            color: #0f5132;
            background-color: #d1e7dd;
            border: 1px solid #badbcc;
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
        <h1>게시글 <c:if test="${isEditMode}">수정</c:if><c:if test="${not isEditMode}">등록</c:if></h1>

        <div id="serverMessage" style="display: none;"></div>

        <form id="postForm"
              action="<c:if test="${isEditMode}">/posts/${postId}</c:if><c:if test="${not isEditMode}">/posts</c:if>"
              method="post" <%-- HTML form method는 여전히 'post'로 유지 --%>
              enctype="multipart/form-data">

            <c:if test="${isEditMode}">
                <input type="hidden" name="postId" value="${postId}">
                <%-- ⭐ _method hidden 필드는 이제 필요 없습니다. fetch API가 직접 메서드를 설정하기 때문입니다.
                     주석 처리하거나 삭제하세요.
                <input type="hidden" name="_method" value="PUT">
                --%>
            </c:if>

            <div>
                <label for="title">제목:</label>
                <input type="text" id="title" name="title" required value="${request.title}">
                <div id="titleError" class="error-message" style="display: none;"></div>
            </div>
            <div>
                <label for="author">작성자:</label>
                <input type="text" id="author" name="author" required
                       value="<c:choose><c:when test="${not empty request.author}">${request.author}</c:when><c:otherwise>익명</c:otherwise></c:choose>">
                <div id="authorError" class="error-message" style="display: none;"></div>
            </div>
            <div>
                <label for="content">내용:</label>
                <textarea id="content" name="content" required>${request.content}</textarea>
                <div id="contentError" class="error-message" style="display: none;"></div>
            </div>

            <div>
                <label for="attachments">첨부파일:</label>
                <input type="file" id="attachments" name="attachments" multiple>
            </div>

            <div class="button-group">
                <button type="button" class="cancel-button" onclick="location.href='/posts'">취소</button>
                <button type="submit" class="submit-button">
                    <c:if test="${isEditMode}">수정 완료</c:if><c:if test="${not isEditMode}">등록</c:if>
                </button>
            </div>
        </form>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const postForm = document.getElementById('postForm');
            // isEditMode 값을 JavaScript 변수로 가져옴
            // ${isEditMode}는 JSP EL이므로, true/false 문자열이 그대로 JavaScript 코드로 삽입됩니다.
            // 따라서 boolean 값으로 사용하려면 `== 'true'` 와 같은 비교를 하거나,
            // JSON.parse를 사용하는 것이 더 안전합니다. 여기서는 직접 주입되므로 문제 없습니다.
            const isEditMode = ${isEditMode};

            clearErrors();
            clearServerMessage();

            postForm.addEventListener('submit', async function(event) {
                event.preventDefault(); // 폼의 기본 제출 동작 막기

                clearErrors(); // 이전 에러 메시지 초기화
                clearServerMessage(); // 이전 서버 메시지 초기화

                const form = event.target;
                const formData = new FormData(form); // 폼 데이터 객체 생성 (파일 포함 가능)

                // ⭐ HTTP 메서드 설정: 등록 시 POST, 수정 시 PUT
                let httpMethod = 'POST'; // 기본값은 POST
                if (isEditMode) {
                    httpMethod = 'PUT'; // 수정 모드일 때는 PUT으로 설정
                }

                try {
                    const response = await fetch(form.action, {
                        method: httpMethod, // ⭐ 동적으로 설정된 HTTP 메서드 사용
                        body: formData // FormData 객체는 Content-Type 헤더를 자동으로 multipart/form-data로 설정
                    });

                    const result = await response.json(); // 응답 본문을 JSON으로 파싱

                    if (response.ok) { // HTTP 상태 코드가 2xx인 경우 (성공)
                        displayServerMessage(result.message, 'success');
                        setTimeout(() => {
                            if (isEditMode) {
                                // 수정 완료 시 상세 페이지로 이동
                                window.location.href = '/posts/' + ${postId}; // JavaScript에서 postId 변수 사용
                            } else {
                                // 등록 완료 시 목록 페이지로 이동
                                window.location.href = '/posts';
                            }
                        }, 1500); // 1.5초 후 이동
                    } else { // HTTP 상태 코드가 4xx, 5xx인 경우 (실패)
                        displayServerMessage(result.message, 'error');

                        if (response.status === 400 && result.errors) { // 유효성 검사 실패 (BAD_REQUEST)
                            displayFieldErrors(result.errors); // 필드별 에러 표시
                        }
                    }
                } catch (error) {
                    console.error('Error during fetch:', error);
                    // 네트워크 오류나 JSON 파싱 실패 등 예상치 못한 오류 발생 시
                    displayServerMessage('네트워크 오류 또는 서버 응답 처리 중 문제가 발생했습니다. 개발자 도구 콘솔을 확인해주세요.', 'error');
                }
            });
        });

        function clearErrors() {
            document.querySelectorAll('.error-message').forEach(el => {
                el.textContent = '';
                el.style.display = 'none';
            });
        }

        function clearServerMessage() {
            const serverMessageDiv = document.getElementById('serverMessage');
            if (serverMessageDiv) {
                serverMessageDiv.textContent = '';
                serverMessageDiv.className = '';
                serverMessageDiv.style.display = 'none';
            }
        }

        function displayFieldErrors(errors) {
            for (const fieldName in errors) {
                const errorDiv = document.getElementById(fieldName + 'Error');
                if (errorDiv) {
                    errorDiv.textContent = errors[fieldName];
                    errorDiv.style.display = 'block';
                }
            }
        }

        function displayServerMessage(message, type) {
            const serverMessageDiv = document.getElementById('serverMessage');
            if (serverMessageDiv) {
                serverMessageDiv.textContent = message;
                serverMessageDiv.className = 'message-' + type;
                serverMessageDiv.style.display = 'block';
            }
        }
    </script>
</body>
</html>