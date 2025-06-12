package com.example.board.global.component;

import static org.junit.jupiter.api.Assertions.assertDoesNotThrow;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

import java.util.UUID;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.web.multipart.MultipartFile;

import com.example.board.global.exception.InvalidFileException;

@ExtendWith(MockitoExtension.class)
class FileHandlerTest {

	@InjectMocks
	private FileHandler fileHandler;

	@Mock
	private MultipartFile mockMultipartFile = mock(MultipartFile.class);

	@ParameterizedTest
	@CsvSource({ "test.txt, txt", "document.pdf, pdf", "image.jpeg, jpeg", "example.tar.gz, gz" })
	void getExtension_ShouldReturnExtension_WhenFileNameIsValid(String fileName, String expectedExtension) {
		// when
		String extension = fileHandler.getExtension(fileName);

		// then
		assertEquals(expectedExtension, extension);
	}

	@Test
	void validateFile_WhenFileIsValid() {
		// given
		when(mockMultipartFile.getOriginalFilename()).thenReturn("test.txt");

		// expected
		assertDoesNotThrow(() -> fileHandler.validateFile(mockMultipartFile));
	}

	@Test
	void validateFile_ShouldThrowInvalidFileException_WhenFileNameDoNotContainsExtension() {
		// given
		when(mockMultipartFile.getOriginalFilename()).thenReturn("no_extension_file");

		// expected
		assertThrows(InvalidFileException.class, () -> fileHandler.validateFile(mockMultipartFile));
	}

	@ParameterizedTest
	@CsvSource({
			"users, 100, '550e8400-e29b-41d4-a716-446655440001', 'test.txt', 'users-100-550e8400-e29b-41d4-a716-446655440001.txt'",
			"users, 200, '550e8400-e29b-41d4-a716-446655440002', 'document.pdf', 'users-200-550e8400-e29b-41d4-a716-446655440002.pdf'",
			"posts, 300, '550e8400-e29b-41d4-a716-446655440003', 'image.jpeg', 'posts-300-550e8400-e29b-41d4-a716-446655440003.jpeg'",
			"posts, 400, '550e8400-e29b-41d4-a716-446655440004', 'example.tar.gz', 'posts-400-550e8400-e29b-41d4-a716-446655440004.gz'" })
	void createNewFileName_WhenParametersAreValid(String identifier, long primaryKey, String fileIdStr,
			String originalFileName, String expected) {
		// given
		UUID fileId = UUID.fromString(fileIdStr);

		// when
		when(mockMultipartFile.getOriginalFilename()).thenReturn(originalFileName);

		String newFileName = fileHandler.createNewFileName(identifier, primaryKey, fileId, mockMultipartFile);

		// then
		assertEquals(expected, newFileName);

	}

}