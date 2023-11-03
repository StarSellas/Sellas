package com.sellas.web.chat;

import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import lombok.RequiredArgsConstructor;
import retrofit2.http.POST;

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
    public String requestChat(@RequestParam Map<String, Object> map, Model model, HttpSession session) {
       
       //System.out.println("채팅으로 받아오는 값입니다 : " + map);
       //System.out.println("세션에서 받아오는 muuid 값입니다 : " + session.getAttribute("muuid"));
       
       //System.out.println("채팅방 uuid 의 값입니다 : " + uuid);
    	if(session.getAttribute("muuid") != null && !(session.getAttribute("muuid").equals(""))) {
    		
    		String uuid =  String.valueOf(UUID.randomUUID());
    		
    		String obuyer = chatRoomService.obuyer(map);
    		
    		String tno = chatRoomService.tno(map);
    		
    		String acontent =  obuyer + "님이 " +  tno + "에 대한 채팅 신청을 하였습니다.";
    		
    		String mnickname = chatRoomService.mNickName(uuid);
    		
    		map.put("roomId", uuid);
    		
    		map.put("acontent", acontent);
    		
    		int alarmresult = chatRoomService.alarmIn(map);
    		
    		int insertresult = chatRoomService.room(map);
    		
    		if(insertresult == 1) {
    			
    			model.addAttribute("tno", map.get("tno"));
        		model.addAttribute("roomId", map.get("roomId"));
        		model.addAttribute("obuyer", map.get("obuyer"));
        		model.addAttribute("oseller", map.get("oseller"));
        		model.addAttribute("mnickname", mnickname);
        		model.addAttribute("acontent", acontent);

    			return "/chat/roomdetail";
    			
    		
    		} else {

    			map.remove("roomId");
    			
    			while(insertresult == 0) {
    				
    				uuid = String.valueOf(UUID.randomUUID());
    				
    				map.put("roomId", uuid);
    				
    				insertresult = chatRoomService.room(map);

    			}
    			
    			model.addAttribute("tno", map.get("tno"));
        		model.addAttribute("roomId", map.get("roomId"));
        		model.addAttribute("obuyer", map.get("obuyer"));
        		model.addAttribute("oseller", map.get("oseller"));
        		model.addAttribute("mnickname", mnickname);
        		model.addAttribute("acontent", acontent);

    			return "/chat/roomdetail";

    		}
    		
          //System.out.println("최종적으로 담기는 값 : " + map);
    		
       }
    	
    	return "/login";
    	
    }
    
    @PostMapping("/alarmChat")
    public String alarmChat(@RequestParam Map<String, Object> roommap, Model model) {
    	//System.out.println("룸 아이디는 " + roomId); 오는거 확인했어요.
    	System.out.println(roommap.get("roomId"));
    	String roomId = (String) roommap.get("roomId");
    	Map<String, Object> map = chatRoomService.alarmChat(roomId);
    	String obuyer = (String) map.get("obuyer");
    	String tno = (String) map.get("tno");
    	String acontent =  obuyer + "님이 " +  tno + "에 대한 채팅 신청을 하였습니다.";
		String oseller = (String) map.get("oseller");
		String mnickname = chatRoomService.mNickName(roomId);
		
		model.addAttribute("roomId", roomId);
		model.addAttribute("tno", tno);
		model.addAttribute("obuyer", obuyer);
		model.addAttribute("oseller", oseller);
		model.addAttribute("mnickname", mnickname);
		model.addAttribute("acontent", acontent);
    	return "/chat/roomalarm";
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