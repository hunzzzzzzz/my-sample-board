-- 시퀀스
CREATE SEQUENCE seq_t_board_like START WITH 1 INCREMENT BY 1 NOCACHE;

-- 시퀀스 트리거
CREATE OR REPLACE TRIGGER trg_board_like_id
BEFORE INSERT ON t_board_like
FOR EACH ROW
BEGIN
	:NEW.id := seq_t_board_like.NEXTVAL;
END;
/

-- 테이블 생성
CREATE TABLE t_board_like
(
   id NUMBER PRIMARY KEY,
   post_id NUMBER NOT NULL,
   user_id VARCHAR2 (36) NOT NULL,
   created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
   
   CONSTRAINT fk_like_post FOREIGN KEY (post_id) REFERENCES t_board_post (id) ON DELETE CASCADE,
   CONSTRAINT fk_like_user FOREIGN KEY (user_id) REFERENCES t_board_user (id) ON DELETE CASCADE
);