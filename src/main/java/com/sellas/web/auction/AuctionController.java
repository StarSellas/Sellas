package com.sellas.web.auction;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class AuctionController {
	
	@Autowired
	private AuctionService auctionService;
	
	
	/* 경매물품 목록 */
	
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
	
	@ResponseBody
	@GetMapping("/auctionItemList")
	public List<Map<String, Object>> auctionItemList(@RequestParam String sortOption, @RequestParam int page) {
		
		List<Map<String, Object>> auctionItemList = auctionService.auctionItemList(sortOption, page*10);
		System.out.println(auctionItemList);
		
		return auctionItemList;
	}
	
	/* 경매물품 디테일 */
	
	@GetMapping("/auctionDetail")
	public String auctionDetail(@RequestParam int tno, Model model) {

		Map<String, Object> auctionItemDetail = auctionService.auctionItemDetail(tno);
		model.addAttribute("auctionItemDetail", auctionItemDetail);
		
		return "auctionDetail";
	}
	
	/* 입찰 */
	
	@ResponseBody
	@PostMapping("/bidding")
	public int bidding(@RequestParam Map<String, Object> map) {
		
		return auctionService.bidding(map);
	}
}