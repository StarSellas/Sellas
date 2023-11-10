package com.sellas.web.trade;

import java.util.Map;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sellas.web.util.Util;

@Controller
public class TradeController {
	
	@Autowired
	private TradeService tradeService;
	@Autowired
	private Util util;
	
	/* 거래 물품 등록 */
	
	@GetMapping("/addTradeItem")
	public String addTradeItem(Model model) {
		
		if(!util.checkLogin()) {
			return "redirect:/login";
		}
		
		Map<String, String> itemCategory = tradeService.getItemCategoryList();
		model.addAttribute("itemCategory", itemCategory);
		
		return "addTradeItem";
	}
	
	@ResponseBody
	@PostMapping("/addTradeItem")
	public String addTradeItem(@RequestParam Map<String, Object> map) {
		
		JSONObject json = new JSONObject();
		int result = tradeService.addTradeItem(map);
		
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
}