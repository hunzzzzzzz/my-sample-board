package com.example.board.domain.file.service;

import java.net.MalformedURLException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.UrlResource;
import org.springframework.stereotype.Service;

import com.example.board.domain.file.dto.response.FileDownloadResponse;
import com.example.board.domain.file.mapper.FileMapper;
import com.example.board.global.exception.FileStorageException;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class FileDownloadService {
	private FileMapper fileMapper;
	private final String uploadDir;

	private FileDownloadService(FileMapper fileMapper, @Value("${file.upload.dir}") String uploadDir) {
		this.fileMapper = fileMapper;
		this.uploadDir = uploadDir;
	}

	public FileDownloadResponse download(UUID fileId) {
		FileDownloadResponse file = fileMapper.getSavedFileName(fileId);

		try {
			if (file == null)
				throw new FileStorageException("존재하지 않는 파일입니다.");

			Path filePath = Paths.get(uploadDir, file.getSavedFileName());
			file.setResource(new UrlResource(filePath.toUri()));

			return file;
		} catch (MalformedURLException e) {
			log.error("잘못된 파일 경로입니다. {}", uploadDir, e);
		} catch (FileStorageException e) {
			log.error("존재하지 않는 파일입니다. fileId: " + fileId);
		}

		return null;
	}
}
