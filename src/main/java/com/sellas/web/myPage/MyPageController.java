package com.sellas.web.myPage;

import java.util.List;
import java.util.Map;
import java.util.Optional;

import javax.servlet.http.HttpSession;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import retrofit2.http.GET;


@Controller
public class MyPageController {

	@Autowired
	MyPageService myPageService;

	@GetMapping("/mypage")
	public String myPage(Model model, HttpSession session) {
		
		String uuid = String.valueOf(session.getAttribute("muuid"));
		//가져오는값 :mnickname, mpoint, mbalance
		
		//세션에 저장된 uuid를 가지고 멤버조회
		Map<String, Object> member = myPageService.memberInfo(uuid);
		
		//일치하는 정보가 없다면
		if(member == null) {
			return "login";
		}
		
		 session.setAttribute("mpoint", member.get("mpoint"));
		 model.addAttribute("nickname", session.getAttribute("mnickname"));
		 model.addAttribute("exp", session.getAttribute("mpoint"));
		 
		return "mypage";
	}
	
	

	//TODO 화면부분
	@GetMapping("/profile")
	public String profile(Model model, HttpSession session) {
		
		//로그인 안했을시
		if(session==null) {
			return "login";
		}
		
		
		//거래후기불러오기
		List<Map<String, Object>> profileReview = myPageService.getprofileReview(session.getAttribute("muuid"));
		
		 model.addAttribute("nickname", session.getAttribute("mnickname"));
		 model.addAttribute("exp", session.getAttribute("mpoint"));
		 model.addAttribute("profileReview" , profileReview );

		return "profile";
	}
	
	
	//다른회원정보보기
	@GetMapping("/profileMember")
	public String profileMember(@RequestParam("muuid") String uuid, Model model, HttpSession session) {
		
		if(uuid == session.getAttribute("muuid")) {
			return "profile";
		}
		
		//멤버불러오기
		Map<String, Object> member = myPageService.memberInfo(uuid);
		model.addAttribute("nickname", member.get("mnickname"));
		model.addAttribute("exp", member.get("mpoint"));
		
		//TODO 판매내역띄우기
		
		//거래후기
		List<Map<String, Object>> profileReview = myPageService.getprofileReview(uuid);
		 model.addAttribute("profileReview" , profileReview );
		
		
		return "profileMember";
	}
	
	
	//TODO 사진부분 추가
	//프로필수정(닉네임/사진)
	   @GetMapping("/profileEdit/{muuid}")
	   public String profileEdit(@PathVariable("muuid") String uuid, Model model, HttpSession session) {
	      
	      model.addAttribute("nickname", session.getAttribute("mnickname"));
	      
	      
	      return "profileEdit";
	   }
	   
	
	/**
	 * 닉네임 중복검사
	 * @param newNickname
	 * @return
	 */
    @PostMapping("/profileEdit/isNicknameExists")
    @ResponseBody
    public int isNicknameExists(@RequestParam("newNickname") String newNickname) {
	int result = myPageService.isNicknameExists(newNickname);
	
    	return result;
    }
	

    @PostMapping("/profileEdit/nicknameModify")
    @ResponseBody
    public int mypageModify(@RequestParam Map<String, Object> map, HttpSession session) {
    
   
    	map.put("uuid",session.getAttribute("muuid"));
    	int result = myPageService.nicknameModify(map);
    	
    	
    	//닉네임 변경 성공시 세션에 새닉네임 넣어줌
    	if(result == 1) {
    		session.setAttribute("mnickname",map.get("newNickname"));
    		
    	}
    	

      return result;
    }
	
    /**
     * 거래후기불러오기
     * @param pno
     * @param model
     * @param session
     * @return
     */

	//거래후기글쓰기
	@GetMapping("review")
	public String review(@RequestParam("tno") String tno, Model model, HttpSession session) {
		// 구매자,판매자확인
		ReviewDTO reviewMember = myPageService.findId(tno);
		
		// 구매정보불러와서 화면전환
		// 후기쓰는 자가 판매자인 경우
		if (reviewMember.getPseller() == session.getAttribute("muuid")) {
			model.addAttribute("type", "seller");
			model.addAttribute("reviewMember",reviewMember);
			return "review";
		}
		model.addAttribute("type", "buyer");
		model.addAttribute("reviewMember",reviewMember);
		return "review";

	}

	//TODO 전환페이지 다시만들기
	//후기작성등록
	@PostMapping("review")
	public String review(ReviewDTO reviewDTO, HttpSession session) {

		int result = myPageService.inputReview(reviewDTO, session);
		
		if (result == 1) {
			return "mypage";
			
		} else {
			return "profile";
		}
	}
	
	
	//후기디테일
	//후기상세페이지
	@GetMapping("reviewDetail")
	public String reviewDetail(@RequestParam int rno, Model model, HttpSession session) {
		
	
		
		
		Map<String, Object> reviewDetail = myPageService.reviewDetail(rno);
		
		System.out.println("뭐가있는지봅시다"+reviewDetail);
		model.addAttribute("reviewDetail", reviewDetail);
		
		return "reviewDetail";
	
	
	}
	
	
	//판매내역
	@GetMapping("getsell")
	public String getSell(Model model, HttpSession session) {
		
		String uuid = String.valueOf(session.getAttribute("muuid"));
		
		//추후수정
		/*
		 * //리뷰중복확인 List<Map<String, Object>> hasReview = myPageService.hasReview(uuid);
		 * model.addAttribute("hasReview",hasReview);
		 */

		//판매내역불러오기
		List<Map<String, Object>> sellList = myPageService.getSell(uuid);
		model.addAttribute("sellList",sellList);
		
		
		return "sellList";
		
	}
	
	

	
	//구매내역
	@GetMapping("getbuy")
	public String getBuy(Model model, HttpSession session) {
		
		String uuid = String.valueOf(session.getAttribute("muuid"));
		
		
		//구매진짜한것만
		List<Map<String, Object>> buyList = myPageService.getBuy(uuid);
		model.addAttribute("buyList",buyList);
		
		return "buyList";
		
	}
	
	
	//TODO 경매내역
	
	
	
	
	
	
	


}
