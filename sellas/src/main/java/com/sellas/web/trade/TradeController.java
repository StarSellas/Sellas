package com.sellas.web.trade;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

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
	
	@PostMapping("/addTradeItem")
	public String addTradeItem(@RequestParam Map<String, Object> map) {
		
		int result = tradeService.addTradeItem(map);
		System.out.println(result);
		
		// TODO : detail 페이지로 이동하도록 수정
		return "main";
	}
}