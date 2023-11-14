package com.sellas.web.location;

import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LocationDAO {

	int addTradeLocation(Map<String, Object> map);

}