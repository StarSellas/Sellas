package com.sellas.web.chat;

import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface ChatMessageDAO {

	Map<String, Object> chatMessage(Map<String, Object> enterMap);

	String name(String name);

	Map<String, Object> alarm(Map<String, Object> alarmMap);

	int enterMessage(Map<String, Object> enterMap);

	int outMessage(Map<String, Object> outMap);

	String alarmSeller(String roomId);

	String oseller(String roomId);

	int alarmPut(String roomuuid);

	int talkMessage(Map<String, Object> talkmap);

	int alarmMessage(Map<String, Object> alarmmap);

	int tradeOkMessage(Map<String, Object> tradeokmap);

	int tradeNoMessage(Map<String, Object> tradenomap);

	int paymentMessage(Map<String, Object> paymentmap);

	
	
}
