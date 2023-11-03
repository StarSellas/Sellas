package com.sellas.web.chat;

import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface ChatRoomDAO {

	int room(Map<String, Object> map);

	int alarmIn(Map<String, Object> map);

	String obuyer(Map<String, Object> map);

	String tno(Map<String, Object> map);

	String mNickName(String uuid);

	Map<String, Object> alarmChat(String roomId);
	
}
