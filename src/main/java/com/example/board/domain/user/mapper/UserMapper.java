package com.example.board.domain.user.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.board.domain.user.entity.User;

@Mapper
public interface UserMapper {
	List<User> getAll();
}
