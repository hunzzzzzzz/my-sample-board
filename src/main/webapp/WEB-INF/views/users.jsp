<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>유저 목록</title>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/ag-grid-community/styles/ag-theme-quartz.css">
<style>
#userGrid {
	height: 600px;
	width: 100%;
}

.container {
	width: 90%;
	max-width: 1200px;
	margin: 50px auto;
	padding: 20px;
	background-color: #fff;
	box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
	border-radius: 8px;
}

h1 {
	text-align: center;
	margin-bottom: 30px;
	color: #333;
}
</style>
</head>
<body>
	<div class="container">
		<h1>전체 유저 목록</h1>

		<div id="userGrid" class="ag-theme-quartz"></div>
	</div>

	<script
		src="https://cdn.jsdelivr.net/npm/ag-grid-community/dist/ag-grid-community.min.js"></script>

	<script>
        document.addEventListener('DOMContentLoaded', function() {
            const gridDiv = document.querySelector('#userGrid');

            // 컬럼 정의
            const columnDefs = [
                { headerName: "ID", field: "userId", sortable: true, filter: true, width: 250 },
                { headerName: "이메일", field: "email", sortable: true, filter: true, width: 200 },
                { headerName: "이름", field: "name", sortable: true, filter: true, width: 150 },
                { headerName: "가입일", field: "createdAt", sortable: true, filter: true, width: 200 },
                { headerName: "수정일", field: "updatedAt", sortable: true, filter: true, width: 200 }
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
            fetch('/api/admin/users')
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
                    console.error('Error fetching user data:', error);
                    alert('유저 목록을 불러오는 데 실패했습니다.');
                });
        });
    </script>
</body>
</html>