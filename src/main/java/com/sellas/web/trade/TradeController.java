package com.sellas.web.trade;

import java.io.File;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

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
		
		Map<String, String> itemCategory = tradeService.getItemCategoryList();
		model.addAttribute("itemCategory", itemCategory);
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
		
		// TODO : detail 페이지로 이동하도록 수정
		return json.toString();
	}

	
}