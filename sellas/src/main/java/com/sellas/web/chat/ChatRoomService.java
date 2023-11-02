package com.sellas.web.chat;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ChatRoomService {
	
	@Autowired
	private ChatRoomDAO chatRoomDAO;

	public int room(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return chatRoomDAO.room(map);
	}
}
