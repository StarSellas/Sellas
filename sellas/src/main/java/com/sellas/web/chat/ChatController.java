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
	
	// 일반대화를 포함한 roomId를 사용하는 메시지들이 들르는 곳입니다.
	// 여기를 지나는 메시지들은 전부 dialogue 테이블에 저장됩니다.
	@MessageMapping("ws/chat/message")
	public void message(ChatMessage message) {
//		System.out.println("message content: " + message.getMessage());
		if (ChatMessage.MessageType.ENTER.equals(message.getType())) { //채팅방에 입장하면 보내는 메소드입니다.
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
			int enter = chatMessageService.enterMessage(entermap); //서버에 입장 메시지를 저장합니다.
		} else if (ChatMessage.MessageType.TALK.equals(message.getType())) { //일반 대화를 보내는 메소드입니다.
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
			int talk = chatMessageService.talkMessage(talkmap); //서버에 일반 대화 내용을 보냅니다.
		} else if (ChatMessage.MessageType.OUT.equals(message.getType())) { //서버와 연결이 끊어지면 발생하는 메시지입니다.
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
			int out = chatMessageService.outMessage(outmap); //서버에 보냅니다.
		} else if (ChatMessage.MessageType.TRADEOK.equals(message.getType())) { //거래수락 버튼을 누르면 전송되는 메시지입니다.
			messagingTemplate.convertAndSend("/sub/ws/chat/room/" + message.getRoomId(), message);
			Map<String, Object> tradeokmap = new HashMap<>();
			String ouuid =  message.getRoomId();
			String muuid = message.getSender();
			String dcontent = message.getMessage();
			String dtype = String.valueOf(message.getType());
			tradeokmap.put("ouuid", ouuid);
			tradeokmap.put("muuid", muuid);
			tradeokmap.put("dcontent", dcontent);
			tradeokmap.put("dtype", dtype);
			int tradeok = chatMessageService.tradeOkMessage(tradeokmap); //거래수락 메시지를 서버에 저장합니다.
		} else if (ChatMessage.MessageType.TRADENO.equals(message.getType())) { //거래취소 버튼을 누르면 전송되는 메시지입니다.
			messagingTemplate.convertAndSend("/sub/ws/chat/room/" + message.getRoomId(), message);
			Map<String, Object> tradenomap = new HashMap<>();
			String ouuid =  message.getRoomId();
			String muuid = message.getSender();
			String dcontent = message.getMessage();
			String dtype = String.valueOf(message.getType());
			tradenomap.put("ouuid", ouuid);
			tradenomap.put("muuid", muuid);
			tradenomap.put("dcontent", dcontent);
			tradenomap.put("dtype", dtype);
			int tradeno = chatMessageService.tradeNoMessage(tradenomap); //거래취소 메시지를 서버에 저장합니다.
		} else if (ChatMessage.MessageType.PAYMENT.equals(message.getType())) { //거래금액 메시지를 보냅니다.
			messagingTemplate.convertAndSend("/sub/ws/chat/room/" + message.getRoomId(), message);
			Map<String, Object> paymentmap = new HashMap<>();
			String ouuid =  message.getRoomId();
			String muuid = message.getSender();
			String dcontent = message.getMessage();
			String dtype = String.valueOf(message.getType());
			paymentmap.put("ouuid", ouuid);
			paymentmap.put("muuid", muuid);
			paymentmap.put("dcontent", dcontent);
			paymentmap.put("dtype", dtype);
			int payment = chatMessageService.paymentMessage(paymentmap); //거래금액을 서버에 저장합니다.
		} else if (ChatMessage.MessageType.INTERVAL.equals(message.getType())) { //인터벌 메시지를 보냅니다.
			messagingTemplate.convertAndSend("/sub/ws/chat/room/" + message.getRoomId(), message);
		}
	}
	
	//알람과 알람용 인터벌이 들르는 페이지입니다.
	//여기를 지나는 메시지는 전부 alarm 테이블에 저장됩니다.
	@MessageMapping("ws/chat/alarmmessage")
	public void alarmmessage(ChatMessage message) {
//		System.out.println("message content: " + message.getMessage());
		if (ChatMessage.MessageType.ALARM.equals(message.getType())) { //알림 메시지를 보냅니다.
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
			int alarm = chatMessageService.alarmMessage(alarmmap); //알림 메시지를 alarm 테이블에 저장합니다.
		} else if (ChatMessage.MessageType.INTERVAL.equals(message.getType())) {
			messagingTemplate.convertAndSend("/sub0/ws/chat/user/" + message.getRecipient(), message);
		}
	}

}