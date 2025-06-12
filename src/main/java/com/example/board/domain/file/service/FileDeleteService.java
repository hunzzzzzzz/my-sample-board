package com.example.board.domain.file.service;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.example.board.domain.file.mapper.FileMapper;
import com.example.board.global.exception.FileStorageException;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class FileDeleteService {
	private final FileMapper fileMapper;
	private final String uploadDir;

	public FileDeleteService(FileMapper fileMapper, @Value("${file.upload.dir}") String uploadDir) {
		this.fileMapper = fileMapper;
		this.uploadDir = uploadDir;
	}

	private void deleteFiles(List<UUID> deletedFileIds) {
		deleteFilesFromPath(deletedFileIds);
		deleteFilesFromDb(deletedFileIds);
	}

	private void deleteFilesFromPath(List<UUID> deletedFileIds) {
		List<String> getSavedFileNames = fileMapper.getSavedFileNames(deletedFileIds);

		getSavedFileNames.forEach((savedFileName) -> {
			try {
				Path filePath = Paths.get(uploadDir, savedFileName);
				boolean deleted = Files.deleteIfExists(filePath);

				if (!deleted)
					log.error("파일 삭제 실패: {}", savedFileName);
			} catch (IOException e) {
				log.error("파일 삭제 실패: {}", savedFileName, e);

				throw new FileStorageException("파일 삭제 실패: " + savedFileName);
			}
		});
	}

	private void deleteFilesFromDb(List<UUID> deletedFileIds) {
		fileMapper.deleteByFileIds(deletedFileIds);

	}

	public void delete(List<UUID> deletedFileIds) {
		deleteFiles(deletedFileIds);
	}
}
