package com.sellas.web.location;

import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

@Service
public class LocationService {

	@Autowired
	private LocationDAO locationDAO;
	
	public int addTradeLocation(Map<String, Object> map) {
		
		HttpSession session = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest().getSession();
        map.put("muuid", session.getAttribute("muuid"));
		
		return locationDAO.addTradeLocation(map);
	}

}