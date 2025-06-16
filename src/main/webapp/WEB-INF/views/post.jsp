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
<link rel="stylesheet" href="/css/post.css">
</head>
<body>
	<div class="container">
		<!-- 서버 메시지가 출력될 공간 -->
		<div id="dynamicMessage" style="display: none;">
			<p></p>
		</div>

		<!-- 제목 -->
		<h1>${post.title}</h1>

		<!-- 게시글 기본 정보 -->
		<div class="post-info">
			<span>작성자: ${post.author}</span> <span>조회수: ${post.viewCount}</span>
			<span>작성일: ${post.formattedCreatedAt}</span>
			<c:if test="${post.isUpdated}">
				<span>(수정됨: ${post.formattedUpdatedAt})</span>
			</c:if>
		</div>

		<!-- 내용 -->
		<div class="post-content">${post.content}</div>

		<!-- 좋아요 버튼 -->
		<div class="like-section">
			<button type="button" id="likeButton" class="like-button">
				<img src="/icons/empty-heart.svg" alt="좋아요" class="like-icon"
					id="heartIcon"> <span id="likeCountDisplay">${post.likeCount}</span>
			</button>
		</div>

		<div class="file-list-group">
			<label>첨부 파일</label>
			<!-- 사용자가 업로드한 첨부파일 목록 조회 -->
			<div id="attachedFiles">
				<c:if test="${not empty post.files}">
					<ul>
						<c:forEach var="file" items="${post.files}">
							<li>
								<!-- 파일 종류 별 아이콘 --> <c:choose>
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
								</c:choose> <!-- 파일명 (클릭 시 해당 파일 다운로드 API 호출) --> <a
								href="/files/${file.fileId}" target="_blank"> <c:out
										value="${file.originalFileName}" />
							</a> <!-- 파일 크기 계산 --> <span class="file-size"> (<c:choose>
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
				<!-- 첨부파일이 없는 경우 -->
				<c:if test="${empty post.files}">
					<p class="no-files-message">첨부 파일이 없습니다.</p>
				</c:if>
			</div>
		</div>
		<!-- 수정, 삭제, 목록으로 버튼 -->
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
        
        // ***** 현재 게시글에 대한 좋아요 여부 확인 *****
        let isLiked = false;
        const heartIcon = document.getElementById('heartIcon');
        const likeCountDisplay = document.getElementById('likeCountDisplay');
        const likeButton = document.getElementById('likeButton');

        // 페이지 로드 시 현재 게시글에 대한 좋아요 여부를 확인하기 위해 API 호출
		document.addEventListener('DOMContentLoaded', checkInitialLikeStatus);

        async function checkInitialLikeStatus() {
            try {
                const response = await fetch('/posts/' + currentPostId + '/like/check');
                const result = await response.json();

                if (response.ok) {
                    isLiked = result.value;
                    updateLikeButtonUI();
                }
            } catch (error) {
                console.error('좋아요 상태 API 호출 중 오류 발생:', error);
                displayDynamicMessage('네트워크 오류로 좋아요 상태를 불러올 수 없습니다.', 'error');
            }
        }
        
        // 좋아요 여부에 따라 '좋아요 버튼의 UI'를 변경
        function updateLikeButtonUI() {
            if (isLiked) {
                heartIcon.src = "/icons/heart.svg";
                heartIcon.classList.add('liked');
                heartIcon.classList.remove('unliked');
            } else {
                heartIcon.src = "/icons/empty-heart.svg";
                heartIcon.classList.add('unliked');
                heartIcon.classList.remove('liked');
            }
        }
        
        // 좋아요 버튼을 클릭했을 때
        likeButton.addEventListener('click', async () => {
            try {
                let url = '/posts/' + currentPostId + '/like'; // URL
                let method; // HTTP Method

				// HTTP Method 세팅
                if (isLiked) {
                    method = 'DELETE';
                } else {
                    method = 'POST';
                }

                // API 요청
                const response = await fetch(url, {
                    method: method,
                    headers: {
                        'Content-Type': 'application/json'
                    }
                });

                // 결과 확인
                const result = await response.json();

                if (response.ok) {
                    isLiked = !isLiked;
                    updateLikeButtonUI();

                    // 좋아요 수 변경
                    let currentLikeCount = parseInt(likeCountDisplay.textContent);
                    if (isLiked) {
                        likeCountDisplay.textContent = currentLikeCount + 1;
                        displayDynamicMessage(result.message, 'success');
                    } else {
                        likeCountDisplay.textContent = currentLikeCount - 1;
                        displayDynamicMessage(result.message, 'success');
                    }
                }
            } catch (error) {
                console.error('좋아요 토글 오류:', error);
                displayDynamicMessage('네트워크 오류 또는 서버 응답 처리 중 문제가 발생했습니다.', 'error');
            }
        });

        // ***** 서버 메시지 출력 *****
        function displayDynamicMessage(message, type) {
            const dynamicMessageDiv = document.getElementById('dynamicMessage');
            const messageParagraph = dynamicMessageDiv.querySelector('p');

            // 기존 클래스 제거 후 재세팅
            dynamicMessageDiv.className = '';
            dynamicMessageDiv.classList.add('message-' + type);
            messageParagraph.textContent = message;
            dynamicMessageDiv.style.display = 'block';

            // 3초 후 메시지 자동 숨김 + 클래스 초기화
            setTimeout(() => {
                dynamicMessageDiv.style.display = 'none';
                dynamicMessageDiv.className = '';
                messageParagraph.textContent = '';
            }, 3000);
        }
		
        // ***** 게시글 삭제 *****
        async function deletePost(postId) {
            if (confirm('정말로 이 게시글을 삭제하시겠습니까?')) {
                try {
                	// API 요청
                    const response = await fetch('/posts/' + postId, {
                        method: 'DELETE',
                        headers: {
                            'Content-Type': 'application/json'
                        }
                    });

                    const result = await response.json();

                    // 결과값 확인
                    if (response.ok) {
                        displayDynamicMessage(result.message, 'success');
                        setTimeout(() => {
                            window.location.href = '/posts';
                        }, 1500); // 1.5초 후 메인 페에지로 이동
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