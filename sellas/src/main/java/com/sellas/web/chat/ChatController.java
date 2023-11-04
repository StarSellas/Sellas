package com.sellas.web.chat;

import java.util.HashMap;
import java.util.Map;

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
	public void message(ChatMessage message) {
//		System.out.println("message content: " + message.getMessage());
		if (ChatMessage.MessageType.ENTER.equals(message.getType())) {
			messagingTemplate.convertAndSend("/sub/ws/chat/room/" + message.getRoomId(), message);
			Map<String, Object> entermap = new HashMap<>();
			String ouuid =  message.getRoomId();
			String muuid = message.getSender();
			String dcontent = message.getMessage();
			String dtype = String.valueOf(message.getType());
			entermap.put("ouuid", ouuid);
			entermap.put("muuid", muuid);
			entermap.put("dcontent", dcontent);
			entermap.put("dtype", dtype);
			int enter = chatMessageService.enterMessage(entermap);
		} else if (ChatMessage.MessageType.TALK.equals(message.getType())) {
			messagingTemplate.convertAndSend("/sub/ws/chat/room/" + message.getRoomId(), message);
			Map<String, Object> talkmap = new HashMap<>();
			String ouuid =  message.getRoomId();
			String muuid = message.getSender();
			String dcontent = message.getMessage();
			String dtype = String.valueOf(message.getType());
			talkmap.put("ouuid", ouuid);
			talkmap.put("muuid", muuid);
			talkmap.put("dcontent", dcontent);
			talkmap.put("dtype", dtype);
			int talk = chatMessageService.talkMessage(talkmap);
		} else if (ChatMessage.MessageType.OUT.equals(message.getType())) {
			messagingTemplate.convertAndSend("/sub/ws/chat/room/" + message.getRoomId(), message);
			Map<String, Object> outmap = new HashMap<>();
			String ouuid =  message.getRoomId();
			String muuid = message.getSender();
			String dcontent = message.getMessage();
			String dtype = String.valueOf(message.getType());
			outmap.put("ouuid", ouuid);
			outmap.put("muuid", muuid);
			outmap.put("dcontent", dcontent);
			outmap.put("dtype", dtype);
			int out = chatMessageService.outMessage(outmap);
		} else if (ChatMessage.MessageType.INTERVAL.equals(message.getType())) {
			messagingTemplate.convertAndSend("/sub/ws/chat/room/" + message.getRoomId(), message);
		}
	}
	
	@MessageMapping("ws/chat/alarmmessage")
	public void alarmmessage(ChatMessage message) {
//		System.out.println("message content: " + message.getMessage());
		if (ChatMessage.MessageType.ALARM.equals(message.getType())) {
			//System.out.println("받는 사람: " + message.getRecipient());
			messagingTemplate.convertAndSend("/sub0/ws/chat/user/" + message.getRecipient(), message);
			Map<String, Object> alarmmap = new HashMap<>();
			String ouuid =  message.getRoomId();
			String oseller = message.getRecipient();
			String acontent = message.getMessage();
			String dtype = String.valueOf(message.getType());
			alarmmap.put("ouuid", ouuid);
			alarmmap.put("oseller", oseller);
			alarmmap.put("acontent", acontent);
			int alarm = chatMessageService.alarmMessage(alarmmap);
		} else if (ChatMessage.MessageType.INTERVAL.equals(message.getType())) {
			messagingTemplate.convertAndSend("/sub0/ws/chat/user/" + message.getRecipient(), message);
		}
	}

}