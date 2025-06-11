package com.example.board.domain.file.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.board.domain.file.entity.File;

@Mapper
public interface FileMapper {
	void save(File file);

	List<String> getFileNames(long postId);
}
