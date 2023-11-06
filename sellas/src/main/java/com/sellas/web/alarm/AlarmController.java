package com.sellas.web.alarm;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequestMapping("/chat")
public class AlarmController {
	
	@Autowired
	private AlarmService alarmService;
	
	//채팅 아이콘 클릭하면 여기를 지나서 알람 리스트 페이지로 들어갑니다.
	//로그아웃한 동안 쌓인 알람 리스트 서버에서 받아오는 메소드입니다.
	//로그인하면 세션에서 muuid받아와서 그걸로 서버에서 받아옵니다.
	@GetMapping("/alarm")
	public String alarm(HttpSession session, Model model) {
		
		String muuid = (String) session.getAttribute("muuid"); //판매자의 uuid를 받아옵니다.
		
		List<Map<String, Object>> alarmlist = alarmService.alarmList(muuid); //로그아웃해 있던 동안 쌓인 알림 리스트 받아옵니다.
		
		//System.out.println("알림 리스트: " + alarmlist);
		
		model.addAttribute("alarmlist", alarmlist); //alarmlist(방의 uuid와 alarm 내용을 alarmlist)라는 이름으로 모델로 보냅니다.
		
		return "/chat/alarm"; //알람리스트 페이지입니다.
		
	}
	
	//알람 리스트 페이지에 들어가면 세션을 사용해서 받아온 알람들의 acheck 값을 다 0으로 update합니다.
	@PostMapping("/alarmcheck")
	public void alarm(HttpSession session) {
		
		//System.out.println("muuid는 " + muuid);
		
		if(session.getAttribute("muuid") != null && !(session.getAttribute("muuid").equals(""))) {
			String muuid = String.valueOf(session.getAttribute("muuid"));
			int setcheckzero = alarmService.setCheckZero(muuid);
		}
	}
	
}
