package com.example.board.domain.file.mapper;

import java.util.List;
import java.util.UUID;

import org.apache.ibatis.annotations.Mapper;

import com.example.board.domain.file.dto.response.FileDownloadResponse;
import com.example.board.domain.file.entity.File;

@Mapper
public interface FileMapper {
	void save(File file);

	FileDownloadResponse getSavedFileName(UUID fileId);

	List<String> getSavedFileNames(List<UUID> deletedFileIds);

	void deleteByFileIds(List<UUID> deletedFileIds);

}
