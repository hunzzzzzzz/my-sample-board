package com.example.board.domain.post.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.board.domain.post.dto.response.PostResponse;
import com.example.board.domain.post.entity.Post;

@Mapper
public interface PostMapper {
	List<PostResponse> getAll(int pageSize, int offset);

	void add(Post post);
	
	int countAllPosts();
}
