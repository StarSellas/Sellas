package com.sellas.web.chat;

import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Controller
@RequestMapping("/chat")
public class ChatRoomController {

 

//    private final ChatRoomRepository chatRoomRepository;

    @Autowired
    private ChatRoomService chatRoomService;

    // 채팅 리스트 화면

//    @GetMapping("/room")
//    public String rooms() {
//
//        return "/chat/room";
//
//    }

    // 모든 채팅방 목록 반환

//    @GetMapping("/rooms")
//    @ResponseBody
//    public List<ChatRoom> room() {
//
//        return chatRoomRepository.findAllRoom();
//
//    }

    // 채팅방 생성

//    @PostMapping("/room")
//    @ResponseBody
//    public ChatRoom createRoom(@RequestParam String name) {
//
//        return chatRoomRepository.createChatRoom(name);
//
//    }

    // 채팅방 입장 화면

    @PostMapping("/requestChat")
    public String requestChat(@RequestParam Map<String, Object> map, HttpSession session) {
       
       //System.out.println("채팅으로 받아오는 값입니다 : " + map);
       //System.out.println("세션에서 받아오는 muuid 값입니다 : " + session.getAttribute("muuid"));
       
       //System.out.println("채팅방 uuid 의 값입니다 : " + uuid);
    	if(session.getAttribute("muuid") != null && !(session.getAttribute("muuid").equals(""))) {
    		
    		String seller = (String) map.get("oseller");
    		
    		String uuid =  String.valueOf(UUID.randomUUID());
          
    		map.put("roomId", uuid);
          
    		int result = chatRoomService.room(map);
    		
    		while(result == 1) {
    			String reuuid = String.valueOf(UUID.randomUUID());
    			
    			map.remove("roomId");
    			map.put("roomId", reuuid);
    			result = chatRoomService.room(map);
    		}
    		
          //System.out.println("최종적으로 담기는 값 : " + map);
       }
    	return "/chat/roomdetail";
    }

    // 특정 채팅방 조회

//    @GetMapping("/room/{roomId}")
//    @ResponseBody
//    public ChatRoom roomInfo(@PathVariable String roomId) {
//
//        return chatRoomRepository.findRoomById(roomId);
//
//    }

}