<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>삭제 게시글 목록</title>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/ag-grid-community/styles/ag-theme-quartz.css">
<style>
#deletedPostGrid {
	height: 600px;
	width: 100%;
}

.container {
	width: 90%;
	max-width: 1500px;
	margin: 50px auto;
	padding: 20px;
	background-color: #fff;
	box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
	border-radius: 8px;
	display: flex;
	flex-direction: column;
	align-items: center; /* 가로 가운데 정렬 */
}

h1 {
	text-align: center;
	margin-bottom: 30px;
	color: #333;
}

.navbar {
	background-color: #333;
	overflow: hidden;
	margin-bottom: 30px;
	border-radius: 8px;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.2);
}

.navbar ul {
	list-style-type: none;
	margin: 0;
	padding: 0;
	display: flex;
	justify-content: center;
}

.navbar li {
	float: left;
}

.navbar li a {
	display: block;
	color: white;
	text-align: center;
	padding: 14px 20px;
	text-decoration: none;
	font-size: 1.1em;
	transition: background-color 0.3s ease, color 0.3s ease;
}

.navbar li a:hover {
	background-color: #575757;
	color: #ffd700;
}

.navbar li a.active {
	background-color: #007bff;
	color: white;
	font-weight: bold;
}

.home-button {
	display: inline-block;
	padding: 12px 25px;
	margin-top: 30px;
	background-color: #28a745;
	color: white;
	border: none;
	border-radius: 8px;
	cursor: pointer;
	font-size: 1.1em;
	font-weight: bold;
	text-decoration: none;
	box-shadow: 0 4px 10px rgba(0, 0, 0, 0.15);
	transition: background-color 0.3s ease, transform 0.2s ease, box-shadow
		0.2s ease;
}

.home-button:hover {
	background-color: #218838;
	transform: translateY(-2px);
	box-shadow: 0 6px 15px rgba(0, 0, 0, 0.2);
}

.home-button:active {
	transform: translateY(0);
	box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
}
</style>
</head>
<body>
	<nav class="navbar">
		<ul>
			<li><a href="/admin/users" class="active">유저 목록</a></li>
			<li><a href="/admin/posts/deleted">삭제된 게시글 목록</a></li>
			<li><a href="/temp1">임시1</a></li>
			<li><a href="/temp2">임시2</a></li>
			<li><a href="/temp3">임시3</a></li>
		</ul>
	</nav>

	<div class="container">
		<h1>전체 삭제 게시글 목록</h1>

		<div id="deletedPostGrid" class="ag-theme-quartz"></div>

		<button id="goToHome" class="home-button">홈으로</button>
	</div>

	<script
		src="https://cdn.jsdelivr.net/npm/ag-grid-community/dist/ag-grid-community.min.js"></script>

	<script>
		// ***** 그리드 정의 *****
        document.addEventListener('DOMContentLoaded', function() {
            const gridDiv = document.querySelector('#deletedPostGrid');

            // 컬럼 정의
            const columnDefs = [
                { headerName: "ID", field: "postId", sortable: true, filter: true, width: 150 },
                { headerName: "제목", field: "title", sortable: true, filter: true, width: 400 },
                { headerName: "작성자", field: "author", sortable: true, filter: true, width: 200 },
                { headerName: "조회수", field: "viewCount", sortable: true, filter: true, width: 150 },
                { headerName: "좋아요수", field: "likeCount", sortable: true, filter: true, width: 150 },
                { headerName: "작성일", field: "formattedCreatedAt", sortable: false, filter: true, width: 200 }
            ];

            // 그리드 옵션 설정
            const gridOptions = {
                columnDefs: columnDefs,
                pagination: true,
                paginationPageSize: 10,
                paginationPageSizeSelector: [10, 20, 50],
                domLayout: 'autoHeight'
            };

            // Ag-Grid 생성
            const gridApi = agGrid.createGrid(gridDiv, gridOptions);

            // API 호출
            fetch('/api/admin/posts/deleted')
                .then(response => {
                    if (!response.ok) {
                        throw new Error(`HTTP error! status: ${response.status}`);
                    }
                    return response.json(); // 응답 본문을 JSON으로 파싱
                })
                .then(rowData => {
                    // 파싱된 JSON 데이터를 그리드에 설정
                    gridApi.setGridOption('rowData', rowData);
                })
                .catch(error => {
                    console.error('Error fetching deleted post data:', error);
                    alert('삭제된 게시글 목록을 불러오는 데 실패했습니다.');
                });
        });
		
		// ***** 내비게이션 바 활성화 여부 정의 *****
		const currentPath = window.location.pathname; // 현재 URI 경로
        const navLinks = document.querySelectorAll('.navbar li a'); // 링크 가져오기

		// active 속성 추가/제거
        navLinks.forEach(link => {
        	let uri = link.getAttribute('href') // href에 포함된 URI
        	
            if (currentPath === '/admin' && uri === '/admin/users') {
                link.classList.add('active'); // 어드민 페이지의 디폴트 내비게이션 = 유저 목록
            } else if (uri === currentPath) {
                link.classList.add('active'); // 해당 링크에 active 속성 추가
            } else {
                link.classList.remove('active'); // 다른 링크에 active 속성 제거
            }
        });
        
        // ***** '홈으로' 버튼을 눌렀을 때 *****
        const goToHomeButton = document.getElementById('goToHome');

        if (goToHomeButton) {
            goToHomeButton.addEventListener('click', function() {
                window.location.href = '/'; // 루트 경로로 이동
            });
        }
    </script>
</body>
</html>