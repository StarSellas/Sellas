package com.sellas.web.normaltrade;

import java.io.File;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.multipart.MultipartFile;

@Controller
public class NormalController {
	@Autowired
	private NormalService normalService;

	// main.jsp로 보내주는 메소드입니다.
	@GetMapping("/")
	public String index(Model model, Model alarmmodel, HttpSession session) {
		
		// ==========================하드코딩 해놨습니다~~~~~ 합쳐지면 지움===================
		String muuid = String.valueOf(session.getAttribute("muuid"));
		
		// 세션에 저장된 uuid를 가지고 회원 정보 조회
		Map<String, Object> mainMemberInfo = normalService.mainMember(muuid);
		// System.out.println("메인 회원의 정보입니다 : " + mainMemberInfo);
		model.addAttribute("memberInfo", mainMemberInfo);
		 
		// 거래 리스트를 뽑아옵니다.

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("sortBy", "tno");
		map.put("inOrder", "desc"); 
		List<Map<String, Object>> normalBoardList = normalService.normalBoardList(map);

		//System.out.println("보드 리스트 : " + normalBoardList);
		// System.out.println(tradeBoardList);
		model.addAttribute("normalBoardList", normalBoardList);
		
		if(session.getAttribute("muuid") != null && !(session.getAttribute("muuid").equals(""))) {
			//System.out.println("muuid:" + muuid);
			int alarmcount = normalService.alarmCount(muuid);
			alarmmodel.addAttribute("alarmcount", alarmcount);
		}
		
		return "main";
	} 
	
	//메인 화면 리스트 정렬 메소드입니다.
	@ResponseBody
	@GetMapping("sortNormalTradeList")
	public String sortNormalTradeList(@RequestParam Map<String, Object> map) {
		//System.out.println("들어오는 map 값입니다 : " + map);
		List<Map<String, Object>> sortNormalBoradList = normalService.normalBoardList(map);
		JSONObject json = new JSONObject();
		json.put("sortNormalBoradList", sortNormalBoradList);
		//System.out.println("제이슨 값입니다 : " + json.toString());
		return json.toString();
	}
	
	
	
	// default jsp로 보내주는 메소드입니다.
	@GetMapping("default")
	public String basic() {
		return "default";
	}

	// 글 쓰기를 눌렀을 때 tradeWrite로 보내주는 메소드입니다.
	@GetMapping("/normalWrite")
	public String tradeWrite(Model model, HttpSession session) {
		// 세션에 값이 없으면 로그인 창으로 보내기 설정

		model.addAttribute("muuid", session.getAttribute("muuid"));

		// 카테고리 list로 불러오기
		List<Map<String, Object>> categoryList = normalService.cateList();

		//System.out.println(categoryList);
		// [{ino=7, iname=가공식품}, {ino=2, iname=가구 / 인테리어},....]

		model.addAttribute("categoryList", categoryList);
		return "normalWrite";
	}

	// 글쓰기 버튼을 눌렀을 때 실행되는 메소드입니다.
	// 사진 파일 업로드 사용하실거면 매개변수 tradeimg랑 주석 참고
	@PostMapping("/normalWirte")
	public String tradeWirte(@RequestParam(value = "tradeimg", required = false) List<MultipartFile> tradeimg,
			@RequestParam Map<String, Object> map) {
		 //System.out.println("글쓰기에서 보내주는 값입니당 : " + map);
		 //System.out.println("이미지가 오려나..?" + tradeimg);
		// System.out.println("트레이드 이미지 사이즈는 : " + tradeimg.size());

		// 일단 보드에 넣어보자
		int tradeWriteResult = normalService.normalWrite(map);
		if (tradeWriteResult == 1) {

			int LastTno = (int) map.get("tno");

			//System.out.println("★★ 방금 넣은 따끈따끈한 값입니다 : " + LastTno);
			// 가져온 tno 값을 맵에 넣기
			map.put("tno", LastTno);
			// 여기부터 사진 넣는 방식임다

			if (tradeimg != null && !tradeimg.isEmpty()) {

				for (int i = 0; i < tradeimg.size(); i++) {

					// 저장할 경로명 뽑기 request뽑기
					HttpServletRequest req = ((ServletRequestAttributes) RequestContextHolder
							.currentRequestAttributes()).getRequest();
					String path = req.getServletContext().getRealPath("/tradeImgUpload");
					//System.out.println("이미지 오리지널 파일 이름 : " + tradeimg.get(i).getOriginalFilename());
					LocalDateTime ldt = LocalDateTime.now();
					String format = ldt.format(DateTimeFormatter.ofPattern("YYYYMMddHHmmss"));
					String realFileName = format + "num" + i + tradeimg.get(i).getOriginalFilename();

					// 확장자 자르기
					String[] parts = tradeimg.get(i).getOriginalFilename().split("\\.");
					String lastPart = parts[parts.length - 1];
					//System.out.println(lastPart);

					// 확장자 아니면 파일 없애보리기

					if (!(lastPart.equals("jpg") || lastPart.equals("png") || lastPart.equals("jpeg")
							|| lastPart.equals("bmp") || lastPart.equals("gif") || lastPart.equals("jpe"))) {
						continue;
					}

					File newFileName = new File(path, realFileName);

					// 진짜 이름을 맵에 넣기
					map.put("realFileName", realFileName);

					try {
						FileCopyUtils.copy(tradeimg.get(i).getBytes(), newFileName);

						int insertTradeimgResult = normalService.insertTradeimg(map);

						if (insertTradeimgResult == 1 && i == 0) {
							normalService.setThumbnail(realFileName);
						}

					} catch (IOException e) {
						e.printStackTrace();
					}

				} // for문의 끝
			} // (!tradeimg.isEmpty()) 의 끝(사진 넣기 끝)

		} // tradeResult의 값이 1일 때 if 문의 끝

		return "redirect:/";
	}

	@GetMapping("/normalDetail") 
	public String tradeDetail(@RequestParam(name = "tno", required = true, defaultValue = "1") int tno, Model model) {
		//System.out.println("tno 값은 : " + tno);
		// tno값에 맞는 값을 가져오기
		Map<String, Object> normalDetail = normalService.normalDetail(tno);
		//System.out.println("디테일 값입니다 : " + normalDetail);
		// 조회수 올리기
		normalService.normalTreadUpdate(tno);
		// 혹시 사진이 있나요?
		int normalDetailCount = normalService.normalDetailCount(tno);
		//System.out.println("사진이 있나요? " + normalDetailCount);
		if (normalDetailCount > 0) {
			// 사진 realFileName 가져오기
			List<Map<String, Object>> normalDetailImage = normalService.normalDetailImage(tno);
			//System.out.println("실제 파일 이름입니당 : " + normalDetailImage);
			// 모델에 값 넣기
			model.addAttribute("normalDetailImage", normalDetailImage);
		}

		model.addAttribute("detail", normalDetail);
		return "normalDetail";
	}

	// 수정하기
	@GetMapping("/normalEdit")
	public String normalEdit(@RequestParam(value = "tno") int tno, Model model) {
		//System.out.println(tno);
		Map<String, Object> normalDetail = normalService.normalDetail(tno);

		// 카테고리 list로 불러오기
				List<Map<String, Object>> categoryList = normalService.cateList();

				model.addAttribute("categoryList", categoryList);
		
		
		int normalDetailCount = normalService.normalDetailCount(tno);
		//모델에 카운트 값 넣기
		model.addAttribute("normalDetailCount", normalDetailCount);
		 
		if (normalDetailCount > 0) {
			// 사진 realFileName 가져오기
			List<Map<String, Object>> normalDetailImage = normalService.normalDetailImage(tno);
			
			// 모델에 값 넣기
			model.addAttribute("normalDetailImage", normalDetailImage);
			
			
			//System.out.println("노말 디테일 이미지 어떻게 오나오 ? : " + normalDetailImage);
		}
		//System.out.println("normalDetail값은 이렇게 옵니다 : " + normalDetail);
		model.addAttribute("detail", normalDetail);
		return "normalEdit";
	}

	//일반거래 게시글 삭제 메소드입니다.
	@ResponseBody
	@PostMapping("/normalDelete")
	public String normalDelete(@RequestParam Map<String, Object> map, HttpSession session) {
		JSONObject json = new JSONObject();
		
		//System.out.println(map);
		if( map.get("muuid").equals(session.getAttribute("muuid"))) {
			int normalDelete = normalService.normalDelete(map);
			//System.out.println("삭제돼랏" + normalDelete);
			if(normalDelete == 1) {
				json.put("deleteSuccess", 1);
			}  
		}else {
			return "redirect:/";
		}
		return json.toString();
	}
	
	//웨일페이 충전하기를 눌렀을 때 결제 정보를 보내러 가는 메소드입니다.
	@GetMapping("/fillPay")
	public String fillPay(Model model, HttpSession session) {
		model.addAttribute("mnickname", session.getAttribute("mnickname"));
		
		return "/fillPay";
	}
	
	//결제 정보를 가져온 뒤 부트페이로 보내는 메소드입니다.
	@PostMapping("/fillRequset")
	public String fillRequset(@RequestParam Map<String, Object> map, Model model) {
		//System.out.println(map);
		model.addAttribute("bootpayDetail", map);
		return "/bootpay";
	} 
	
	//결제가 완료되었을 때 실행되는 메소드입니다.
	@PostMapping("/payOK")
	public String payOK(@RequestParam Map<String, Object> map) {
		//System.out.println("결제가 성공하면 나오는 값 " + map);
		int fillResult = normalService.fillWhalePay(map); 
			if(fillResult == 1 ) {
				normalService.fillMamount(map);
			}  
		//결제 성공하면 어디로 보낼지 정해봅시당
		return "redirect:/";
	}
	
	
	
	
	@PostMapping("/normalEdit")
	public String normalEdit(@RequestParam(value = "tradeimg", required = false) List<MultipartFile> tradeimg,
			@RequestParam Map<String, Object> map) {
		//System.out.println("이미지 값이 어떻게 올까요? " + tradeimg);
		//System.out.println(map); 

		int normalEditResult = normalService.normalEdit(map);
		if(normalEditResult == 1) {
			
	
			if((map.get("selectedImage0") != null && !(map.get("selectedImage0").equals("")))
		|| (map.get("selectedImage1") != null && !(map.get("selectedImage1").equals(""))) 
		|| (map.get("selectedImage2") != null && !(map.get("selectedImage2").equals("")))){
			//수정된 사진이 있다면 삭제하는 식.
			Map<String, Object> deleteImage = new HashMap<String, Object>();
			deleteImage.put("tno", map.get("tno"));
			for (Map.Entry<String, Object> entry : map.entrySet()) {
				String selectedImage = entry.getKey();
				Object Imagesrc = entry.getValue();
				
				if(selectedImage.startsWith("selectedImage")) {
					deleteImage.put(selectedImage, Imagesrc);
				}
			}
			//System.out.println("deleteImage의 값입니당 왔으면 좋겠다 : "+deleteImage);
			
			int normalDeleteEditImageResult = normalService.normalDeleteEditImage(deleteImage);
			//System.out.println("수정되었을 때 사진이 삭제되는지 ?? : " + normalDeleteEditImageResult);
			
			}//if(!(map.get("selectedImage0").equals(""))) 끝
			
			
			//사진 업로드
			if (tradeimg != null && !tradeimg.isEmpty()) {
				//System.out.println("이게 왜 안나옴?????????????????????????????????????????");
				for (int i = 0; i < tradeimg.size(); i++) {

					// 저장할 경로명 뽑기 request뽑기
					HttpServletRequest req = ((ServletRequestAttributes) RequestContextHolder
							.currentRequestAttributes()).getRequest();
					String path = req.getServletContext().getRealPath("/tradeImgUpload");
					//System.out.println("이미지 오리지널 파일 이름 : " + tradeimg.get(i).getOriginalFilename());
					LocalDateTime ldt = LocalDateTime.now();
					String format = ldt.format(DateTimeFormatter.ofPattern("YYYYMMddHHmmss"));
					String realFileName = format + "num" + i + tradeimg.get(i).getOriginalFilename();

					// 확장자 자르기
					String[] parts = tradeimg.get(i).getOriginalFilename().split("\\.");
					String lastPart = parts[parts.length - 1];
					//System.out.println(lastPart);

					// 확장자 아니면 파일 없애보리기

					if (!(lastPart.equals("jpg") || lastPart.equals("png") || lastPart.equals("jpeg")
							|| lastPart.equals("bmp") || lastPart.equals("gif") || lastPart.equals("jpe"))) {
						continue;
					}

					File newFileName = new File(path, realFileName);

					// 진짜 이름을 맵에 넣기
					map.put("realFileName", realFileName);

					try {
						FileCopyUtils.copy(tradeimg.get(i).getBytes(), newFileName);

						int insertTradeimgResult = normalService.insertTradeimg(map);

						if (insertTradeimgResult == 1 && i == 0) {
							
							int ThumbnailCount =  normalService.SelectnormalThumbnail(map);
							if(ThumbnailCount == 0) {
								normalService.setThumbnail(realFileName);
								
							}
							
						}

					} catch (IOException e) {
						e.printStackTrace();
					}

				} // for문의 끝
			} // (!tradeimg.isEmpty()) 의 끝(사진 넣기 끝)
			
		}
		
		return "redirect:/normalDetail?tno="+map.get("tno");
	}
	
	
	//이건 채팅이 구현되면 사용하겠습니다.
	//채팅 신청 -> 채팅방 개설 -> 거래 수락 -> tnormalstate 값 수정하고 payment에 값 박고 돈 빼고 거래 시작!
	
	//거래 파기 > tnormalstate값 수정하고 payment에 enddate 넣고 
	@PostMapping("/checkTnormalstate")
	@ResponseBody
	public String checkTnormalstate(@RequestParam Map<String, Object> map) {
		JSONObject json = new JSONObject();
		//System.out.println(map);
		int tnormalstate = normalService.selectTnormalstate(map);
		json.put("tnormalstate", tnormalstate);
		//System.out.println("tnormalstate의 값은 : " + tnormalstate);
		if(tnormalstate==0) {
			//거래가 가능한 경우
			int mamount = normalService.selectMamountForTrade(map);
			//System.out.println("너 얼마있냐?? : " + mamount);
			json.put("mamount", mamount);
			if(mamount >= Integer.parseInt(String.valueOf(map.get("tnormalprice")))) {
				//돈 빼고 state 1로 바꾸고 payment 에 값 넣자
				//먼저 돈을 빼버리자
				int takeMamount = normalService.takeMamount(map);
					if(takeMamount == 1) {
						//state를 1로 바꾸자
					 int changeStateForTrade = 	normalService.changeStateForNormal(map);
					 	if(changeStateForTrade ==1 ) {
					 		//payment에 값을 넣자
					 			int insertPaymentForNormal = normalService.insertPaymentForNormal(map);
					 			if(insertPaymentForNormal == 1) {
					 				json.put("success", 1);
					 				//처음 거래 신청할 때는 pseller은 대기상태, pbuyer은 수락상태.
					 				//이후 pseller가 수락을 하면 둘 다 대기상태(2)로 변경.
					 				//구매 성공 시 성공 메소드를 따로 처리
					 				//구매 실패 시 실패 메소드를 따로 처리
					 				
					 			}//if(insertPaymentForNormal == 1) 끝
					 	}//if(changeStateForTrade ==1 ) 끝
					}//if(takeMamount == 1) 끝
			}else {
				//System.out.println("ㅠㅠ 못사요");
				//json에 따로 값을 넣어서 경고창을 날릴 수 있게 해주자
			}
			
		}
		 
		
		return json.toString();
	}
	
	
	//위 메소드에서 다 처리할 수 있으면 삭제함
	@PostMapping("/requestTrade")
	@ResponseBody
	public String requestTrade(@RequestParam(value = "mnickname") String mnickname) {
		//System.out.println(mnickname);
		JSONObject json = new JSONObject();
		return json.toString(); 
		
	}
	
	@PostMapping("/compareamounts")
	@ResponseBody
	public String compareAmounts(@RequestParam(name ="tno") String tno, @RequestParam(name ="obuyer") String obuyer) {
		//구매자가 충전한 금액이 상품 금액보다 크면 1리턴합니다.
		int productamounts = normalService.productAmount(tno);
		int obuyeramounts = normalService.obuyerAmounts(obuyer);
		JSONObject json = new JSONObject();
		int comparecount = 2;
		if(obuyeramounts >= productamounts) {
		    comparecount = 1;
		
		} else {
			comparecount = 0;
		}
		json.put("comparecount", comparecount);
		return json.toString();
	}
	
	
	
	
}// 컨트롤러 끝
