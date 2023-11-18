package com.sellas.web.chat;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ChatMessage {

    // 메시지 타입 : 입장, 채팅, 나감, 알림, 인터벌, 거래금액, 거래수락, 거래취소
    public enum MessageType {
        ENTER, TALK, OUT, ALARM, INTERVAL, PAYMENT, TRADEOK, TRADENO, TRADEACCEPT, TRADECANCEL, TRADECOMPLETE
    }
    //payment가 가격, tradeallow가 거래 수락, traderefuse가 거래 취소
    
    private MessageType type; // 메시지 타입
    private String roomId; // 방번호
    private String sender; // 메시지 보낸사람
    private String message; // 메시지
    private String recipient; // 메시지 받을 사람
    private String mnickname; //메시지 보낸 사람의 닉네임
    private String requestMoney;
    private String time;
		
}