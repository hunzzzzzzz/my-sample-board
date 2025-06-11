CREATE TABLE t_board_file
(
   id VARCHAR2 (36) PRIMARY KEY,
   post_id NUMBER NOT NULL,
   original_file_name VARCHAR2 (255) NOT NULL,
   saved_file_name VARCHAR2 (100) NOT NULL UNIQUE,
   file_path VARCHAR2 (512) NOT NULL,
   CONSTRAINT fk_file_post FOREIGN KEY (post_id) REFERENCES t_board_post (id) ON DELETE CASCADE
);