<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시글 <c:if test="${isEditMode}">수정</c:if><c:if test="${not isEditMode}">등록</c:if></title>
<link rel="stylesheet" href="/css/post-form.css">
</head>
<body>
	<div class="container">
		<!-- 제목 -->
		<h1>게시글
			<c:if test="${isEditMode}">수정</c:if>
			<c:if test="${not isEditMode}">등록</c:if>
		</h1>

		<!-- 서버 메시지가 출력되는 공간 -->
		<div id="serverMessage" class="message" style="display: none;"></div>

		<!-- 등록/수정 폼 -->
		<form id="postForm"
			action=
				"<c:if test="${isEditMode}">/posts/${post.postId}</c:if>
				<c:if test="${not isEditMode}">/posts</c:if>"
			method="post" 
			enctype="multipart/form-data">

			<c:if test="${isEditMode}">
				<input type="hidden" name="postId" value="${post.postId}">
			</c:if>

			<!-- 제목 -->
			<div>
				<label for="title">제목:</label> <input type="text" id="title"
					name="title" required value="${post.title}">
				<div id="titleError" class="error-message" style="display: none;"></div>
			</div>
			<!-- 작성자 -->
			<div>
				<label for="author">작성자:</label> <input type="text" id="author"
					name="author" required
					value="<c:choose><c:when test="${not empty post.author}">${post.author}</c:when><c:otherwise>익명</c:otherwise></c:choose>">
				<div id="authorError" class="error-message" style="display: none;"></div>
			</div>
			<!-- 내용 -->
			<div>
				<label for="content">내용:</label>
				<textarea id="content" name="content" required>${post.content}</textarea>
				<div id="contentError" class="error-message" style="display: none;"></div>
			</div>
			
			<!-- 기존 첨부 파일 목록 (수정 시에만 보여지는 요소) -->
			<c:if test="${isEditMode}">
				<div class="existing-files-group">
					<label>기존 첨부 파일:</label>
					<div id="existingFiles">
						<c:if test="${not empty post.files}">
							<ul>
								<!-- 기존 첨부 파일 목록 출력 -->
								<c:forEach var="file" items="${post.files}">
									<li data-file-id="${file.fileId}">
										<c:choose>
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
										</c:choose>
										<a href="/files/${file.fileId}" target="_blank">
											<c:out value="${file.originalFileName}" />
										</a>
										<span class="file-size">
											(<c:choose>
												<c:when test="${file.fileSize eq 0}">0KB</c:when>
												<c:when test="${file.fileSize ge (1024 * 1024)}">
													<fmt:formatNumber value="${file.fileSize / (1024 * 1024)}" pattern="#.#" />MB
                                                </c:when>
												<c:when test="${file.fileSize ge 1024}">
													<fmt:formatNumber value="${file.fileSize / 1024}" pattern="#.#" />KB
                                                </c:when>
												<c:otherwise>
													<c:out value="${file.fileSize}" />Bytes
                                                </c:otherwise>
											</c:choose>)
										</span>
										<button type="button" class="remove-file-button" data-file-id="${file.fileId}">
											<img src="/icons/delete.png" alt="삭제" class="delete-icon">
										</button>
									</li>
								</c:forEach>
							</ul>
						</c:if>
						<!-- 기존 첨부파일 목록이 존재하지 않는 경우 -->
						<c:if test="${empty post.files}">
							<p class="no-existing-files-message">첨부된 파일이 없습니다.</p>
						</c:if>
					</div>
				</div>
			</c:if>

			<!-- 첨부파일 추가 -->
			<div class="form-group">
				<label for="newFiles">새로운 첨부 파일:</label>
				<input type="file" id="newFiles" name="files" class="form-control" multiple>
			</div>
			
			<!-- 삭제하고자 하는 첨부파일의 id 목록을 담을 필드 -->
			<input type="hidden" id="deletedFileIds" name="deletedFileIds" value="">

			<!-- 버튼 목록 -->
			<div class="button-group">
				<button type="button" class="cancel-button" onclick="location.href='/posts/${post.postId}'">취소</button>
				<button type="submit" class="submit-button">
					<c:if test="${isEditMode}">수정 완료</c:if>
					<c:if test="${not isEditMode}">등록</c:if>
				</button>
			</div>
		</form>
	</div>

	<script>
        document.addEventListener('DOMContentLoaded', function() {
            const postForm = document.getElementById('postForm');
            const isEditMode = ${isEditMode};
            
            const deletedFileUuids = [];
            const deletedFileIdsInput = document.getElementById('deletedFileIds');

            // 페이지 로드 시 ,기존의 서버 메시지 제거
            clearErrors();
            clearServerMessage();

            // 수정 모드인 경우, '기존 첨부파일 삭제 버튼' 이벤트 추가
            if (isEditMode) {
                document.querySelectorAll('.remove-file-button').forEach(button => {
                    button.addEventListener('click', function() {
                        const fileIdToRemove = this.dataset.fileId;
                        const listItem = this.closest('li');

                        if (confirm('이 파일을 정말 삭제하시겠습니까?')) {
                            if (listItem) {
                                listItem.remove();
                            }
                            deletedFileUuids.push(fileIdToRemove);
                            console.log('삭제될 파일 ID:', deletedFileUuids);

                            const existingFilesList = document.querySelector('#existingFiles ul');
                            if (existingFilesList && existingFilesList.children.length === 0) {
                                const noFilesMessage = document.createElement('p');
                                noFilesMessage.className = 'no-existing-files-message';
                                noFilesMessage.textContent = '첨부된 파일이 없습니다.';
                                document.getElementById('existingFiles').appendChild(noFilesMessage);
                            }
                        }
                    });
                });
            }

            // 폼 제출 이벤트 처리
            postForm.addEventListener('submit', async function(event) {
                event.preventDefault();

                clearErrors();
                clearServerMessage();

                const form = event.target;
                const formData = new FormData(form);

                // 삭제하고자 하는 첨부파일이 있는 경우, 해당 파일의 id를 추가
                if (deletedFileUuids.length > 0) {
                    deletedFileUuids.forEach(uuid => {
                        formData.append('deletedFileIds', uuid);
                    });
                }
                
                // 등록인 경우 'POST' 방식, 수정인 경우 'PUT' 방식으로 요청 전송
                let httpMethod = 'POST';
                if (isEditMode) {
                    httpMethod = 'PUT';
                }

                try {
                	// API 호출
                    const response = await fetch(form.action, {
                        method: httpMethod,
                        body: formData
                    });

                	// 응답값 파싱
                    const result = await response.json();

                	// HTTP 상태 코드가 2xx인 경우 (성공)
                    if (response.ok) {
                    	// 성공 메시지 출력 후 1.5초 후 게시글 목록으로 리다이렉트
                        displayServerMessage(result.message, 'success');
                        setTimeout(() => {
                            window.location.href = '/posts'; 
                        }, 1500);
                    } 
                    // HTTP 상태 코드가 4xx, 5xx인 경우 (실패)
                    else {
                    	console.log(result.message);
						// 에러 메시지 출력                    	
                        displayServerMessage(result.message, 'error');

                        if (response.status === 400 && result.errors) {
                            displayFieldErrors(result.errors);
                        }
                    }
                } catch (error) {
                    console.error('Error during fetch:', error);
                    displayServerMessage('네트워크 오류 또는 서버 응답 처리 중 문제가 발생했습니다.', 'error');
                }
            });
        });

        // 서버 메시지 제거
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
                serverMessageDiv.className = 'message';
                serverMessageDiv.style.display = 'none';
            }
        }

        // 서버 메시지 출력
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