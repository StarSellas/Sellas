package com.sellas.web.chat;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ChatMessageService {
	
	@Autowired
	private ChatMessageDAO chatMessageDAO;

	public Map<String, Object> chatMessage(Map<String, Object> enterMap) {
		// TODO Auto-generated method stub
		return chatMessageDAO.chatMessage(enterMap);
	}

	public String name(String name) {
		// TODO Auto-generated method stub
		return chatMessageDAO.name(name);
	}

	public Map<String, Object> alarm(Map<String, Object> alarmMap) {
		// TODO Auto-generated method stub
		return chatMessageDAO.alarm(alarmMap);
	}

	public Map<String, Object> enterMessage(Map<String, Object> enterMap) {
		// TODO Auto-generated method stub
		return chatMessageDAO.enterMessage(enterMap);
	}

	public Map<String, Object> outMessage(Map<String, Object> outMap) {
		// TODO Auto-generated method stub
		return chatMessageDAO.outMessage(outMap);
	}

	public String alarmSeller(String roomId) {
		// TODO Auto-generated method stub
		return chatMessageDAO.alarmSeller(roomId);
	}

	
}
