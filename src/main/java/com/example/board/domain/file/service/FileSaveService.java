package com.example.board.domain.file.service;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.example.board.domain.file.entity.File;
import com.example.board.domain.file.mapper.FileMapper;
import com.example.board.global.component.FileHandler;
import com.example.board.global.exception.file.FileStorageException;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class FileSaveService {
	private final FileHandler fileHandler;
	private final FileMapper fileMapper;
	private final String uploadDir;

	/**
	 * 파일 업로드 디렉터리가 존재하는지 확인하고, 없으면 생성하는 메서드
	 * 디렉터리 생성에 실패할 경우 {@link FileStorageException}을 발생
	 */
	public void checkIfDirectoryExists() {
		try {
			Path uploadPath = Paths.get(uploadDir);

			if (!Files.exists(uploadPath)) {
				Files.createDirectories(uploadPath);

				log.info("디렉터리 생성: {}", uploadDir);
			}
		} catch (IOException e) {
			log.error("디렉터리 생성 실패: {}", uploadDir, e);

			throw new FileStorageException("디렉터리 생성 실패: " + uploadDir);
		}
	}

	/**
	 * FileSaveService의 생성자
	 */
	public FileSaveService(
			FileHandler fileHandler, 
			FileMapper fileMapper,
			@Value("${file.upload.dir}") String uploadDir
	) {
		this.fileHandler = fileHandler;
		this.fileMapper = fileMapper;
		this.uploadDir = uploadDir;
		
		// 디렉터리 존재여부 확인
		checkIfDirectoryExists();
	}

	/**
	 * 단일 MultipartFile을 저장하는 내부 메서드
	 * MultipartFile을 파일 시스템과 데이터베이스에 저장
	 *
	 * @param postId                파일이 연관될 게시글의 ID
	 * @param multipartFile         저장할 MultipartFile 객체
	 * @throws FileStorageException 파일 저장 중 예외 발생 시
	 */
	private void saveFile(long postId, MultipartFile multipartFile) {
		try {
			// 검증
			fileHandler.validateFileExtension(multipartFile);

			// 파일명 생성
			UUID fileId = UUID.randomUUID();
			String savedFileName = fileHandler.createNewFileName("posts", postId, fileId, multipartFile);

			// 저장
			saveFileInPath(multipartFile, savedFileName);
			saveFileInDb(postId, fileId, multipartFile, savedFileName);
		} catch (IOException e) {
			log.error("파일 저장 실패: {}", postId, e);

			throw new FileStorageException("파일 저장 실패: " + multipartFile.getOriginalFilename());
		}

	}

	/**
	 * MultipartFile을 지정된 경로에 물리적으로 저장하는 메서드
	 *
	 * @param multipartFile 저장할 MultipartFile 객체
	 * @param savedFileName 파일 시스템에 저장될 파일명
	 * @throws IOException  파일 쓰기 중 발생할 수 있는 예외
	 */
	private void saveFileInPath(MultipartFile multipartFile, String savedFileName) throws IOException {
		Path filePath = Paths.get(uploadDir, savedFileName);

		Files.copy(
				multipartFile.getInputStream(), 
				filePath
		);
	}

	/**
	 * 파일 정보를 데이터베이스에 저장하는 메서드
	 *
	 * @param postId        파일이 연관될 게시글의 ID
	 * @param fileId        파일의 고유 UUID
	 * @param multipartFile 원본 MultipartFile 객체
	 * @param savedFileName 파일 시스템에 저장된 파일명
	 */
	private void saveFileInDb(long postId, UUID fileId, MultipartFile multipartFile, String savedFileName) {
		File file = File.builder()
				.fileId(fileId)
				.postId(postId)
				.originalFileName(multipartFile.getOriginalFilename())
				.savedFileName(savedFileName)
				.path(uploadDir)
				.fileSize(multipartFile.getSize())
				.fileType(multipartFile.getContentType())
				.build();

		fileMapper.save(file);
	}

	/**
	 * 여러 개의 첨부 파일을 저장하는 메서드
	 * 파일이 존재하지 않으면 아무 작업도 수행하지 않고 메서드를 종료
	 *
	 * @param postId 파일이 연관될 게시글의 ID
	 * @param files  저장할 MultipartFile 목록
	 */
	public void save(long postId, List<MultipartFile> files) {
		// 첨부파일이 존재하지 않는 경우 해당 메서드 종료
		if (!fileHandler.hasFiles(files)) return;
		
		// 파일 저장
		files.forEach((file) -> saveFile(postId, file));
	}
}
