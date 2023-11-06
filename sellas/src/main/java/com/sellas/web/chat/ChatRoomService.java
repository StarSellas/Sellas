package com.sellas.web.chat;

import java.util.List;
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

	public int alarmIn(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return chatRoomDAO.alarmIn(map);
	}

	public String tno(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return chatRoomDAO.tno(map);
	}

	public String mNickName(String uuid) {
		// TODO Auto-generated method stub
		return chatRoomDAO.mNickName(uuid);
	}

	public Map<String, Object> alarmChat(String roomId) {
		// TODO Auto-generated method stub
		return chatRoomDAO.alarmChat(roomId);
	}

	public String tnoName(String tno) {
		// TODO Auto-generated method stub
		return chatRoomDAO.tnoName(tno);
	}

	public String obuyerName(String obuyer) {
		// TODO Auto-generated method stub
		return chatRoomDAO.obuyerName(obuyer);
	}

	public List<Map<String, Object>> lastChatList(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return chatRoomDAO.lastChatList(map);
	}

	public Map<String, Object> searchChatRoom(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return chatRoomDAO.searchChatRoom(map);
	}
	
}
