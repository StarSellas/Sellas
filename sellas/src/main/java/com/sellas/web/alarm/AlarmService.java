package com.sellas.web.alarm;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class AlarmService {
	
	@Autowired
	private AlarmDAO alarmDAO;

	public List<Map<String, Object>> alarmList(String muuid) {
		// TODO Auto-generated method stub
		return alarmDAO.alarmList(muuid);
	}
	
	
}
