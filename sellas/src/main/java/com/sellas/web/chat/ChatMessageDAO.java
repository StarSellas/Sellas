package com.sellas.web.chat;

import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface ChatMessageDAO {

	Map<String, Object> chatMessage(Map<String, Object> enterMap);

	String name(String name);

	Map<String, Object> alarm(Map<String, Object> alarmMap);

	Map<String, Object> enterMessage(Map<String, Object> enterMap);

	Map<String, Object> outMessage(Map<String, Object> outMap);

	String alarmSeller(String roomId);

	
	
}
