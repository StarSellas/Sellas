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
	
	@GetMapping("/alarm")
	public String alarm(HttpSession session, Model model) {
		
		String muuid = (String) session.getAttribute("muuid"); //판매자의 uuid를 받아옵니다.
		
		List<Map<String, Object>> alarmlist = alarmService.alarmList(muuid); //로그아웃해 있던 동안 쌓인 알림 리스트 받아옵니다.
		
		System.out.println("알림 리스트: " + alarmlist);
		
			model.addAttribute("alarmlist", alarmlist); //alarmlist(방의 uuid와 alarm 내용을 alarmlist)라는 이름으로 모델로 보냅니다.
		
		return "/chat/alarm";
		
	}
	
	@PostMapping("/alarm")
	public void alarm(@RequestParam String muuid) {
		
		//System.out.println("muuid는 " + muuid);
		
		if(muuid != null && !(muuid.equals(""))) {
			int setcheckzero = alarmService.setCheckZero(muuid);
		}
	}
	
}
