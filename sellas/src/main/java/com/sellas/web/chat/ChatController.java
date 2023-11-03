package com.sellas.web.chat;

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
			message.setMessage(message.getMessage());
		} else if (ChatMessage.MessageType.TALK.equals(message.getType())) {
			messagingTemplate.convertAndSend("/sub/ws/chat/room/" + message.getRoomId(), message);
		} else if (ChatMessage.MessageType.OUT.equals(message.getType())) {
			message.setMessage(message.getMessage());
		} else if (ChatMessage.MessageType.INTERVAL.equals(message.getType())) {
			messagingTemplate.convertAndSend("/sub/ws/chat/room/" + message.getRoomId(), message);
		}
	}
	
	@MessageMapping("ws/chat/alarmmessage")
	public void alarmmessage(ChatMessage message) {
//		System.out.println("message content: " + message.getMessage());
		if (ChatMessage.MessageType.ALARM.equals(message.getType())) {
			System.out.println("받는 사람: " + message.getRecipient());
			messagingTemplate.convertAndSend("/sub0/ws/chat/user/" + message.getRecipient(), message);
		} else if (ChatMessage.MessageType.INTERVAL.equals(message.getType())) {
			messagingTemplate.convertAndSend("/sub0/ws/chat/user/" + message.getRecipient(), message);
		}
	}

}