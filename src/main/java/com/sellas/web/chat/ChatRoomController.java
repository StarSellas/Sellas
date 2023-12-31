package com.sellas.web.chat;

import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.io.File;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.multipart.MultipartFile;

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
		//System.out.println("onlyalarm에ㅐ서 받아오는 맵값 : " + map); tno, oseller, obuyer
		
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
			int checkenter = chatRoomService.checkEnter(map);
			if(checkenter > 0) {
				model.addAttribute("checkenter", checkenter);
			}
			
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
			String mphototime = chatRoomService.getMphoto(me);
			int lastroomcheck = Integer.parseInt(String.valueOf(map.get("lastroomcheck")));
			int searchchatroom = chatRoomService.searchChatRoom(map);
			int tnormalstate = chatRoomService.selectTnormalstate(map);
			int tnormalprice = chatRoomService.tNormalPrice(map);
			model.addAttribute("tnormalprice", tnormalprice);
			String tnoname = chatRoomService.tnoName(tno);
			if (tnoname.length() >= 10) {
			    tnoname = tnoname.substring(0, 10) + "...";
			}
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
				//System.out.println("불러온 채팅 목록 : " + lastchatlist);
				model.addAttribute("tnormalstate", tnormalstate);
				model.addAttribute("lastroomcheck", lastroomcheck);
				
				for (int n = 0; n < lastchatlist.size(); n++) {
				    Map<String, Object> chatroom = lastchatlist.get(n);
				    LocalDateTime localDateTime = (LocalDateTime) chatroom.get("ddate");
				    Timestamp ddate = Timestamp.valueOf(localDateTime);

				    // 현재 시간과의 차이 계산
				    long timeDiff = System.currentTimeMillis() - ddate.getTime();
				    long hoursDiff = timeDiff / (60 * 60 * 1000);

				    SimpleDateFormat sdf;
				    if (hoursDiff < 24) {
				        // 24시간 이내라면 시간과 분으로 표시
				        sdf = new SimpleDateFormat("HH시 mm분");
				    } else {
				        // 24시간 이후라면 월과 일로 표시
				        sdf = new SimpleDateFormat("MM월 dd일");
				    }

				    // Date를 사용하여 Timestamp를 형식에 맞게 변환
				    Date date = new Date(ddate.getTime());
				    String formattedDate = sdf.format(date);

				    // chatroom 맵에 변환된 날짜를 저장
				    chatroom.replace("ddate", formattedDate);
				    lastchatlist.set(n, chatroom);
				}
				
				for (int n = 0; n < lastchatlist.size(); n++) {
				    // chatroomlist에서 n번째 chatroom 맵을 가져옴
				    Map<String, Object> chatroom = lastchatlist.get(n);

				    // chatroom 맵에 ttitle 키가 없다면, tno를 사용하여 trade 테이블에서 ttitle 조회
				    if (!chatroom.containsKey("mphoto")) {
				        String muuid = String.valueOf(session.getAttribute("muuid"));
				        String mphoto = chatRoomService.getMphoto(muuid);

				        // 조회된 ttitle을 chatroom 맵에 추가
				        chatroom.put("mphoto", mphoto);
				        lastchatlist.set(n, chatroom);
				    }
				}
				
				model.addAttribute("lastchatlist", lastchatlist);
				model.addAttribute("tno", tno);
				model.addAttribute("roomId", roomId);
				model.addAttribute("oseller", oseller);
				model.addAttribute("mnickname", mnickname);
				model.addAttribute("emessage", emessage);
				model.addAttribute("obuyer", obuyer);
				model.addAttribute("tcmessage", tcmessage);
				model.addAttribute("tnoname", tnoname);
				model.addAttribute("mphoto", mphototime);
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
				model.addAttribute("mphoto", mphototime);
				return "/chat/roomdetail";

			}
			int checkenter = chatRoomService.checkEnter(map);
			
			model.addAttribute("checkenter", checkenter);
			
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
		String mphoto = chatRoomService.getMphoto(oseller);
		if (tnoname.length() >= 10) {
		    tnoname = tnoname.substring(0, 10) + "...";
		}
		
		if(tnormalstate == 1) {
			Map<String, Object> payment = chatRoomService.selectPayment(map);
			
			System.out.println("payment의 값은 : " + payment);
			model.addAttribute("payment", payment);
			}
		
		model.addAttribute("tnormalstate", tnormalstate);
		model.addAttribute("lastroomcheck", searchchatroom);
		
		for (int n = 0; n < lastchatlist.size(); n++) {
		    Map<String, Object> chatroom = lastchatlist.get(n);
		    LocalDateTime localDateTime = (LocalDateTime) chatroom.get("ddate");
		    Timestamp ddate = Timestamp.valueOf(localDateTime);

		    // 현재 시간과의 차이 계산
		    long timeDiff = System.currentTimeMillis() - ddate.getTime();
		    long hoursDiff = timeDiff / (60 * 60 * 1000);

		    SimpleDateFormat sdf;
		    if (hoursDiff < 24) {
		        // 24시간 이내라면 시간과 분으로 표시
		        sdf = new SimpleDateFormat("HH시 mm분");
		    } else {
		        // 24시간 이후라면 월과 일로 표시
		        sdf = new SimpleDateFormat("MM월 dd일");
		    }

		    // Date를 사용하여 Timestamp를 형식에 맞게 변환
		    Date date = new Date(ddate.getTime());
		    String formattedDate = sdf.format(date);

		    // chatroom 맵에 변환된 날짜를 저장
		    chatroom.replace("ddate", formattedDate);
		    lastchatlist.set(n, chatroom);
		}
		
		for (int n = 0; n < lastchatlist.size(); n++) {
		    // chatroomlist에서 n번째 chatroom 맵을 가져옴
		    Map<String, Object> chatroom = lastchatlist.get(n);

		    // chatroom 맵에 ttitle 키가 없다면, tno를 사용하여 trade 테이블에서 ttitle 조회
		    if (!chatroom.containsKey("mphoto")) {
		        String muuid = oseller;
		        String pastmphoto = chatRoomService.getMphoto(muuid);

		        // 조회된 ttitle을 chatroom 맵에 추가
		        chatroom.put("mphoto", pastmphoto);
		        lastchatlist.set(n, chatroom);
		    }
		}

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
		
		//System.out.println("알림 리스트: " + alarmlist);
		
		model.addAttribute("alarmlist", alarmlist); //alarmlist(방의 uuid와 alarm 내용을 alarmlist)라는 이름으로 모델로 보냅니다.
		
		List<Map<String, Object>> chatroomlist = chatRoomService.chatRoomList(muuid); //내 muuid를 통해서 내가 있는 ouuid와 tno, oseller, obuyer 가져옵니다.
		
		for (int n = 0; n < chatroomlist.size(); n++) {
		    // chatroomlist에서 n번째 chatroom 맵을 가져옴
		    Map<String, Object> chatroom = chatroomlist.get(n);

		    // chatroom 맵에 ttitle 키가 없다면, tno를 사용하여 trade 테이블에서 ttitle 조회
		    if (!chatroom.containsKey("ttitle")) {
		        Integer tno = (Integer) chatroom.get("tno");
		        String ttitle = chatRoomService.getTtitleByTno(tno);
		        if (ttitle.length() >= 10) {
		        	ttitle = ttitle.substring(0, 10) + "...";
		        }

		        // 조회된 ttitle을 chatroom 맵에 추가
		        chatroom.put("ttitle", ttitle);
		        chatroomlist.set(n, chatroom);
		    }
		}
		
		for (int n = 0; n < chatroomlist.size(); n++) {
		    // chatroomlist에서 n번째 chatroom 맵을 가져옴
		    Map<String, Object> chatroom = chatroomlist.get(n);

		    // chatroom 맵에 ttitle 키가 없다면, tno를 사용하여 trade 테이블에서 ttitle 조회
		    if (!chatroom.containsKey("dcontent")) {
		        String ouuid = String.valueOf(chatroom.get("ouuid"));
		        String dcontent = chatRoomService.getDcontentByTno(ouuid);

		        // 조회된 ttitle을 chatroom 맵에 추가
		        chatroom.put("dcontent", dcontent);
		        chatroomlist.set(n, chatroom);
		    }
		}
		
		for (int n = 0; n < chatroomlist.size(); n++) {
		    // chatroomlist에서 n번째 chatroom 맵을 가져옴
		    Map<String, Object> chatroom = chatroomlist.get(n);

		    // chatroom 맵에 ttitle 키가 없다면, tno를 사용하여 trade 테이블에서 ttitle 조회
		    if (!chatroom.containsKey("sortdate")) {
		        String ouuid = String.valueOf(chatroom.get("ouuid"));
		        Timestamp sortdate = chatRoomService.getDdateByOuuid(ouuid);

		        // 조회된 ttitle을 chatroom 맵에 추가
		        chatroom.put("sortdate", sortdate);
		        chatroomlist.set(n, chatroom);
		    }
		}
		
		for (int n = 0; n < chatroomlist.size(); n++) {
		    // List<Map<String, Object>> chatroomlist에서 n번째 Map<String, Object> chatroom 맵을 가져옴
		    Map<String, Object> chatroom = chatroomlist.get(n);

		    // chatroom 맵에 ttitle(물품제목) 키가 없다면, tno(물품번호)를 사용하여 trade 테이블에서 ttitle 조회
		    if (!chatroom.containsKey("thumbnail")) { //chatroom에 썸네일이라는 이름의 키가 없으면
		        Integer tno = (Integer) chatroom.get("tno"); //물품번호 가져오고
		        String thumbnail = chatRoomService.getThumbnailByTno(tno); //서버에서 이미지 가져옵니다.
		        
		        String filePath = "../tradeImgUpload/" + thumbnail; //파일경로를 만듭니다.

		        try { //이미지 파일이 그 경로에 실제로 있는지 검사합니다.
		            // Resource 객체를 생성하여 파일을 로드
		            Resource resource = new UrlResource(filePath); //파일경로에 실제로 파일이 있는지 검사합니다.

		            // 파일이 존재하는지 확인
		            if (resource.exists()) { //검사하는 if문입니다.
		                int thumbnailcheck = 1; //1이면 사진이 실제로 있다는 의미입니다.
		                chatroom.put("thumbnailcheck", thumbnailcheck); //jsp에 chatroomlist를 모델로 보내서 거기서 ${chatroomlist.thumbnailcheck}가 1이면 사진을 등록합니다.
		                chatroom.put("thumbnail", thumbnail);
		            } else {
		                // 파일이 존재하지 않으면 디폴트 이미지 사용
		            	int thumbnailcheck = 0; //0이면 그냥 디폴트 이미지를 등록합니다.
		            	chatroom.put("thumbnailcheck", thumbnailcheck);
		            }
		        } catch (Exception e) {
		            // 예외 처리
		            e.printStackTrace();
		        }

		        chatroomlist.set(n, chatroom);
		    }
		}
		
		for (int n = 0; n < chatroomlist.size(); n++) {
		    // chatroomlist에서 n번째 chatroom 맵을 가져옴
		    Map<String, Object> chatroom = chatroomlist.get(n);

		    // chatroom 맵에 ttitle 키가 없다면, tno를 사용하여 trade 테이블에서 ttitle 조회
		    if (!chatroom.containsKey("lastroomcheck")) {
		        Integer lastroomcheck = chatRoomService.searchChatRoom(chatroom);

		        // 조회된 ttitle을 chatroom 맵에 추가
		        chatroom.put("lastroomcheck", lastroomcheck);
		        chatroomlist.set(n, chatroom);
		    }
		}
		
		for (int n = 0; n < chatroomlist.size(); n++) {
		    // List<Map<String,Object>> chatroomlist에서 n번째 Map<String, Object> chatroom 맵을 가져옴
		    Map<String, Object> chatroom = chatroomlist.get(n);

		    // chatroom 맵에 ttitle(물품 이름) 키가 없다면, tno(물품 번호)를 사용하여 trade 테이블에서 ttitle 조회
		    if (!chatroom.containsKey("ddate")) {
		        String ouuid = String.valueOf(chatroom.get("ouuid"));
		        Timestamp ddate = chatRoomService.getDdateByOuuid(ouuid);
		        
		     // 현재 시간과의 차이 계산
			    long timeDiff = System.currentTimeMillis() - ddate.getTime(); //만약 여기에 null값이 들어와 오류나면
			    //서버에 onlinechat과 dialogue 테이블에 한 쪽에는 채팅방이 있고, 다른곳엔 없어서 그런겁니다.
			    //제일 쉬운 해결법은 다 삭제하는 겁니다.
			    long hoursDiff = timeDiff / (60 * 60 * 1000);

			    SimpleDateFormat sdf;
			    if (hoursDiff < 24) {
			        // 24시간 이내라면 시간과 분으로 표시
			        sdf = new SimpleDateFormat("오늘");
			    } else {
			        // 24시간 이후라면 월과 일로 표시
			        sdf = new SimpleDateFormat("MM월 dd일");
			    }

			    // Date를 사용하여 Timestamp를 형식에 맞게 변환
			    Date date = new Date(ddate.getTime());
			    String formattedDate = sdf.format(date);

		        // 조회된 ttitle을 chatroom 맵에 추가
		        chatroom.put("ddate", formattedDate);
		        chatroomlist.set(n, chatroom);
		    }
		}
		
		Collections.sort(chatroomlist, new Comparator<Map<String, Object>>() {
		    @Override
		    public int compare(Map<String, Object> o1, Map<String, Object> o2) {
		        // 각 Map에서 sortdate 값을 가져옴
		        Timestamp sortdate1 = (Timestamp) o1.get("sortdate");
		        Timestamp sortdate2 = (Timestamp) o2.get("sortdate");

		        // sortdate 값을 비교하여 정렬
		        return sortdate2.compareTo(sortdate1);
		    }
		});
		
		model.addAttribute("chatroomlist", chatroomlist);
		
		return "/chat/alarm"; //채팅방 리스트 페이지입니다.
		
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
	
	//채팅 리스트 페이지에 들어가면 세션을 사용해서 받아온 알람들의 acheck 값을 다 0으로 update합니다.
//	@PostMapping("/alarmcheck")
//	@ResponseBody
//	public String alarm(@RequestBody String ouuid, HttpSession session) {
//		
//		//System.out.println("muuid는 " + muuid);
//		
//		if(session.getAttribute("muuid") != null && !(session.getAttribute("muuid").equals(""))) {
//			
//			
//			int setcheckzero = chatRoomService.setCheckZero(ouuid);
//			
//			JSONObject json = new JSONObject();
//			
//			if(setcheckzero > 0) {
//				
//				json.put("check", 1);
//				
//			} else {
//				
//				json.put("check", 0);
//				
//			}
//			
//			return json.toString();
//			
//		}
//		
//		return "/";
//	}
	
	@PostMapping("/auctionchat")
	public String auctionChat(@RequestParam(name="roomId") String roomId, @RequestParam(name="lastroomcheck") int lastroomcheck, Model model, HttpSession session) {
		
		Map<String, Object> map = chatRoomService.auctionChat(roomId); //roomId를 이용해서 tno, oseller, obuyer를 가져왔습니다.
		String tno = String.valueOf(map.get("tno"));
		String oseller = String.valueOf(map.get("oseller"));
		String obuyer = String.valueOf(map.get("obuyer"));
		
		model.addAttribute("roomId", roomId);
		model.addAttribute("tno", tno);
		model.addAttribute("oseller", oseller);
		model.addAttribute("obuyer", obuyer);
		
		map.put("roomId", roomId);
		
		if(lastroomcheck == 1) {
		List<Map<String, Object>> lastchatlist = chatRoomService.lastChatList(map);
		
		for (int n = 0; n < lastchatlist.size(); n++) {
		    // chatroomlist에서 n번째 chatroom 맵을 가져옴
		    Map<String, Object> chatroom = lastchatlist.get(n);

		    // chatroom 맵에 ttitle 키가 없다면, tno를 사용하여 trade 테이블에서 ttitle 조회
		    if (!chatroom.containsKey("mphoto")) {
		        String muuid = String.valueOf(session.getAttribute("muuid"));
		        String mphoto = chatRoomService.getMphoto(muuid);
		        
		        String filePath = "../userImgUpload/" + mphoto;

		        try {
		            // Resource 객체를 생성하여 파일을 로드
		            Resource resource = new UrlResource(filePath);

		            // 파일이 존재하는지 확인
		            if (resource.exists()) {
		                int mphotocheck = 1;
		                chatroom.put("mphotocheck", mphotocheck);
		                chatroom.put("mphoto", mphoto);
		            } else {
		                // 파일이 존재하지 않으면 디폴트 이미지 사용
		            	int mphotocheck = 0;
		            	chatroom.put("mphotocheck", mphotocheck);
		            }
		        } catch (Exception e) {
		            // 예외 처리
		            e.printStackTrace();
		        }
		        
		        // 조회된 ttitle을 chatroom 맵에 추가
		        chatroom.put("mphoto", mphoto);
		        lastchatlist.set(n, chatroom);
		    }
		}
		
		for (int n = 0; n < lastchatlist.size(); n++) {
		    Map<String, Object> chatroom = lastchatlist.get(n);
		    LocalDateTime localDateTime = (LocalDateTime) chatroom.get("ddate");
		    Timestamp ddate = Timestamp.valueOf(localDateTime);

		    // 현재 시간과의 차이 계산
		    long timeDiff = System.currentTimeMillis() - ddate.getTime();
		    long hoursDiff = timeDiff / (60 * 60 * 1000);

		    SimpleDateFormat sdf;
		    if (hoursDiff < 24) {
		        // 24시간 이내라면 시간과 분으로 표시
		        sdf = new SimpleDateFormat("HH시 mm분");
		    } else {
		        // 24시간 이후라면 월과 일로 표시
		        sdf = new SimpleDateFormat("MM월 dd일");
		    }

		    // Date를 사용하여 Timestamp를 형식에 맞게 변환
		    Date date = new Date(ddate.getTime());
		    String formattedDate = sdf.format(date);

		    // chatroom 맵에 변환된 날짜를 저장
		    chatroom.replace("ddate", formattedDate);
		    lastchatlist.set(n, chatroom);
		}
		model.addAttribute("lastchatlist", lastchatlist);
		model.addAttribute("lastroomcheck", lastroomcheck);
		
		}

		String mphoto = chatRoomService.getMphoto(String.valueOf(session.getAttribute("muuid")));
		
		String filePath = "../userImgUpload/" + mphoto;

        try {
            // Resource 객체를 생성하여 파일을 로드
            Resource resource = new UrlResource(filePath);

            // 파일이 존재하는지 확인
            if (resource.exists()) {
                int mphotocheck = 1;
                model.addAttribute("mphotocheck", mphotocheck);
                model.addAttribute("mphoto", mphoto);
            } else {
                // 파일이 존재하지 않으면 디폴트 이미지 사용
            	int mphotocheck = 0;
            	model.addAttribute("mphotocheck", mphotocheck);
            }
        } catch (Exception e) {
            // 예외 처리
            e.printStackTrace();
        }
		
		model.addAttribute("mphoto", mphoto);
		
		
		return "/chat/auctionchat";
	}
	
	@PostMapping("/alarmauction")
	@ResponseBody
	public String alarmauction(@RequestParam Map<String, Object> map) {
		
		JSONObject json = new JSONObject();
		
		int auction = chatRoomService.auctionCheck(map);
		
		json.put("auction", auction);
		
		return json.toString();
	}
	
	@ResponseBody
	@PostMapping("/chatImage")
	   public String chatImageupload(@RequestParam(name = "file") List<MultipartFile> chatImgFile) {
	      System.out.println(chatImgFile);
	      Map<String, Object> map = new HashMap<String, Object>();
	      
	      
	      if (chatImgFile != null && !chatImgFile.isEmpty()) {

	         for (int i = 0; i < chatImgFile.size(); i++) {

	            // 저장할 경로명 뽑기 request뽑기
	            HttpServletRequest req = ((ServletRequestAttributes) RequestContextHolder
	                  .currentRequestAttributes()).getRequest();
	            String path = req.getServletContext().getRealPath("/chatImgUpload");
	            System.out.println("이미지 오리지널 파일 이름 : " + chatImgFile.get(i).getOriginalFilename());
	            LocalDateTime ldt = LocalDateTime.now();
	            String format = ldt.format(DateTimeFormatter.ofPattern("YYYYMMddHHmmss"));
	            
	            // 확장자 자르기
	            String[] parts = chatImgFile.get(i).getOriginalFilename().split("\\.");
	            String lastPart = parts[parts.length - 1];
	            System.out.println(lastPart);

	            String realFileName = format + "num" + i +"."+lastPart;
	            // 확장자 아니면 파일 없애보리기

	            if (!(lastPart.equals("jpg") || lastPart.equals("png") || lastPart.equals("jpeg")
	                  || lastPart.equals("bmp") || lastPart.equals("gif") || lastPart.equals("jpe"))) {
	               continue;
	            }
	            
	            
	            

	            File newFileName = new File(path, realFileName);

	            // 진짜 이름을 맵에 넣기
	            map.put("realFileName", realFileName);

	            try {
	               FileCopyUtils.copy(chatImgFile.get(i).getBytes(), newFileName);



	            } catch (IOException e) {
	               e.printStackTrace();
	            }

	         } // for문의 끝
	      } // (!tradeimg.isEmpty()) 의 끝(사진 넣기 끝)
	      return "";
	   }
}