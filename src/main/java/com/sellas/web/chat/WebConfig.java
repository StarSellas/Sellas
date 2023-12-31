package com.sellas.web.chat;

import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;
import org.springframework.web.socket.config.annotation.WebSocketMessageBrokerConfigurer;
import org.springframework.web.socket.config.annotation.WebSocketTransportRegistration;

@Configuration
@EnableWebSocketMessageBroker
public class WebConfig implements WebSocketMessageBrokerConfigurer {

	@Override
	public void registerStompEndpoints(StompEndpointRegistry registry) {
		// stomp 접속 주소 url => /ws-stomp
		registry.addEndpoint("/ws/chat") // 연결될 엔드포인트
				.setAllowedOriginPatterns("*").withSockJS(); // SocketJS 를 연결한다는 설정
	}

	@Override
	public void configureMessageBroker(MessageBrokerRegistry registry) {
		// 메시지를 구독하는 요청 url => 즉 메시지 받을 때
		registry.enableSimpleBroker("/sub", "/sub0");

		// 메시지를 발행하는 요청 url => 즉 메시지 보낼 때
		registry.setApplicationDestinationPrefixes("/pub", "/pub0");
	}
	
	@Override
    public void configureWebSocketTransport(WebSocketTransportRegistration registration) {
        registration.setMessageSizeLimit(50 * 1024 * 1024); // 메세지 크기 제한 오류 방지(이 코드가 없으면 byte code를 보낼때 소켓 연결이 끊길 수 있음)
    }
}
