package com.example.board.domain.file.service;

import org.springframework.stereotype.Service;

import com.example.board.domain.file.mapper.FileMapper;

@Service
public class FileGetService {
	private FileMapper fileMapper;

	public FileGetService(FileMapper fileMapper) {
		this.fileMapper = fileMapper;
	}
	
	void get() {
		
	}

}
