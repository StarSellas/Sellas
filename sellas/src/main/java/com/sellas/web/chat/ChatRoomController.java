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
import org.springframework.web.bind.annotation.ResponseBody;

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
	@PostMapping("/onlyalarm")
	public String onlyAlarm(@RequestParam Map<String, Object> map, Model model, HttpSession session) {
		if (session.getAttribute("muuid") != null && !(session.getAttribute("muuid").equals(""))) {
			String uuid = String.valueOf(UUID.randomUUID());
			String tno = String.valueOf(map.get("tno"));
			String obuyer = String.valueOf(map.get("obuyer"));
			String oseller = String.valueOf(map.get("oseller"));
			String tnoname = chatRoomService.tnoName(tno);
			String obuyername = chatRoomService.obuyerName(obuyer);
			String acontent = obuyername + "님이 " + tnoname + "에 대한 채팅 신청을 하였습니다.";
			model.addAttribute("tno", tno);
			model.addAttribute("obuyer", obuyer);
			model.addAttribute("oseller", oseller);
			model.addAttribute("acontent", acontent);
			model.addAttribute("ouuid", uuid);
			
			return "/chat/onlyalarm";
		}
		return "/login";
	}

	@PostMapping("/requestChat")
	public String requestChat(@RequestParam Map<String, Object> map, Model model, HttpSession session) {

		System.out.println("채팅으로 받아오는 값입니다 : " + map);
		// System.out.println("세션에서 받아오는 muuid 값입니다 : " +
		// session.getAttribute("muuid"));

		// System.out.println("채팅방 uuid 의 값입니다 : " + uuid);
		if (session.getAttribute("muuid") != null && !(session.getAttribute("muuid").equals(""))) {

			

			String me = (String) session.getAttribute("muuid");

			String obuyer = chatRoomService.obuyer(me);


			String mnickname = chatRoomService.mNickName(me);

			String econtent = mnickname + "님이 입장하셨습니다.";


			int insertresult = chatRoomService.room(map);

			if (insertresult == 1) {

				model.addAttribute("tno", map.get("tno"));
				model.addAttribute("roomId", map.get("roomId"));
				model.addAttribute("obuyer", obuyer);
				model.addAttribute("oseller", map.get("oseller"));
				model.addAttribute("mnickname", mnickname);
				model.addAttribute("econtent", econtent);

				return "/chat/roomdetail";

			} else {

				map.remove("ouuid");

				while (insertresult == 0) {

					String uuid = String.valueOf(UUID.randomUUID());

					map.put("roomId", uuid);

					insertresult = chatRoomService.room(map);

				}

				model.addAttribute("tno", map.get("tno"));
				model.addAttribute("roomId", map.get("roomId"));
				model.addAttribute("obuyer", obuyer);
				model.addAttribute("oseller", map.get("oseller"));
				model.addAttribute("mnickname", mnickname);
				model.addAttribute("econtent", econtent);

				return "/chat/roomdetail";

			}

			// System.out.println("최종적으로 담기는 값 : " + map);

		}

		return "/login";

	}

	@PostMapping("/alarmChat")
	public String alarmChat(@RequestParam Map<String, Object> roommap, Model model) {
		// System.out.println("룸 아이디는 " + roomId); 오는거 확인했어요.
		// System.out.println("roomId는 " + roommap.get("roomId"));
		String roomId = (String) roommap.get("roomId");
		Map<String, Object> map = chatRoomService.alarmChat(roomId);
		// System.out.println(map);
		String obuyer = String.valueOf(map.get("obuyer"));
		String tno = String.valueOf(map.get("tno"));
		String acontent = obuyer + "님이 " + tno + "에 대한 채팅 신청을 하였습니다.";
		System.out.println("acontent" + acontent);
		String oseller = String.valueOf(map.get("oseller"));
		String mnickname = chatRoomService.mNickName(oseller);
		String econtent = mnickname + "님이 입장하셨습니다.";

		model.addAttribute("roomId", roomId);
		model.addAttribute("tno", tno);
		model.addAttribute("obuyer", obuyer);
		model.addAttribute("oseller", oseller);
		model.addAttribute("mnickname", mnickname);
		model.addAttribute("acontent", acontent);
		model.addAttribute("econtent", econtent);
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