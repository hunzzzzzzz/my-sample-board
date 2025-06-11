package com.example.board.domain.post.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.board.domain.post.dto.request.PostUpdateRequest;
import com.example.board.domain.post.dto.response.PostDetailResponse;
import com.example.board.domain.post.dto.response.PostResponse;
import com.example.board.domain.post.entity.Post;
import com.example.board.domain.post.entity.SortCondition;

@Mapper
public interface PostMapper {
	int countAllPosts(String keyword);

	List<PostResponse> getAll(int pageSize, int offset, String keyword, SortCondition sort);

	PostDetailResponse get(long postId);

	void add(Post post);

	void update(long postId, PostUpdateRequest request);

	void delete(long postId, String deletedTitle);

}
