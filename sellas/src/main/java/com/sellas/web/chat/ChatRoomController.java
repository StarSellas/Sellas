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


	@Autowired
	private ChatRoomService chatRoomService;

	// 채팅방 입장 화면
	// 알람을 보내는 웹소켓 서버와 일반 대화용 웹소켓 서버가 달라서 알람용 페이지를 하나 더 만들었습니다.
	// 웹소켓 서버가 한 jsp페이지에 2개를 실행시키는게 저는 실패해서 이렇게 했습니다.
	@PostMapping("/onlyalarm")
	public String onlyAlarm(@RequestParam Map<String, Object> map, Model model, HttpSession session) {
		if (session.getAttribute("muuid") != null && !(session.getAttribute("muuid").equals(""))) { //로그인 여부 검사합니다.
			String uuid = String.valueOf(UUID.randomUUID()); //채팅방용 uuid를 이곳에서 생성합니다.
			String tno = String.valueOf(map.get("tno"));
			String obuyer = String.valueOf(map.get("obuyer"));
			String oseller = String.valueOf(map.get("oseller")); //이게 알람용 웹소켓 서버의 마지막 주소입니다.
			String tnoname = chatRoomService.tnoName(tno);
			String obuyername = chatRoomService.obuyerName(obuyer);
			String acontent = obuyername + "님이 " + tnoname + "에 대한 채팅 신청을 하였습니다."; //oseller에게 보낼 메시지입니다.
			model.addAttribute("tno", tno);
			model.addAttribute("obuyer", obuyer);
			model.addAttribute("oseller", oseller);
			model.addAttribute("acontent", acontent);
			model.addAttribute("ouuid", uuid);
			
			return "/chat/onlyalarm";
		}
		return "/login";
	}
	
	//일반 채팅용 서버와 페이지로 가는 메소드입니다.
	@PostMapping("/requestChat")
	public String requestChat(@RequestParam Map<String, Object> map, Model model, HttpSession session) {

		//System.out.println("채팅으로 받아오는 값입니다 : " + map);
		// System.out.println("세션에서 받아오는 muuid 값입니다 : " +
		// session.getAttribute("muuid"));

		// System.out.println("채팅방 uuid 의 값입니다 : " + uuid);
		if (session.getAttribute("muuid") != null && !(session.getAttribute("muuid").equals(""))) { //로그인 여부를 검사합니다.

			

			String me = (String) session.getAttribute("muuid"); //obuyer의 uuid를 세션에서 받아옵니다.

			String obuyer = chatRoomService.obuyer(me);

			String mnickname = chatRoomService.mNickName(me); //obuyer의 닉네임을 받아옵니다.

			String econtent = mnickname + "님이 입장하셨습니다."; //입장 메시지입니다.

			int insertresult = chatRoomService.room(map); //같은 uuid를 가진 채팅방이 있는지 검사하고, 있으면 0, 없으면 1을 리턴합니다.

			if (insertresult == 1) { //같은 uuid를 가진 채팅방이 없으므로 모델로 채팅방에 필요한 정보들을 전달합니다.

				model.addAttribute("tno", map.get("tno"));
				model.addAttribute("roomId", map.get("roomId"));
				model.addAttribute("obuyer", obuyer);
				model.addAttribute("oseller", map.get("oseller"));
				model.addAttribute("mnickname", mnickname);
				model.addAttribute("econtent", econtent);

				return "/chat/roomdetail";

			} else { //같은 uuid를 가진 채팅방이 있어서 uuid를 삭제하고, 재생성한 후 다시 검사하고, 없으면 보냅니다.

				map.remove("ouuid");

				while (insertresult == 0) { //insertresult가 1이면 탈출합니다.

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
	
	//판매자(oseller)가 접속할 roomalarm.jsp에 접속하는 메소드입니다.
	//판매자는 구매자에게 알람을 보내지 않아서 alarm은 없습니다.
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


}