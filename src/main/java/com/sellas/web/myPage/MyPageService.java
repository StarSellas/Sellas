package com.sellas.web.myPage;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import javax.mail.Multipart;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.multipart.MultipartFile;

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
		Map<String, Object> member  = myPageDAO.memberInfo(uuid);
		
		//mpoint가 100이상일 경우에도 100으로 나옴
		int mpoint = Integer.parseInt(member.get("mpoint").toString());
		if(mpoint > 100) {
			member.put("mpoint", 100);
		}
		
		return  member;
	}

	public int isNicknameExists(String newNickname) {
		
		return myPageDAO.isNicknameExists(newNickname);
	}

	public int nicknameModify(Map<String, Object> map) {

		return myPageDAO.nicknameModify(map);
	}

	public List<Map<String, Object>> getprofileReview(Object attribute) {
		 List<Map<String, Object>> profileReview = myPageDAO.getprofileReview(attribute);
		return formatDates(profileReview);
	}

	public Map<String, Object> reviewDetail(Map<String, Object> map) {
		return myPageDAO.reviewDetail(map);
	}

	public Map<String, Object> reviewDetailByMe(Map<String, Object> map) {
		return myPageDAO.reviewDetailByMe(map);
	}
	
	
    public List<Map<String, Object>> getSell(String uuid) {
        List<Map<String, Object>> sellList = myPageDAO.getSell(uuid);
        return formatDates(sellList);
    }


	public List<Map<String, Object>> getBuy(String uuid) {
		List<Map<String, Object>> buyList = myPageDAO.getBuy(uuid);
		return formatDates(buyList);
	}

	public List<Map<String, Object>> getAucSell(String uuid) {
		List<Map<String, Object>> aucSellList= myPageDAO.getAucSell(uuid);
		return formatDates(aucSellList);
	}


	public List<Map<String, Object>> getAucBuy(String uuid) {
		List<Map<String, Object>>  aucBuyList= myPageDAO.getAucBuy(uuid);
		return formatDates(aucBuyList);
	}


	public int addWish(Map<String, Object> map) {
		return myPageDAO.addWish(map);
	}

	public int delWish(Map<String, Object> map) {
		return myPageDAO.delWish(map);
	}

	public List<Map<String, Object>> getWish(String uuid) {
		List<Map<String, Object>> wishList = myPageDAO.getWish(uuid);
		return formatDates(wishList);
	}

	public List<Map<String, Object>> getMyPost(String uuid) {
		return myPageDAO.getMyPost(uuid);
	}

	public List<Map<String, Object>> getMyComment(String uuid) {
		return myPageDAO.getMyComment(uuid);
	}

	public int photoModify(Map<String, Object> memberphoto) {
		  
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder
					.currentRequestAttributes()).getRequest();
			String path = request.getServletContext().getRealPath("/userImgUpload");
			
			Object fileObject = memberphoto.get("mphoto");

			if (fileObject instanceof MultipartFile) {
				
				//멀티파트파일
			    MultipartFile file = (MultipartFile) fileObject;
			    String[] split = file.getOriginalFilename().split("/");
			    System.out.println("split : " + split);
			    
			    LocalDateTime ldt = LocalDateTime.now();
				String format = ldt.format(DateTimeFormatter.ofPattern("YYYYMMddHHmmss"));
				String realFileName = format + "num" + split[split.length-1];
			    
				// 확장자 자르기
				String[] parts = file.getOriginalFilename().split("\\.");
				String lastPart = parts[parts.length - 1];
				
				System.out.println(lastPart);
				System.out.println(parts);

				
				if (!(lastPart.equals("jpg") || lastPart.equals("png") || lastPart.equals("jpeg")
				        || lastPart.equals("bmp") || lastPart.equals("gif") || lastPart.equals("jpe"))) {
				    // 허용된 확장자가 아니면 처리하지 않음
				  return -1;
				  
				} else {
				
				File mphoto = new File(path, realFileName);
				System.out.println("mphoto : " + mphoto);
				
				try {
					FileCopyUtils.copy(file.getBytes(), mphoto);
				} catch (IllegalStateException e) {
					e.printStackTrace();
				} catch (IOException e) {
					e.printStackTrace();
				}
				memberphoto.put("mphoto", realFileName);
				}		
			    
			} else {
			    System.out.println("해당 키에 해당하는 파일이 MultipartFile이 아닙니다.");
			    return -1;
			}
		
		return myPageDAO.photoModify(memberphoto);
	}

	public int photoModifySubmit(String uuid) {
		return myPageDAO.photoModifySubmit(uuid);
	}

	
	/**
	 * 오늘이면 시간, 아니라면 날짜를 보여주는 로직
	 * @param currentDateTime
	 * @param targetDateTime
	 * @return
	 */
	  public boolean isToday(LocalDateTime currentDateTime, LocalDateTime targetDateTime) {
	        SimpleDateFormat sdfDate = new SimpleDateFormat("yyyy-MM-dd");
	        return sdfDate.format(convertToDate(currentDateTime)).equals(sdfDate.format(convertToDate(targetDateTime)));
	    }

	    private List<Map<String, Object>> formatDates(List<Map<String, Object>> dataList) {
	        LocalDateTime currentDateTime = LocalDateTime.now();
	        SimpleDateFormat sdfDateTime = new SimpleDateFormat("HH시 mm분");
	        SimpleDateFormat sdfDate = new SimpleDateFormat("yyyy-MM-dd");

	        for (Map<String, Object> data : dataList) {
	            LocalDateTime tDateTime = (LocalDateTime) data.get("tdate");
	            String displayDate = isToday(currentDateTime, tDateTime)
	                    ? sdfDateTime.format(convertToDate(tDateTime))
	                    : sdfDate.format(convertToDate(tDateTime));
	            data.put("displayDate", displayDate);

	        }

	        return dataList;
	    }

	    private Date convertToDate(LocalDateTime dateTime) {
	        return Date.from(dateTime.atZone(ZoneId.systemDefault()).toInstant());
	    }



}
