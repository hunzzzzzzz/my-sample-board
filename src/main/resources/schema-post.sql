-- 시퀀스
CREATE SEQUENCE seq_t_board_post START WITH 1 INCREMENT BY 1 NOCACHE;

-- 시퀀스 트리거
CREATE OR REPLACE TRIGGER trg_board_post_id
BEFORE INSERT ON t_board_post
FOR EACH ROW
BEGIN
	:NEW.id := seq_t_board_post.NEXTVAL;
END;
/

-- 테이블 생성
CREATE TABLE t_board_post
(
   id NUMBER PRIMARY KEY,
   status VARCHAR2 (10) DEFAULT 'NORMAL' NOT NULL,
   title VARCHAR2 (255) NOT NULL,
   content CLOB NOT NULL,
   author VARCHAR2 (100) NOT NULL,
   view_count NUMBER DEFAULT 0 NOT NULL,
   like_count NUMBER DEFAULT 0 NOT NULL,
   created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
   updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
   CONSTRAINT check_post_status CHECK
   (
      status IN
      (
         'NORMAL',
         'DELETED'
      )
   )
);

-- 트리거 생성 (updated_at)
CREATE
OR REPLACE
   TRIGGER trg_board_post_updated_at BEFORE UPDATE ON t_board_post FOR EACH ROW BEGIN :NEW.updated_at := SYSTIMESTAMP;
END;
/