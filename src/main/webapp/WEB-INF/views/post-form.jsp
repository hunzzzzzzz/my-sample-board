<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>게시글 등록</title>
    <style>
        /* (이전과 동일한 스타일) */
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
        form textarea {
            width: calc(100% - 22px); /* padding 고려 */
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 16px;
        }
        form textarea {
            resize: vertical; /* 세로 크기 조절 가능 */
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
            background-color: #28a745; /* 초록색 */
            color: white;
            margin-left: 10px;
        }
        .submit-button:hover {
            background-color: #218838;
        }
        .cancel-button {
            background-color: #6c757d; /* 회색 */
            color: white;
        }
        .cancel-button:hover {
            background-color: #5a6268;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>게시글 등록</h1>
        <form action="/posts" method="post">
            <div>
                <label for="title">제목:</label>
                <input type="text" id="title" name="title" required>
            </div>
            <div>
                <label for="author">작성자:</label>
                <input type="text" id="author" name="author" required>
            </div>
            <div>
                <label for="content">내용:</label>
                <textarea id="content" name="content" required></textarea>
            </div>
            <div class="button-group">
                <button type="button" class="cancel-button" onclick="location.href='/posts'">취소</button>
                <button type="submit" class="submit-button">등록</button>
            </div>
        </form>
    </div>
</body>
</html>