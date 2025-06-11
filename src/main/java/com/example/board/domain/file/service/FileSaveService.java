package com.example.board.domain.file.service;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.UUID;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.example.board.domain.file.entity.File;
import com.example.board.domain.file.mapper.FileMapper;

@Service
public class FileSaveService {
	private final FileMapper fileMapper;
	private static final String FILE_NAME_PATTERN = "posts-%s-%s.%s";
	private final String uploadDir = "C:\\workspace\\files\\";

	public FileSaveService(FileMapper fileMapper) {
		this.fileMapper = fileMapper;

		try {
			Path uploadPath = Paths.get(uploadDir);

			// 디렉토리가 존재하지 않는 경우, 디렉터리를 생성한다.
			if (!Files.exists(uploadPath))
				Files.createDirectories(uploadPath);
		} catch (IOException e) {
			System.out.println(e.getMessage()); // TODO: 추후 로깅 처리
		}
	}

	private String getExtension(String fileName) {
		int indexOfComma = fileName.lastIndexOf('.');

		return fileName.substring(indexOfComma + 1);
	}

	private UUID createRandomUUID() {
		return UUID.randomUUID();
	}

	private String createNewFileName(long postId, MultipartFile multipartFile) {
		return FILE_NAME_PATTERN.formatted(postId, UUID.randomUUID(),
				getExtension(multipartFile.getOriginalFilename()));
	}

	private void saveFileInPath(MultipartFile multipartFile, String savedFileName) throws IOException {
		Path filePath = Paths.get(uploadDir, savedFileName);

		Files.copy(multipartFile.getInputStream(), filePath);
	}

	private void saveFileInDb(long postId, MultipartFile multipartFile, String savedFileName) {
		File file = new File(createRandomUUID(), postId, multipartFile.getOriginalFilename(), savedFileName, uploadDir);
		fileMapper.save(file);
	}

	public void add(long postId, List<MultipartFile> files) {
		try {
			for (MultipartFile multipartFile : files) {
				String savedFileName = createNewFileName(postId, multipartFile);

				saveFileInPath(multipartFile, savedFileName);
				saveFileInDb(postId, multipartFile, savedFileName);
			}
		} catch (IOException e) {
			System.out.println(e.getMessage()); // TODO: 추후 로깅 처리
		}

	}
}
