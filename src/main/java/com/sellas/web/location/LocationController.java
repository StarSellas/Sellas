package com.sellas.web.location;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sellas.web.util.Util;

@Controller
public class LocationController {
	
	@Autowired
	private LocationService locationService;
	@Autowired
	private Util util;

	@GetMapping("/addTradeLocation")
	public String addTradeLocation() {
		
		if(!util.checkLogin()) {
			return "redirect:/login";
		}
		
		return "addTradeLocation";
	}
	
	@ResponseBody
	@PostMapping("/addTradeLocation")
	public int addTradeLocation(@RequestParam Map<String, Object> map) {
		
		System.out.println(map);
		
		int result = locationService.addTradeLocation(map);
		System.out.println(result);
		
		return result;
	}
}