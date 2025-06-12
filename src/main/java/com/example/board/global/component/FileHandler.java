package com.example.board.global.component;

import java.util.UUID;

import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

import com.example.board.global.exception.InvalidFileException;

@Component
public class FileHandler {
	private static final String FILE_NAME_PATTERN = "%s-%s-%s.%s";

	/**
	 * 파일명으로부터 확장자를 추출하는 메서드
	 *
	 * @param fileName 확장자를 추출할 파일명
	 * @return 파일의 확장자
	 */
	public String getExtension(String fileName) {
		int indexOfComma = fileName.lastIndexOf('.');

		return fileName.substring(indexOfComma + 1);
	}

	/**
	 * 업로드된 MultipartFile의 유효성을 검사하는 메서드
	 *
	 * @param file 유효성을 검사할 MultipartFile 객체
	 * @throws InvalidFileException 파일이 유효하지 않을 경우 발생
	 */
	public void validateFile(MultipartFile file) {
		if ((file == null) || !file.getOriginalFilename().contains(".") )
			throw new InvalidFileException("유효하지 않은 파일입니다.");
	}

	/**
	 * 파일 시스템에 저장될 새로운 파일명을 생성하는 메서드
	 *
	 * @param identifier 파일의 종류나 출처를 나타내는 식별자
	 * @param primaryKey 파일이 연결된 엔티티의 기본키
	 * @param fileId 고유한 파일 식별자 (UUID)
	 * @param multipartFile 원본 MultipartFile 객체 (확장자 추출에 사용)
	 * @return 생성된 새로운 파일명
	 */
	public String createNewFileName(
			String identifier, 
			long primaryKey, 
			UUID fileId, 
			MultipartFile multipartFile
	) {
		return FILE_NAME_PATTERN.formatted(
				identifier, 
				primaryKey,
				fileId,
				getExtension(multipartFile.getOriginalFilename()))
		;
	}
}
