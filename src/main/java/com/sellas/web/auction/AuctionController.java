package com.sellas.web.auction;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class AuctionController {
	
	@Autowired
	private AuctionService auctionService;
	
	
	@GetMapping("/auction")
	public String auctionList(Model model) {
		
		/*
		List<Map<String, Object>> auctionList = auctionService.auctionList();
		model.addAttribute("auctionList", auctionList);
		*/
		
		Map<String, String> itemCategory = auctionService.getItemCategoryList();
		model.addAttribute("itemCategory", itemCategory);
		
		return "auction";
	}
	
	/* 경매물품 목록 */
	
	@ResponseBody
	@GetMapping("/auctionItemList")
	public List<Map<String, Object>> auctionItemList(@RequestParam String sortOption) {
		
		List<Map<String, Object>> auctionItemList = auctionService.auctionItemList(sortOption);
		System.out.println(auctionItemList);
		
		return auctionItemList;
	}
}