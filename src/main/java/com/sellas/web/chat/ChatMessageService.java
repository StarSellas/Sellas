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

	public int tradeOkMessage(Map<String, Object> tradeokmap) {
		// TODO Auto-generated method stub
		return chatMessageDAO.tradeOkMessage(tradeokmap);
	}

	public int tradeNoMessage(Map<String, Object> tradenomap) {
		// TODO Auto-generated method stub
		return chatMessageDAO.tradeNoMessage(tradenomap);
	}

	public int paymentMessage(Map<String, Object> paymentmap) {
		// TODO Auto-generated method stub
		return chatMessageDAO.paymentMessage(paymentmap);
	}

	public int tradeAcceptMessage(Map<String, Object> tradeacceptmap) {
		// TODO Auto-generated method stub
		return chatMessageDAO.tradeAcceptMessage(tradeacceptmap);
	}

	public int tradeCancelMessage(Map<String, Object> tradecancelmap) {
		// TODO Auto-generated method stub
		return chatMessageDAO.tradeCancelMessage(tradecancelmap);
	}

	public int tradeCompleteMessage(Map<String, Object> tradecompletemap) {
		// TODO Auto-generated method stub
		return chatMessageDAO.tradeCompleteMessage(tradecompletemap);
	}

	
}
