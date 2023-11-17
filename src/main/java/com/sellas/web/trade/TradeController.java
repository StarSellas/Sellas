package com.sellas.web.trade;

import java.util.List;
import java.util.Map;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sellas.web.upload.UploadService;
import com.sellas.web.util.Util;

@Controller
public class TradeController {
	
	@Autowired
	private TradeService tradeService;
	@Autowired
	private Util util;
	@Autowired
	UploadService uploadService;
	
	/* 거래 물품 등록 */
	
	@GetMapping("/addTradeItem")
	public String addTradeItem(Model model) {

		if(!util.checkLogin()) {
			return "redirect:/login";
		}

		// 물품 카테고리 목록
		Map<String, String> itemCategory = tradeService.getItemCategoryList();
		model.addAttribute("itemCategory", itemCategory);

		// 거래 장소 목록
		List<Map<String, Object>> locationList = tradeService.getLocationList();
		model.addAttribute("locationList", locationList);

		return "addTradeItem";
	}

	@ResponseBody
	@PostMapping("/addTradeItem")
	public String addTradeItem(@RequestParam Map<String, Object> map) {
		System.out.println("오는 맵 값입니다 : " + map);
		JSONObject json = new JSONObject();
		int result = tradeService.addTradeItem(map);
		System.out.println(result);
		if(Integer.parseInt(String.valueOf(map.get("tradeType"))) == 1) {
			System.out.println("트레이드 타입은 1");
		}if(Integer.parseInt(String.valueOf(map.get("tradeType"))) == 0) {
			System.out.println("트레이드 타입은 0");
		}

		if(result == 1) {
			int LastTno = (int) map.get("tno");
			json.put("tradeType", map.get("tradeType"));
			json.put("tno", LastTno);
			json.put("addSuccess", 1);
		}

		return json.toString();
	}
	
	/* 거래 진행 */
	
	// 잔액 확인 필요 시 ajax 요청
	@ResponseBody
	@GetMapping("/checkBalance")
	public boolean checkBalance(@RequestParam int price) {
		
		return tradeService.checkBalance(price);
	}
	
	@ResponseBody
	@PostMapping("/auctioncompare")
	public String auctionCompare(@RequestParam Map<String, Object> map) {
		
		int abidprice = tradeService.getAbidprice(map); //tno가 같고, astate가 0인 것의 abidprice를 가져옵니다.
		
		map.put("abidprice", abidprice);
		
		int putabidprice = tradeService.putAbidprice(map);
		
		JSONObject json = new JSONObject();
		
		json.put("complete", putabidprice);
		
		return json.toString();
		
	}
	
	@ResponseBody
	@PostMapping("/buyertradecancel")
	public String buyerTradeCancel(@RequestParam Map<String, Object> map) {
		
		int depositreturn = tradeService.depositReturn(map);
		
		JSONObject json = new JSONObject();
		
		return json.toString();
		
	}
}