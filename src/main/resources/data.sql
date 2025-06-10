BEGIN
    FOR i IN 1 .. 200 LOOP
        INSERT INTO t_board_post (
            title,
            content,
            author,
            view_count
        ) VALUES (
            '테스트 게시글 제목 ' || i,
            '이것은 ' || i || '번째 테스트 게시글의 내용입니다. Oracle 데이터베이스에 임시 데이터를 삽입하고 있습니다.',
            '테스트유저' || TRUNC(DBMS_RANDOM.VALUE(1, 10)), -- 테스트유저1 ~ 테스트유저9 랜덤 할당
            TRUNC(DBMS_RANDOM.VALUE(1, 1001)) -- 1부터 1000까지의 랜덤 값
        );
    END LOOP;
    COMMIT; -- 모든 변경사항을 영구적으로 저장
END;
/