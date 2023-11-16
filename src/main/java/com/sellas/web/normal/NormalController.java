package com.sellas.web.normal;

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

	 @GetMapping("/menu")
	   public String menu() {
	      return "menu";
	   }
	 
	   // main.jsp로 보내주는 메소드입니다.
	   @GetMapping("/")
	   public String index(@RequestParam(value = "searchCate", required = false , defaultValue = "title") String searchCate,
	                  @RequestParam(value = "search", required = false) String search,
	                  Model model, HttpSession session) {
	      
		   Map<String, Object> map = new HashMap<String, Object>();
		   
		   map.put("search", "");
		   //System.out.println("search : " + search);
		   //System.out.println("searchCate : " + searchCate);
		   
	      String muuid = String.valueOf(session.getAttribute("muuid"));

	      // 세션에 저장된 uuid를 가지고 회원 정보 조회
	      Map<String, Object> mainMemberInfo = normalService.mainMember(muuid);
	      // System.out.println("메인 회원의 정보입니다 : " + mainMemberInfo);
	      model.addAttribute("memberInfo", mainMemberInfo);
	      model.addAttribute("addTradeItem", 1);
	      
	   // 검색누른경우(검색값 없는경우 포함)
	      if(search != null && searchCate != null) {
	         
	         //System.out.println("메인에서 잡는 searchCate : " + searchCate);
	         //System.out.println("메인에서 잡는 search : " + search);
	    	 map.put("searchCate", searchCate);
	         map.put("search", search);
	         map.put("orderBy", "ORDER BY tno DESC");
	         
	         //System.out.println("main의 map(검색O) : " + map);
	         List<Map<String, Object>> normalSearchList = normalService.normalSearchList(map);
	         //System.out.println("normalSearchList : " + normalSearchList);
	         model.addAttribute("normalSearchList", normalSearchList);
	         model.addAttribute("searchCate", searchCate);
	         System.out.println("searchCate : " + model.getAttribute("searchCate"));
	         
	      } else {
	    	  
	    	  // 검색안했을 때
	    	  map.put("search", "");
	    	  //System.out.println("main의 map(검색X) : " + map);
	    	  // 거래 리스트를 뽑아옵니다. (최신순10개)
	    	  List<Map<String, Object>> normalBoardList = normalService.normalBoardList();
	    	  //System.out.println("보드 리스트 : " + normalBoardList);
	    	  model.addAttribute("normalBoardList", normalBoardList);
	      }
	      
	      return "main";
	   }
	   
	   // 스크롤페이징
	      @ResponseBody
	      @PostMapping("/nextTradePage")
	      public String nextPage(@RequestParam(value = "searchCate", required = false , defaultValue = "title") String searchCate,
					    		  @RequestParam(value = "search", required = false) String search,
					    		  @RequestParam(value = "ino",required = true, defaultValue = "0")int ino,
					  			  @RequestParam(name = "sort", defaultValue = "0") int sort,
					    		  @RequestParam Map<String, Object> map, HttpSession session) {
			
		   JSONObject json = new JSONObject();
		   //System.out.println("sort : " + sort);
		   //System.out.println("ino : " + ino);
		   //System.out.println("search : " + search);
		   //System.out.println("searchCate : " + searchCate);
		   
		// 메인(ino없)
					if(sort == 0 && ino == 0) {
						
						//System.out.println("sort도0, ino도0 (메인next)");
						
						map.put("searchCate", searchCate);
				  		map.put("orderBy", "ORDER BY tno DESC");
				  		
				  		// 메인 & 검색했을때
				  		if(search != "" && searchCate != null) {
				  			
				  			map.put("search", search);
				  			//System.out.println("쿼리갈map (sort는0 + 검색O + next): " + map);
				  			// {lasttno=233, count=14, search=ㅇㅇ, startpage=20, pageCount=10, searchCate=title, orderBy=ORDER BY tno DESC}
				  			//System.out.println("검색했을때는 맞는데");
				  			List<Map<String, Object>> nextNormalBoardList = normalService.nextNormalBoardList(map);
					        //System.out.println("다음리스트 : " + nextNormalBoardList);
					        
					        json.put("list", nextNormalBoardList);
				  			
					    // 메인 & 검색안했을때 (검색값 없는경우 포함)
				  		} else {
				  			
				  			map.put("search", "");
				  			//System.out.println("쿼리갈map (sort는0 + 검색X + next): " + map);
				  			//  {lasttno=245, count=23, search=, startpage=10, pageCount=10, searchCate=title, orderBy=ORDER BY tno DESC}
				  			List<Map<String, Object>> nextNormalBoardList = normalService.nextNormalBoardList(map);
				  			//System.out.println("다음리스트 : " + nextNormalBoardList);
				  			
				  			json.put("list", nextNormalBoardList);
				  		}
				  		
				  	// 메인(ino있 + sort있)
					} else {
						
						String orderBy = "";
				  		switch (sort) {
				  		case 1:
				  			orderBy = "ORDER BY tnormalprice ASC";
				  			break;
				  		case 2:
				  			orderBy = "ORDER BY tnormalprice DESC";
				  			break;
				  		case 3:
				  			orderBy = "ORDER BY tread DESC";
				  			break;
				  		default:
				  			// 기본 정렬은 tno DESC
				  			orderBy = "ORDER BY tno DESC";
				  			break;
				  		}
				  		String[] sortList = { "최신순", "가격 낮은 순", "가격 높은 순", "인기순" }; 
				  		
				  		map.put("orderBy", orderBy);
				    	//System.out.println("다음페이지순서는 : " + map.get("orderBy"));
				    	
				 		// 검색한경우
				    	if(search != "" && searchCate != null) {
				  			
				  			map.put("search", search);
				  			//System.out.println("쿼리문MAP (sortnext+검색O): " + map);
				  			
				  			List<Map<String, Object>> nextNormalBoardList = normalService.nextsortNormalList(map);
					        //System.out.println("다음리스트(검색O) : " + nextNormalBoardList);
					        json.put("list", nextNormalBoardList);
				  		
					     // 검색안한경우 (검색값 없는경우 포함)
				  		} else {
				  			
				  			//System.out.println("쿼리문MAP (sortnext_검색x): " + map);
				  			List<Map<String, Object>> nextsortNormalList = normalService.nextsortNormalList(map);
				  			//System.out.println("다음리스트(검색x) : " + nextsortNormalList);
				  			json.put("list", nextsortNormalList);
				  		}
			         
					} 
					
					 String muuid = String.valueOf(session.getAttribute("muuid"));

			         // 세션에 저장된 uuid를 가지고 회원 정보 조회
			         Map<String, Object> mainMemberInfo = normalService.mainMember(muuid);
			         // System.out.println("메인 회원의 정보입니다 : " + mainMemberInfo);
			         json.put("memberInfo", mainMemberInfo);
			         

			         return json.toString();
			         
			      }
	   
	   // 카테고리별 정렬 메소드입니다.
	  	@GetMapping("/sortcate")
	  	public String sortNormalTradeList(@RequestParam(value = "ino",required = true, defaultValue = "1")int ino,
	  										@RequestParam(name = "sort", defaultValue = "0") int sort,
	  										@RequestParam(value = "searchCate", required = false , defaultValue = "title") String searchCate,
	  							            @RequestParam(value = "search", required = false) String search,
	  										Model model, HttpSession session) {
	  		
	  		Map<String, Object> map = new HashMap<String, Object>();
	  		
	  		//System.out.println("*********************");
	  		//System.out.println("ino: " + ino);
	  		//System.out.println("sort: " + sort);
	  		//System.out.println("searchCate: " + searchCate);
	  		//System.out.println("search: " + search);	// null
	  		// {search=, searchCate=, ino=1, sort=0}
	  		
	  		
	  		String orderBy = "";
	  		switch (sort) {
	  		case 1:
	  			orderBy = "ORDER BY tnormalprice ASC";
	  			break;
	  		case 2:
	  			orderBy = "ORDER BY tnormalprice DESC";
	  			break;
	  		case 3:
	  			orderBy = "ORDER BY tread DESC";
	  			break;
	  		default:
	  			// 기본 정렬은 tno DESC
	  			orderBy = "ORDER BY tno DESC";
	  			break;
	  		}
	  		String[] sortList = { "최신순", "가격 낮은 순", "가격 높은 순", "인기순" };
	  		
	  		map.put("orderBy", orderBy);
	  		map.put("ino", ino);
	  		map.put("sort", sort);
	  		map.put("search", "");
	  		
	  		// 검색했을때
	  		if(search != null && searchCate != null) {
	  	         
	  	         //System.out.println("sort메인에서 보낸 searchCate : " + searchCate);
	  	         //System.out.println("sort메인에서 보낸 search : " + search);
	  	    	 map.put("searchCate", searchCate);
	  	         map.put("search", search);
	  	         
	  	         //System.out.println("쿼리문MAP (정렬O+검색O) : " + map);
	  	         // {search=ㅇㅇ, searchCate=title, ino=1, sort=0, orderBy=ORDER BY tno DESC}
	  	         List<Map<String, Object>> normalSearchList = normalService.normalSearchList(map);
	  	         //System.out.println("정렬O + 검색O : " + normalSearchList);
	  	         model.addAttribute("SnormalSearchList", normalSearchList);
	  	         
	  	       // 검색안했을 때
	  	      } else {
	  	    	  
	  	    	  map.put("searchCate", searchCate);
	  	    	  //System.out.println("쿼리문MAP (정렬O+검색X): " + map);
	  	    	  List<Map<String, Object>> sortNormalList = normalService.sortNormalList(map);
	  	    	  
	  	    	  //System.out.println("정렬O + 검색X" + sortNormalList);
	  	    	  model.addAttribute("SnormalBoardList", sortNormalList);
	  	    	  
	  	      }
	  		
	  		String muuid = String.valueOf(session.getAttribute("muuid"));

	
	  	      // 세션에 저장된 uuid를 가지고 회원 정보 조회
	  	      Map<String, Object> mainMemberInfo = normalService.mainMember(muuid);
	  	      // System.out.println("메인 회원의 정보입니다 : " + mainMemberInfo);
	  	      model.addAttribute("memberInfo", mainMemberInfo);
	  	      model.addAttribute("sortList", sortList[sort]);
	  	      model.addAttribute("ino", ino);
	  	      
	  		return "/sortMain";
	  	}

	
	
	// 글 쓰기를 눌렀을 때 tradeWrite로 보내주는 메소드입니다.
	@GetMapping("/normalWrite")
	public String tradeWrite(Model model, HttpSession session) {
		// 세션에 값이 없으면 로그인 창으로 보내기 설정

		model.addAttribute("muuid", session.getAttribute("muuid"));

		// 카테고리 list로 불러오기
		List<Map<String, Object>> categoryList = normalService.cateList();

		// System.out.println(categoryList);
		// [{ino=7, iname=가공식품}, {ino=2, iname=가구 / 인테리어},....]

		model.addAttribute("categoryList", categoryList);
		return "normalWrite";
	}

	
	// 글쓰기 버튼을 눌렀을 때 실행되는 메소드입니다.
	// 사진 파일 업로드 사용하실거면 매개변수 tradeimg랑 주석 참고
	@PostMapping("/normalWirte")
	public String tradeWirte(@RequestParam(value = "tradeimg", required = false) List<MultipartFile> tradeimg,
			@RequestParam Map<String, Object> map) {
		System.out.println("글쓰기에서 보내주는 값입니당 : " + map);
		System.out.println("이미지가 오려나..?" + tradeimg);
		// System.out.println("트레이드 이미지 사이즈는 : " + tradeimg.size());

		// 일단 보드에 넣어보자
		int tradeWriteResult = normalService.normalWrite(map);
		if (tradeWriteResult == 1) {

			int LastTno = (int) map.get("tno");

			System.out.println("★★ 방금 넣은 따끈따끈한 값입니다 : " + LastTno);
			// 가져온 tno 값을 맵에 넣기
			map.put("tno", LastTno);
			// 여기부터 사진 넣는 방식임다

			if (tradeimg != null && !tradeimg.isEmpty()) {

				for (int i = 0; i < tradeimg.size(); i++) {

					// 저장할 경로명 뽑기 request뽑기
					HttpServletRequest req = ((ServletRequestAttributes) RequestContextHolder
							.currentRequestAttributes()).getRequest();
					String path = req.getServletContext().getRealPath("/tradeImgUpload");
					System.out.println("이미지 오리지널 파일 이름 : " + tradeimg.get(i).getOriginalFilename());
					LocalDateTime ldt = LocalDateTime.now();
					String format = ldt.format(DateTimeFormatter.ofPattern("YYYYMMddHHmmss"));
					String realFileName = format + "num" + i + tradeimg.get(i).getOriginalFilename();

					// 확장자 자르기
					String[] parts = tradeimg.get(i).getOriginalFilename().split("\\.");
					String lastPart = parts[parts.length - 1];
					System.out.println(lastPart);

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
	
	//노말 디테일로 리다이렉트 해주는 메소드입니다.
		@GetMapping("/redirectnormalDetail")
		public String redirectnormalDetail(@RequestParam(value = "tno")int tno) {
			System.out.println("끌올 tno의 값은 : " + tno);
			return "redirect:/normalDetail?tno="+tno;
		}
	
	//TODO 지은 찜 추가부분
	@GetMapping("/normalDetail")
	public String tradeDetail(@RequestParam(name = "tno", required = true, defaultValue = "1") int tno, Model model, HttpSession session) {
		System.out.println("tno 값은 : " + tno);
		// tno값에 맞는 값을 가져오기
		Map<String, Object> normalDetail = normalService.normalDetail(tno);
		System.out.println("디테일 값입니다 : " + normalDetail);
		// 조회수 올리기
		normalService.normalTreadUpdate(tno);
		// 혹시 사진이 있나요?
		int normalDetailCount = normalService.normalDetailCount(tno);
		System.out.println("사진이 있나요? " + normalDetailCount);
		if (normalDetailCount > 0) {
			// 사진 realFileName 가져오기
			List<Map<String, Object>> normalDetailImage = normalService.normalDetailImage(tno);
			System.out.println("실제 파일 이름입니당 : " + normalDetailImage);
			// 모델에 값 넣기
			model.addAttribute("normalDetailImage", normalDetailImage);
			
		}
		//찜여부 확인
		Map<String,Object> wishInfo = new HashMap<>();
		wishInfo.put("tno", tno);
		wishInfo.put("muuid",session.getAttribute("muuid"));
		Map<String,Object> hasWish = normalService.hasWish(wishInfo);
		System.out.println(hasWish);
		model.addAttribute("hasWish",hasWish);
		model.addAttribute("detail", normalDetail);
		return "normalDetail";
	}

	// 수정하기
	@GetMapping("/normalEdit")
	public String normalEdit(@RequestParam(value = "tno") int tno, Model model) {
		System.out.println(tno);
		Map<String, Object> normalDetail = normalService.normalDetail(tno);

		// 카테고리 list로 불러오기
		List<Map<String, Object>> categoryList = normalService.cateList();

		model.addAttribute("categoryList", categoryList);

		int normalDetailCount = normalService.normalDetailCount(tno);
		// 모델에 카운트 값 넣기
		model.addAttribute("normalDetailCount", normalDetailCount);

		if (normalDetailCount > 0) {
			// 사진 realFileName 가져오기
			List<Map<String, Object>> normalDetailImage = normalService.normalDetailImage(tno);

			// 모델에 값 넣기
			model.addAttribute("normalDetailImage", normalDetailImage);

			System.out.println("노말 디테일 이미지 어떻게 오나오 ? : " + normalDetailImage);
		}
		System.out.println("normalDetail값은 이렇게 옵니다 : " + normalDetail);
		model.addAttribute("detail", normalDetail);
		return "normalEdit";
	}

	// 일반거래 게시글 삭제 메소드입니다.
	@ResponseBody
	@PostMapping("/normalDelete")
	public String normalDelete(@RequestParam Map<String, Object> map, HttpSession session) {
		JSONObject json = new JSONObject();

		System.out.println(map);
		if (map.get("muuid").equals(session.getAttribute("muuid"))) {
			int normalDelete = normalService.normalDelete(map);
			System.out.println("삭제돼랏" + normalDelete);
			if (normalDelete == 1) {
				json.put("deleteSuccess", 1);
			}
		} else {
			return "redirect:/";
		}
		return json.toString();
	}

	// 웨일페이 충전하기를 눌렀을 때 결제 정보를 보내러 가는 메소드입니다.
	@GetMapping("/fillPay")
	public String fillPay(Model model, HttpSession session) {
		model.addAttribute("mnickname", session.getAttribute("mnickname"));

		return "/fillPay";
	}

	// 결제 정보를 가져온 뒤 부트페이로 보내는 메소드입니다.
	@PostMapping("/fillRequset")
	public String fillRequset(@RequestParam Map<String, Object> map, Model model) {
		System.out.println(map);
		model.addAttribute("bootpayDetail", map);
		return "/bootpay";
	}

	// 결제가 완료되었을 때 실행되는 메소드입니다.
	@PostMapping("/payOK")
	public String payOK(@RequestParam Map<String, Object> map) {
		System.out.println("결제가 성공하면 나오는 값 " + map);
		int fillResult = normalService.fillWhalePay(map);
		if (fillResult == 1) {
			normalService.fillMamount(map);
		}
		// 결제 성공하면 어디로 보낼지 정해봅시당
		return "redirect:/";
	}
	
	@ResponseBody
	@PostMapping("/normalEdit")
	public String normalEdit( @RequestParam Map<String, Object> map) {
		JSONObject json = new JSONObject();
		System.out.println("맵 값은 어떻게 오나요?" + map);
		int normalEditResult = normalService.normalEdit(map);
		
		
		if(map.get("OriImgMap[0]") != null) {
		Map<String, Object> deleteImage = new HashMap<String, Object>();
		deleteImage.put("tno", map.get("tno"));
		if(map.get("OriImgMap[0]") != null) {
			deleteImage.put("Original1", map.get("OriImgMap[0]"));
		}if(map.get("OriImgMap[1]") != null) {
			deleteImage.put("Original2", map.get("OriImgMap[1]"));
		}if(map.get("OriImgMap[2]") != null) {
			deleteImage.put("Original3", map.get("OriImgMap[2]"));
		}if(map.get("OriImgMap[3]") != null) {
			deleteImage.put("Original4", map.get("OriImgMap[3]"));
		}
		 
		
			int normalDeleteEditImage = normalService.normalDeleteEditImage(deleteImage);
				if(normalDeleteEditImage == 1) {   
				json.put("ImgdeleteSuccess", 1);
				}
		}else {
			json.put("justDelete", 1);
		}

		return json.toString();
	}
	
	@ResponseBody
	@PostMapping("/insertEditImage")
	public String insertEditImage(@RequestParam Map<String, Object> map) {
		System.out.println("넣을 이미지 목록입니다 :" +map);
		return "";
	}
	
	
	
	 
	
	@PostMapping("/checkTnormalstate")
	@ResponseBody
	public String checkTnormalstate(@RequestParam Map<String, Object> map, HttpSession session) {
		System.out.println("checkTnormalstate의 맵값 : " + map);
		//checkTnormalstate의 맵값 : {tno=52, mnickname=대붕, tnormalprice=500, sellerMnickname=divy}
		System.out.println("세션값은 : " + session.getAttribute("muuid"));
		JSONObject json = new JSONObject();
		// 로그인 했는지 검사
		if (session.getAttribute("muuid") == null || session.getAttribute("muuid") == "") {
			json.put("emptySession", 1);
			return json.toString();
		}

		System.out.println(map);
		// 아직 판매중인지 검사(tnormalstate검사)
		int tnormalstate = normalService.selectTnormalstate(map);
		json.put("tnormalstate", tnormalstate);
		System.out.println("tnormalstate의 값은 : " + tnormalstate);
		if (tnormalstate == 0) {
			// 거래가 가능한 경우 잔액을 조회합니다.
			int mamount = normalService.selectMamountForTrade(map);
			System.out.println("너 얼마있냐?? : " + mamount);
			json.put("mamount", mamount);
			// 돈이 부족한 경우 경고창을 띄워주기 위한..
			if (mamount < Integer.parseInt(String.valueOf(map.get("tnormalprice")))) {
				System.out.println("이게 돈도없는게");
				json.put("nomoney", 1);
			}


				// 이미 채팅창이 생성되어 있는거 아녀??
				int paymentCount = normalService.normalTradePaymentCountCount(map);
				System.out.println("paymentCount의 값은 : " + paymentCount);
				json.put("paymentCount", paymentCount);
				if (paymentCount > 0) {
					// payment에 값이 이미 있다면
					System.out.println("이미 거래내역이 있구나!");
					return json.toString();
				}

				json.put("success", 1);

			// }//if(takeMamount == 1) 끝
		} else {
			System.out.println("ㅠㅠ 못사요");
			// json에 따로 값을 넣어서 경고창을 날릴 수 있게 해주자
		}
		return json.toString();
	}
	// }

	// }

	/*
	 * @PostMapping("/requestChat") public String requestChat(@RequestParam
	 * Map<String, Object> map, HttpSession session, Model model) {
	 * 
	 * // System.out.println("채팅으로 받아오는 값입니다 : " + map); //
	 * System.out.println("세션에서 받아오는 muuid 값입니다 : " + //
	 * session.getAttribute("muuid"));
	 * 
	 * String uuid = String.valueOf(UUID.randomUUID()); //
	 * System.out.println("채팅방 uuid 의 값입니다 : " + uuid); if
	 * (session.getAttribute("muuid") != null &&
	 * !(session.getAttribute("muuid").equals(""))) {
	 * 
	 * map.put("roomId", uuid);
	 * 
	 * System.out.println("최종적으로 담기는 값 : " + map); }
	 * model.addAttribute("roomdetail", map); return "/chat/roomdetail"; }
	 */

	// 받아와야 하는 값 : buyer, seller, 제시한 돈, tno
	@ResponseBody
	@PostMapping("/tradeOk")
	public String tradeOk(@RequestParam Map<String, Object> map) {
		// 거래를 수락하는 메소드입니다.
		JSONObject json = new JSONObject();
		System.out.println("tradeAccepted를 눌렀을 때 받아오는 값입니다 : " + map);
		map.put("state", 1);
		String obuyer = normalService.obuyerUuid(map);
		System.out.println("obuyer 값을 받아오나요? : " + obuyer);
		map.put("pbuyer", obuyer);
		int tnormalstate = normalService.selectTnormalstate(map);
		if (tnormalstate == 0) {
			System.out.println("tnormalstate==0이 들어오나요?");
			// 구매자의 돈을 귀속합니다.
			int takeMamount = normalService.takeMamount(map);
			//<update id="takeMamount" parameterType="Map">
			//UPDATE member
			//SET mamount = mamount-#{tnormalprice}
			//WHERE muuid = #{obuyer}
			//</update>
		
			if (takeMamount == 1) {
				System.out.println("takeMamount==1이 들어오나요?");
				// payment에 값을 집어넣습니다.
				int insertPaymentForNormal = normalService.insertPaymentForNormal(map);
 
				// <insert id="insertPaymentForNormal" parameterType="Map">
				// INSERT INTO payment (tno, pseller, pbuyer, psellerok, pbuyerok, pamount,
				// pstate)
				// VALUES(#{tno}, (SELECT muuid FROM member WHERE mnickname =
				// #{sellerMnickname}),
				// (SELECT muuid FROM member WHERE mnickname = #{mnickname}), 2, 2,
				// #{tnormalprice}, 2 )
				// </insert>
				if (insertPaymentForNormal == 1) {
					System.out.println("insertPaymentForNormal==1이 들어오나요?");
					// tnormalstate의 값을 변경해줍니다.(판매중 -> 거래중)
					int changeStateForTrade = normalService.changeStateForNormal(map);
					if (changeStateForTrade == 1) {
						json.put("tradeAccepted", "ok");
					}
 
				}  
			}

		}//if (tnormalstate == 0)  
		else {
			json.put("tnormalstateFalse", 0);
			return json.toString();
		}
		
		System.out.println("맵의 값입니다 : " + map);
		System.out.println("아이구 어서옵쇼");

		// 일단 임시로 값을 넣겠습니다.

		return json.toString();

	}

	// 물품 수령 완료 메소드(거래 완료)
	// ajax?
	// 받아와야 하는 값 : 세션의 muuid(muuid) , tno(tno),
	//recieveChecked의 맵값은 : {tno=52, muuid=a3d69eb4-bc98-47c6-abc5-55ba93c9fb99}

	@ResponseBody
	@PostMapping("/recieveChecked")
	public String recieveChecked(@RequestParam Map<String, Object> map) {
		System.out.println("recieveChecked의 맵값은 : " + map);
		JSONObject json = new JSONObject();
		// 당신은 구매자인가요 판매자인가요? + pamount가져오기
		Map<String, Object> buyerOrSeller = normalService.buyerOrSeller(map);
		System.out.println("buyerOrSeller의 값을 알려줘 : " + buyerOrSeller);
		// SELECT
		// (SELECT COUNT(*) FROM payment WHERE pbuyer =
		// 'a3d69eb4-bc98-47c6-abc5-55ba93c9fb99' AND tno = 48) AS buyer,
		// (SELECT COUNT(*) FROM payment WHERE pbuyer <>
		// 'a3d69eb4-bc98-47c6-abc5-55ba93c9fb99' AND tno = 48) AS seller;

		// buyer든 seller 든 누가 눌렀든 값을 가져와서 payment에 입력
		if (Integer.parseInt(String.valueOf(buyerOrSeller.get("buyer"))) == 1) {
			map.put("ok", "pbuyerok");
		} else {
			map.put("ok", "psellerok");
		} 

		map.put("pamount", buyerOrSeller.get("pamount"));
		int recieveChecked = normalService.recieveChecked(map);
		// UPDATE payment
		// SET #{ok} = 0
		// WHERE tno = #{tno} and pstate = 2
		if (recieveChecked == 1) {
			int selectPaymentResult = normalService.selectPaymentResult(map);
			 
			if (selectPaymentResult == 1) {
				// tnormalstate 값 변경(거래완료)
				map.put("state", 2);
				normalService.changeStateForNormal(map);
				// pstate값 변경(거래완료), enddate 삽입
				map.put("pstate", 0);
				normalService.changePstateForNormal(map);

				// 판매자한테 돈 주기
				int giveMamountForSeller = normalService.giveMamountForSeller(map);
				if (giveMamountForSeller == 1) {
					json.put("tradeAllSuccess", 1);
				}
			}//selectPaymentResult == 1 끝
			else {
				json.put("tradesuccess", 1);
			}
		}

		return json.toString();
		//jsp에서 if(data.TradeAllSuccess == 1){
	// 	alert("거래가 성공적으로 완료되었습니다"); or 알람 보내주기}
		//if(data.tradesuccess == 1){
		// alert("정상 처리 되었습니다. 상대방의 수락을 기다립니다."); or 알람 보내주기}
		
	}
	

	// 거래 취소 메소드(거래중 > 거래취소)
	// 받아와야 하는 값 : tno, 세션의 muuid, 실패 사유, tnormalprice
	//recieveCancelled의 맵 값은 : {reason=저 이거 사기 싫ㄹ어요;;, tnormalprice=500, muuid=a3d69eb4-bc98-47c6-abc5-55ba93c9fb99, tno=52}
	@ResponseBody
	@PostMapping("/recieveCancelled")
	public String recieveCancelled(@RequestParam Map<String, Object> map) {
		JSONObject json = new JSONObject();
		System.out.println("recieveCancelled의 맵 값은 : " + map);
		// 당신은 구매자인가요 판매자인가요? + pamount가져오기
		Map<String, Object> buyerOrSeller = normalService.buyerOrSeller(map);
		
		if (Integer.parseInt(String.valueOf(buyerOrSeller.get("buyer"))) == 1) {
			map.put("who", map.get("muuid"));
			map.put("ok", "pbuyerok");
		} else {
			map.put("who", map.get("muuid"));
			map.put("ok", "psellerok");
		}
		map.put("pamount", buyerOrSeller.get("pamount"));
		System.out.println("pamount의 값은 : "+  buyerOrSeller.get("pamount"));
		
		System.out.println("구매자?판매자?의 값 : " + buyerOrSeller);
		map.put("state", 0);
		// tnormalstate 값 변경(판매중) Trade 테이블
		normalService.changeStateForNormal(map);
		
		// 구매자한테 돈 돌려주기 Member 테이블
		String buyer = normalService.selectBuyer(map);
		map.put("buyer", buyer);
		int mamountReturn = normalService.mamountReturn(map);
		 
		// pstate값 변경(실패), enddate 삽입, 누가 취소했는지, 사유가 무엇인지 넣기 Payment 테이블
		int normalTradeFail = normalService.normalTradeFail(map);
		
		
		// ajax로 성공 값 보내주기
		json.put("recieveCancelledSuccess", 1);
		return json.toString();
	}
	
	//구매자의 소지 금액과 물품 가격을 비교해서 리턴하는 메소드입니다. made by 선우
		@PostMapping("/compareamounts")
		@ResponseBody
		public String compareAmounts(@RequestParam(name ="tno") int tno, @RequestParam(name ="obuyer") String obuyer) {
			System.out.println("값이 잘 오네요");
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
			json.put("obuyeramounts", obuyeramounts);
			return json.toString();
		}
	@ResponseBody
	@PostMapping("/normalHikeUp")
	public String normalHikeUp(@RequestParam Map<String,Object> map) {
		JSONObject json = new JSONObject();
		int LastTno = normalService.SelectLastTno();
		if(Integer.parseInt(String.valueOf(map.get("tno")))==LastTno) {
			json.put("noNeedToHikeUp", 1);
			return json.toString();
		}
		LastTno = LastTno + 1;
		map.put("LastTno", LastTno);
		System.out.println("끌올에서 오는 맵 값입니다 " + map);
		int normalHikeUpResult = normalService.normalHikeUp(map);
		if(normalHikeUpResult ==1 ) {
			json.put("tnormalhikeupok", 1); 
			json.put("tno", LastTno);
		}
		return json.toString();
	}
	
	
}// 컨트롤러 끝