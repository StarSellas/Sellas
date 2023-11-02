package com.sellas.web.chat;

import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessageSendingOperations;
import org.springframework.stereotype.Controller;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Controller
public class ChatController {

	private final SimpMessageSendingOperations messagingTemplate;

	@Autowired
	private ChatMessageService chatMessageService;

	@MessageMapping("ws/chat/message")
	public void message(ChatMessage message, HttpSession session) {
		String roomId = message.getRoomId();
		String hello = "님이 방에 입장하셨습니다.";
		String out = "님이 방을 나가셨습니다.";
		String alarm = "님이 채팅신청을 하셨습니다.";
		String name = message.getSender();
		String realName = chatMessageService.name(name);
		String alarmseller = chatMessageService.alarmSeller(roomId);
		String type = String.valueOf(message.getType());
		String enterContent = message.getSender() + hello;
		String talkContent = message.getMessage();
		String outContent = message.getSender() + out;
		String alarmContent = realName + alarm;
		Map<String, Object> enterMap = null;
		Map<String, Object> talkMap = null;
		Map<String, Object> outMap = null;
		Map<String, Object> alarmMap = null;
		enterMap.put("roomId", roomId);
		enterMap.put("muuid", name);
		enterMap.put("message", enterContent);
		enterMap.put("type", type);
		talkMap.put("roomId", roomId);
		talkMap.put("muuid", name);
		talkMap.put("message", talkContent);
		talkMap.put("type", type);
		outMap.put("roomId", roomId);
		outMap.put("muuid", name);
		outMap.put("message", outContent);
		outMap.put("type", type);
		alarmMap.put("roomId", roomId);
		alarmMap.put("muuid", name);
		alarmMap.put("message", alarmContent);
		alarmMap.put("type", type);
		if (ChatMessage.MessageType.ENTER.equals(message.getType())) {
			message.setMessage(realName + hello);
			Map<String, Object> map = chatMessageService.enterMessage(enterMap);
		} else if (ChatMessage.MessageType.TALK.equals(message.getType())) {
			messagingTemplate.convertAndSend("/sub/ws/chat/room/" + message.getRoomId(), message);
			Map<String, Object> map = chatMessageService.chatMessage(talkMap);
		} else if (ChatMessage.MessageType.OUT.equals(message.getType())) {
			message.setMessage(realName + out);
			Map<String, Object> map = chatMessageService.outMessage(outMap);
		} else if (ChatMessage.MessageType.ALARM.equals(message.getType())) {
			messagingTemplate.convertAndSend("/sub/ws/chat/room/" + message.getRoomId(), alarmContent);
			Map<String, Object> map = chatMessageService.alarm(alarmMap);
		}

	}

}