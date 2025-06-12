<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<%-- Add this for string functions like startsWith, contains --%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%-- Add this for number formatting like file size --%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시글 <c:if test="${isEditMode}">수정</c:if><c:if
		test="${not isEditMode}">등록</c:if></title>
<link rel="stylesheet" href="/css/post-form.css">
</head>
<body>
	<div class="container">
		<h1>
			게시글
			<c:if test="${isEditMode}">수정</c:if>
			<c:if test="${not isEditMode}">등록</c:if>
		</h1>

		<div id="serverMessage" class="message" style="display: none;"></div>

		<form id="postForm"
			action="<c:if test="${isEditMode}">/posts/${postId}</c:if><c:if test="${not isEditMode}">/posts</c:if>"
			method="post" enctype="multipart/form-data">

			<c:if test="${isEditMode}">
				<input type="hidden" name="postId" value="${postId}">
			</c:if>

			<div>
				<label for="title">제목:</label> <input type="text" id="title"
					name="title" required value="${post.title}">
				<div id="titleError" class="error-message" style="display: none;"></div>
			</div>
			<div>
				<label for="author">작성자:</label> <input type="text" id="author"
					name="author" required
					value="<c:choose><c:when test="${not empty post.author}">${post.author}</c:when><c:otherwise>익명</c:otherwise></c:choose>">
				<div id="authorError" class="error-message" style="display: none;"></div>
			</div>
			<div>
				<label for="content">내용:</label>
				<textarea id="content" name="content" required>${post.content}</textarea>
				<div id="contentError" class="error-message" style="display: none;"></div>
			</div>

			<c:if test="${isEditMode}">
				<div class="existing-files-group">
					<label>기존 첨부 파일:</label>
					<div id="existingFiles">
						<c:if test="${not empty post.files}">
							<%-- 'post' object (e.g., PostResponse) must contain a 'files' list --%>
							<ul>
								<c:forEach var="file" items="${post.files}">
									<%-- ⭐ data-file-id 속성 추가 및 삭제 버튼 추가 ⭐ --%>
									<li data-file-id="${file.fileId}">
										<%-- SVG icon based on file type --%> <c:choose>
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
										</c:choose> <%-- Download link --%> <a href="/files/${file.fileId}"
										target="_blank"> <c:out value="${file.originalFileName}" />
									</a> <%-- File size display --%> <span class="file-size"> (<c:choose>
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
										<button type="button" class="remove-file-button"
											data-file-id="${file.fileId}">
											<img src="/icons/delete.png" alt="삭제" class="delete-icon">
										</button>
									</li>
								</c:forEach>
							</ul>
						</c:if>
						<c:if test="${empty post.files}">
							<p class="no-existing-files-message">첨부된 파일이 없습니다.</p>
						</c:if>
					</div>
				</div>
			</c:if>

			<div class="form-group">
				<label for="newFiles">새로운 첨부 파일:</label>
				<%-- ⭐ name="newFiles"로 변경 ⭐ --%>
				<input type="file" id="newFiles" name="files" class="form-control"
					multiple>
			</div>
			
			<%-- ⭐ 삭제할 파일 ID들을 위한 숨겨진 필드 추가 ⭐ --%>
			<input type="hidden" id="deletedFileIds" name="deletedFileIds" value="">

			<div class="button-group">
				<button type="button" class="cancel-button"
					onclick="location.href='/posts/${postId}'">취소</button>
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
            const isEditMode = ${isEditMode}; // JSP EL로 isEditMode 값 주입
            
            // ⭐ 삭제할 파일 ID들을 저장할 배열 ⭐
            const deletedFileUuids = [];
            const deletedFileIdsInput = document.getElementById('deletedFileIds');

            clearErrors(); // 페이지 로드 시 기존 에러 메시지 초기화
            clearServerMessage(); // 페이지 로드 시 기존 서버 메시지 초기화

            // ⭐ 삭제 버튼 클릭 이벤트 리스너 추가 ⭐
            if (isEditMode) {
                document.querySelectorAll('.remove-file-button').forEach(button => {
                    button.addEventListener('click', function() {
                        const fileIdToRemove = this.dataset.fileId; // data-file-id 속성에서 ID 가져오기
                        const listItem = this.closest('li'); // 해당 파일의 <li> 요소 찾기

                        if (confirm('이 파일을 정말 삭제하시겠습니까?')) {
                            // DOM에서 해당 파일 항목 제거
                            if (listItem) {
                                listItem.remove();
                            }
                            // 삭제할 파일 ID 배열에 추가
                            deletedFileUuids.push(fileIdToRemove);
                            console.log('삭제될 파일 ID:', deletedFileUuids);

                            // 만약 모든 파일이 삭제되면 "첨부된 파일이 없습니다." 메시지 표시
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

            postForm.addEventListener('submit', async function(event) {
                event.preventDefault(); // 폼의 기본 제출 동작 막기

                clearErrors(); // 새로운 제출 시 에러 메시지 초기화
                clearServerMessage(); // 새로운 제출 시 서버 메시지 초기화

                const form = event.target;
                const formData = new FormData(form); // 폼 데이터 객체 생성 (파일 포함 가능)

                // ⭐ 삭제할 파일 ID들을 FormData에 추가 ⭐
                if (deletedFileUuids.length > 0) {
                    // deletedFileIdsInput.value = deletedFileUuids.join(','); // 숨겨진 필드에 콤마로 구분된 문자열 저장
                    // FormData에 직접 추가하는 것이 더 유연합니다 (스프링이 List<UUID>로 바인딩하기 쉬움)
                    deletedFileUuids.forEach(uuid => {
                        formData.append('deletedFileIds', uuid);
                    });
                }
                
                // HTTP 메서드 설정: 등록 시 POST, 수정 시 PUT
                let httpMethod = 'POST';
                if (isEditMode) {
                    httpMethod = 'PUT'; // 수정 모드일 때는 PUT으로 설정
                }

                try {
                    const response = await fetch(form.action, {
                        method: httpMethod,
                        body: formData // FormData 객체는 Content-Type 헤더를 자동으로 multipart/form-data로 설정
                    });

                    const result = await response.json(); // 응답 본문을 JSON으로 파싱

                    if (response.ok) { // HTTP 상태 코드가 2xx인 경우 (성공)
                        displayServerMessage(result.message, 'success');
                        setTimeout(() => {
                            // 등록/수정 모두 완료 시 /posts로 리다이렉트
                            window.location.href = '/posts'; 
                        }, 1500); // 1.5초 후 이동
                    } else { // HTTP 상태 코드가 4xx, 5xx인 경우 (실패)
                        displayServerMessage(result.message, 'error');

                        if (response.status === 400 && result.errors) { // 유효성 검사 실패 (BAD_REQUEST)
                            displayFieldErrors(result.errors); // 필드별 에러 표시
                        }
                    }
                } catch (error) {
                    console.error('Error during fetch:', error);
                    displayServerMessage('네트워크 오류 또는 서버 응답 처리 중 문제가 발생했습니다. 개발자 도구 콘솔을 확인해주세요.', 'error');
                }
            });
        });

        // 모든 필드 에러 메시지 영역 초기화
        function clearErrors() {
            document.querySelectorAll('.error-message').forEach(el => {
                el.textContent = '';
                el.style.display = 'none';
            });
        }

        // 서버 메시지 영역 초기화
        function clearServerMessage() {
            const serverMessageDiv = document.getElementById('serverMessage');
            if (serverMessageDiv) {
                serverMessageDiv.textContent = '';
                serverMessageDiv.className = 'message'; // 클래스 초기화
                serverMessageDiv.style.display = 'none';
            }
        }

        // 필드별 에러 메시지 표시 (errors 객체는 {필드명: 메시지} 형태)
        function displayFieldErrors(errors) {
            for (const fieldName in errors) {
                const errorDiv = document.getElementById(fieldName + 'Error');
                if (errorDiv) {
                    errorDiv.textContent = errors[fieldName];
                    errorDiv.style.display = 'block';
                }
            }
        }

        // 서버 메시지 표시 (성공 또는 실패)
        function displayServerMessage(message, type) {
            const serverMessageDiv = document.getElementById('serverMessage');
            if (serverMessageDiv) {
                serverMessageDiv.textContent = message;
                serverMessageDiv.className = 'message-' + type; // CSS 클래스 변경 (예: message-success, message-error)
                serverMessageDiv.style.display = 'block';
            }
        }
    </script>
</body>
</html>