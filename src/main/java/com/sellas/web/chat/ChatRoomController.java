package com.sellas.web.chat;

import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpSession;

import org.json.JSONObject;
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
		//System.out.println("onlyalarm에ㅐ서 받아오는 맵값 : " + map);
		
		if (session.getAttribute("muuid") != null && !(session.getAttribute("muuid").equals(""))) { //로그인 여부 검사합니다.
			
			String tno = String.valueOf(map.get("tno"));
			
			String obuyer = String.valueOf(map.get("obuyer"));
			
			String oseller = String.valueOf(map.get("oseller")); //이게 알람용 웹소켓 서버의 마지막 주소입니다.
			
			int searchchatroom = chatRoomService.searchChatRoom(map); //tno, obuyer, oseller를 조건으로 ouuid가 있는지 검사해서 있으면 1과 ouuid를 리턴합니다.
			//System.out.println("searchchatroom의 값입니다 : " + searchchatroom);
			if(searchchatroom == 1 ) { //1 리턴하면 과거에 생성한 대화방이 존재했으니까 거기에 대화내용을 불러옵니다.
				String ouuid = chatRoomService.getOuuid(map);
			
				model.addAttribute("lastroomcheck", searchchatroom); /* 이 변수를 모델로 보내는 이유는 1이면 얘도 olnyalarm.jsp에서 폼으로 보내서
				requestChat메소드에서 List<Map<String, Object>> lastchatlist을 불러오게 하기위함입니다.*/
				model.addAttribute("ouuid", ouuid);
				//model.addAttribute("lastChatList",lastchatlist);
			} else if(searchchatroom == 0) {
				String ouuid = String.valueOf(UUID.randomUUID()); //채팅방용 uuid를 이곳에서 생성합니다.
				map.put("ouuid", ouuid); 
				int chatroom = chatRoomService.room(map);
				model.addAttribute("ouuid", ouuid);
				model.addAttribute("lastroomcheck", searchchatroom);
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
		//System.out.println("세션에서 받아오는 muuid 값입니다 : " + session.getAttribute("muuid"));

		//System.out.println("채팅방 uuid 의 값입니다 : " + uuid);
		if (session.getAttribute("muuid") != null && !(session.getAttribute("muuid").equals(""))) { //로그인 여부를 검사합니다.
			String me = String.valueOf(session.getAttribute("muuid")); //obuyer의 uuid를 세션에서 받아옵니다.
			String tno = String.valueOf(map.get("tno"));
			String mnickname = chatRoomService.mNickName(me); //obuyer의 닉네임을 받아옵니다.
			String roomId = String.valueOf(map.get("roomId"));
			String emessage = mnickname + "님이 입장하셨습니다."; //입장 메시지입니다.
			//System.out.println(econtent);
			String oseller = String.valueOf(map.get("oseller"));
			String obuyer = String.valueOf(map.get("obuyer"));
			int lastroomcheck = Integer.parseInt(String.valueOf(map.get("lastroomcheck")));
			int searchchatroom = chatRoomService.searchChatRoom(map);
			int tnormalstate = chatRoomService.selectTnormalstate(map);
			String tnoname = chatRoomService.tnoName(tno);
			String tcmessage = mnickname+ "   거래가 취소되었습니다. 자세한 사항은"+ "<a href='/'>"+"마이페이지"+"</a>"+ "에서 확인해주세요.";
			
			if(tnormalstate == 1) {
			Map<String, Object> payment = chatRoomService.selectPayment(map);
			
			System.out.println("payment의 값은 : " + payment);
			model.addAttribute("payment", payment);
			}
			if(lastroomcheck == 1) { //똑같은 채팅방 uuid가 있다는 의미입니다. 그래서 과거 대화기록을 불러옵니다.(
				//System.out.println("last chat list의 map 값입니다 : " + map);
				map.put("me", me);
				//ENTER, TALK, OUT, PAYMENT, TRADEOK, TRADENO
				map.put("ENTER", "ENTER");
				map.put("TALK", "TALK");
				map.put("OUT", "OUT");
				map.put("PAYMENT", "PAYMENT");
				map.put("TRADEOK", "TRADEOK");
				map.put("TRADENO", "TRADENO");
				List<Map<String, Object>> lastchatlist = chatRoomService.lastChatList(map); //ouuid의 과거 채팅 내역 불러옵니다. dialogue 테이블의 ouuid컬럼 제외한 전부 다 불러옵니다.
				System.out.println("불러온 채팅 목록 : " + lastchatlist);
				model.addAttribute("tnormalstate", tnormalstate);
				model.addAttribute("lastroomcheck", lastroomcheck);
				model.addAttribute("lastchatlist", lastchatlist);
				model.addAttribute("tno", tno);
				model.addAttribute("roomId", roomId);
				model.addAttribute("oseller", oseller);
				model.addAttribute("mnickname", mnickname);
				model.addAttribute("emessage", emessage);
				model.addAttribute("obuyer", obuyer);
				model.addAttribute("tcmessage", tcmessage);
				model.addAttribute("tnoname", tnoname);
				return "/chat/roomdetail";

			} else if(lastroomcheck == 0) {
				model.addAttribute("tnormalstate", tnormalstate);
				model.addAttribute("lastroomcheck", lastroomcheck);
				model.addAttribute("tno", tno);
				model.addAttribute("roomId", roomId);
				model.addAttribute("oseller", oseller);
				model.addAttribute("mnickname", mnickname);
				model.addAttribute("emessage", emessage);
				model.addAttribute("obuyer", obuyer);
				model.addAttribute("tcmessage", tcmessage);
				model.addAttribute("tnoname", tnoname);
				return "/chat/roomdetail";

			}
			
			//System.out.println("최종적으로 담기는 값 : " + map);
			return "/chat/roomdetail";
		}

		return "/login";

	}
	
	//판매자(oseller)가 접속할 roomalarm.jsp에 접속하는 메소드입니다.
	//판매자는 구매자에게 알람을 보내지 않아서 alarm은 없습니다.
	@PostMapping("/alarmChat")
	public String alarmChat(@RequestParam String roomId, Model model) {
		//System.out.println("roomId의 값은 : " + roomId);
		
		// System.out.println("룸 아이디는 " + roomId); 오는거 확인했어요.
		// System.out.println("roomId는 " + roommap.get("roomId"));
		Map<String, Object> map = chatRoomService.alarmChat(roomId); //tno, oseller, obuyer 불러와서 저장하는 맵입니다.
		
		int tnormalstate = chatRoomService.selectTnormalstate(map);
		
		//System.out.println("map의 값은 : " + map);
		map.put("roomId", roomId);
		//System.out.println("roomId가 나오나요? : " + roomId);
		//System.out.println("chatRoomService.alarmChat(roomId) 의 결과값입니다 : " + map);
		map.put("ENTER", "ENTER");
		map.put("TALK", "TALK");
		map.put("OUT", "OUT");
		map.put("PAYMENT", "PAYMENT");
		map.put("TRADEOK", "TRADEOK");
		map.put("TRADENO", "TRADENO");
		int searchchatroom = chatRoomService.searchChatRoom(map);
		List<Map<String, Object>> lastchatlist = chatRoomService.lastChatList(map); //서버에 저장된 지난 대화내용 불러오는 리스트맵입니다.
		// System.out.println(map);
		String obuyer = String.valueOf(map.get("obuyer"));
		String tno = String.valueOf(map.get("tno"));
		String oseller = String.valueOf(map.get("oseller"));
		String mnickname = chatRoomService.mNickName(oseller); //판매자 닉네임입니다.
		String econtent = mnickname + "님이 입장하셨습니다.";
		String tnoname = chatRoomService.tnoName(tno);
		
		if(tnormalstate == 1) {
			Map<String, Object> payment = chatRoomService.selectPayment(map);
			
			System.out.println("payment의 값은 : " + payment);
			model.addAttribute("payment", payment);
			}
		
		model.addAttribute("tnormalstate", tnormalstate);
		model.addAttribute("lastroomcheck", searchchatroom);
		model.addAttribute("lastchatlist", lastchatlist);
		model.addAttribute("roomId", roomId);
		model.addAttribute("tno", tno);
		model.addAttribute("obuyer", obuyer);
		model.addAttribute("oseller", oseller);
		model.addAttribute("mnickname", mnickname);
		model.addAttribute("econtent", econtent);
		model.addAttribute("tnoname", tnoname);
		return "/chat/roomalarm";
	}
	
	@GetMapping("/alarm")
	public String alarm(HttpSession session, Model model) {
		
		if (session.getAttribute("muuid") != null && !(session.getAttribute("muuid").equals(""))) { //로그인 여부를 검사합니다.
		
		String muuid = String.valueOf(session.getAttribute("muuid")); //판매자의 uuid를 받아옵니다.
		
		List<Map<String, Object>> alarmlist = chatRoomService.alarmList(muuid); //로그아웃해 있던 동안 쌓인 알림 리스트 받아옵니다.
		
		System.out.println("알림 리스트: " + alarmlist);
		
		model.addAttribute("alarmlist", alarmlist); //alarmlist(방의 uuid와 alarm 내용을 alarmlist)라는 이름으로 모델로 보냅니다.
		
		return "/chat/alarm"; //알람리스트 페이지입니다.
		
		} else {
			return "/login";
		}
		
	}
	
	@PostMapping("/alarmcount")
	@ResponseBody
	public String alarmcount(@RequestParam String oseller) {
		int roomcount = chatRoomService.alarmcount(oseller);
		JSONObject json = new JSONObject();
		json.put("count",roomcount);
		return json.toString();
	}
	
	//알람 리스트 페이지에 들어가면 세션을 사용해서 받아온 알람들의 acheck 값을 다 0으로 update합니다.
	@PostMapping("/alarmcheck")
	public void alarm(HttpSession session) {
		
		//System.out.println("muuid는 " + muuid);
		
		if(session.getAttribute("muuid") != null && !(session.getAttribute("muuid").equals(""))) {
			String muuid = String.valueOf(session.getAttribute("muuid"));
			int setcheckzero = chatRoomService.setCheckZero(muuid);
		}
	}
	
	@PostMapping("/auctionchat")
	public String auctionChat(@RequestParam String roomId, Model model) {
		
		Map<String, Object> map = chatRoomService.auctionChat(roomId);
		String tno = String.valueOf(map.get("tno"));
		String oseller = String.valueOf(map.get("oseller"));
		String obuyer = String.valueOf(map.get("obuyer"));
		
		model.addAttribute("roomId", roomId);
		model.addAttribute("tno", tno);
		model.addAttribute("oseller", oseller);
		model.addAttribute("obuyer", obuyer);
		
		map.put("roomId", roomId);
		
		List<Map<String, Object>> lastchatlist = chatRoomService.lastChatList(map);
		
		model.addAttribute("lastchatlist", lastchatlist);
		
		int searchchatroom = chatRoomService.searchChatRoom(map);
		
		if(searchchatroom == 1) {
			model.addAttribute("lastroomcheck", searchchatroom);
		}
		
		return "/chat/auctionchat";
	}


}