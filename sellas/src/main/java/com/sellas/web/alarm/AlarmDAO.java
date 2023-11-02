package com.sellas.web.alarm;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface AlarmDAO {

	List<Map<String, Object>> alarmList(String muuid);

}
