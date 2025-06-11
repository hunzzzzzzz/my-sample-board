<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시글 상세 보기</title>
<style>
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
	max-width: 900px;
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
	min-height: 200px;
	white-space: pre-wrap;
	word-wrap: break-word;
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
	background-color: #007bff;
	color: white;
}

.edit-button:hover {
	background-color: #0056b3;
	transform: translateY(-2px);
}

.delete-button {
	background-color: #dc3545;
	color: white;
}

.delete-button:hover {
	background-color: #c82333;
	transform: translateY(-2px);
}

.back-button {
	background-color: #6c757d;
	color: white;
}

.back-button:hover {
	background-color: #5a6268;
	transform: translateY(-2px);
}

/* 기존 메시지 스타일 활용 */
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
	display: block; /* 기본적으로는 block으로 표시 */
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
	display: block; /* 기본적으로는 block으로 표시 */
}
/* JavaScript에서 메시지를 숨길 때 사용할 클래스 */
.hidden-message {
	display: none !important;
}
</style>
</head>
<body>
	<div class="container">
		<%-- 기존 메시지 표시 영역: JSP에서 전달받은 message/error --%>
		<c:if test="${not empty message}">
			<div id="initialSuccessMessage" class="message-success">
				<p>${message}</p>
			</div>
		</c:if>
		<c:if test="${not empty error}">
			<div id="initialErrorMessage" class="message-error">
				<p>${error}</p>
			</div>
		</c:if>

		<%-- ⭐ JavaScript로 동적으로 표시할 메시지 영역 --%>
		<div id="dynamicMessage" style="display: none;">
			<p></p>
		</div>


		<h1>${post.title}</h1>

		<div class="post-info">
			<span>작성자: ${post.author}</span> <span>조회수: ${post.viewCount}</span>
			<span>작성일: ${post.formattedCreatedAt}</span>
			<c:if test="${post.isUpdated}">
				<span>(수정됨: ${post.formattedUpdatedAt})</span>
			</c:if>
		</div>

		<div class="post-content">${post.content}</div>

		<div class="button-group">
			<a href="/posts/edit/${postId}" class="action-button edit-button">수정</a>
			<button type="button" class="action-button delete-button"
				onclick="deletePost(${postId})">삭제</button>
			<a href="/posts" class="action-button back-button">목록으로</a>
		</div>
	</div>

	<script>
        document.addEventListener('DOMContentLoaded', function() {
            // 페이지 로드 시 기존 메시지 (if any)를 1.5초 후 숨김
            const initialSuccessMessage = document.getElementById('initialSuccessMessage');
            const initialErrorMessage = document.getElementById('initialErrorMessage');

            if (initialSuccessMessage) {
                setTimeout(() => {
                    initialSuccessMessage.classList.add('hidden-message');
                }, 1500);
            }
            if (initialErrorMessage) {
                setTimeout(() => {
                    initialErrorMessage.classList.add('hidden-message');
                }, 1500);
            }
        });


        // JavaScript로 동적으로 메시지를 표시하는 함수
        function displayDynamicMessage(message, type) {
            const dynamicMessageDiv = document.getElementById('dynamicMessage');
            const messageParagraph = dynamicMessageDiv.querySelector('p');

            // 기존 클래스 제거 및 새로운 클래스 추가
            dynamicMessageDiv.className = ''; // 모든 클래스 초기화
            dynamicMessageDiv.classList.add('message-' + type);
            messageParagraph.textContent = message;
            dynamicMessageDiv.style.display = 'block'; // 메시지 표시

            // 일정 시간 후 메시지 자동 숨김
            setTimeout(() => {
                dynamicMessageDiv.style.display = 'none';
                dynamicMessageDiv.className = ''; // 클래스 초기화
                messageParagraph.textContent = '';
            }, 3000); // 3초 후 숨김
        }

        // 게시글 삭제를 처리하는 Fetch API 함수
        async function deletePost(postId) {
            if (confirm('정말로 이 게시글을 삭제하시겠습니까?')) {
                try {
                    const response = await fetch('/posts/' + postId, {
                        method: 'DELETE', // DELETE 메서드 사용
                        headers: {
                            'Content-Type': 'application/json' // 서버가 JSON 응답을 보내므로 명시해주는 것이 좋습니다.
                        }
                    });

                    // 응답 본문을 JSON으로 파싱 (SuccessResponse 객체)
                    const result = await response.json();

                    if (response.ok) { // HTTP 상태 코드가 2xx인 경우 (성공)
                        displayDynamicMessage(result.message, 'success'); // 성공 메시지 표시
                        // 1.5초 후 게시글 목록 페이지로 이동
                        setTimeout(() => {
                            window.location.href = '/posts';
                        }, 1500);
                    } else {
                        // 응답이 에러(4xx, 5xx 등)인 경우
                        // result.message에서 서버가 보낸 에러 메시지(ErrorResponse)를 가져와 표시
                        displayDynamicMessage(result.message || '게시글 삭제에 실패했습니다. 알 수 없는 오류.', 'error');
                        // 필요에 따라 더 상세한 에러 처리 (예: console.error(result.errors))
                    }
                } catch (error) {
                    console.error('삭제 실패:', error);
                    displayDynamicMessage('네트워크 오류 또는 서버 응답 처리 중 문제가 발생했습니다.', 'error');
                }
            }
        }
    </script>
</body>
</html>