<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
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

.like-section {
	display: flex;
	align-items: center;
	justify-content: center; /* 가운데 정렬 */
	gap: 10px; /* 아이콘과 텍스트 사이 간격 */
	margin-top: 20px;
	margin-bottom: 20px;
	padding: 15px 0;
	border-top: 1px solid #e9ecef;
	border-bottom: 1px solid #e9ecef;
	background-color: #fcfcfc;
	border-radius: 8px;
}

.like-button {
	background: none;
	border: none;
	cursor: pointer;
	padding: 0;
	display: flex;
	align-items: center;
	font-size: 1.2em;
	color: #dc3545; /* 하트 색상 (빨간색) */
	transition: transform 0.2s ease;
}

.like-button:hover {
	transform: scale(1.1);
}

.like-icon {
	width: 28px; /* 아이콘 크기 조정 */
	height: 28px;
	margin-right: 5px;
	transition: fill 0.2s ease;
}

/* 좋아요가 눌러진 상태의 하트 색상 */
.like-icon.liked {
    fill: #dc3545; /* 빨간색 채우기 */
}

/* 좋아요가 눌러지지 않은 상태의 하트 색상 */
.like-icon.unliked {
    fill: #ccc; /* 회색 비움 */
}

.like-count {
	font-size: 1.2em;
	font-weight: bold;
	color: #333;
}

.file-list-group {
	margin-top: 30px;
	padding-top: 20px;
	border-top: 1px solid #e9ecef;
}

.file-list-group label {
	font-weight: bold;
	color: #2c3e50;
	margin-bottom: 15px;
	display: block;
	font-size: 1.1em;
}

#attachedFiles ul {
	list-style: none;
	padding: 0;
	margin: 0;
}

#attachedFiles li {
	background-color: #f0f0f0;
	border: 1px solid #e0e0e0;
	padding: 10px 15px;
	margin-bottom: 8px;
	border-radius: 6px;
	display: flex;
	align-items: center;
	gap: 10px;
	box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
}

.file-icon {
	width: 24px;
	height: 24px;
	flex-shrink: 0;
}

#attachedFiles li a {
	text-decoration: none;
	color: #007bff;
	font-weight: 600;
	flex-grow: 1;
}

#attachedFiles li a:hover {
	text-decoration: underline;
}

.file-size {
	color: #6c757d;
	font-size: 0.85em;
	white-space: nowrap;
}

.no-files-message {
	color: #6c757d;
	font-style: italic;
	padding: 10px 0;
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

/* JavaScript로 동적으로 표시할 메시지 스타일 */
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
	display: block;
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
	display: block;
}
</style>
</head>
<body>
	<div class="container">
		<%-- JavaScript로 동적으로 표시할 메시지 영역 --%>
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

        <%-- ⭐ 좋아요 섹션 추가 시작 ⭐ --%>
		<div class="like-section">
			<button type="button" id="likeButton" class="like-button">
				<img src="/icons/heart.svg" alt="좋아요" class="like-icon" id="heartIcon">
				<span id="likeCountDisplay">${post.likeCount}</span>
			</button>
		</div>
        <%-- ⭐ 좋아요 섹션 추가 끝 ⭐ --%>

		<div class="file-list-group">
			<label>첨부 파일</label>
			<div id="attachedFiles">
				<c:if test="${not empty post.files}">
					<ul>
						<c:forEach var="file" items="${post.files}">
							<li>
								<%-- 파일 타입에 따른 SVG 아이콘 --%> <c:choose>
									<c:when test="${fn:startsWith(file.fileType, 'image/')}">
										<img src="/icons/image.svg" alt="이미지 파일" class="file-icon">
									</c:when>
									<c:when test="${file.fileType eq 'application/pdf'}">
										<img src="/icons/pdf.svg" alt="PDF 파일" class="file-icon">
									</c:when>
									<c:when test="${fn:contains(file.fileType, 'wordprocess')}">
										<img src="/icons/word.svg" alt="워드 문서" class="file-icon">
									</c:when>
									<c:when
										test="${fn:contains(file.fileType, 'excel') || fn:contains(file.fileType, 'spreadsheet')}">
										<img src="/icons/excel.svg" alt="엑셀 문서" class="file-icon">
									</c:when>
									<c:when
										test="${fn:contains(file.fileType, 'powerpoint') || fn:contains(file.fileType, 'presentation')}">
										<img src="/icons/ppt.svg" alt="파워포인트 문서" class="file-icon">
									</c:when>
									<c:when
										test="${file.fileType eq 'application/zip' || file.fileType eq 'application/x-zip-compressed'}">
										<img src="/icons/zip.svg" alt="압축 파일" class="file-icon">
									</c:when>
									<c:otherwise>
										<img src="/icons/file.svg" alt="기타 파일" class="file-icon">
									</c:otherwise>
								</c:choose> <%-- 다운로드 링크 --%> <a href="/files/${file.fileId}"
								target="_blank"> <c:out value="${file.originalFileName}" />
							</a> <%-- 파일 크기 표시 (fmt:formatNumber 사용) --%> <span class="file-size">
									(<c:choose>
										<c:when test="${file.fileSize eq 0}">
											0KB
										</c:when>
										<c:when test="${file.fileSize ge (1024 * 1024)}">
											<fmt:formatNumber value="${file.fileSize / (1024 * 1024)}"
												pattern="#.#" />MB
										</c:when>
										<c:when test="${file.fileSize ge 1024}">
											<fmt:formatNumber value="${file.fileSize / 1024}"
												pattern="#.#" />KB
										</c:when>
										<c:otherwise>
											<c:out value="${file.fileSize}" />Bytes
										</c:otherwise>
									</c:choose>)
							</span>
							</li>
						</c:forEach>
					</ul>
				</c:if>
				<c:if test="${empty post.files}">
					<p class="no-files-message">첨부 파일이 없습니다.</p>
				</c:if>
			</div>
		</div>
		<div class="button-group">
			<a href="/posts/edit/${post.postId}"
				class="action-button edit-button">수정</a>
			<button type="button" class="action-button delete-button"
				onclick="deletePost(${post.postId})">삭제</button>
			<a href="/posts" class="action-button back-button">목록으로</a>
		</div>
	</div>

	<script>
        const currentPostId = ${post.postId};
        let isLiked = false; // 현재 사용자의 좋아요 상태 (서버에서 받아옴)
        const heartIcon = document.getElementById('heartIcon');
        const likeCountDisplay = document.getElementById('likeCountDisplay');
        const likeButton = document.getElementById('likeButton');

        // 좋아요 버튼 UI 업데이트 함수
        function updateLikeButtonUI() {
            if (isLiked) {
                heartIcon.classList.add('liked');
                heartIcon.classList.remove('unliked');
            } else {
                heartIcon.classList.add('unliked');
                heartIcon.classList.remove('liked');
            }
        }

        // 페이지 로드 시 현재 사용자의 좋아요 상태를 서버에서 확인
        async function checkInitialLikeStatus() {
            try {
                const response = await fetch('/posts/' + currentPostId + '/like/check');
                const result = await response.json(); // SuccessResponse 파싱

                if (response.ok) {
                    isLiked = result.value; // SuccessResponse의 두번째 값(value)이 boolean hasLike
                    updateLikeButtonUI(); // UI 업데이트
                } else {
                    console.error('좋아요 상태를 가져오는 데 실패했습니다:', result.message);
                    displayDynamicMessage('좋아요 상태를 불러오는 데 실패했습니다.', 'error');
                }
            } catch (error) {
                console.error('좋아요 상태 API 호출 중 오류 발생:', error);
                displayDynamicMessage('네트워크 오류로 좋아요 상태를 불러올 수 없습니다.', 'error');
            }
        }

        // 좋아요 토글 기능
        likeButton.addEventListener('click', async () => {
            try {
                let url = '/posts/' + currentPostId + '/like';
                let method;

                if (isLiked) {
                    method = 'DELETE'; // 좋아요 취소
                } else {
                    method = 'POST'; // 좋아요 추가
                }

                const response = await fetch(url, {
                    method: method,
                    headers: {
                        'Content-Type': 'application/json'
                    }
                    // POST/DELETE 요청이지만, 현재 컨트롤러는 @RequestBody를 사용하지 않으므로 body는 비워둡니다.
                    // 만약 나중에 userId를 함께 보내야 한다면 body에 JSON.stringify({ userId: '...' }) 추가
                });

                const result = await response.json(); // SuccessResponse 파싱

                if (response.ok) {
                    isLiked = !isLiked; // 좋아요 상태 토글
                    updateLikeButtonUI(); // UI 업데이트

                    // 좋아요 개수 업데이트 (서버에서 최신 좋아요 개수를 받아오는 것이 가장 정확)
                    // 현재 컨트롤러는 업데이트된 좋아요 수를 반환하지 않으므로, 클라이언트에서만 1 증가/감소시킵니다.
                    let currentLikeCount = parseInt(likeCountDisplay.textContent);
                    if (isLiked) {
                        likeCountDisplay.textContent = currentLikeCount + 1;
                        displayDynamicMessage(result.message, 'success');
                    } else {
                        likeCountDisplay.textContent = currentLikeCount - 1;
                        displayDynamicMessage(result.message, 'success');
                    }
                } else {
                    displayDynamicMessage(result.message || '좋아요 처리 중 오류가 발생했습니다.', 'error');
                    console.error('좋아요 처리 실패:', result);
                }
            } catch (error) {
                console.error('좋아요 토글 오류:', error);
                displayDynamicMessage('네트워크 오류 또는 서버 응답 처리 중 문제가 발생했습니다.', 'error');
            }
        });

        // 페이지 로드 시 초기 좋아요 상태 확인 함수 호출
        document.addEventListener('DOMContentLoaded', checkInitialLikeStatus);


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
                        // result.message에서 서버가 보낸 에러 메시지를 가져와 표시
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