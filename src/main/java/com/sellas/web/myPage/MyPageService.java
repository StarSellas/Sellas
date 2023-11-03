package com.sellas.web.myPage;

import java.util.List;
import java.util.Map;
import java.util.Optional;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class MyPageService {

	@Autowired
	MyPageDAO myPageDAO;
	
	
	@Transactional(rollbackFor = Exception.class)
	public int inputReview(ReviewDTO reviewDTO, HttpSession session) {
		
		   String uuid = String.valueOf(session.getAttribute("muuid"));
		    reviewDTO.setMuuid(uuid);
		
	    try {
	    	//평점합치기
	        int rpoint = reviewDTO.getReviewStar1() + reviewDTO.getReviewStar2() + reviewDTO.getReviewStar3();
	        reviewDTO.setRpoint(rpoint);
	        
	        //상대방의 uuid가져오기
	        //세션에 저장된 uuid가 파는사람의 uuid와 같다면
	        if(uuid.equals(reviewDTO.getPseller())) {
	        	String targetMember = reviewDTO.getPbuyer();
	        	//평점 올려줄 멤버에 산 사람 uuid를 넣어주세요.
	        	reviewDTO.setTargetMember(targetMember);
	        	
	        } else {
	        	String targetMember = reviewDTO.getPseller();
	        	reviewDTO.setTargetMember(targetMember);
	        	
	        }
	        
	        System.out.println("상대방"+reviewDTO.getTargetMember());
	        
	        int resultInput = myPageDAO.inputReview(reviewDTO);
	        int resultUpdate = myPageDAO.updatePoint(reviewDTO);

	        if (resultInput == 1 && resultUpdate == 1) {
	            return 1; // 성공적으로 처리됨
	        } else {
	            return 0; // 하나 이상의 작업이 실패함
	        }
	    } catch (Exception e) {
	        // 예외 처리
	        return -1;
	    }
	}

	public ReviewDTO findId(String tno) {
		return myPageDAO.findId(tno);
	}

	public Map<String, Object> memberInfo(String uuid) {
		return myPageDAO.memberInfo(uuid);
	}

	public int isNicknameExists(String newNickname) {
		
		return myPageDAO.isNicknameExists(newNickname);
	}

	public int nicknameModify(Map<String, Object> map) {

		return myPageDAO.nicknameModify(map);
	}

	public List<Map<String, Object>> getprofileReview(Object attribute) {
		return myPageDAO.getprofileReview(attribute);
	}

	public Map<String, Object> reviewDetail(int rno) {
		return myPageDAO.reviewDetail(rno);
	}

	public List<Map<String, Object>> getSell(String uuid) {
		return myPageDAO.getSell(uuid);
	}

	public List<Map<String, Object>> getBuy(String uuid) {
		return myPageDAO.getBuy(uuid);
	}

	public Map<String, Object> hasReview(String uuid) {
		
		return myPageDAO.hasReview(uuid);
	}

	
	

	

}
