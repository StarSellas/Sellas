package com.sellas.web.chat;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ChatMessageService {
	
	@Autowired
	private ChatMessageDAO chatMessageDAO;

	public String name(String name) {
		// TODO Auto-generated method stub
		return chatMessageDAO.name(name);
	}

	public Map<String, Object> alarm(Map<String, Object> alarmMap) {
		// TODO Auto-generated method stub
		return chatMessageDAO.alarm(alarmMap);
	}

	public int enterMessage(Map<String, Object> enterMap) {
		// TODO Auto-generated method stub
		return chatMessageDAO.enterMessage(enterMap);
	}

	public int outMessage(Map<String, Object> outMap) {
		// TODO Auto-generated method stub
		return chatMessageDAO.outMessage(outMap);
	}

	public String alarmSeller(String roomId) {
		// TODO Auto-generated method stub
		return chatMessageDAO.alarmSeller(roomId);
	}

	public String oseller(String roomId) {
		// TODO Auto-generated method stub
		return chatMessageDAO.oseller(roomId);
	}

	public int alarmPut(String roomuuid) {
		// TODO Auto-generated method stub
		return chatMessageDAO.alarmPut(roomuuid);
	}

	public int talkMessage(Map<String, Object> talkmap) {
		// TODO Auto-generated method stub
		return chatMessageDAO.talkMessage(talkmap);
	}

	public int alarmMessage(Map<String, Object> alarmmap) {
		// TODO Auto-generated method stub
		return chatMessageDAO.alarmMessage(alarmmap);
	}

	
}
