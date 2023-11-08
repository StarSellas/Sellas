package com.sellas.web.chat;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface ChatRoomDAO {

	int room(Map<String, Object> map);

	int alarmIn(Map<String, Object> map);

	String tno(Map<String, Object> map);

	String mNickName(String uuid);

	Map<String, Object> alarmChat(String roomId);

	String tnoName(String tno);

	String obuyerName(String obuyer);

	List<Map<String, Object>> lastChatList(Map<String, Object> map);

	int searchChatRoom(Map<String, Object> map);

	String getOuuid(Map<String, Object> map);

	List<Map<String, Object>> alarmList(String muuid);

	int setCheckZero(String muuid);

	int selectTnormalstate(Map<String, Object> map);

	Map<String, Object> selectPayment(Map<String, Object> map);
	
}
