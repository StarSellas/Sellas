package com.sellas.web.chat;

import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface ChatRoomDAO {

	int room(Map<String, Object> map);
	
}
