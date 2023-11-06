package com.sellas.web.chat;

import java.util.List;
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
			
			String tno = String.valueOf(map.get("tno"));
			
			String obuyer = String.valueOf(map.get("obuyer"));
			
			String oseller = String.valueOf(map.get("oseller")); //이게 알람용 웹소켓 서버의 마지막 주소입니다.
			
			Map<String,Object> searchchatroom = chatRoomService.searchChatRoom(map); //tno, obuyer, oseller를 조건으로 ouuid가 있는지 검사해서 있으면 1과 ouuid를 리턴합니다.
			
			if(searchchatroom.get("count") == "1") { //1 리턴하면 과거에 생성한 대화방이 존재했으니까 거기에 대화내용을 불러옵니다.
				
				model.addAttribute("lastroomcheck", searchchatroom.get("count")); /* 이 변수를 모델로 보내는 이유는 1이면 얘도 olnyalarm.jsp에서 폼으로 보내서
				requestChat메소드에서 List<Map<String, Object>> lastchatlist을 불러오게 하기위함입니다.*/
				model.addAttribute("ouuid", searchchatroom.get("ouuid"));
				//model.addAttribute("lastChatList",lastchatlist);
			} else if(searchchatroom.get("count") == "0") {
				String uuid = String.valueOf(UUID.randomUUID()); //채팅방용 uuid를 이곳에서 생성합니다.
				model.addAttribute("ouuid", uuid);
				model.addAttribute("lastroomcheck", searchchatroom.get("count"));
			}
			String tnoname = chatRoomService.tnoName(tno);
			String obuyername = chatRoomService.obuyerName(obuyer);
			String acontent = obuyername + "님이 " + tnoname + "에 대한 채팅 신청을 하였습니다."; //oseller에게 보낼 메시지입니다.
			model.addAttribute("tno", tno);
			model.addAttribute("obuyer", obuyer);
			model.addAttribute("oseller", oseller);
			model.addAttribute("acontent", acontent);
			
			
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

			String mnickname = chatRoomService.mNickName(me); //obuyer의 닉네임을 받아옵니다.

			String econtent = mnickname + "님이 입장하셨습니다."; //입장 메시지입니다.

			String lastroomcheck = String.valueOf(map.get("lastroomcheck"));

			if(lastroomcheck == "1") { //똑같은 채팅방 uuid가 있다는 의미입니다. 그래서 과거 대화기록을 불러옵니다.(
				
				List<Map<String, Object>> lastchatlist = chatRoomService.lastChatList(map); //ouuid의 과거 채팅 내역 불러옵니다. dialogue 테이블의 ouuid컬럼 제외한 전부 다 불러옵니다.

				model.addAttribute("lastroomcheck", lastroomcheck);
				model.addAttribute("lastchatlist", lastchatlist);
				model.addAttribute("tno", map.get("tno"));
				model.addAttribute("roomId", map.get("roomId"));
				model.addAttribute("oseller", map.get("oseller"));
				model.addAttribute("mnickname", mnickname);
				model.addAttribute("econtent", econtent);

				return "/chat/roomdetail";

			} else if(lastroomcheck == "0") {

				model.addAttribute("lastroomcheck", lastroomcheck);
				model.addAttribute("tno", map.get("tno"));
				model.addAttribute("roomId", map.get("roomId"));
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
		List<Map<String, Object>> lastchatlist = chatRoomService.lastChatList(roommap); //서버에 저장된 지난 대화내용 불러오는 리스트맵입니다.
		Map<String, Object> map = chatRoomService.alarmChat(roomId); //tno, oseller, obuyer 불러와서 저장하는 맵입니다.
		// System.out.println(map);
		String obuyer = String.valueOf(map.get("obuyer"));
		String tno = String.valueOf(map.get("tno"));
		String oseller = String.valueOf(map.get("oseller"));
		String mnickname = chatRoomService.mNickName(oseller); //판매자 닉네임입니다.
		String econtent = mnickname + "님이 입장하셨습니다.";

		model.addAttribute("lastchatlist", lastchatlist);
		model.addAttribute("roomId", roomId);
		model.addAttribute("tno", tno);
		model.addAttribute("obuyer", obuyer);
		model.addAttribute("oseller", oseller);
		model.addAttribute("mnickname", mnickname);
		model.addAttribute("econtent", econtent);
		return "/chat/roomalarm";
	}


}