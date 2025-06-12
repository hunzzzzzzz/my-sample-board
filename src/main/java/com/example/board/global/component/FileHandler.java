package com.example.board.global.component;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

import com.example.board.global.exception.file.InvalidFileException;

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
	
	public boolean hasFiles(List<MultipartFile> files) {
		if (files == null) return false;
		
		List<MultipartFile> actualFiles = files.stream().filter(file -> !file.isEmpty()).collect(Collectors.toList());
		
		return actualFiles.size() > 0;
	}


	public void validateFileExtension(MultipartFile file) {
		if (!file.getOriginalFilename().contains(".") )
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
